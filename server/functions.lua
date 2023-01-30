if GetResourceState("qb-core") == "started" then
    QBCore = exports['qb-core']:GetCoreObject()
    CreateCallback = QBCore.Functions.CreateCallback
end

if GetResourceState("es_extended") == "started" then
    if ESX == nil then
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
    
    CreateCallback = ESX.RegisterServerCallback
end

Functions = {
    RemoveItem = function(item, amount)
        if GetResourceState("qb-core") == "started" then
            local Player = QBCore.Functions.GetPlayer(source)
            Player.Functions.RemoveItem(item, amount)
            TriggerClientEvent("inventory:client:ItemBox", Player.PlayerData.source, QBCore.Shared.Items[item], "remove")
        end

        if GetResourceState("es_extended") == "started" then
            local Player = ESX.GetPlayerFromId(source)
            Player.removeInventoryItem(item, amount)
        end
    end
}
