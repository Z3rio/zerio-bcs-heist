local lootleft = 0
trolleys, currentprompt, currentlydatacracking, currentlydatacracking2, npcsToRemove, promptsToRemove, doors = {
    gold = {},
    goldprompts = {},
    money = {},
    moneyprompts = {}
}, nil, false, false, {}, {}, nil
isProximityPromptsLoaded = false

if GetResourceState("qb-core") == "started" then
    QBCore = exports['qb-core']:GetCoreObject()
    TriggerCallback = QBCore.Functions.TriggerCallback
end
if GetResourceState("es_extended") == "started" then
    CreateThread(function()
        if ESX == nil then
            while ESX == nil do
                TriggerEvent("esx:getSharedObject", function(obj)
                    ESX = obj
                end)
                Citizen.Wait(250)
            end
        end

        TriggerCallback = ESX.TriggerServerCallback
    end)
end

Functions = {
    awaitProximityPrompt = function()
        while isProximityPromptsLoaded == false do
            Wait(100)
        end
    end,

    Reset = function()
        if currentprompt ~= nil then
            currentprompt:Remove()
            currentprompt = nil
        end

        for i, v in pairs(promptsToRemove) do
            if v ~= nil then
                v:Remove()
            end
        end
        promptsToRemove = {}

        for i, v in pairs(npcsToRemove) do
            if v ~= nil then
                DeleteEntity(v)
            end
        end
        npcsToRemove = {}

        for i, v in pairs(trolleys.money) do
            if v ~= nil then
                DeleteEntity(v)
            end
        end
        trolleys.money = {}

        RequestModel("hei_prop_hei_cash_trolly_01")
        for i, v in pairs(Config.Positions.money) do
            local trolley = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), v.x, v.y, 30.2303, 1, 0, 0)
            SetEntityHeading(trolley, v.w)
            PlaceObjectOnGroundProperly(trolley)
            FreezeEntityPosition(trolley, true)
            table.insert(trolleys.money, trolley)
        end

        for i, v in pairs(trolleys.gold) do
            if v ~= nil then
                DeleteEntity(v)
            end
        end
        trolleys.gold = {}

        RequestModel("ch_prop_gold_trolly_01a")
        for i, v in pairs(Config.Positions.gold) do
            local trolley = CreateObject(GetHashKey("ch_prop_gold_trolly_01a"), v.x, v.y, 30.2303, 1, 0, 0)
            SetEntityHeading(trolley, v.w)
            PlaceObjectOnGroundProperly(trolley)
            FreezeEntityPosition(trolley, true)
            table.insert(trolleys.gold, trolley)
        end

        Functions.ResetDoors()
        Functions.CloseSafe()

        Functions.awaitProximityPrompt()
        currentprompt = exports["zerio-proximityprompt"]:AddNewPrompt({
            name = "bobcatsecurity-placethermite",
            objecttext = "Bobcat Security",
            actiontext = Lang:t("prompt.placethermite"),
            holdtime = 2500,
            key = "E",
            position = Config.Positions.thermite1.prompt,
            usage = function()
                TriggerCallback("zerio-bcs-heist:server:hasitem", function(result)
                    if result then
                        TriggerCallback("zerio-bcs-heist:server:getpolicecount", function(count)
                            if count >= Config.PoliceNeeded then
                                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
                                DisableAllControlActions()
                                FreezeEntityPosition(PlayerPedId(), true)
                                exports["memorygame"]:thermiteminigame(5, 5, 3, 10, function()
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    if currentprompt ~= nil then
                                        currentprompt:Remove()
                                        currentprompt = nil
                                    end
                                    TriggerServerEvent("zerio-bcs-heist:server:removethermite")
                                    Functions.Notify(Lang:t("success.hackingcompleted"), "success")
                                    Functions.ThermiteAnimation(Config.Positions.thermite1.playerpos,
                                        Config.Positions.thermite1.burnpos, "")
                                    Functions.UpdateDoor("bobcatsecurity-maindoor", false)
                                    Functions.Notify(Lang:t("success.thermite"), "success")
                                end, function()
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    Functions.Notify(Lang:t("error.hackingfailed"), "error")
                                end)
                            else
                                Functions.Notify(Lang:t("error.notenoughpolice"), "error")
                            end
                        end)
                    else
                        Functions.Notify(Lang:t("error.donthavethermite"), "error")
                    end
                end, "thermite")
            end,
            drawdist = 3,
            usagedist = 1.5
        })
    end,

    UpdateDoor = function(id, state)
        if GetResourceState("qb-doorlock") == "started" then
            TriggerServerEvent("qb-doorlock:server:updateState", id, state, nil, false, true, false, false, nil)
        end
        if GetResourceState("ox_doorlock") == "started" then
            TriggerServerEvent("zerio-doorlock:server:ox_doorlock-setState", id, state)
        end
    end,

    Notify = function(text, type, duration)
        if GetResourceState("qb-core") == "started" then
            TriggerEvent("QBCore:Notify", text, type, duration)
        end
        if GetResourceState("es_extended") == "started" then
            TriggerEvent("esx:showNotification", text, type, duration)
        end
    end,

    ResetDoors = function()
        Functions.UpdateDoor("bobcatsecurity-maindoor", true)
        Functions.UpdateDoor("bobcatsecurity-seconddoor", true)
        Functions.UpdateDoor("bobcatsecurity-unentrabledoor", true)
        Functions.UpdateDoor("bobcatsecurity-thirddoor", true)
    end,

    OpenSafe = function()
        CreateModelSwap(888.12, -2129.87, 29.23, 7.5, GetHashKey("des_vaultdoor001_start"),
            GetHashKey("des_vaultdoor001_end"), 1)
    end,

    CloseSafe = function()
        CreateModelSwap(888.12, -2129.87, 29.23, 7.5, GetHashKey("des_vaultdoor001_end"),
            GetHashKey("des_vaultdoor001_start"), 1)
    end,

    ThermiteAnimation = function(pedpos, burnpos, idx)
        local ped = PlayerPedId()
        RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
        RequestModel("hei_p_m_bag_var22_arm_s")
        RequestNamedPtfxAsset("scr_ornate_heist")
        while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and
            not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
            Citizen.Wait(50)
        end
        SetEntityHeading(ped, pedpos.w)

        Citizen.Wait(100)

        local rotx, roty, rotz = table.unpack(vec3(GetEntityRotation(ped)))
        local bagscene = NetworkCreateSynchronisedScene(pedpos.x, pedpos.y, pedpos.z, rotx, roty, rotz + 170.0, 2,
            false, false, 1065353216, 0, 1.3)
        local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), pedpos.x, pedpos.y, pedpos.z, true, true, false)
        SetEntityCollision(bag, false, true)
        NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5,
            -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge",
            "bag_thermal_charge", 4.0, -8.0, 1)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        NetworkStartSynchronisedScene(bagscene)

        Citizen.Wait(1500)

        local x, y, z = table.unpack(GetEntityCoords(ped))
        local thermite = CreateObject(GetHashKey("hei_prop_heist_thermite"), x, y, z + 0.2, true, true, true)
        SetEntityCollision(thermite, false, true)
        AttachEntityToEntity(thermite, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true,
            1, true)
        Citizen.Wait(4000)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        DetachEntity(thermite, 1, 1)
        FreezeEntityPosition(thermite, true)

        TriggerServerEvent("zerio-bcs-heist:server:sync" .. idx, burnpos)
        SetPtfxAssetNextCall("scr_ornate_heist")

        local burn = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", burnpos, 0.0, 0.0, 0.0, 1.0, false,
            false, false, false)
        NetworkStopSynchronisedScene(bagscene)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_intro", 8.0, 8.0, 1000, 36, 1, 0, 0, 0)
        TaskPlayAnim(ped, "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, 8.0, 9000, 49, 1, 0, 0, 0)
        Citizen.Wait(10000)
        StopParticleFxLooped(burn, 0)
        ClearPedTasks(ped)

        Citizen.Wait(1000)

        DeleteObject(thermite)
        FreezeEntityPosition(PlayerPedId(), false)
    end,

    C4Animation = function(pedpos)
        local ped = PlayerPedId()
        RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
        RequestModel("hei_p_m_bag_var22_arm_s")
        RequestModel("prop_bomb_01")
        while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and
            not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasModelLoaded("prop_bomb_01") do
            Citizen.Wait(50)
        end
        SetEntityHeading(ped, pedpos.w)
        Citizen.Wait(100)
        local rot = vec3(GetEntityRotation(ped))
        local bagscene = NetworkCreateSynchronisedScene(pedpos.x - 0.70, pedpos.y + 0.50, pedpos.z, rot, 2, false,
            false, 1065353216, 0, 1.3)
        local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), pedpos.x, pedpos.y, pedpos.z, true, true, false)
        NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5,
            -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge",
            "bag_thermal_charge", 4.0, -8.0, 1)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        NetworkStartSynchronisedScene(bagscene)
        Citizen.Wait(1500)
        local x, y, z = table.unpack(GetEntityCoords(ped))
        local c4 = CreateObject(GetHashKey("prop_bomb_01"), x, y, z + 0.2, true, true, true)
        AttachEntityToEntity(c4, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1,
            true)
        Citizen.Wait(3000)
        DeleteObject(bag)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        DetachEntity(c4, 1, 1)
        FreezeEntityPosition(c4, true)
        NetworkStopSynchronisedScene(bagscene)
        Citizen.Wait(15000)
        AddExplosion(888.3242, -2130.5498, 31.2301, 43, 2.5, true, false, 1.0, true)
        DeleteEntity(c4)
        FreezeEntityPosition(PlayerPedId(), false)
    end,

    LootTrolley = function(type, index)
        TriggerServerEvent("zerio-bcs-heist:server:synctrolley", type, index)
        lootleft = math.random(Config.MoneyLootAmount[1], Config.MoneyLootAmount[2]) + 1
        local orglootleft = lootleft
        if type == "gold" then
            lootleft = math.random(Config.GoldLootAmount[1], Config.GoldLootAmount[2])
        end
        Trolley = nil
        local ped = PlayerPedId()
        local model = "hei_prop_heist_cash_pile"

        if type == "money" then
            Trolley = GetClosestObjectOfType(Config.Positions.money[index].x, Config.Positions.money[index].y,
                Config.Positions.money[index].z, 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
        elseif type == "gold" then
            Trolley = GetClosestObjectOfType(Config.Positions.gold[index].x, Config.Positions.gold[index].y,
                Config.Positions.gold[index].z, 1.0, GetHashKey("ch_prop_gold_trolly_01a"), false, false, false)
            model = "ch_prop_gold_bar_01a"
        end

        local emptyobj = 769923921

        if currentgrab == 4 or currentgrab == 5 then
            emptyobj = 2714348429
        end
        if IsEntityPlayingAnim(Trolley, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
            return
        end
        local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

        RequestAnimDict("anim@heists@ornate_bank@grab_cash")
        RequestModel(baghash)
        RequestModel(emptyobj)
        while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and
            not HasModelLoaded(baghash) do
            Citizen.Wait(100)
        end
        while not NetworkHasControlOfEntity(Trolley) do
            Citizen.Wait(1)
            NetworkRequestControlOfEntity(Trolley)
        end

        GrabBag =
            CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
        Grab1 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false,
            1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Grab1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16,
            1148846080, 0)
        NetworkAddEntityToSynchronisedScene(GrabBag, Grab1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0,
            1)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        NetworkStartSynchronisedScene(Grab1)

        Citizen.Wait(1500)

        local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
        end
        local grabobj = CreateObject(grabmodel, pedCoords, true)

        FreezeEntityPosition(grabobj, true)
        SetEntityInvincible(grabobj, true)
        SetEntityNoCollisionEntity(grabobj, ped)
        SetEntityVisible(grabobj, false, false)
        AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false,
            false, false, 0, true)
        local startedGrabbing = GetGameTimer()

        Citizen.CreateThread(function()
            while GetGameTimer() - startedGrabbing < 37000 do
                Citizen.Wait(1)
                DisableControlAction(0, 73, true)
                if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
                    if not IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, true, false)
                    end
                end
                if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
                    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                    end
                end
            end
            DeleteObject(grabobj)
        end)

        Citizen.CreateThread(function()
            while lootleft ~= 1 do
                lootleft = lootleft - 1
                if type == "money" then
                    TriggerCallback("zerio-bcs-heist:server:takemoney", function()
                    end)
                elseif type == "gold" then
                    TriggerCallback("zerio-bcs-heist:server:takegold", function()
                    end)
                end
                Citizen.Wait(37000 / orglootleft)
            end
        end)

        Grab2 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false,
            1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Grab2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16,
            1148846080, 0)
        NetworkAddEntityToSynchronisedScene(GrabBag, Grab2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0,
            1)
        NetworkAddEntityToSynchronisedScene(Trolley, Grab2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear",
            4.0, -8.0, 1)
        NetworkStartSynchronisedScene(Grab2)
        Citizen.Wait(37000)
        Grab3 = NetworkCreateSynchronisedScene(GetEntityCoords(Trolley), GetEntityRotation(Trolley), 2, false, false,
            1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, Grab3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16,
            1148846080, 0)
        NetworkAddEntityToSynchronisedScene(GrabBag, Grab3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0,
            1)
        NetworkStartSynchronisedScene(Grab3)
        local coords, rot = GetEntityCoords(Trolley), GetEntityRotation(Trolley)
        while not NetworkHasControlOfEntity(Trolley) do
            Citizen.Wait(1)
            NetworkRequestControlOfEntity(Trolley)
        end
        DeleteObject(Trolley)
        NewTrolley = CreateObject(emptyobj, coords + vector3(0.0, 0.0, -0.985), true, false, false)
        if type == "gold" then
            table.insert(trolleys.gold, NewTrolley)
        else
            table.insert(trolleys.money, NewTrolley)
        end
        SetEntityRotation(NewTrolley, rot)
        PlaceObjectOnGroundProperly(NewTrolley)
        Citizen.Wait(1800)
        if DoesEntityExist(GrabBag) then
            DeleteEntity(GrabBag)
        end
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
        SetModelAsNoLongerNeeded(emptyobj)
        SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))

        if #trolleys.goldprompts == 0 and #trolleys.moneyprompts == 0 then
            TriggerServerEvent("zerio-bcs-heist:server:robberydone")
        end
        FreezeEntityPosition(PlayerPedId(), false)
    end
}

Functions.Reset()
