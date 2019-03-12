-- version check
Citizen.CreateThread(function()
    print('nearest-postal by BlockBa5her started')
    local vRaw = LoadResourceFile(GetCurrentResourceName(), "version.json")
    if vRaw then
        local v = json.decode(vRaw)
        PerformHttpRequest("https://raw.githubusercontent.com/blockba5her/nearest-postal/master/version.json", function(code, res, headers)
            if code == 200 then
                local rv = json.decode(res)
                if rv.version == v.version then
                    print('nearest-postal up to date!')
                else
                    print((
[[

-------------------------------------------------------
nearest-postal
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------
]]                  ):format(rv.version, rv.changelog))
                end
            else
                print('nearest-postal unable to check version')
            end
        end, 'GET')
    end
end)
