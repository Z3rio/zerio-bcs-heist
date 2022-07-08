# Make sure you have the following dependencies

- datacrack, https://github.com/utkuali/datacrack
- memorygame, https://github.com/pushkart2/memorygame
- ox_doorlock, https://github.com/overextended/ox_doorlock/
- ox_lib, https://github.com/overextended/ox_lib

# Setup custom ytyp files for gabz-bobcat

Drag all files from "cfx-gabz-bobcat FILES" into cfx-gabz-bobcat -> stream -> ytyp and replace the one that already exists here.
If you dont then the gold trolleys will be wrong.

# Setup inventory images

Move all the images from the "INVENTORY IMAGES" folder into your inventories image folder

# Setup items

Execute the following SQL query to add all items needed by the script

```sql
INSERT INTO `esx_legacy`.`items` (`name`, `label`) VALUES ('goldbar', 'Gold Bar');
INSERT INTO `esx_legacy`.`items` (`name`, `label`) VALUES ('thermite', 'Thermite');
INSERT INTO `esx_legacy`.`items` (`name`, `label`) VALUES ('c4', 'C4');
INSERT INTO `esx_legacy`.`items` (`name`, `label`) VALUES ('bcssecuritycard', 'Bobcat Security Keycard');
```

# Setup doorlocks

Execute the locks.sql ifle