fx_version 'cerulean'
game 'gta5'

author 'takenncs'
description 'addon carhud for v2'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/Gilroy-ExtraBold.otf',
    'html/WorkSans-SemiBold.ttf'
}

client_scripts {
    'config.lua',
    'client/main.lua'
}

server_scripts {
    'config.lua',
    'server/main.lua'
}