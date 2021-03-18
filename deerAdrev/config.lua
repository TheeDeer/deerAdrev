config = {
    ESX = false,
    selfResTime = 240, -- How long in seconds until a user can self res (to disable set this to false)
    selfRevTime = 480, -- How long in seconds until a user can self rev (to disable set this to false)
    selfResWebhook = false,
    selfRevWebhook = false,
    spawnPoints = {
        {
            x1 = -448, x2 = -448, y1 = -340, y2 = -329, z = 35.5, heading = 0 -- Mount Zonah
        },
    },
    adrev = {
        allowed = {"staff"}, -- Who is allowed to run the command (Accepts Ace Permissions, ESX.Jobs, SteamID, and DiscordID)
        webhook = false -- The discord webhook for logging, if you do not want logging change to false, otherwise put the webhook link here.
    },
    adres = {
        allowed = {"staff"}, -- Who is allowed to run the command (Accepts Ace Permissions, ESX.Jobs, SteamID, and DiscordID)
        webhook = false -- The discord webhook for logging, if you do not want logging change to false, otherwise put the webhook link here.
    },
    adrevall = {
        allowed = {"staff"}, -- Who is allowed to run the command (Accepts Ace Permissions, ESX.Jobs, SteamID, and DiscordID)
        webhook = false -- The discord webhook for logging, if you do not want logging change to false, otherwise put the webhook link here.
    },
    adresall = {
        allowed = {"staff"}, -- Who is allowed to run the command (Accepts Ace Permissions, ESX.Jobs, SteamID, and DiscordID)
        webhook = false -- The discord webhook for logging, if you do not want logging change to false, otherwise put the webhook link here.
    }
}