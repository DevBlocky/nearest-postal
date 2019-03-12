local raw = LoadResourceFile(GetCurrentResourceName(), 'postals.json')
local postals = json.decode(raw)

local nearest = nil
local pBlip = nil

-- thread for finding nearest postal
Citizen.CreateThread(function()
    while true do
        local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

        local nd = -1
        local ni = -1
        for i, p in ipairs(postals) do
            local d = math.sqrt((x - p.x)^2 + (y - p.y)^2) -- pythagorean theorem
            if nd == -1 or d < nd then
                ni = i
                nd = d
            end
        end

        if ni ~= -1 then
            nearest = {dist = nd, i = ni}
        end

        Wait(100)
    end
end)
-- text display thread
Citizen.CreateThread(function()
    while true do
        if nearest then
            local text = config.text.format:format(postals[nearest.i].code, nearest.dist)
            SetTextScale(0.42, 0.42)
            SetTextFont(4)
            SetTextProportional(false)
            SetTextEntry("STRING")
            SetTextCentre(0)
            SetTextOutline()
            AddTextComponentString(text)
            DrawText(config.text.posX, config.text.posY)
        end
        Wait(2)
    end
end)

-- blip thread
Citizen.CreateThread(function()
    while true do
        if pBlip then
            local p = GetEntityCoords(GetPlayerPed(-1))
            local b = {x = pBlip.p.x, y = pBlip.p.y}
            local dx, dy = math.abs(p.x - b.x), math.abs(p.y - b.y)
            local d = math.sqrt(dx^2 + dy^2)
            if d < config.blip.distToDelete then
                RemoveBlip(pBlip.hndl)
                pBlip = nil
            end
        end
        Wait(100)
    end
end)
RegisterCommand('postal', function(source, args, raw)
    if #args < 1 then
        if pBlip then
            RemoveBlip(pBlip.hndl)
            pBlip = nil
        end
        return
    end
    local n = string.upper(args[1])

    local fp = nil
    for _, p in ipairs(postals) do
        if string.upper(p.code) == n then
            fp = p
        end
    end

    if fp then
        if pBlip then
            RemoveBlip(pBlip.hndl)
        end
        pBlip = {hndl = AddBlipForCoord(fp.x, fp.y, 0.0), p = fp}
        SetBlipRoute(pBlip.hndl, true)
        SetBlipColour(pBlip.hndl, 3)
        SetBlipRouteColour(pBlip.hndl, config.blip.color)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(config.blip.textFormat:format(pBlip.p.code))
        EndTextCommandSetBlipName(pBlip.hndl)

        TriggerEvent('chat:addMessage', {
            color = {255,0,0},
            args = {
                'Postals',
                'Drawing a route to '..fp.code
            }
        })
    else
        TriggerEvent('chat:addMessage', {
            color = {255,0,0},
            args = {
                'Postals',
                'That postal code doesn\'t exist'
            }
        })
    end
end)

--[[Development shit]]
local dev = true
if dev then
    local devLocal = json.decode(raw)
    local next = 0

    RegisterCommand('setnext', function(src, args, raw)
        local n = tonumber(args[1])
        if n ~= nil then
            next = n
            print('next '..next)
            return
        end
        print('invalid '..n)
    end)
    RegisterCommand('next', function(src, args, raw)
        for i, d in ipairs(devLocal) do
            if d.code == tostring(next) then
                print('duplicate '..next)
                return
            end
        end
        local coords = GetEntityCoords(GetPlayerPed(-1))
        table.insert(devLocal, {code = tostring(next), x = coords.x, y = coords.y})
        print('insert '..next)
        next = next + 1
    end)
    RegisterCommand('rl', function(src, args, raw)
        if #devLocal > 0 then
            local data = table.remove(devLocal, #devLocal)
            print('remove '..data.code)
            print('next '..next)
            next = next - 1
        else
            print('invalid')
        end
    end)
    RegisterCommand('remove', function(src, args, raw)
        if #args < 1 then
            print('invalid')
        else
            for i, d in ipairs(devLocal) do
                if d.code == args[1] then
                    table.remove(devLocal, i)
                    print('remove '..d.code)
                    return
                end
            end
            print('invalid')
        end
    end)
    RegisterCommand('json', function(src, args, raw)
        print(json.encode(devLocal))
    end)
end
