-- version check
Citizen.CreateThread(function()
    local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
    if vRaw and config.versionCheck then
        local v = json.decode(vRaw)
        local url = 'https://raw.githubusercontent.com/DevBlocky/nearest-postal/master/version.json'
        PerformHttpRequest(url, function(code, res)
            if code == 200 then
                local rv = json.decode(res)
                if rv.version ~= v.version then
                    print(([[
-------------------------------------------------------
nearest-postal
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------
]]):format(rv.version, rv.changelog))
                end
            else
                print('nearest-postal was unable to check the version')
            end
        end, 'GET')
    end
end)

-- add functionality to get postals server side from a vec3

local postals = nil
Citizen.CreateThread(function()
    postals = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
    postals = json.decode(postals)
    for i, postal in ipairs(postals) do
        postals[i] = {vec(postal.x, postal.y), code = postal.code}
    end
end)

local function getPostalServer(coords)
    while postals == nil do
        Wait(1)
    end
    local _total = #postals
    local _nearestIndex, _nearestD
    coords = vec(coords[1], coords[2])

    for i = 1, _total do
        local D = #(coords - postals[i][1])
        if not _nearestD or D < _nearestD then
            _nearestIndex = i
            _nearestD = D
        end
    end
    local _code = postals[_nearestIndex].code
    local nearest = {code = _code, dist = _nearestD}
    return nearest or nil
end

exports('getPostalServer', function(coords)
    return getPostalServer(coords)
end)
