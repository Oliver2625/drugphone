local Simkort = false

ESX.RegisterServerCallback('Oliver_drugphone:InsertSimkort', function(source, cb, slot, Contacts)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local success = exports.ox_inventory:RemoveItem(source, 'simkort', 1, Contacts, slot)
        if success then
            Simkort = true
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('Oliver_drugphone:AddContact')
AddEventHandler('Oliver_drugphone:AddContact', function (Kontakter, slot)
    exports.ox_inventory:RemoveItem(source, 'simkort', 1, nil, slot)
    exports.ox_inventory:AddItem(source, 'simkort', 1, Kontakter, slot)
end)

RegisterNetEvent('Oliver_drugphone:RemoveSimkort')
AddEventHandler('Oliver_drugphone:RemoveSimkort', function (Kontakter)
    exports.ox_inventory:AddItem(source, 'simkort', 1, Kontakter)
end)

ESX.RegisterServerCallback('Oliver_drugphone:GiveReward', function(source, cb, DrugName, Kontakter)
    local xPlayer = ESX.GetPlayerFromId(source)
    local Count = exports.ox_inventory:GetItemCount(source, DrugName)

    local TakeRandomAmount = math.random(Config.DrugPhone.Reward[DrugName].Take.Min, Config.DrugPhone.Reward[DrugName].Take.Max)
    local RewardRandomAmount = math.random(Config.DrugPhone.Reward[DrugName].Reward.Min, Config.DrugPhone.Reward[DrugName].Reward.Max)

    local Bonus = (Kontakter//Config.DrugPhone.Settings.ContactBonus.RequiredContacts*Config.DrugPhone.Settings.ContactBonus.Bonus/100)*(RewardRandomAmount*TakeRandomAmount)

    if xPlayer then
        if Simkort and Count > TakeRandomAmount then
            if Config.DrugPhone.Settings.BlackMoney then
                exports.ox_inventory:RemoveItem(source, DrugName, TakeRandomAmount)
                exports.ox_inventory:AddItem(source, 'black_money', (RewardRandomAmount*TakeRandomAmount)+Bonus)
                cb(true)
            else
                exports.ox_inventory:RemoveItem(source, DrugName, TakeRandomAmount)
                exports.ox_inventory:AddItem(source, 'money', (RewardRandomAmount*TakeRandomAmount)+Bonus)
                cb(true)
            end
        else
            cb(false)
        end
    end
end)