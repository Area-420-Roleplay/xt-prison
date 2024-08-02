if GetResourceState('ox_core') ~= 'started' then return end

local file = ('imports/%s.lua'):format(IsDuplicityVersion() and 'server' or 'client')
local import = LoadResourceFile('ox_core', file)
local chunk = assert(load(import, ('@@ox_core/%s'):format(file)))
chunk()

function getPlayer(id)
    return Ox.GetPlayer(id)
end

function getCharID(src)
    local player = getPlayer(src)
    return player and player.charId or nil
end

function getCharJob(src)
    -- TODO
    return
end

function setCharJob(src, job)
    -- TODO
    return
end

function setJailTime(src, time)
    local playerState = Player(src)?.state
    local player = getPlayer(src)
    if not playerState or not player then return end

    playerState.jailTime = time

    return playerState and (playerState.jailTime == time) or false
end