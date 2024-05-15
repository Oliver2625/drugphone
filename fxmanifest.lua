fx_version 'cerulean'
games { 'gta5' }

author 'Oliver - DrugPhone System'
description 'Oliver - DrugPhone System'
version '1.0.0'
legacyversion '1.9.1'

lua54 'yes'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    '@mysql-async/lib/MySQL.lua',
}