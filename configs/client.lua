return {
    DebugPoly = false,
    Freedom = vec4(1837.25, 2588.88, 46.01, 205.71), -- Freedom spawn coords
    RemoveJob = true,          -- Remove player jobs when send to jail

    -- Create Target Zone to Check Time (if XTPrisonJobs is false) --
    CheckOut = {
        coords = vec3(1828.76, 2580.11, 46.01),
        size = vec3(1.5, 1.5, 1.5),
        rotation = 0.5,
    },

    -- Alert When Entering Prison --
    EnterPrisonAlert  = {
        enable = true,
        header = 'Welcome to Prison, Criminal Scum!',
        content = 'To reduce your time in prison, get a job from the guard in the cells. Get your ass to work and maybe you\'ll learn a thing or two.',
    },

    -- Enter Prison Spawn Location & Emotes --
    Spawns = {
        { coords = vec4(1770.7249755859, 2479.9802246094, 45.74076461792, 31.66007232666),   emote = 'pushup' },
        { coords = vec4(1761.0710449219, 2474.9235839844, 49.693054199219, 33.123195648193), emote = 'pushup' },
        { coords = vec4(1745.0281982422, 2479.2116699219, 45.740684509277, 323.06579589844), emote = 'weights' },
        { coords = vec4(1768.1342773438, 2481.6772460938, 45.740734100342, 33.281074523926), emote = 'lean' },
    },

    -- Canteen Ped --
    CanteenPed = {
        model = 's_m_m_linecook',
        coords = vector4(1780.47, 2564.31, 45.67, 2.93),
        scenario = 'PROP_HUMAN_BBQ',
        mealLength = 2
    },

    -- Prison Doctor --
    --[[
    PrisonDoctor = {
        model = 's_m_m_doctor_01',
        coords = vector4(1765.39, 2598.54, 45.72, 190.91),
        scenario = 'WORLD_HUMAN_CLIPBOARD',
        healLength = 5
    },
    ]]--

    -- Roster Location --
    RosterLocation = {
        coords = vec3(1840.37, 2579.26, 46.01),
        radius = 0.8,
    },

    -- Set Prison Outfits --
    EnablePrisonOutfits = true,
    PrisonOufits = {
        male = {
            accessories = {
                item = 0,
                texture = 0
            },
            mask = {
                item = 0,
                texture = 0
            },
            pants = {
                item = 5,
                texture = 7
            },
            jacket = {
                item = 0,
                texture = 0
            },
            shirt = {
                item = 15,
                texture = 0
            },
            arms = {
                item = 0,
                texture = 0
            },
            shoes = {
                item = 42,
                texture = 2
            },
            bodyArmor = {
                item = 0,
                texture = 0
            },
        },
        female = {
            accessories = {
                item = 0,
                texture = 0
            },
            mask = {
                item = 0,
                texture = 0
            },
            pants = {
                item = 0,
                texture = 0
            },
            jacket = {
                item = 0,
                texture = 0
            },
            shirt = {
                item = 0,
                texture = 0
            },
            arms = {
                item = 0,
                texture = 0
            },
            shoes = {
                item = 0,
                texture = 0
            },
            bodyArmor = {
                item = 0,
                texture = 0
            },
        }
    },

    -- Reloads Player's Last Skin When Freed --
    ResetClothing = function()
        TriggerEvent('illenium-appearance:client:reloadSkin', true)
    end,

    -- Triggered on Player Heal --
    PlayerHealed = function()
        TriggerEvent('hospital:client:Revive')
        -- TriggerEvent('osp_ambulance:partialRevive')
    end,

    -- Trigger Emote --
    Emote = function(emote)
        -- exports.scully_emotemenu:playEmoteByCommand(emote)
        exports["rpemotes"]:EmoteCommandStart(emote)
    end,

    -- Trigger Prison Break Dispatch --
    Dispatch = function(coords)
        exports['ps-dispatch']:PrisonBreak()
        -- TriggerEvent('police:client:policeAlert', coords, 'Prison Break')
        
       -- ND Core
        -- exports["ND_MDT"]:createDispatch({
        --             caller = "Boilingbroke Penitentiary",
        --             location = "Sandy Shores",
        --             callDescription = "Prison Break",
        --             coords = vec3(1845.8302, 2585.9011, 45.6726)
        --         })
    end,
}