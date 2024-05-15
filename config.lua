Config = {}

Config.DrugPhone = {
    Settings = {
        GetContactTime = 1, -- I minutter
        GetContactRemoveTime = 2, -- I sekunder
        ChanceToGetRecommended = 5, -- I procent - fx 5 = 5%, 25 = 25%. 1-100
        BlackMoney = true, -- Om pengene skal være i sorte eller hvide.
        ContactBonus = {
            RequiredContacts = 10, -- Dette er for hver 10 kontakter du har. Det vil sige har du 20 er det 4%.
            Bonus = 2, -- Dette er i procent
        },
        MinCooldownTime = 10, -- Hvis du fx har 100 kontakter, så kan det fx tage 20 sekunder for at få et opkald, 
        -- derfor har jeg sat den så der er min cooldown så man ikke kan få den inde for 2 sekunder.
    },
    Stof = {
        {
            label = 'Coke Pose',
            value = 'coke_pooch'
        },
        {
            label = 'Meth Pose',
            value = 'meth_pooch',
        },
        {
            label = 'Kanyle',
            value = 'opium_pooch',
        },
        {
            label = 'Joint',
            value = 'weed_pooch',
        },
        {
            label = 'Test',
            value = 'bread',
        },
    },
    Target = {
        Icon = 'fa-solid fa-comment',
        Label = 'Forhandle med din køber'
    },
    Reward = {
        ['coke_pooch'] = {
            Take = {
                Min = 1, -- Min antal der bliver taget.
                Max = 20, -- Max antal der bliver taget.
            },
            Reward = {
                Min = 450, -- Min Antal kr. per stk.
                Max = 550, -- Max Antal kr. per stk.
            }
        },
        ['meth_pooch'] = {
            Take = {
                Min = 1, -- Min antal der bliver taget.
                Max = 20, -- Max antal der bliver taget.
            },
            Reward = {
                Min = 450, -- Min Antal kr. per stk.
                Max = 550, -- Max Antal kr. per stk.
            }
        },
        ['opium_pooch'] = {
            Take = {
                Min = 1, -- Min antal der bliver taget.
                Max = 20, -- Max antal der bliver taget.
            },
            Reward = {
                Min = 450, -- Min Antal kr. per stk.
                Max = 550, -- Max Antal kr. per stk.
            }
        },
        ['weed_pooch'] = {
            Take = {
                Min = 1, -- Min antal der bliver taget.
                Max = 20, -- Max antal der bliver taget.
            },
            Reward = {
                Min = 450, -- Min Antal kr. per stk.
                Max = 550, -- Max Antal kr. per stk.
            }
        },
        ['bread'] = {
            Take = {
                Min = 1, -- Min antal der bliver taget.
                Max = 20, -- Max antal der bliver taget.
            },
            Reward = {
                Min = 450, -- Min Antal kr. per stk.
                Max = 550, -- Max Antal kr. per stk.
            }
        },
    },
    Mission = {
        --{ Dette er en skabelon til hvordan du opsætter steder. Scriptet håndtere selv hvor mange steder der er på mappet, så du skal bare oprette dem!
            --Settings = {
                --SpawnPos = vector4(-11.7045, 8.2537, 70.2523, 289.4556), -- Dette er lokationen, brug Kopir Koordinater under din txAdmin Menu
                --MissionPed = 'u_m_y_antonb', -- Dette er PED modellen, den kan du skifte sådan det ikke er den samme PED model man skal hen til ved hvert sted.
            --}
        --},
        {
            Settings = {
                SpawnPos = vector4(-11.7045, 8.2537, 70.2523, 289.4556),
                MissionPed = 'u_m_y_antonb',
            }
        },
    }
}

Config.Notifys = {
    NoContacts = 'Simkortet havde ingen kunder på, og der blev derfor automatisk tilføjet en kontakt på simkortet!',
    SimkortNotInPhone = 'Du har ikke noget simkort i din telefon!',
    NotEnough = 'Du har ikke nok stof på dig!',
    GotRecommended = 'Du er blevet anbefalet, og har derfor fået en kontakt mere!'
}