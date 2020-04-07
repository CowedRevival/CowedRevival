var/list/spincache = list()
/*mob/proc/breakdance(var/speed = 3)
	var/icon/I = new(icon)
	for(var/item/E in my_overlays)
		spawn()
			if(usr.rhand == E)
				E.icon=E.L_ICON
			var/list/L = getspins(E.icon)
			overlays -= E
			var/image/newoverlay = image(icon = E.icon, icon_state = E.icon_state, layer = E.layer, dir = E.dir)
			for(var/v = 1, v <= 3, v++)
				newoverlay.icon = L[v]
				overlays += newoverlay
				sleep(speed)
				overlays -= newoverlay
			overlays += E
			if(usr.rhand == E)
				E.icon=E.R_ICON
	I.Turn(90)
	usr.icon = I
	step(usr,usr.dir)
	sleep(3)
	I.Turn(90)
	usr.icon = I
	step(usr,usr.dir)
	sleep(3)
	I.Turn(90)
	usr.icon = I
	step(usr,usr.dir)
	sleep(3)
	I.Turn(90)
	usr.icon = I
	step(usr,usr.dir)
	rolling = 0
	return*/
obj/Fireball
	icon='icons/Turfs.dmi'
	icon_state="Fireball"
	density=1
	var/stepleft=5
	New()
		spawn for()
			step(src,src.dir)
			sleep(2)
			src.stepleft-=1
			if(src.stepleft==0)
				del src
	Bump(mob/M)
		if(istype(M))
			M.HP-=30
			M.last_hurt = "fire"
			M.checkdead(M)
			hud_main.UpdateHUD(M)
			M<<"<font color=red><b>Ouch! Fireballs!"
			chat_log << "\<<font color=\"red\">[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\> [M] has been hit by Fireball!</font><br />"
			del src
obj/Iceball
	icon='icons/Turfs.dmi'
	icon_state="Iceball"
	density=1
	var/stepleft=5
	New()
		spawn for()
			step(src,src.dir)
			sleep(2)
			src.stepleft-=1
			if(src.stepleft==0)
				del src
	Bump(mob/M)
		if(istype(M))
			M.HP-=30
			M.last_hurt = "ice"
			M.checkdead(M)
			hud_main.UpdateHUD(M)
			M<<"<font color=red><b>Ouch! Iceballs!"
			chat_log << "\<<font color=\"red\">[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\> [M] has been hit by Iceball!</font><br />"
			del src
obj/Electrozap
	icon='icons/Turfs.dmi'
	icon_state="Electrozap"
	density=1
	var/stepleft=5
	New()
		spawn for()
			step(src,src.dir)
			sleep(2)
			src.stepleft-=1
			if(src.stepleft==0)
				del src
	Bump(mob/M)
		if(istype(M))
			M.HP-=5
			M.last_hurt = "zap"
			M.checkdead(M)
			M.stunned = max(M.stunned, 10)
			hud_main.UpdateHUD(M)
			M<<"<font color=red><b>Ouch! Electricity!"
			chat_log << "\<<font color=\"red\">[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\> [M] has been hit by Electrozap!</font><br />"
			del src

proc/getspins(var/icon/i)
	if( !(i in spincache) )
		var/list/L = list()
		for(var/v = 90, v <= 270, v += 90)
			L += turn(i, v)
		spincache[i] = L
	return spincache[i]
mob
	var/list/my_overlays = list()
	proc/UpdateOverlays()
		overlays = list() // Clear out the overlays list.
		for(var/obj/O in my_overlays)
			overlays += O
	proc/TurnOverlays(angle)
		for(var/obj/E in my_overlays)
			E.icon = turn(E.icon,90)
mob
	var
		last_x
		last_y
		last_z
		atom/movable/whopull

mob/var/rolling = 0
var/bridge = "closed"
obj
	seeded_soil
		icon_state="seeded soil"
		anchored = 1
		DblClick()
			if(usr.shackled==1) return
			if(get_dist(src,usr)<=1)
				if(usr.inHand(/item/weapon/shovel))
					if(usr.movable==0)
						usr.movable=1
						hearers()<<"<small>[usr] starts to dig up the soil."
						sleep(20)
						hearers()<<"<small>[usr] digs up the soil."
						new/turf/path(locate(src.x,src.y,src.z))
						usr.movable=0
						del src
			..()
obj
	lever
		anchored=1
		density=1
		icon = 'icons/bridge and lever.dmi'
		icon_state = "leverup"
		name = "Lever"
		DblClick()
			if(usr.shackled==1) return
			if(get_dist(src,usr) <= 1)
				if(icon_state == "leverup")
					bridge = "closed"
					icon_state = "leverdown"
				else if(icon_state == "leverdown")
					bridge = "open"
					icon_state = "leverup"
			..()
var/bridgel = "closed"
obj
	leverl
		anchored=1
		density=1
		icon = 'icons/bridge and lever.dmi'
		icon_state = "leverup"
		name = "Lever"
		DblClick()
			if(usr.shackled==1) return
			if(usr in range(src,1))
				if(icon_state == "leverup")
					bridgel = "closed"
					icon_state = "leverdown"
				else if(icon_state == "leverdown")
					bridgel = "open"
					icon_state = "leverup"
			..()