ESX = exports['es_extended']:getSharedObject()

RegisterServerEvent('prx_dineronegro:lavarDinero')
AddEventHandler('prx_dineronegro:lavarDinero', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer.getAccount('black_money').money < amount then
		xPlayer.showNotification(_U('dont_have_money'))
	else
		xPlayer.removeAccountMoney('black_money', amount)
		xPlayer.addMoney(amount)
		xPlayer.showNotification(_U('are_wash1')..amount.._U('are_wash2'))
	end
end)



