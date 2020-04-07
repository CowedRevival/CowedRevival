
obj/Weather
	icon='icons/Area.dmi'
	layer=MOB_LAYER-1
mob
	icon = 'icons/Cow.dmi'
	icon_state="alive"
mob
	var
		loggedin = 0
		movable = 0
		attackable = 0
		attackmode = "attack"

obj/var/checked=0
var/list/names = new