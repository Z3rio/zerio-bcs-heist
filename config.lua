Config = {}

Config.Blip = {
    position = vector3(910.8591, -2121.0571, 31.2328),
    color = 0,
    sprite = 110,
    scale = 0.75,
    text = "Bobcat Security Robbery"
}

Config.GoldLootAmount = {3, 7} -- min, max
Config.MoneyLootAmount = {2, 3} -- min, max
Config.MoneyLootWorth = {200, 500} -- min, max

Config.PoliceNeeded = 0
Config.RequireOnDuty = false -- only for qb-core, if on esx this should always be false
Config.ResetTime = 60 * 60 * 1000 -- Time to reset after starting robbery. Measured in milliseconds. By default this is an hour.

Config.PedHash = GetHashKey("s_m_m_prisguard_01")
Config.Positions = {
    thermite1 = {
        prompt = vector3(914.9858, -2121.8691, 31.2310),
        playerpos = vector4(914.75, -2121.9397, 31.2310, 271.2391),
        burnpos = vector3(914.6462, -2120.95, 31.2)
    },
    thermite2 = {
        prompt = vector3(908.8208, -2120.6428, 31.2303),
        playerpos = vector4(908.575, -2120.6467, 31.2303, 263.4942),
        burnpos = vector3(908.575, -2119.625, 31.2303)
    },
    securitycard = {
        prompt = vector3(905.0696, -2121.0820, 31.2303),
        playerpos = vector4(905.7454, -2119.7, 31.2303, 86.7866)
    },
    vault = {
        prompt = vector3(888.3440, -2130.4658, 31.2300),
        playerpos = vector4(889.0, -2130.6, 31.2300, 0.7961)
    },
    npcs = {vector4(896.1457, -2132.5039, 31.2303, 356.1608), vector4(898.3466, -2129.1311, 31.2303, 3.7665),
            vector4(896.3973, -2124.4341, 31.2303, 332.7293), vector4(891.4799, -2134.0090, 31.2303, 269.0237),
            vector4(898.1379, -2121.7278, 31.2303, 226.4685)},
    money = {vector4(891.25, -2126.5, 30.7, 160.0), vector4(886.22, -2125.06, 30.70, -50.0),
             vector4(887.13, -2122.0, 30.70, 125.0)},
    gold = {vector4(886.14, -2128.1, 30.7, 80.0), vector4(890.12, -2121.89, 30.70, 45.0)}
}
