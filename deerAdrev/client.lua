isDead = false
playerPed = GetPlayerPed()
playerPedId = PlayerPedId()
playerId = PlayerId()

resTime = config.selfResTime
revTime = config.selfRevTime
revSent = false
resSent = false
dTime = nil
spawnPoints = {}

AddEventHandler('onClientMapStart', function()
	exports.spawnmanager:spawnPlayer()
	Citizen.Wait(3000)
	exports.spawnmanager:setAutoSpawn(false)
end)

Citizen.CreateThread(function()
    function createSpawnPoint(x1,x2,y1,y2,z,heading)
		local xValue = math.random(x1,x2) + 0.0001
		local yValue = math.random(y1,y2) + 0.0001

		local newObject = {
			x = xValue,
			y = yValue,
			z = z + 0.0001,
			heading = heading + 0.0001
		}
		table.insert(spawnPoints,newObject)
	end

	for _,gg in pairs(config.spawnPoints) do
        createSpawnPoint(gg.x1,gg.x2,gg.y1,gg.y2,gg.z,gg.heading)
    end

    while true do
        playerPed = GetPlayerPed()
        playerPedId = PlayerPedId()
        isDead = IsEntityDead(playerPedId)
        if isDead then
            if dTime == nil then
                dTime = GetGameTimer()
            end
            local timePassed = (GetGameTimer()/1000) - (dTime/1000)
            print(timePassed)
            SetPlayerInvincible( ped, true )
			SetEntityHealth( ped, 1 )
            if resTime ~= false then
                if timePassed > resTime then
                    if not resSent then
                        resSent = true
                        TriggerEvent('chat:addMessage',{
                            color = {255, 255, 255},
                            multiline = true,
                            args = {'^3SYSTEM ^7| ^1You may now respawn using ^3/respawn'}
                        })
                    end
                end
            end
            if revTime ~= false and revTime > 0 then
                if timePassed > revTime then
                    if not revSent then
                        revSent = true
                        TriggerEvent('chat:addMessage',{
                            color = {255, 255, 255},
                            multiline = true,
                            args = {'^3SYSTEM ^7| ^1You may now respawn using ^3/revive'}
                        })
                    end
                end
            end
        end
        Citizen.Wait(2500)
    end
end)

RegisterNetEvent("deerAdrev:notif:ret")
AddEventHandler("deerAdrev:notif:ret", function(message)
    TriggerEvent('chat:addMessage',{
        color = {255, 255, 255},
        multiline = true,
        args = {'^3SYSTEM ^7| '..message}
    })
end)

RegisterNetEvent("deerAdrev:adrev")
AddEventHandler("deerAdrev:adrev", function(sr,admin,all)
    playerPed = GetPlayerPed()
    playerPedId = PlayerPedId()
    if dTime == nil then
        if not all then
            TriggerServerEvent('deerAdrev:notif', admin, 'Player already alive')
        end
    else
        if admin == sr then
            local timePassed = (GetGameTimer()/1000) - (dTime/1000)
            if timePassed > revTime then
                TriggerEvent('deerAdrev:notif:ret', 'You have revived yourself.')

                NetworkResurrectLocalPlayer(GetEntityCoords(playerPedId, true), true, true, false)
                SetPlayerInvincible(playerPedId, false)
                ClearPedBloodDamage(playerPedId)

                revSent = false
                resSent = false
                dTime = nil
            else
                TriggerEvent('deerAdrev:notif:ret', 'You must wait '..revTime-timePassed..' more seconds before using /revive')
            end
        else
            TriggerEvent('deerAdrev:notif:ret', 'An admin has revived you.')
            TriggerServerEvent('deerAdrev:notif', admin, 'Player revived.')
            NetworkResurrectLocalPlayer(GetEntityCoords(playerPedId, true), true, true, false)
            SetPlayerInvincible(playerPedId, false)
            ClearPedBloodDamage(playerPedId)

            revSent = false
            resSent = false
            dTime = nil
        end
    end
end)

RegisterNetEvent("deerAdrev:adres")
AddEventHandler("deerAdrev:adres", function(sr,admin,all)
    playerPed = GetPlayerPed()
    playerPedId = PlayerPedId()
    if dTime == nil then
        if not all then
            TriggerServerEvent('deerAdrev:notif', admin, 'Player already alive')
        end
    else
        if admin == sr then
            local timePassed = (GetGameTimer()/1000) - (dTime/1000)
            if timePassed > resTime then
                TriggerEvent('deerAdrev:notif:ret', 'You have respawned yourself.')

                local coords = spawnPoints[math.random(1,#spawnPoints)]
                SetEntityCoordsNoOffset(playerPedId, coords.x, coords.y, coords.z, false, false, false, true)
                NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false) 
                SetPlayerInvincible(playerPedId, false) 
                TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
                ClearPedBloodDamage(playerPedId)

                revSent = false
                resSent = false
                dTime = nil
            else
                TriggerEvent('deerAdrev:notif:ret', 'You must wait '..resTime-timePassed..' more seconds before using /respawn')
            end
        else
            TriggerEvent('deerAdrev:notif:ret', 'An admin has respawned you.')
            TriggerServerEvent('deerAdrev:notif', admin, 'Player respawned.')

            local coords = spawnPoints[math.random(1,#spawnPoints)]
            SetEntityCoordsNoOffset(playerPedId, coords.x, coords.y, coords.z, false, false, false, true)
            NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false) 
            SetPlayerInvincible(playerPedId, false) 
            TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
            ClearPedBloodDamage(playerPedId)

            revSent = false
            resSent = false
            dTime = nil
        end
    end
end)

