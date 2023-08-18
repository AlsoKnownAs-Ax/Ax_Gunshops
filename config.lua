AxConfig = {}

--// Gunshop Configs //--

AxConfig.Radius = 4
AxConfig.MarkerID = 27
AxConfig.not_enough_hours_message = "Nu ai destule ore"
AxConfig.Text_to_draw = "Apasa ~g~[E] ~w~pentru a deschide Armament"
AxConfig.VIP_acces_denied = "Nu poti accesa sectiunea VIP"
AxConfig.No_Selected_item = "Nu ai niciun item slectat"
AxConfig.Kick_message = "Reilable Network Event Overflow" --// For lua executors

AxConfig.vip_weapons = {
    {item ='WEAPON_APPISTOL', price = 0 , ammo_price = 100},
    {item = 'weapon_militaryrifle', price = 150 , ammo_price = 300},
    {item = 'WEAPON_REVOLVER', price = 150 , ammo_price = 300},
}

--// VIP INFO: The function used is vRP.isUserVip{user_id}
--// Make sure your function name is the same , else create one with the same name
--// Info: 
--// item = 'weapon_name', price = "body_price" , ammo_price = "ammo_price"                                              https://wiki.rage.mp/index.php?title=Weapons)
--// if the item is melee weapon or an item set the ammo_price to 0


AxConfig.Gunshops = {
    ['Civil'] = {

        use_blip = true,
        blip = 110,
        blip_color = 1, --// Full list --> https://docs.fivem.net/docs/game-references/blips/
        needed_hours = 0,

        faction = false,  --// Set it to false so everyone can access the gunshop , else put the faction name
        vip_section = true,
        items = {
            {item = 'weapon_autoshotgun', price = 15000 , ammo_price = 300},
            {item = 'weapon_appistol', price = 15000 , ammo_price = 300},
            {item = 'weapon_heavypistol', price = 15000 , ammo_price = 300},
            {item = 'body_armor', price = 0 , ammo_price = 0},
        },
        coords = {
            vector3(21.188360214233,-1106.4090576172,29.797018051147),
        },
    },
    ['Politie'] = {

        use_blip = true,
        blip = 110,
        blip_color = 57,
        needed_hours = 0,

        faction = "Politie",
        vip_section = false,
        items = {
            {item = 'WEAPON_PISTOL', price = 150 },
            {item = 'WEAPON_SPECIALCARBINE', price = 200},
            {item = 'body_armor', price = 0 , ammo_price = 0},
        },
        coords = {
            vector3(452.05999755859,-980.21240234375,30.689603805542)
        },
    },
}


--// A list with all items that have IMGs ( full-list on https://wiki.rage.mp/index.php?title=Weapons)

--[[ 
    {item = 'weapon_autoshotgun', price = 15000 , ammo_price = 300},
    {item = 'weapon_minismg', price = 150 , ammo_price = 300},
    {item = 'weapon_hatchet', price = 150 , ammo_price = 0},
    {item = 'weapon_marksmanrifle', price = 150 , ammo_price = 300},
    {item = 'weapon_heavyshotgun', price = 150 , ammo_price = 3000},
    {item = 'weapon_musket', price = 150 , ammo_price = 300},
    {item = 'weapon_dagger', price = 55000 , ammo_price = 0}, 
    {item = 'weapon_vintagepistol', price = 55000 , ammo_price = 0},
    {item = 'weapon_bullpuprifle', price = 55000 , ammo_price = 0},
    {item = 'weapon_heavypistol', price = 55000 , ammo_price = 0},
    {item = 'weapon_gusenberg', price = 55000 , ammo_price = 0},
    {item = 'weapon_bottle', price = 55000 , ammo_price = 0},
    {item = 'weapon_snspistol', price = 55000 , ammo_price = 0},
    {item = 'weapon_petrolcan', price = 55000 , ammo_price = 0},
    {item = 'weapon_hammer', price = 55000 , ammo_price = 0},
    {item = 'weapon_nightstick', price = 55000 , ammo_price = 0},
    {item = 'weapon_knife', price = 55000 , ammo_price = 0},
    {item = 'weapon_heavysniper', price = 55000 , ammo_price = 0},
    {item = 'weapon_sniperrifle', price = 55000 , ammo_price = 0},
    {item = 'weapon_advancedrifle', price = 55000 , ammo_price = 0},
    {item = 'weapon_carbinerifle', price = 55000 , ammo_price = 0},
    {item = 'weapon_assaultrifle', price = 55000 , ammo_price = 0},
    {item = 'weapon_combatmg', price = 55000 , ammo_price = 0},
    {item = 'weapon_mg', price = 55000 , ammo_price = 0},
    {item = 'weapon_assaultsmg', price = 55000 , ammo_price = 0},
    {item = 'weapon_smg', price = 55000 , ammo_price = 0},
    {item = 'weapon_microsmg', price = 55000 , ammo_price = 0},
    {item = 'weapon_bullpupshotgun', price = 55000 , ammo_price = 0},
    {item = 'weapon_assaultshotgun', price = 55000 , ammo_price = 0},
    {item = 'weapon_pumpshotgun', price = 55000 , ammo_price = 0},
    {item = 'weapon_sawnoffshotgun', price = 55000 , ammo_price = 0},
    {item = 'weapon_pistol50', price = 55000 , ammo_price = 0},
    {item = 'weapon_combatpistol', price = 55000 , ammo_price = 0},
    {item = 'weapon_golfclub', price = 55000 , ammo_price = 0},
    {item = 'weapon_crowbar', price = 55000 , ammo_price = 0},
    {item = 'weapon_bat', price = 55000 , ammo_price = 0},
    {item = 'weapon_marksmanrifle_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_bullpuprifle_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_specialcarbine_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_pumpshotgun_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_revolver_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_snspistol_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_heavysniper_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_carbinerifle_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_assaultrifle_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_combatmg_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_smg_mk2', price = 55000 , ammo_price = 0},
    {item = 'weapon_pistol_mk2', price = 55000 , ammo_price = 0}, 
    {item = 'weapon_gadgetpistol', price = 55000 , ammo_price = 0},
    {item = 'weapon_navyrevolver', price = 55000 , ammo_price = 0},
    {item = 'weapon_stone_hatchet', price = 55000 , ammo_price = 0},
    {item = 'weapon_doubleaction', price = 55000 , ammo_price = 0}, 
    {item = 'weapon_emplauncher', price = 55000 , ammo_price = 0},
    {item = 'weapon_stungun', price = 55000 , ammo_price = 0},
    {item = 'weapon_wrench', price = 55000 , ammo_price = 0},
    {item = 'weapon_poolcue', price = 55000 , ammo_price = 0},

]]