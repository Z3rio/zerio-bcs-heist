# Make sure you have the following dependencies

- datacrack, https://github.com/utkuali/datacrack
- memorygame, https://github.com/pushkart2/memorygame

# Setup items

Add the following items into qb-core -> shared.lua -> items.lua (if you don't already have them)

```lua
['thermite'] = {['name'] = 'thermite', ['label'] = 'Thermite', ['weight'] = 1000, ['type'] = 'item', ['image'] = 'thermite.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Sometimes you\'d wish for everything to burn'},
['bcssecuritycard'] = {['name'] = 'bcssecuritycard', ['label'] = 'Bobcat Security Keycard', ['weight'] = 1000, ['type'] = 'item', ['image'] = 'bcssecuritycard.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Might be useful to have when robbing Bobcat Security'},
['c4'] = {['name'] = 'c4', ['label'] = 'C4', ['weight'] = 1000, ['type'] = 'item', ['image'] = 'c4.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'Sometimes you\'d wish for everything to burn'},
```

# Setup custom ytyp files for gabz-bobcat

Drag all files from "cfx-gabz-bobcat FILES" into cfx-gabz-bobcat -> stream -> ytyp and replace the one that already exists here.
If you dont then the gold trolleys will be wrong.

# Setup inventory images

Move all the images from the "INVENTORY IMAGES" folder into your inventories image folder

# Setup doorlocks

Move the locks.lua file to qb-doorlock -> configs and name it bobcatsecurity.lua