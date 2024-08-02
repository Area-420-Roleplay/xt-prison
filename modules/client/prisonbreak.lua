local config            = require 'configs.client'
local prisonBreakcfg    = require 'configs.prisonbreak'
local utils             = require 'modules.client.utils'

local PrisonBreakBlip
local HackZones = {}

CurrentCops = 0

local prisonBreakModules = {}

-- Create Prisonbreak Hacking Zones --
function prisonBreakModules.createHackZones()
    for x = 1, #prisonBreakcfg.HackZones do
        local zoneInfo = prisonBreakcfg.HackZones[x]
        HackZones[x] = exports.ox_target:addSphereZone({
            coords = zoneInfo.coords,
            radius = zoneInfo.radius,
            debug = config.DebugPoly,
            drawsprite = true,
            options = {
                {
                    label = 'Hack Prison Gate',
                    icon = 'fas fa-laptop-code',
                    items = prisonBreakcfg.RequiredItems,
                    onSelect = function()
                        prisonBreakModules.startGateHack(x)
                    end,
                    canInteract = function()
                        local canHack = lib.callback.await('xt-prison:server:canHackTerminal', false, x)
                        return ((CurrentCops >= prisonBreakcfg.MinimumPolice) and canHack) and true or false
                    end
                }
            }
        })
    end
end

function prisonBreakModules.removeBlip()
    if DoesBlipExist(PrisonBreakBlip) then
        RemoveBlip(PrisonBreakBlip)
    end
end

function prisonBreakModules.removeHackZones()
    for x = 1, #HackZones do
        exports.ox_target:removeZone(HackZones[x])
    end
end

function prisonBreakModules.startGateHack(ID)
    config.Emote('tablet2')
    local setBusy = lib.callback.await('xt-prison:server:setTerminalBusyState', false, ID, true)
    if not setBusy then
        ClearPedTasks(cache.ped)
        return
    end

    local success = prisonBreakcfg.GateHackMinigame(ID)

    local resetBusy = lib.callback.await('xt-prison:server:setTerminalBusyState', false, ID, false)

    local randChance1 = math.random(100)
    local alarmChance = success and prisonBreakcfg.AlarmChanceOnHack.success or prisonBreakcfg.AlarmChanceOnHack.fail
    if randChance1 <= alarmChance then
        local triggerAlarm = lib.callback.await('xt-prison:server:setPrisonAlarms', false, true)
    end

    local randChance2 = math.random(100)
    local removeItemsChance = success and prisonBreakcfg.RemoveItemsChanceOnHack.success or prisonBreakcfg.RemoveItemsChanceOnHack.fail
    if randChance2 <= removeItemsChance then
        local removeItems = lib.callback.await('xt-prison:server:removePrisonbreakItems', false)
    end

    if success then
        if lib.progressCircle({
            label = 'Hacking Terminal...',
            duration = (prisonBreakcfg.HackLength * 1000),
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true,
                sprint = true
            },
        }) then
            lib.notify({ title = 'You completed the hack!', type = 'success' })
            local setHacked = lib.callback.await('xt-prison:server:setTerminalHackedState', false, ID, true)
        end
    else
        lib.notify({ title = 'You failed the hack!', type = 'error' })
    end

    ClearPedTasks(cache.ped)
end

-- Sets Alarm State --
function prisonBreakModules.initAlarm(state)
    local alarmIpl = GetInteriorAtCoordsWithType(1787.004, 2593.1984, 45.7978, "int_prison_main")
    RefreshInterior(alarmIpl)
    EnableInteriorProp(alarmIpl, "prison_alarm")
    while not PrepareAlarm("PRISON_ALARMS") do
        Wait(100)
    end

    if state then
        StartAlarm("PRISON_ALARMS", true)
    else
        StopAllAlarms(true)
    end
end

-- Prison Alarm Toggle --
function prisonBreakModules.setPrisonAlarm(setState)
    if setState then
        config.Dispatch(prisonBreakcfg.Center)

        prisonBreakModules.initAlarm(true)

        PrisonBreakBlip = utils.createBlip('PRISON BREAK', prisonBreakcfg.Center, 161, 3.0, 3, true)
    else
        prisonBreakModules.initAlarm(false)

        prisonBreakModules.removeBlip()
    end
end

return prisonBreakModules