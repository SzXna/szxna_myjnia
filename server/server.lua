ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) esx = obj end)

RegisterServerEvent('szxna_myjnia:checkmoney')
AddEventHandler('szxna_myjnia:checkmoney', function ()
    local _source = source
    local xPlayer = esx.GetPlayerFromId(_source)
    if xPlayer.getMoney() >= config.price then
        xPlayer.removeMoney(config.price)
        TriggerClientEvent('szxna_myjnia:success', _source, config.price)
    else
        TriggerClientEvent('szxna_myjnia:notenoughmoney', _source)
    end
end)