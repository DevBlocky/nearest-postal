-- optimizations
local Wait = Wait
local format = string.format
local ipairs = ipairs
local RemoveBlip = RemoveBlip
local PlayerPedId = PlayerPedId
local IsHudHidden = IsHudHidden
local SetTextFont = SetTextFont
local SetTextScale = SetTextScale
local SetTextOutline = SetTextOutline
local GetEntityCoords = GetEntityCoords
local EndTextCommandDisplayText = EndTextCommandDisplayText
local BeginTextCommandDisplayText = BeginTextCommandDisplayText
local AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName
local vec = vec
-- end optimizations

local raw = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))

---@class PostalData : table<number, vec>
---@field code string
---@type table<number, PostalData>
local postals = json.decode(raw)
for i, postal in ipairs(postals) do postals[i] = { vec(postal.x, postal.y), code = postal.code } end

local nearest = nil
local pBlip = nil
local nearestPostalText = ""

-- thread for nearest and blip
CreateThread(function()
    local config = config
    local deleteDist = config.blip.distToDelete
    local _total = #postals

    while true do
        local coords = GetEntityCoords(PlayerPedId())
        local _nearestIndex, _nearestD
        coords = vec(coords[1], coords[2])

        for i = 1, _total do
            local D = #(coords - postals[i][1])
            if not _nearestD or D < _nearestD then
                _nearestIndex = i
                _nearestD = D
            end
        end

        if pBlip and _nearestD < deleteDist then
            -- delete blip if close
            RemoveBlip(pBlip.hndl)
            pBlip = nil
        end

        nearest = { code = postals[_nearestIndex].code, dist = _nearestD }
        Wait(250)
    end
end)

CreateThread(function()
    local formatTemplate = config.text.format
    while true do
        if nearest then nearestPostalText = format(formatTemplate, nearest.code, nearest.dist) end
        Wait(250)
    end
end)

-- text display thread
CreateThread(function()
    local posX = config.text.posX
    local posY = config.text.posY
    local _string = "STRING"
    local _scale = 0.42
    local _font = 4
    while true do
        if nearest and not IsHudHidden() then
            SetTextScale(_scale, _scale)
            SetTextFont(_font)
            SetTextOutline()
            BeginTextCommandDisplayText(_string)
            AddTextComponentSubstringPlayerName(nearestPostalText)
            EndTextCommandDisplayText(posX, posY)
        end
        Wait(0)
    end
end)

RegisterCommand('postal', function(source, args, raw)
    if #args < 1 then
        if pBlip then
            RemoveBlip(pBlip.hndl)
            pBlip = nil
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0 },
                args = {
                    'Postals',
                    config.blip.deleteText
                }
            })
        end
        return
    end
    local n = string.upper(args[1])

    local fp = nil
    for _, p in ipairs(postals) do
        if string.upper(p.code) == n then
            fp = p
            break
        end
    end

    if fp then
        if pBlip then
            RemoveBlip(pBlip.hndl)
        end
        pBlip = { hndl = AddBlipForCoord(fp.x, fp.y, 0.0), p = fp }
        SetBlipRoute(pBlip.hndl, true)
        SetBlipSprite(pBlip.hndl, config.blip.sprite)
        SetBlipColour(pBlip.hndl, config.blip.color)
        SetBlipRouteColour(pBlip.hndl, config.blip.color)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(config.blip.blipText:format(pBlip.p.code))
        EndTextCommandSetBlipName(pBlip.hndl)

        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = {
                'Postals',
                config.blip.drawRouteText:format(fp.code)
            }
        })
    else
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = {
                'Postals',
                config.blip.notExistText
            }
        })
    end
end)

--[[Development shit]]
local dev = false
if dev then
    local devLocal = json.decode(raw)
    local next = 0

    RegisterCommand('setnext', function(src, args, raw)
        local n = tonumber(args[1])
        if n ~= nil then
            next = n
            print('next ' .. next)
            return
        end
        print('invalid ' .. n)
    end)

    RegisterCommand('next', function(src, args, raw)
        for i, d in ipairs(devLocal) do
            if d.code == tostring(next) then
                print('duplicate ' .. next)
                return
            end
        end
        local coords = GetEntityCoords(GetPlayerPed(-1))
        table.insert(devLocal, { code = tostring(next), x = coords.x, y = coords.y })
        print('insert ' .. next)
        next = next + 1
    end)

    RegisterCommand('rl', function(src, args, raw)
        if #devLocal > 0 then
            local data = table.remove(devLocal, #devLocal)
            print('remove ' .. data.code)
            print('next ' .. next)
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
                    print('remove ' .. d.code)
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

exports('getPostal', function() return nearest and nearest.code or nil end)
