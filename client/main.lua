Citizen.CreateThread(function()
    Functions.Reset()

    local blip = AddBlipForCoord(Config.Blip.position.x, Config.Blip.position.y, Config.Blip.position.z)
    SetBlipSprite(blip, Config.Blip.sprite)
    SetBlipColour(blip, Config.Blip.color)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, Config.Blip.scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.Blip.text)
    EndTextCommandSetBlipName(blip)

    RegisterNetEvent("zerio-bcs-heist:client:synctrolleyprompt")
    AddEventHandler("zerio-bcs-heist:client:synctrolleyprompt", function(type, index)
        if trolleys[tostring(type) .. "prompts"][index] then
            trolleys[tostring(type) .. "prompts"][index]:Remove()
        end
    end)

    RegisterNetEvent("zerio-bcs-heist:client:sync")
    AddEventHandler("zerio-bcs-heist:client:sync", function(burnpos)
        Citizen.CreateThread(function()
            Citizen.Wait(Config.ResetTime)
            Functions.Reset()
        end)

        if currentprompt ~= nil then
            currentprompt:Remove()
            currentprompt = nil
        end

        RequestNamedPtfxAsset("scr_ornate_heist")
        while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
            Citizen.Wait(1)
        end
        SetPtfxAssetNextCall("scr_ornate_heist")
        local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", burnpos, 0.0, 0.0, 0.0, 1.0, false,
            false, false, false)
        Citizen.Wait(13000)
        StopParticleFxLooped(effect, 0)

        currentprompt = exports["zerio-proximityprompt"]:AddNewPrompt({
            name = "bobcatsecurity-placethermite2",
            objecttext = "Bobcat Security",
            actiontext = Lang:t("prompt.placethermite"),
            holdtime = 2500,
            key = "E",
            position = Config.Positions.thermite2.prompt,
            usage = function()
                TriggerCallback("zerio-bcs-heist:server:hasitem", function(result)
                    if result then
                        SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
                        FreezeEntityPosition(PlayerPedId(), true)
                        exports["memorygame"]:thermiteminigame(5, 5, 3, 10, function()
                            FreezeEntityPosition(PlayerPedId(), false)
                            currentprompt:Remove()
                            TriggerServerEvent("zerio-bcs-heist:server:removethermite")
                            Functions.Notify(Lang:t("success.hackingcompleted"), "success")
                            Functions.ThermiteAnimation(Config.Positions.thermite2.playerpos,
                                Config.Positions.thermite2.burnpos, "2")
                            Functions.UpdateDoor("bobcatsecurity-seconddoor", false)
                            Functions.Notify(Lang:t("success.thermite"), "success")
                        end, function()
                            FreezeEntityPosition(PlayerPedId(), false)
                            Functions.Notify(Lang:t("error.hackingfailed"), "error")
                        end)
                    else
                        Functions.Notify(Lang:t("error.donthavethermite"), "error")
                    end
                end, "thermite")
            end
        })
    end)

    RegisterNetEvent("zerio-bcs-heist:client:sync2")
    AddEventHandler("zerio-bcs-heist:client:sync2", function(burnpos)
        if currentprompt ~= nil then
            currentprompt:Remove()
            currentprompt = nil
        end
        RequestNamedPtfxAsset("scr_ornate_heist")
        while not HasNamedPtfxAssetLoaded("scr_ornate_heist") do
            Citizen.Wait(1)
        end
        SetPtfxAssetNextCall("scr_ornate_heist")
        local effect = StartParticleFxLoopedAtCoord("scr_heist_ornate_thermal_burn", burnpos, 0.0, 0.0, 0.0, 1.0, false,
            false, false, false)
        Citizen.Wait(13000)
        StopParticleFxLooped(effect, 0)

        currentprompt = exports["zerio-proximityprompt"]:AddNewPrompt({
            name = "bobcatsecurity-swipesecuritycard",
            objecttext = "Bobcat Security",
            actiontext = Lang:t("prompt.swipecard"),
            holdtime = 2500,
            key = "E",
            position = Config.Positions.securitycard.prompt,
            usage = function()
                TriggerCallback("zerio-bcs-heist:server:hasitem", function(result)
                    if result then
                        if currentlydatacracking == false then
                            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
                            FreezeEntityPosition(PlayerPedId(), true)
                            if currentprompt ~= nil then
                                currentprompt:Remove()
                                currentprompt = nil
                            end

                            currentlydatacracking = true
                            exports["datacrack"]:Start(6.0)
                        else
                            Functions.Notify(Lang:t("error.alreadyswiping"), "error")
                        end
                    else
                        Functions.Notify(Lang:t("error.donthavesecuritycard"), "error")
                    end
                end, "bcssecuritycard")
            end
        })
    end)

    RegisterNetEvent("zerio-bcs-heist:client:sync3")
    AddEventHandler("zerio-bcs-heist:client:sync3", function(burnpos)
        if currentprompt ~= nil then
            currentprompt:Remove()
            currentprompt = nil
        end

        Functions.OpenSafe()

        trolleys.goldprompts = {}
        trolleys.moneyprompts = {}

        for i, v in pairs(Config.Positions.gold) do
            local prompt = exports["zerio-proximityprompt"]:AddNewPrompt({
                name = "bobcatsecurity-takegold" .. tostring(i),
                objecttext = "Bobcat Security",
                actiontext = Lang:t("prompt.takegold"),
                holdtime = 2500,
                key = "E",
                position = vector3(v.x, v.y, v.z),
                usage = function()
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
                    FreezeEntityPosition(PlayerPedId(), true)
                    Functions.LootTrolley("gold", i)
                end
            })

            trolleys.goldprompts[i] = prompt
            table.insert(promptsToRemove, prompt)
        end

        for i, v in pairs(Config.Positions.money) do
            local prompt = exports["zerio-proximityprompt"]:AddNewPrompt({
                name = "bobcatsecurity-takemoney" .. tostring(i),
                objecttext = "Bobcat Security",
                actiontext = Lang:t("prompt.takemoney"),
                holdtime = 2500,
                key = "E",
                position = vector3(v.x, v.y, v.z),
                usage = function()
                    SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), true)
                    FreezeEntityPosition(PlayerPedId(), true)
                    Functions.LootTrolley("money", i)
                end
            })

            trolleys.moneyprompts[i] = prompt
            table.insert(promptsToRemove, prompt)
        end
    end)

    RegisterNetEvent("datacrack")
    AddEventHandler("datacrack", function(output)
        if currentlydatacracking then
            FreezeEntityPosition(PlayerPedId(), false)
            currentlydatacracking = false
            if output then
                TriggerServerEvent("zerio-bcs-heist:server:removebcscard")

                local ped = PlayerPedId()
                local targetPosition, targetRotation = (vec3(GetEntityCoords(ped))), vec3(GetEntityRotation(ped))

                RequestAnimDict("anim@heists@ornate_bank@hack")
                RequestModel("hei_prop_heist_card_hack_02")
                while not HasAnimDictLoaded("anim@heists@ornate_bank@hack") or
                    not HasModelLoaded("hei_prop_heist_card_hack_02") do
                    Citizen.Wait(100)
                end

                SetEntityHeading(ped, Config.Positions.securitycard.playerpos.w)
                local animPos = GetAnimInitialOffsetPosition("anim@heists@ornate_bank@hack", "hack_enter",
                    Config.Positions.securitycard.playerpos.x, Config.Positions.securitycard.playerpos.y,
                    Config.Positions.securitycard.playerpos.z, Config.Positions.securitycard.playerpos.x,
                    Config.Positions.securitycard.playerpos.y, Config.Positions.securitycard.playerpos.z, 0, 2)

                FreezeEntityPosition(ped, true)
                local netScene = NetworkCreateSynchronisedScene(animPos, targetRotation, 2, false, false, 1065353216, 0,
                    1.3)
                local card = CreateObject(GetHashKey("hei_prop_heist_card_hack_02"), targetPosition, 1, 1, 0)

                NetworkAddPedToSynchronisedScene(ped, netScene, "anim@heists@ornate_bank@hack", "hack_enter", 1.5, -4.0,
                    1, 16, 1148846080, 0)
                NetworkAddEntityToSynchronisedScene(card, netScene, "anim@heists@ornate_bank@hack", "hack_enter_card",
                    4.0, -8.0, 1)

                NetworkStartSynchronisedScene(netScene)
                Citizen.Wait(6300)
                DeleteObject(card)
                FreezeEntityPosition(ped, false)
                SetPedComponentVariation(ped, 5, 45, 0, 0)

                Functions.UpdateDoor("bobcatsecurity-thirddoor", false)
                Functions.Notify(Lang:t("success.hackingcompleted"), "success")

                local playerped = PlayerPedId()
                RequestModel(Config.PedHash)
                while not HasModelLoaded(Config.PedHash) do
                    Citizen.Wait(0)
                end
                AddRelationshipGroup("Guards")
                for i, v in pairs(Config.Positions.npcs) do
                    local ped = CreatePed(28, Config.PedHash, v.x, v.y, v.z - 1, 0.0, true, true)
                    SetEntityHeading(ped, v.w)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    SetPedRelationshipGroupHash(ped, "Guards")
                    SetPedAccuracy(ped, 50)
                    SetPedCombatAttributes(ped, 46, true)
                    SetPedFleeAttributes(ped, 0, 0)
                    GiveWeaponToPed(ped, GetHashKey("WEAPON_PISTOL"), math.random(20, 100), false, false)
                    TaskCombatPed(ped, playerped, 0, 16)
                    table.insert(npcsToRemove, ped)
                end

                currentprompt = exports["zerio-proximityprompt"]:AddNewPrompt({
                    name = "bobcatsecurity-placec4",
                    objecttext = "Bobcat Security",
                    actiontext = Lang:t("prompt.placec4"),
                    holdtime = 2500,
                    key = "E",
                    position = Config.Positions.vault.prompt,
                    usage = function()
                        TriggerCallback("zerio-bcs-heist:server:hasitem", function(result)
                            if result then
                                if currentlydatacracking2 == false then
                                    if currentprompt ~= nil then
                                        currentprompt:Remove()
                                        currentprompt = nil
                                    end

                                    currentlydatacracking2 = true
                                    exports["datacrack"]:Start(6.0)
                                else
                                    Functions.Notify(Lang:t("error.alreadyswiping"), "error")
                                end
                            else
                                Functions.Notify(Lang:t("error.donthavec4"), "error")
                            end
                        end, "c4")
                    end
                })
            else
                currentprompt = exports["zerio-proximityprompt"]:AddNewPrompt({
                    name = "bobcatsecurity-swipesecuritycard",
                    objecttext = "Bobcat Security",
                    actiontext = Lang:t("prompt.swipecard"),
                    holdtime = 2500,
                    key = "E",
                    position = Config.Positions.securitycard.prompt,
                    usage = function()
                        TriggerCallback("zerio-bcs-heist:server:hasitem", function(result)
                            if result then
                                currentlydatacracking = true
                                if currentprompt ~= nil then
                                    currentprompt:Remove()
                                    currentprompt = nil
                                end
                                exports["datacrack"]:Start(3.0)
                            else
                                Functions.Notify(Lang:t("error.donthavesecuritycard"), "error")
                            end
                        end, "bcssecuritycard")
                    end
                })
                Functions.Notify(Lang:t("error.hackingfailed"), "error")
            end
        end

        if currentlydatacracking2 then
            FreezeEntityPosition(PlayerPedId(), false)
            currentlydatacracking2 = false
            if output then
                TriggerServerEvent("zerio-bcs-heist:server:removec4")
                Functions.C4Animation(Config.Positions.vault.playerpos)
                TriggerServerEvent("zerio-bcs-heist:server:sync3")
            else
                currentprompt = exports["zerio-proximityprompt"]:AddNewPrompt({
                    name = "bobcatsecurity-placec4",
                    objecttext = "Bobcat Security",
                    actiontext = Lang:t("prompt.placec4"),
                    holdtime = 2500,
                    key = "E",
                    position = Config.Positions.vault.prompt,
                    usage = function()
                        TriggerCallback("zerio-bcs-heist:server:hasitem", function(result)
                            if result then
                                if currentlydatacracking2 == false then
                                    if currentprompt ~= nil then
                                        currentprompt:Remove()
                                        currentprompt = nil
                                    end

                                    currentlydatacracking2 = true
                                    exports["datacrack"]:Start(6.0)
                                else
                                    Functions.Notify(Lang:t("error.alreadyswiping"), "error")
                                end
                            else
                                Functions.Notify(Lang:t("error.donthavec4"), "error")
                            end
                        end, "c4")
                    end
                })
            end
        end
    end)

    local curResName = GetCurrentResourceName()
    RegisterNetEvent("onResourceStop")
    AddEventHandler('onResourceStop', function(resourceName)
        if resourceName == curResName then
            if currentprompt ~= nil then
                currentprompt:Remove()
                currentprompt = nil
            end

            for i, v in pairs(promptsToRemove) do
                if v ~= nil then
                    v:Remove()
                end
            end

            for i, v in pairs(npcsToRemove) do
                if v ~= nil then
                    DeleteEntity(v)
                end
            end

            for i, v in pairs(trolleys.money) do
                if v ~= nil then
                    DeleteEntity(v)
                end
            end

            for i, v in pairs(trolleys.gold) do
                if v ~= nil then
                    DeleteEntity(v)
                end
            end
        end
    end)
end)
