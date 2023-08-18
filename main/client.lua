--/////////// vRP bind \\\\\\\\\\\--

vRPCax = {}
Tunnel.bindInterface("ax_gunshops",vRPCax)
Proxy.addInterface("ax_gunshops",vRPCax)
vRP = Proxy.getInterface("vRP")
vRPSax = Tunnel.getInterface("ax_gunshops","ax_gunshops")

--===============================================--

local items = {}
local vip_wp = {}
local item_ids = {}
local vip_wp_ids = {}

local in_gs = false

function OpenGunshop(gunshop)
	StartScreenEffect("MenuMGHeistIn", 0, true)
	in_gs = true

	local vip__section =  AxConfig.Gunshops[gunshop].vip_section

	--//Getting items info
	vRPSax.get_items_info({AxConfig.Gunshops[gunshop].items,AxConfig.vip_weapons,vip__section},function(cb_items,cb_vip,vip_access)

		--// Caching items

		if not items[gunshop] then
			items[gunshop] = cb_items
		end
		if not vip_wp[gunshop] then
			vip_wp[gunshop] = cb_vip
		end

		if not item_ids[gunshop] then
			item_ids[gunshop] = AxConfig.Gunshops[gunshop].items
		end

		if not vip_wp_ids[gunshop] then
			vip_wp_ids[gunshop] = AxConfig.vip_weapons
		end

		--// SEND INFO TO NUI
		SendNUIMessage({
			open = true,
			title = "Armament "..gunshop,
			items = {
				items_name = items[gunshop],
				items_id = item_ids[gunshop],
				vip_weapons = vip_wp[gunshop],
				vip_weapons_ids = vip_wp_ids[gunshop],
			},
			vip_section = vip__section,
			vip_access = vip_access
		})
	end)
    SetNuiFocus(true, true)
	
end

RegisterNUICallback("buy-items", function (data,cb)
    vRPSax.buy_items({data})
	cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
	CloseGunshop()
	cb('ok')
end)

RegisterNUICallback('novipnotify', function(data, cb)
	vRP.notify({AxConfig.VIP_acces_denied})
	cb('ok')
end)

RegisterNUICallback('noslected', function(data , cb)
	vRP.notify({AxConfig.No_Selected_item})
	cb('ok')
end)

function CloseGunshop()
    StopScreenEffect("MenuMGHeistIn")
	StartScreenEffect("MenuMGHeistOut", 800, false)

    SendNUIMessage({
        open = false,
    })

    SetNuiFocus(false, false)
	in_gs = false
end

CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(0) end

	for i,k in pairs(AxConfig.Gunshops) do
		if k.use_blip then
			for _,j in pairs(k.coords) do
				local x,y,z = table.unpack(j)
				local blip = AddBlipForCoord(x,y,z)
				SetBlipSprite(blip, k.blip)
				SetBlipColour(blip, k.blip_color)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Armament ( "..i.." )")
				EndTextCommandSetBlipName(blip)
			end
		end
	end
end)

local Draw3DText = function(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local scale = 0.35
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.030, 66, 66, 66, 150)
    end
end


local drawn_marker = false
local pos_close = nil
local marker = nil

Citizen.CreateThread(function()
    ticks = 2000
	while true do
		
		local closest, dist, position = closestGS()

		if dist < AxConfig.Radius then
			ticks = 1
			if not in_gs then
				Draw3DText( position.x, position.y, position.z, AxConfig.Text_to_draw)
			end
			if IsControlJustPressed(0, 38) then
				vRPSax.Check_GS({closest},function(access)
					if access then
						OpenGunshop(closest)
					end
				end)
				
			end
		elseif dist < 50.0 then
			ticks = 1000
			pos_close = position
			marker = AxConfig.MarkerID
			drawn_marker = true
		else
			ticks = 2000
			drawn_marker = false					
			pos_close = nil
			marker = nil
		end
		
		Wait(ticks)
	end
end)

CreateThread(function()
	while true do
		local sleep = 0
		if drawn_marker then
			sleep = 0
			DrawMarker(marker, pos_close.x, pos_close.y, pos_close.z-0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 100, false, true, 2, false, false, false, false)
		else
			sleep = 1000
		end

		Wait(sleep)
	end
end)

function closestGS()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local min = 99999

	local closest = -1
	local position = nil

	for i,k in pairs(AxConfig.Gunshops) do
		for _,j in pairs(k.coords) do
			local dist = #(j - pos)

			if dist < min then
				closest = i
				min = dist
				position = j
			end
		end
	end

	return closest, min, position
end