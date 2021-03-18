ESX = nil
Citizen.CreateThread(function()
    if config.ESX then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

RegisterCommand('revive', function(source, args, rawCommand)
    if config.selfRevTime ~= false then
        if config.selfRevWebhook ~= false then
            discordLog(source, source, config.selfRevWebhook)
        end
        return TriggerClientEvent('deerAdrev:adrev',source, source, source, false)
    end
end)

RegisterCommand('respawn', function(source, args, rawCommand)
    if config.selfResTime ~= false then
        if config.selfResWebhook ~= false then
            discordLog(source, source, config.selfResWebhook)
        end
        return TriggerClientEvent('deerAdrev:adres',source, source, source, false)
    end
end)

RegisterCommand('adrev', function(source, args, rawCommand)
    local allowed = {} -- Who can run the command, accepts steamID, discordID, or ace permissions
    if isSourceAllowed(source, config.adrev.allowed) then
        if #args == 1 and tonumber(args[1]) then
            local target = tonumber(args[1])
            if GetPlayerName(target) then
                if config.adrev.webhook ~= false then
                    discordLog(source, target, config.adrev.webhook)
                end
                return TriggerClientEvent('deerAdrev:adrev', target,target, source, false)
            end
        end
    else
        TriggerClientEvent('deerAdrev:notif:ret', source, "You do not have permission to use /adrev")
    end
end)

RegisterCommand('adres', function(source, args, rawCommand)
    local allowed = {} -- Who can run the command, accepts steamID, discordID, or ace permissions
    if isSourceAllowed(source, config.adres.allowed) then
        if #args == 1 and tonumber(args[1]) then
            local target = tonumber(args[1])
            if GetPlayerName(target) then
                if config.adrev.webhook ~= false then
                    discordLog(source, target, config.adres.webhook)
                end
                TriggerClientEvent('deerAdrev:adres',target,target, source, false)
            end
        end
    else
        TriggerClientEvent('deerAdrev:notif:ret', source, "You do not have permission to use /adres")
    end
end)

RegisterCommand('adrevall', function(source, args, rawCommand)
    local allowed = {} -- Who can run the command, accepts steamID, discordID, or ace permissions
    if isSourceAllowed(source, config.adrevall.allowed) then
        if config.adrev.webhook ~= false then
            discordLog(source, false, config.adresall.webhook)
        end
        TriggerClientEvent('deerAdrev:adrev', -1, 0, source, true)
    else
        TriggerClientEvent('deerAdrev:notif:ret', source, "You do not have permission to use /adrevall")
    end
end)

RegisterCommand('adresall', function(source, args, rawCommand)
    local allowed = {} -- Who can run the command, accepts steamID, discordID, or ace permissions
    if isSourceAllowed(source, config.adresall.allowed) then
        if config.adrev.webhook ~= false then
            discordLog(source, false, config.adresall.webhook)
        end
        TriggerClientEvent('deerAdrev:Adres', -1, 0, source, true)
    else
        TriggerClientEvent('deerAdrev:notif:ret', source, "You do not have permission to use /adresall")
    end
end)

RegisterServerEvent('deerAdrev:notif')
AddEventHandler('deerAdrev:notif',function(source, admin, message)
    TriggerClientEvent('deerAdrev:notif:ret', admin, message)
end)

function discordLog(source,target,webhook) 
    local srcName = GetPlayerName(source)        
    local sourceIDs = ExtractIdentifiers(source)
    if not target then
        local embed = {
            {
                ["fields"] = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = srcName..'[ID:'..source..']',
                        ["inline"] = true
                    },{
                        ["name"] = "**Discord:**",
                        ["value"] = '@<'..sourceIDs.discord..'>',
                        ["inline"] = true
                    },
                },
                ["color"] = 2676952,
                ['footer'] = {
                    ["text"] = "Revived Everyone",
                },
            }
        }
        PerformHttpRequest(webhook, function(err, text, header) end, 'POST',json.encode({embeds = embed}), {["Content-Type"] = 'application/json'})
    elseif target == source then
        local embed = {
            {
                ["fields"] = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = srcName..'[ID:'..source..']',
                        ["inline"] = true
                    },{
                        ["name"] = "**Discord:**",
                        ["value"] = '@<'..sourceIDs.discord..'>',
                        ["inline"] = true
                    },
                },
                ["color"] = 2676952,
                ['footer'] = {
                    ["text"] = "Revived Themselfs",
                },
            }
        }
        PerformHttpRequest(webhook, function(err, text, header) end, 'POST',json.encode({embeds = embed}), {["Content-Type"] = 'application/json'})
    else
       
        local trgName = GetPlayerName(target)
        local targetIDs = ExtractIdentifiers(target)
        local embed = {
            {
                ["fields"] = {
                    {
                        ["name"] = "**Player Name:**",
                        ["value"] = trgName..'[ID:'..target..']',
                        ["inline"] = true
                    },{
                        ["name"] = "**Discord:**",
                        ["value"] = '@<'..targetIDs.discord..'>',
                        ["inline"] = true
                    },
                },
                ["color"] = 2676952,
                ['footer'] = {
                    ["text"] = "Revived by: "..srcName..'[ID:'..source..']',
                },
            }
        }
        PerformHttpRequest(webhook, function(err, text, header) end, 'POST',json.encode({embeds = embed}), {["Content-Type"] = 'application/json'})
    end
end

function isSourceAllowed(source, table)
    local identifiers = ExtractIdentifiers(source)
    if config.ESX then
        xPlayer = ESX.GetPlayerFromId(source)
    end
    for _, i in pairs(table) do
        if config.ESX and xPlayer.job.name == table[_] then
            return true
        elseif IsPlayerAceAllowed(source,table[_]) then
            return true
        elseif identifiers.steam ~= 'N/A' and (identifiers.steam:gsub('steam:', '') == table[_] or identifiers.steam == table[_]) then
            return true
        elseif identifiers.discord ~= 'N/A' and (identifiers.discord:gsub('discord:', '') == table[_] or identifiers.discord == table[_]) then
            return true
        end
    end
    return false
end

function ExtractIdentifiers(src)
    local identifiers = {
        steam = 'N/A',
        ip = 'N/A',
        discord = 'N/A',
        license = 'N/A',
        xbl = 'N/A',
        live = 'N/A'
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end
