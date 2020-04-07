var/list/chronojohns = new/list()

obj/chronojohn
	name = "Chron-o-John"
	desc = "Made in Switserland"
	icon = 'icons/chronojohn.dmi'
	density = 1
	layer = FLY_LAYER
	luminosity = 6
	pixel_x = -8
	anchored = 1
	var
		active = 0
		operating = 0
		list/operators
		network
	New()
		. = ..()
		chronojohns += src
		update_overlays()
	attack_hand(mob/M)
		var/list/L = new/list()
		for(var/obj/chronojohn/O in world)
			if(O.network == src.network)
				for(var/item/I in O.contents) L += I

		var/item/I = input(M, "Select an item to take from the list below.", "Take Item") as null|anything in L
		L = new/list()
		for(var/obj/chronojohn/O in world)
			if(O.network == src.network)
				for(var/item/B in O.contents) L += B

		if((I in L) && (M in range(1, src)) && !M.restrained())
			I.Move(M, forced = 1)
			I.getting(M)
			for(var/obj/chronojohn/O in world) if(O.network == src.network) O.update_overlays()
	MouseDropped(item/I)
		if((usr in range(1, src)) && !usr.restrained() && (I in usr.contents))
			I.Move(src, forced = 1)
			I.dropped(usr)
			play_sound(src, hearers(src), sound('sounds/chronojohn/timemachine_flush.ogg'), falloff = 3)
			for(var/obj/chronojohn/O in world) if(O.network == src.network)
				if(O != src && !(O in range(src)))
					play_sound(O, hearers(O), sound('sounds/chronojohn/timemachine_flush.ogg'), falloff = 3)
				O.update_overlays()
			return 1
		else return ..()
	Bumped(mob/M)
		var/turf/loc = src.loc
		if(!istype(M) || !istype(loc) || !loc.empty(src)) return
		if(M.dir == NORTH && icon_state != "door")
			M.Move(loc, forced = 1)
		else return
	objExit(atom/movable/A)
		if(icon_state == "door" || A.dir != SOUTH) return 0
		return 1
	proc
		update_overlays()
			overlays = list()
			if(!active)
				var/list/L = new/list()
				for(var/obj/chronojohn/O in world)
					if(O.network == src.network)
						for(var/item/I in O.contents) L += I
				if(L && L.len)
					overlays += image(icon = 'icons/chronojohn.dmi', icon_state = "overlayflush", layer = OBJ_LAYER)
				else
					overlays += image(icon = 'icons/chronojohn.dmi', icon_state = "overlay", layer = OBJ_LAYER)
		relayMove(mob/M, newloc, newdir) return
		activate()
			if(active || operating) return
			icon_state = "door"
			operating = 1
			active = 1
			overlays = list()
			for(var/mob/M in range(10, src))
				M.PlaySound(sound('sounds/chronojohn/teleport.ogg', repeat = 0, wait = 0, channel = 88))
				M.PlaySound(sound('sounds/chronojohn/timecar_active.ogg', repeat = 1, wait = 1, channel = 88))
			spawn(40)
				icon_state = "active"
			spawn(82)
				icon_state = "blank"
				for(var/mob/M in loc) if(M.invisibility == 0) M.invisibility = 99
				flick("rollup", src)
			spawn(120)
				operating = 0
				icon_state = "door"
				src.Move(null, forced = 1)
				for(var/mob/M in src) if(M.invisibility == 99) M.invisibility = 0
		drop(turf/T)
			if(!active || operating || !T) return
			operating = 1
			src.Move(T, forced = 1)
			world << sound(null, channel = 88)
			for(var/mob/M in range(10, src))
				M.PlaySound(sound('sounds/chronojohn/timemachine_land.ogg', repeat = 0, wait = 0, channel = 88))
			spawn(25)
				active = 0
				update_overlays()
				icon_state = ""
				operating = 0
	Move(turf/newloc, newdir, forced = 0)
		var/turf/oldloc = src.loc
		. = ..()
		if(loc != oldloc)
			if(loc)
				for(var/mob/M in oldloc) M.Move(loc, forced = 1)
				for(var/mob/M in src) M.Move(loc, forced = 1)
			else
				for(var/mob/M in oldloc) M.Move(src, forced = 1)

sadmin/verb
	activate_chron(obj/chronojohn/O in chronojohns)
		set category = null
		if(!O) return

		O.activate()
	drop_chron(obj/chronojohn/O in chronojohns, var/x as num, var/y as num, var/z as num)
		set category = null
		if(!O) return

		O.drop(locate(x, y, z))