fx_version 'cerulean'
game 'gta5'

client_scripts {
    'client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

shared_script '@es_extended/imports.lua'

ui_page "html/index.html"

files {
    'html/index.html',
    'html/*.js',
    'html/img/*.png',
    'html/*.css'
}
