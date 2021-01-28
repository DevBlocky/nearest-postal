-- the postal map to read from
-- change it to whatever model you want that is in this directory
local postalFile = 'new-postals.json'

--[[
WHAT EVER YOU DO, DON'T TOUCH ANYTHING BELOW UNLESS YOU **KNOW** WHAT YOU ARE DOING
If you just want to change the postal file, **ONLY** change the above variable
--]]
fx_version 'cerulean'
games { 'gta5' }

author 'blockba5her'
description 'This script displays a nearest postal next to where PLD would go and also has a command to draw a route to a specific postal'
version '1.4.2'
url 'https://github.com/blockba5her/nearest-postal'

client_scripts {
	'config.lua',
	'cl.lua'
}
server_scripts {
	'config.lua',
	'sv.lua'
}

file(postalFile)
postal_file(postalFile)

file 'version.json'
