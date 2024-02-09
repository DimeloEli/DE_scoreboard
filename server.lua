if Shared.Core == 'esx' then
    ESX.RegisterServerCallback('DE_scoreboard:getOnlinePlayers', function(source, cb)
        local xPlayers = ESX.GetExtendedPlayers()
        local data = {}
    
        for _, xPlayer in pairs(xPlayers) do
            table.insert(data, {
                id = xPlayer.source,
                label = '[' .. xPlayer.source .. '] ' .. GetPlayerName(xPlayer.source)
            })
        end
        
        cb(data)
    end)
elseif Shared.Core == 'qb' then
    QBCore.Functions.CreateCallback('DE_scoreboard:getOnlinePlayers', function(source, cb)
        local Player = QBCore.Functions.GetPlayer(source)
        local data = {}
    
        for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
            table.insert(data, {
                id = Player.PlayerData.source,
                label = '[' .. Player.PlayerData.source .. '] ' .. GetPlayerName(Player.PlayerData.source)
            })
        end
        cb(data)
    end)
end
