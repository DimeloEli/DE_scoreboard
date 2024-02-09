local playerDistances = {}
local showId = false
----------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------
DrawText3D = function(position, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1)
    local dist = #(GetGameplayCamCoords()-position)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
        else 
            SetTextScale(0.0*scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
----------------------------------------------------------------------
-- Threads
----------------------------------------------------------------------
-- Code Credit: Robbster
CreateThread(function()
    Wait(500)
    while true do

        if showId then
            for _, id in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(id)

                if targetPed ~= PlayerPedId() then
                    if playerDistances[id] then
                        if playerDistances[id] < 6.0 then
                            local targetPedCords = GetEntityCoords(targetPed)

                            DrawText3D(targetPedCords, GetPlayerServerId(id), 255,255,255)
                        end
                    end
                end
            end
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        if showId then
            for _, id in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(id)
                if targetPed ~= playerPed then
                    local distance = #(playerCoords-GetEntityCoords(targetPed))
                    playerDistances[id] = distance
                end
            end
        end
        Wait(1000)
    end
end)
----------------------------------------------------------------------
-- Commands
----------------------------------------------------------------------
RegisterKeyMapping('scoreboard', 'Open Scoreboard Menu', 'keyboard', Config.Keybind)

RegisterCommand('scoreboard', function(source, args, user)
    local Options = {}

    if Shared.Core == 'esx' then
        ESX.TriggerServerCallback('DE_scoreboard:getOnlinePlayers', function(playerData)
            for k, v in pairs(playerData) do
                table.insert(Options, {
                    label = v.label,
                    close = false,
                })
            end
    
            lib.registerMenu({
                id = 'scoreboard',
                title = 'Players List',
                position = 'top-right',
                onClose = function(keyPressed)
                    showId = false
                end,
                options = Options
            }, function(selected, scrollIndex, args)
                print(selected, scrollIndex, args)
            end)
        
            lib.showMenu('scoreboard')
            showId = true
        end)
    elseif Shared.Core == 'qb' then
        QBCore.Functions.TriggerCallback('DE_scoreboard:getOnlinePlayers', function(playerData)
            for k, v in pairs(playerData) do
                table.insert(Options, {
                    label = v.label,
                    close = false,
                })
            end
    
            lib.registerMenu({
                id = 'scoreboard',
                title = 'Players List',
                position = 'top-right',
                onClose = function(keyPressed)
                    showId = false
                end,
                options = Options
            }, function(selected, scrollIndex, args)
                print(selected, scrollIndex, args)
            end)
        
            lib.showMenu('scoreboard')
            showId = true
        end)
    end
end, false)
