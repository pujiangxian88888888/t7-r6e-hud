# t7-r6e-hud
A custom black ops 3 hud, rainbow six extraction style.

## HOW TO INSTALL?
* 1: You must download and install L3akMod from https://wiki.modme.co/wiki/black_ops_3/lua_(lui)/Installation.html or the linker cannot compile lua files!
* 2: Put the "texture_assets" and "bin" folder in your BO3 root.
* 3: Put the GDT file to BO3ROOT/source_data.
* 4: Put the "ui","scripts" and "fonts" folders in BO3ROOT/usermaps/yourmap.
* 5: Put the ZPKG file in BO3ROOT/usermaps/yourmap/zone_source, the add the following line to your zm_mapname.zone:
```
include,r6e_hud
```

* 6: In your zm_mapname.gsc, add this line to your preprocessor:
```
#using scripts\zm\_zm_r6ehud_hitmarks;
#using scripts\zm\_zm_r6e_hud;
```
then add this line to your map csc file:
```
#using scripts\zm\_zm_r6e_hud;
```

* 7: Compile and link your map.
## NOTICE
* **THE FONTS IN THIS CONTENT ARE COPYRIGHTED. PLEASE DO NOT USE THEM AS COMMERICAL PURPOSE.**
  
* This HUD has only be tested in SOLO mode and BOTs, It has not been tested in COOP mode yet. If you find any bugs during the game please let me know. Contact me at discord, gmail or just leave a issue.

* This HUD does not contain BGB widget ( actionslot1 ). If you want to add it, You can add the following code in R6eHudScoreContainer.lua:

    ```
    require( "ui.uieditor.widgets.HUD.ZM_AmmoWidget.ZmAmmo_BBGumMeterWidget" )
    self.BGBWidget = CoD.ZmAmmo_BBGumMeterWidget.new( menu, controller )
    -- then use function setLeftRight and setTopBottom to set the location on HUD
    self:addElement( self.BGBWidget )
    ```
* If you use your custom character and want to set the player icon, you just need set an image to your playerbodytype assets->Player List Icon( the pixel value of width and length must be mulitply of 4,  "mipmap disabled" and "streamable" box must be checked ), then navigate to R6eHudTeammateScore.lua and R6eHudSelfScore.lua, find the member "self.PortraitImage", I have left the comment for reference.( I suggest you to use charactercustomizationtable asset to customize your player model instead of overriding the original primus model directly because it will be for flexiable, for example if you want to change your player's model during the game, you can just simply use function "SetCharacterBodyStyle" )

* If you want to add the new perks, navigate to R6eHudPerksContainer.lua, find the table "perksImages",then add element like this:
    ```
    first actual argument name in function zm_perks::register_perk_basic_info = "the perk icon image name in APE"
    ```
And do not forget add the perk icon image asset to the HUD ZPKG file.

* If you want to add the new power ups, navigate to R6eHudPowerupsContainer.lua, find the table "CoD.PowerUps.ClientFieldNames" then add a new table in it with two elements:
    ```
    clientFieldName = "power_up clientfield name",
	material = RegisterMaterial( "material name in APE" )

    --power_up clientfield name is the 9th actual argument in zm_powerups::add_zombie_powerup.
    ```
And do not forget add the power up material asset to the HUD ZPKG file.

* The tactical grenade widget, I have set the icon for all types of tactical grenades to "ui_icon_aura_grenade". (In R6E, the aura grenade has the same function as the monkey and octobomb, which is to attract enemies and explode.) You can set the icon according to your actual needs.

* Due to the author's limited 2D art skills, the icons used for actionslot2, 3, 4 (shield, altweapon, tripmine) may not be particularly well-suited.

* There may be some obsolete images in the repo.


## CREDITS
* Treyarch and Activsion - All original assets
* Ubisoft Montreal - UI design
* MizugakiIsla - UI coding
* Kingslayer Kyle - Code reference
* K7Ysh5A_4.1 - LUA help
* Scobalula - HydraX
* JariKCoding - CoDLuaDecompiler
* D3V Team - L3akMod

## CONTACT ME

* **DISCORD: Isla#2608**
* **GMAIL: wel4369240@gmail.com**
