# t7-r6e-hud
A custom black ops 3 hud, rainbow six extraction style.

# HOW TO INSTALL?
* 1: You must download and install L3akMod from (https://wiki.modme.co/wiki/black_ops_3/lua_(lui)/Installation.html) or the linker cannot compile lua files!
* 2: Put the "custom" folder in your BO3 root.
* 3: Put the GDT file to BO3ROOT/source_data.
* 4: Put the "ui","scripts" and "fonts" dictionarys in BO3ROOT/usermaps/yourmap.
* 5: Put the ZPKG file in BO3ROOT/usermaps/yourmap/zone_source, the add the following content to your zm_mapname.zone:
'''
include,r6e_hud
material,overlay_low_health_digital
image,ui_icon_selfplayer_down_bleedout_bar_icon
image,ui_icon_teammate_bleedout_bar
image,ui_icon_teammate_down_bg
image,ui_icon_teammate_dead_icon
image,ui_icon_revive_arrow
image,uie_t7_zm_hud_revive_ringglow
image,ui_icon_dead_spectating_bg
image,ui_icon_being_revived
image,ui_icon_mortar_strike
image,ui_icon_riot_shield
image,ui_icon_trip_mine
'''