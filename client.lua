local DrugPhoneActive = false
local DrugName = nil
local NPCSpawned = false
local GetMission = math.random(1, #Config.DrugPhone.Mission)
local GetSimkort = false
local Kontakter = nil
local GetNPC = nil

local option = {
    {
        name = 'drugphone1',
        icon = Config.DrugPhone.Target.Icon,
        label = Config.DrugPhone.Target.Label,
        onSelect = function()
            ESX.TriggerServerCallback('Oliver_drugphone:GiveReward', function(HasItem) 
                if HasItem then
                    print(GetNPC)
                    print(GetPlayerPed(-1))
                    
                    AttachPropToPlayer("prop_paper_bag_small")

                    RequestAnimDict("mp_common")
                    while not HasAnimDictLoaded("mp_common") do
                        Wait(100)
                    end
            
                    FreezeEntityPosition(GetPlayerPed(-1), true)
            
                    TaskPlayAnim(GetPlayerPed(-1), "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                    TaskPlayAnim(GetNPC, "mp_common", "givetake1_a", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
                    Citizen.Wait(2000)
            
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    ClearPedTasksImmediately(GetNPC)

                    RemoveAttachedProp()

                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    FreezeEntityPosition(GetNPC, false)

                    local ChanceRecommended = math.random(1, 100)

                    if DoesBlipExist(TargetBlip) then
                        RemoveBlip(TargetBlip)
                    end

                    if ChanceRecommended <= Config.DrugPhone.Settings.ChanceToGetRecommended then
                        Kontakter = Kontakter+1
                        Wait(2500)
                        DeleteEntity(GetNPC)
                        exports.ox_target:removeModel(Config.DrugPhone.Mission[GetMission].Settings.MissionPed, 'drugphone1')
                        Wait(2500)
                        StartFindingContact(Kontakter)
                        lib.notify({
                            description = Config.Notifys.GotRecommended,
                            type = 'success'
                        })
                    else
                        Wait(2500)
                        DeleteEntity(GetNPC)
                        exports.ox_target:removeModel(Config.DrugPhone.Mission[GetMission].Settings.MissionPed, 'drugphone1')
                        Wait(2500)
                        StartFindingContact(Kontakter)
                    end
                else
                    lib.notify({
                        description = Config.Notifys.NotEnough,
                        type = 'error'
                    })
                end
            end, DrugName, Kontakter)
        end,
        distance = 2.0
    },
}

local attachedProp = nil

function AttachPropToPlayer(propModel)
    local playerPed = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(playerPed))

    RequestModel(propModel)
    while not HasModelLoaded(propModel) do
        Wait(500)
    end

    local prop = CreateObject(GetHashKey(propModel), x, y, z, true, false, false)
    AttachEntityToEntity(prop, playerPed, GetPedBoneIndex(playerPed, 57005), 0.12, 0.0, 0.0, 0.0, 90.0, 180.0, true, true, false, true, 1, true)
    attachedProp = prop
    Wait(500)
    SetModelAsNoLongerNeeded(propModel)
end

function RemoveAttachedProp()
    if attachedProp then
        DeleteEntity(attachedProp)
        attachedProp = nil
    end
end

RegisterNetEvent('Oliver_drugphone:RemoveSimkort')
AddEventHandler('Oliver_drugphone:RemoveSimkort', function ()
    if GetSimkort then
        if Anim('Fjerner Simkort fra telefonen') then
            GetSimkort = false
            TriggerServerEvent('Oliver_drugphone:RemoveSimkort', Kontakter)
        end
    else
        lib.notify({
            description = Config.Notifys.SimkortNotInPhone,
            type = 'error'
        })
    end
end)

RegisterNetEvent('Oliver_drugphone:InsertSimkort')
AddEventHandler('Oliver_drugphone:InsertSimkort', function(Contacts, slot)
    if not GetSimkort then
        if Contacts == nil then
            lib.notify({
                description = Config.Notifys.NoContacts,
                type = 'info'
            })
            TriggerServerEvent('Oliver_drugphone:AddContact', 1, slot)
        else
            if Anim('Indsætter simkortet i telefonen') then
                ESX.TriggerServerCallback('Oliver_drugphone:InsertSimkort', function(Inserted)
                    if Inserted then
                        GetSimkort = true
                        Kontakter = Contacts
                    end
                end, slot, Contacts) 
            end
        end
    else
        if Anim('Opretter forbindelse til nettet') then
            TriggerEvent('Oliver_drugphone:openMenu', Contacts, DrugName)
        end
    end
end)

RegisterNetEvent('Oliver_drugphone:UsePayPhone')
AddEventHandler('Oliver_drugphone:UsePayPhone', function()
    if not GetSimkort then
        lib.notify({
            description = Config.Notifys.SimkortNotInPhone,
            type = 'error'
        })
        return
    end
    if DrugName then
        TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', 0, true)
        TriggerEvent('Oliver_drugphone:openMenu', Kontakter, DrugName)
    else
        TriggerEvent('Oliver_drugphone:GetDrug', Kontakter)
    end
end)

RegisterNetEvent('Oliver_drugphone:GetDrug')
AddEventHandler('Oliver_drugphone:GetDrug', function(Contacts)
    local input = lib.inputDialog('Drug Phone - Handling', {
        {type = 'select', label = 'Vælg Stof', description = 'Vælg det stof som du gerne vil sælge til dine kunder', options = Config.DrugPhone.Stof, required = true},
    })

    if not input then
        return
    end
    
    DrugName = input[1]

    TriggerEvent('Oliver_drugphone:openMenu', Contacts, DrugName)
end)

AddEventHandler('Oliver_drugphone:openMenu', function (Contacts)
    local option = {}

    if not DrugPhoneActive then
        option = {
            {
                title = 'Kontakter: '..Contacts,
                description = 'Nuværende kunder på dette simkort.',
                icon = 'address-book',
            },
            {
                title = 'Modtager Ikke Opkald.',
                icon = 'wifi',
                iconColor = 'red',
                description = 'Tryk for at ændre din status.',
                onSelect = function()
                    DrugPhoneActive = true
                    lib.notify({
                        description = 'Tilknytter netværket.',
                        type = 'info',
                        duration = 2000,
                        icon = 'wifi',
                    })
                    Wait(2000)
                    TriggerEvent('Oliver_drugphone:openMenu', Contacts)
                    StartFindingContact(Contacts)
                end
            },
            {
                title = 'Sluk for netværket',
                description = 'Sluk mobilen, og du afbryder alt kontakten med dine kunder.',
                icon = 'mobile-retro',
                onSelect = function()
                    DrugName = nil
                end
            },
            {
                description = 'Created By OS DEVELOPMENT'
            }
        }
    else
        option = {
            {
                title = 'Kontakter: '..Contacts,
                description = 'Nuværende kunder på dette simkort.',
                icon = 'address-book',
            },
            {
                title = 'Modtager Opkald.',
                icon = 'wifi',
                iconColor = 'green',
                description = 'Tryk for at ændre din status.',
                onSelect = function()
                    DrugPhoneActive = false
                    lib.notify({
                        description = 'Frakobler netværket.',
                        type = 'info',
                        duration = 2000,
                        icon = 'wifi',
                    })
                    Wait(2000)
                    ESX.TriggerServerCallback('Oliver_drugphone:GetContacts', function(Contacts)
                        TriggerEvent('Oliver_drugphone:openMenu', Contacts)
                    end)
                end
            },
            {
                title = 'Sluk for netværket',
                description = 'Sluk mobilen, og du afbryder alt kontakten med dine kunder.',
                icon = 'mobile-retro',
                onSelect = function()
                    DrugName = nil
                end
            },
            {
                description = 'Created By OS DEVELOPMENT'
            }
        }
    end

    lib.registerContext({
        id = 'drugphone',
        title = 'Drug Phone - Handlinger',
        options = option,
    })
     
    lib.showContext('drugphone')
end)

function StartFindingContact(Contacts)
    local WaitTime = (Config.DrugPhone.Settings.GetContactTime*60000)-(Contacts*(Config.DrugPhone.Settings.GetContactRemoveTime*1000))
    if DrugPhoneActive then

        GetMission = math.random(1, #Config.DrugPhone.Mission)

        AddTextEntry('FINDCONTACT', 'Venter på opkald...')
        BeginTextCommandBusyspinnerOn('FINDCONTACT')
        EndTextCommandBusyspinnerOn(4)
        print(WaitTime)
        if WaitTime < Config.DrugPhone.Settings.MinCooldownTime*1000 then
            Wait(Config.DrugPhone.Settings.MinCooldownTime*1000)
        else
            Wait((Config.DrugPhone.Settings.GetContactTime*60000)-(Contacts*(Config.DrugPhone.Settings.GetContactRemoveTime*1000)))
        end
        print('Fundet kontakt')
        lib.notify({
            title = 'Drug Phone',
            description = 'Du er blevet ringet op af kontakt. Følg GPSen',
            type = 'info',
            icon = 'mobile-retro',
        })
        CreateNPC()
        CreateBlipRoute(Config.DrugPhone.Mission[GetMission].Settings.SpawnPos, 'Kontakt', function(blip)
            TargetBlip = blip
        end)
        BusyspinnerOff()
    end
end

CreateBlipRoute = function(coords, text, cb)
    local blip = AddBlipForCoord(coords.x,  coords.y,  coords.z)
    SetBlipColour(blip, 1)
	SetBlipRoute(blip, true)
    SetBlipSprite(blip, 280)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)

    if cb then
        cb(blip)
    end
end

function CreateNPC()
    if not NPCSpawned then
        lib.RequestModel(Config.DrugPhone.Mission[GetMission].Settings.MissionPed)
        NPC = CreatePed(0, Config.DrugPhone.Mission[GetMission].Settings.MissionPed, Config.DrugPhone.Mission[GetMission].Settings.SpawnPos, false, true)
        FreezeEntityPosition(NPC, true)
        SetBlockingOfNonTemporaryEvents(NPC, true)
        SetEntityInvincible(NPC, true)
        exports.ox_target:addModel(Config.DrugPhone.Mission[GetMission].Settings.MissionPed, option)
        GetNPC = NPC
    end
end

function Anim(Message)
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', 0, true)
    if lib.progressBar({
        duration = 5000,
        label = Message,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
    }) then
        return true 
    end
end