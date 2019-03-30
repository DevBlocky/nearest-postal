-- the postal map to read from
-- change it to whatever model you want that is in this directory
local postalFile = 'new-postals.json'

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'config.lua',
    'cl.lua'
}
server_script 'sv.lua'

file(postalFile)
postal_file(postalFile)

file 'version.json'
