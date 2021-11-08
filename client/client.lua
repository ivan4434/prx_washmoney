local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)



function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        for k in pairs(Config.place) do
          local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.place[k].x, Config.place[k].y, Config.place[k].z)
            if dist <= Config.DrawDistance then
              DrawMarker(Config.Marker.type, Config.place[k].x, Config.place[k].y, Config.place[k].z, 0, 0, 0, 0, 0, 0, Config.Marker.size.x, Config.Marker.size.y, Config.Marker.size.z, Config.Marker.color.r, Config.Marker.color.g, Config.Marker.color.b, 200, 0, 0, 0, 0)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        for k in pairs(Config.place) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.place[k].x, Config.place[k].y, Config.place[k].z)

            if dist <= 0.5 then
                --doesnt spam notifcations only shows top corner
                hintToDisplay(_U('wash_money?'))
				
				if IsControlJustPressed(0, Keys['E']) then -- "E"
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
      TriggerServerEvent('prx_dineronegro:lavarDinero', amount, 'rTQ(@CwZjhU')
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


