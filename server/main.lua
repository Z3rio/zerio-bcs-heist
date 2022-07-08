local robberyinprogress, doorlocks = false, {}
if GetResourceState("ox_doorlock") == "started" then
    CreateThread(function()
        local doors = MySQL.query.await("SELECT * FROM `ox_doorlock` WHERE `name` LIKE '%bobcatsecurity%'", {})
        for i, v in pairs(doors) do
            doorlocks[v.name] = tonumber(v.id)
        end
    end)
end

-- ITEM RELATED
CreateCallback("zerio-bcs-heist:server:takegold", function(source, cb)
    if GetResourceState("qb-core") == "started" then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddItem("goldbar", 1)
        TriggerClientEvent("inventory:client:ItemBox", Player.PlayerData.source, QBCore.Shared.Items["goldbar"], "add")
    end

    if GetResourceState("es_extended") == "started" then
        local Player = ESX.GetPlayerFromId(source)
        Player.addInventoryItem("goldbar", 1)
    end
end)

CreateCallback("zerio-bcs-heist:server:hasitem", function(source, cb, item)
    if GetResourceState("qb-core") == "started" then
        local Player = QBCore.Functions.GetPlayer(source)
        local item = Player.Functions.GetItemByName(item)
        if item then
            cb(true)
            return
        end
        cb(false)
    end

    if GetResourceState("es_extended") == "started" then
        local Player = ESX.GetPlayerFromId(source)
        for k, v in ipairs(Player.inventory) do
            if (v.name == item) and (v.count >= 1) then
                cb(true)
                return
            end
        end
        cb(false)
    end
end)

CreateCallback("zerio-bcs-heist:server:takemoney", function(source, cb)
    if GetResourceState("qb-core") == "started" then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.AddItem("moneybag", 1, false, {
            cash = math.random(Config.MoneyLootWorth[1], Config.MoneyLootWorth[2])
        })
        TriggerClientEvent("inventory:client:ItemBox", Player.PlayerData.source, QBCore.Shared.Items["moneybag"], "add")
    end

    if GetResourceState("es_extended") == "started" then
        local Player = ESX.GetPlayerFromId(source)
        Player.addAccountMoney("black_money", math.random(Config.MoneyLootWorth[1], Config.MoneyLootWorth[2]))
    end
end)

CreateCallback("zerio-bcs-heist:server:getpolicecount", function(source, cb)
    local count = 0
    if GetResourceState("qb-core") == "started" then
        for i, v in pairs(QBCore.Functions.GetQBPlayers()) do
            if v.PlayerData.job.name == "police" and (v.PlayerData.job.onduty == true or Config.RequireOnDuty == false) then
                count = count + 1
            end
        end
    end

    if GetResourceState("es_extended") == "started" then
        for i, v in pairs(ESX.GetPlayers()) do
            local Player = ESX.GetPlayerFromId(v)
            if Player.job.name == "police" then
                count = count + 1
            end
        end
    end

    cb(count)
end)

-- DOORLOCKS
RegisterNetEvent("zerio-doorlock:server:ox_doorlock-setState")
AddEventHandler("zerio-doorlock:server:ox_doorlock-setState", function(name, state)
    if GetResourceState("ox_doorlock") == "started" then
        if string.find(name, "bobcatsecurity") ~= nil then
            if doorlocks[name] ~= nil then
                TriggerClientEvent("ox_doorlock:setState", -1, doorlocks[name], state, nil, nil)
            else
                print("Door with name " .. name .. " doesn't exist")
            end
        else
            print("Door with name " .. name .. " is not authorized")
            DropPlayer(source, "Exploiting")
        end
    else
        DropPlayer(source, "Exploiting")
    end
end)

-- OTHER
RegisterNetEvent("zerio-bcs-heist:server:robberydone")
AddEventHandler("zerio-bcs-heist:server:robberydone", function()
    if robberyinprogress == true then
        robberyinprogress = false
    else
        DropPlayer(source, "Exploiting")
    end
end)

-- SYNC
RegisterNetEvent("zerio-bcs-heist:server:sync")
AddEventHandler("zerio-bcs-heist:server:sync", function(burnpos)
    if robberyinprogress == false then
        TriggerClientEvent("zerio-bcs-heist:client:sync", -1, burnpos)
        robberyinprogress = true
        moneyleft = #Config.Positions.money
        goldleft = #Config.Positions.gold
    else
        DropPlayer(source, "Exploiting")
    end
end)

RegisterNetEvent("zerio-bcs-heist:server:sync2")
AddEventHandler("zerio-bcs-heist:server:sync2", function(burnpos)
    if robberyinprogress then
        TriggerClientEvent("zerio-bcs-heist:client:sync2", -1, burnpos)
    else
        DropPlayer(source, "Exploiting")
    end
end)

RegisterNetEvent("zerio-bcs-heist:server:sync3")
AddEventHandler("zerio-bcs-heist:server:sync3", function(burnpos)
    if robberyinprogress then
        TriggerClientEvent("zerio-bcs-heist:client:sync3", -1)
    else
        DropPlayer(source, "Exploiting")
    end
end)

RegisterNetEvent("zerio-bcs-heist:server:synctrolley")
AddEventHandler("zerio-bcs-heist:server:synctrolley", function(type, index)
    if robberyinprogress then
        TriggerClientEvent("zerio-bcs-heist:client:synctrolleyprompt", -1, type, index)
    else
        DropPlayer(source, "Exploiting")
    end
end)

-- REMOVE ITEMS
RegisterNetEvent("zerio-bcs-heist:server:removethermite")
AddEventHandler("zerio-bcs-heist:server:removethermite", function()
    Functions.RemoveItem("thermite", 1)
end)

RegisterNetEvent("zerio-bcs-heist:server:removebcscard")
AddEventHandler("zerio-bcs-heist:server:removebcscard", function()
    Functions.RemoveItem("bcssecuritycard", 1)
end)

RegisterNetEvent("zerio-bcs-heist:server:removec4")
AddEventHandler("zerio-bcs-heist:server:removec4", function()
    Functions.RemoveItem("c4", 1)
end)
