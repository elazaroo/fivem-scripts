fx_version 'adamant'
games { 'gta5' }

server_scripts { 
    '@mysql-async/lib/MySQL.lua',
    'server/ck_sv.lua' 
}

shared_script '@es_extended/imports.lua'