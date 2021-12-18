fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'szxna'
description 'myjnia samochodowa'
version '1.0.0'

client_script {
	'config.lua',
    'client/client.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/server.lua'
}