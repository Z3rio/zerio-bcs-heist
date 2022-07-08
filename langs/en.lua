local Translations = {
    success = {
        hackingcompleted = "Hacking completed! It was a success",
        thermite = "You successfully used the thermite"

    },
    error = {
        donthavethermite = "You need an thermite to do this",
        donthavesecuritycard = "You need a Bobcat Security Keycard to do this",
        donthavec4 = "You need a C4 to do this",
        hackingfailed = "The hacking failed",
        alreadyswiping = "You are already doing this",
        notenoughpolice = "There's not enough police in the city. There has to be atleast " ..
            tostring(Config.PoliceNeeded) .. " police online"
    },
    progress = {
        usingthermal = "Using the thermal"
    },
    prompt = {
        swipecard = "Swipe security card",
        placethermite = "Place thermite",
        placec4 = "Place C4",
        takegold = "Take gold",
        takemoney = "Take money"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
