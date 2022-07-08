-- ONLY FOR QB-Core WITH qb-doorlock
Config.DoorList['bobcatsecurity-maindoor'] = {
    distance = 2,
    authorizedJobs = {},
    doorRate = 1.0,
    doorType = 'double',
    cantUnlock = true,
    doors = {{
        objName = -2023754432,
        objYaw = 264.99993896484,
        objCoords = vec3(914.785645, -2120.547363, 31.395027)
    }, {
        objName = -2023754432,
        objYaw = 84.999885559082,
        objCoords = vec3(914.558960, -2123.137695, 31.395027)
    }},
    locked = true
}

Config.DoorList['bobcatsecurity-seconddoor'] = {
    objCoords = vec3(908.440430, -2121.276123, 31.380991),
    distance = 2,
    cantUnlock = true,
    locked = true,
    objYaw = 84.999885559082,
    objName = -2023754432,
    authorizedJobs = {},
    fixText = false,
    doorType = 'door',
    doorRate = 1.0
}

Config.DoorList['bobcatsecurity-unentrabledoor'] = {
    authorizedJobs = {},
    cantUnlock = true,
    doorType = 'door',
    locked = true,
    objName = -551608542,
    fixText = false,
    distance = 0,
    doorRate = 1.0,
    objCoords = vec3(906.676270, -2113.287842, 31.380184),
    objYaw = 354.99996948242
}

Config.DoorList['bobcatsecurity-thirddoor'] = {
    doorRate = 1.0,
    distance = 2,
    cantUnlock = true,
    locked = true,
    doorType = 'double',
    authorizedJobs = {},
    doors = {{
        objName = 1438783233,
        objYaw = 264.99996948242,
        objCoords = vec3(904.913635, -2119.686279, 31.380224)
    }, {
        objName = 1438783233,
        objYaw = 84.999885559082,
        objCoords = vec3(904.687012, -2122.276123, 31.380224)
    }}
}

Config.DoorList['bobcatsecurity-lastdoor'] = {
    authorizedJobs = {},
    doorType = 'garage',
    cantUnlock = true,
    distance = 3,
    fixText = false,
    objName = -1514454788,
    doorRate = 1.0,
    objCoords = vec3(889.914307, -2107.780762, 30.235733),
    locked = true,
    objYaw = 174.99992370605
}

Config.DoorList['bobcatsecurity-securitydoor'] = {
    authorizedJobs = {},
    objName = -311575617,
    objCoords = vec3(877.821777, -2121.991943, 31.380184),
    doorType = 'door',
    locked = true,
    distance = 2,
    cantUnlock = true,
    objYaw = 264.99996948242,
    fixText = false,
    doorRate = 1.0
}
