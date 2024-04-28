
fx_version 'adamant'
game 'gta5'
lua54 'yes'
name 'Armour Prop Spawner'
description 'A simple Prop Spawner script for FiveM'
author 'Brazy#9999 at Armour Solutions'
version '1.0.0'

client_scripts {
    'config/*.lua',
    'client/*.lua'
}

server_scripts {
    'config/*.lua',
    'server/*.lua'
}

ui_page('html/index.html')

files {
    'html/index.html',
    'html/styles.css',
    'html/scripts.js'
}

escrow_ignore { 'config/*.lua' }

