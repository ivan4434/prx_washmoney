ESX = exports['es_extended']:getSharedObject()

CreateThread(function()

	if Config.Blip == true then
		for k,v in pairs(Config.place) do
			local blip = AddBlipForCoord(v)
			SetBlipSprite(blip, Config.BlipStyle.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, Config.BlipStyle.scale)
			SetBlipColour(blip, Config.BlipStyle.colour)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U("blip"))
			EndTextCommandSetBlipName(blip)
		end
	end

	while true do
		ms = 3000
		for k,v in pairs(Config.place) do
			local plyCoords = GetEntityCoords(PlayerPedId())
			local dist = #(plyCoords - v)
			if dist <= Config.DrawDistance then
				ms = 0
				DrawMarker(Config.Marker.type, v - vec3(0,0,1), 0, 0, 0, 0, 0, 0, Config.Marker.size, Config.Marker.color, 200, 0, 0, 0, 0)
				if dist <= Config.Marker.size[1] then
					ESX.ShowHelpNotification(_U("wash_money?"))

					if IsControlJustPressed(0, 51) then -- E
						AbraMenuDinero()
					end
				end
			end
		end
		Wait(ms)
	end
end)

function AbraMenuDinero()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "lavar_dinero", {
		title = _U("want_to_wash"),
		align = "bottom-right",
		elements = {
			{
				label = _U("yes"),
				value = "si"
			},
			{
				label = _U("no"),
				value = "no"
			}
		}
	}, function(data, menu)
		if data.current.value == "si" then
			AbrirMenuRecuento()
			menu.close()
		else
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

function AbrirMenuRecuento()
	ESX.UI.Menu.Open("dialog", GetCurrentResourceName(), "recuento", {
		title = _U("how_much")
	}, function(data, menu)
		local amount = tonumber(data.value)
		if amount == nil then
			ESX.ShowNotification(_U("invalid_quantity"))
		else
			menu.close()
			TriggerServerEvent("prx_dineronegro:lavarDinero", amount, "rTQ(@CwZjhU")
		end
	end, function(data, menu)
		menu.close()
	end)
end