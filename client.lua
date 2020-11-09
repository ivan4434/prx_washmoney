

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(Config.place) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.place[k].x, Config.place[k].y, Config.place[k].z)
            if dist <= 30.0 then
            -- Marker (START)
            DrawMarker(22, Config.place[k].x, Config.place[k].y, Config.place[k].z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 0, 255, 50, 200, 0, 0, 0, 0)
			-- Marker (END)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        for k in pairs(Config.place) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.place[k].x, Config.place[k].y, Config.place[k].z)

            if dist <= 0.5 then
                --doesnt spam notifcations only shows top corner
                hintToDisplay(_U('wash_money?'))
				
				if IsControlJustPressed(0, 38) then -- "E"
					AbraMenuDinero()
				end			
            end
        end
    end
end)

function AbraMenuDinero()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'lavar_dinero', -- Replace the menu name
  {
    title    = _U('want_to_wash'),
    align = 'top-left', -- Menu position
    elements = { -- Contains menu elements
      {label = _U('yes'),     value = 'si'},
      {label = _U('no'),     value = 'no'},
    }
  },
  function(data, menu) -- This part contains the code that executes when you press enter
    if data.current.value == 'si' then
      AbrirMenuRecuento()
      menu.close()
    else 
    	menu.close()
    end   
  end,
  function(data, menu) -- This part contains the code  that executes when the return key is pressed.
      menu.close() -- Close the menu
  end
)
end

function AbrirMenuRecuento()

	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'recuento',
  {
    title = _U('how_much')
  },
  function(data, menu)
    local amount = tonumber(data.value)
    if amount == nil then
      ESX.ShowNotification(_U('invalid_quantity'))
    else
      menu.close()
      TriggerServerEvent('prx_dineronegro:lavarDinero', amount)
    end
  end,
  function(data, menu)
    menu.close()
  end)
end

--BLIPS

local x = 0
local y = 0
local z = 0
for k in pairs(Config.place) do
	x = Config.place[k].x
	y = Config.place[k].y
	z = Config.place[k].z
end

local blips = {
	
    {title= _U('blip'), colour=1, id=500, x = x, y = y, z = z}
    
}


if Config.Blip == true then  
	Citizen.CreateThread(function()

    	for _, info in pairs(blips) do
      		info.blip = AddBlipForCoord(info.x, info.y, info.z)
      		SetBlipSprite(info.blip, info.id)
      		SetBlipDisplay(info.blip, 4)
      		SetBlipScale(info.blip, 1.0)
      		SetBlipColour(info.blip, info.colour)
      		SetBlipAsShortRange(info.blip, true)
	  		BeginTextCommandSetBlipName("STRING")
      		AddTextComponentString(_U('blip'))
      		EndTextCommandSetBlipName(info.blip)
    	end
	end)
end


