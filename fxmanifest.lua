fx_version 'adamant'

game 'gta5'

ui_page 'nui/index.html'

files{
    'nui/index.html',
    'nui/main.js',
    'nui/style.css',
    'nui/reset.css',
    'img/*.png'
}

client_scripts {
    "lib/Tunnel.lua",
	"lib/Proxy.lua",
    "config.lua",
    'main/client.lua',
}

server_scripts{
    "@vrp/lib/utils.lua",
    "config.lua",
    'main/server.lua',
}
