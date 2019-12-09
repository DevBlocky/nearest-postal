local raw = LoadResourceFile(GetCurrentResourceName(), GetResourceMetadata(GetCurrentResourceName(), 'postal_file'))
local postals = json.decode(raw)

local nearest = nil
local pBlip = nil

-- thread for nearest and blip
Citizen.CreateThread(
	function()
		while true do
			local x, y = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

			local ndm = -1 -- nearest distance magnitude
			local ni = -1 -- nearest index
			for i, p in ipairs(postals) do
				local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2 -- distance magnitude
				if ndm == -1 or dm < ndm then
					ni = i
					ndm = dm
				end
			end

			--setting the nearest
			if ni ~= -1 then
				local nd = math.sqrt(ndm) -- nearest distance
				nearest = {i = ni, d = nd}
			end

			-- if blip exists
			if pBlip then
				local b = {x = pBlip.p.x, y = pBlip.p.y} -- blip coords
				local dm = (b.x - x) ^ 2 + (b.y - y) ^ 2 -- distance magnitude
				if dm < config.blip.distToDelete ^ 2 then
					-- delete blip if close
					RemoveBlip(pBlip.hndl)
					pBlip = nil
				end
			end

			Wait(100)
		end
	end
)
-- text display thread
Citizen.CreateThread(
	function()
		while true do
			if nearest then
				--print(json.encode(nearest))
				local text = config.text.format:format(postals[nearest.i].code, nearest.d)
				SetTextScale(0.42, 0.42)
				SetTextFont(4)
				SetTextProportional(false)
				SetTextEntry('STRING')
				SetTextCentre(0)
				SetTextOutline()
				AddTextComponentString(text)
				DrawText(config.text.posX, config.text.posY)
			end
			Wait(0)
		end
	end
)

RegisterCommand(
	'postal',
	function(source, args, raw)
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

			TriggerEvent(
				'chat:addMessage',
				{
					color = {255, 0, 0},
					args = {
						'Postals',
						'Drawing a route to ' .. fp.code
					}
				}
			)
		else
			TriggerEvent(
				'chat:addMessage',
				{
					color = {255, 0, 0},
					args = {
						'Postals',
						"That postal code doesn't exist"
					}
				}
			)
		end
	end
)

--[[Development shit]]
local dev = false
if dev then
	local devLocal = json.decode(raw)
	local next = 0

	RegisterCommand(
		'setnext',
		function(src, args, raw)
			local n = tonumber(args[1])
			if n ~= nil then
				next = n
				print('next ' .. next)
				return
			end
			print('invalid ' .. n)
		end
	)
	RegisterCommand(
		'next',
		function(src, args, raw)
			for i, d in ipairs(devLocal) do
				if d.code == tostring(next) then
					print('duplicate ' .. next)
					return
				end
			end
			local coords = GetEntityCoords(GetPlayerPed(-1))
			table.insert(devLocal, {code = tostring(next), x = coords.x, y = coords.y})
			print('insert ' .. next)
			next = next + 1
		end
	)
	RegisterCommand(
		'rl',
		function(src, args, raw)
			if #devLocal > 0 then
				local data = table.remove(devLocal, #devLocal)
				print('remove ' .. data.code)
				print('next ' .. next)
				next = next - 1
			else
				print('invalid')
			end
		end
	)
	RegisterCommand(
		'remove',
		function(src, args, raw)
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
		end
	)
	RegisterCommand(
		'json',
		function(src, args, raw)
			print(json.encode(devLocal))
		end
	)
end
