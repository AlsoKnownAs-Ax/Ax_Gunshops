--/////////// vRP bind \\\\\\\\\\\--

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","ax_gunshops")

vRPCax = Tunnel.getInterface("ax_gunshops","ax_gunshops")

vRPSax = {}
Tunnel.bindInterface("ax_gunshops",vRPSax)
Proxy.addInterface("ax_gunshops",vRPSax)

--===============================================--

--[[
   items = {
        items_array ={
            weapons = {
                {item_id = "WEAPON_", ammo_amount = 50, body_price = 500, ammo_price = 200},
                {item_id = "WEAPON_", ammo_amount = 50, body_price = 500, ammo_price = 200},
            }

            non_weapons_items = {
                {item_id = "id",amount = 100, price = 500},
            },
        }
    }
]]


function vRPSax.buy_items(items)
    local items = items.items_array
    local user_id = vRP.getUserId{source}
    local src = vRP.getUserSource{user_id}
    if user_id then
        local total = 0 --// Reseting total price and ammo amount
        local items_weight = 0
        --// Calculating items weight

        if items.non_weapons_items then
            for _,v in pairs(items.non_weapons_items) do
                items_weight = vRP.getItemWeight{string.lower(v.item_id)} * v.amount
            end
        end
        
        --// Calculating price

        local new_weight = vRP.getInventoryWeight({user_id}) + items_weight
        if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
            --// Weapons Items
            vRPclient.getWeapons(src,{},function(_weapons)
                for _,v in pairs(items.weapons) do
                    local ammo = 0
                    if tonumber(v.ammo_amount) >  250 then
                        ammo = 250
                    else
                        ammo = tonumber(v.ammo_amount)
                    end
                    total = math.ceil(parseFloat(v.ammo_price)*parseFloat(ammo))
                    if not _weapons[string.upper(v.item_id)] then
                        total = total + tonumber(v.body_price)
                    end
                end
            
                --// Adding Normal Items Price

                for _,v in pairs(items.non_weapons_items) do
                    total = total + tonumber(v.price)*tonumber(v.amount)
                end


                --// Payment

                if vRP.tryPayment{user_id,total} then
                    for _,v in pairs(items.weapons) do
                        local ammo = 0
                        if tonumber(v.ammo_amount) >  250 then
                            ammo = 250
                        else
                            ammo = tonumber(v.ammo_amount)
                        end
                        vRPclient.giveWeapons(src,{{
                            [string.upper(v.item_id)] = {ammo=ammo}
                        }})
                    end
                    for _,v in pairs(items.non_weapons_items) do
                        vRP.giveInventoryItem({user_id, string.lower(v.item_id), tonumber(v.amount), true})
                    end
                else
                    vRPclient.notify(src,{"Nu ai destui bani"})
                end
            end)
        else
            vRPclient.notify(src,{"Nu ai destul spatiu in inventar"})
        end
    end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function vRPSax.get_items_info(items,vip_items,vip_section)
    local user_id = vRP.getUserId{source}
    local vip = false
    if user_id then
        local cb_items = {}
        local cb_vip = {}
        for _,v in pairs(items) do
            local item_name = string.upper(vRP.getItemName{v.item})
            item_name = string.lower(item_name:gsub("WEAPON_",""))
            item_name = firstToUpper(item_name)
            table.insert(cb_items,item_name)
        end
        if vip_section then
            for _,v in pairs(vip_items)do
                local item_name = string.upper(vRP.getItemName{v.item})
                item_name = string.lower(item_name:gsub("WEAPON_",""))
                item_name = firstToUpper(item_name)
                table.insert(cb_vip,item_name)
            end
            if vRP.isUserVip{user_id} then
                vip = true
            end
            return cb_items,cb_vip,vip
        end
        return cb_items, nil,false
    end
end

local function check_lua_exec(gunshop,source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local dist  = nil
    for _,v in pairs(AxConfig.Gunshops[gunshop].coords) do
        local _dist = #(coords - v)
        if _dist < (AxConfig.Radius + 4) then
            dist = _dist
            break
        end
    end
    if not dist then
        DropPlayer(source, AxConfig.Kick_message)
        return false
    end
    return true
end

function vRPSax.Check_GS(gunshop)
    local user_id = vRP.getUserId{source}
    local src = vRP.getUserSource{user_id}
    local ok = check_lua_exec(gunshop,src)
    if not ok then
        return
    end
    local hours = vRP.getUserHoursPlayed{user_id}
    if user_id then
        local faction = AxConfig.Gunshops[gunshop].faction
        if faction then
            if vRP.isUserInFaction{user_id,faction} then
                if hours < AxConfig.Gunshops[gunshop].needed_hours then
                    vRPclient.notify(src,{AxConfig.not_enough_hours_message})
                    return false
                end
                return true
            end
            vRPclient.notify(src,{"Nu poti accesa acest Gunshop"})
            return false
        end
        if hours < AxConfig.Gunshops[gunshop].needed_hours then
            vRPclient.notify(src,{AxConfig.not_enough_hours_message})
            return false
        end
        return true
    else
        DropPlayer(source, AxConfig.Kick_message)
    end
end
