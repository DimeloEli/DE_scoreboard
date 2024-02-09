Shared = {}

-- Code Credit: SOH69
if GetResourceState('qb-core') == 'started' then
    Shared.Core = 'qb'
elseif GetResourceState('es_extended') == 'started' then
    Shared.Core = 'esx'
end

if Shared.Core == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Shared.Core == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
end
