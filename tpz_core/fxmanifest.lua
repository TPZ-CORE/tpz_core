fx_version "adamant"
games {"rdr3"}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'Nosmakos'
description 'TPZ-CORE Base'
version '1.0.5'

ui_page 'html/index.html'

shared_scripts { 'config.lua', 'locales.lua' }

client_scripts { 
    'init.lua',
    'client/*.lua',
	"client/modules/**/*shared.lua",
	"client/modules/**/*client.lua",
    "client/modules/component/clothesList.lua",
	"client/modules/component/horseComponents.lua",
	"client/modules/component/data/horseComponents.lua",
	"client/modules/component/data/playerComponents.lua",
    'client/player/*.lua',
    'client/nui/*.lua',
    'client/api/*.lua'
}

server_scripts { 'server/*.lua' }

files { 'html/**/*' }

lua54 'yes'



