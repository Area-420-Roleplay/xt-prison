return {
    EnableJailCommand = true,                   -- Jail command using ox_lib input menu

    UnemployedJobName = 'unemployed',           -- Name of unemployed job (if remove job is enabled)

    CanteenMeal = {                             -- Food & Drink received from canteen
        food = {
            item = 'prison_food',
            count = 1
        },
        drink = {
            item = 'prison_water',
            count = 1
        }
    },

    AllowedToKeepItems = {                      --  Items found/received in prison that can be kept when released
        ['money'] = true,
        ['cigs'] = true,
        ['lockpick'] = true,
        ['steel'] = true
    },

    PoliceJobs = {                              -- Police jobs
        'police',
        'bcso',
    },

    Lifers = {                                  -- Lifer identifiers
        'RANDOLIOCID',
        'QWADEBOTCID'
    }
}