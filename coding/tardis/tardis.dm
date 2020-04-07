obj/tardis/tardis //the exterior of the TARDIS
	name = "TARDIS"
	desc = "This looks like a police box from the 1950s."
	icon = 'icons/tardis/tardis_b.dmi'
	icon_state = "null"
	anchored = 1
	density = 1
	var
		dematerialized = 1 //0 = no, 1 = yes, 2 = dematerializing/rematerializing...
		door = 0 //0 = closed; 1 = opened; -1 = locked; -2 = deadlocked
		cloaked = 0 //one second out of sync; 0 = off, 1 = on, -1 = damaged
		intercom = 0 //0: off; 1: receive only; 2: duplex
		forcefield = 0 //0: off; 1: on; -1: damaged
		fused_coordinates = 0 //if set, coordinates can only be changed between last_depart and current
		chameleon = 0 //if set, TARDIS will disguise itself as a bookcase

		state = 0
		const
			STATE_DEMAT = 1
			STATE_ROT = 2
			STATE_BEACON = 4
			STATE_DOOR = 8

			VOID_X = 1
			VOID_Y = 150
			VOID_Z = 1
		obj/tardis
			door/int_door
			main_console/console
			console_column/console_column
		image
			overlay_top
			redX
		area/area

		turf
			destination
			last_departed
	New()
		. = ..()
		spawn
			area = locate(area)
			src.area = area
			for(int_door in area) break
			for(console in area) break
			for(console_column in area) break
			for(var/obj/tardis/O in area) O.master = src
			master = src
			overlay_top = image(icon = 'icons/tardis/tardis_t.dmi', loc = src,pixel_y = 32, layer = FLY_LAYER)
			redX = image(icon = 'icons/classes.dmi', icon_state = "redx", layer = 18)
			updateicon()
	proc
		open_door()
			if(dematerialized) return
			state |= STATE_DOOR
			updateicon()
			for(var/obj/tardis/door/O in world) O.updateicon()
			door = 1
			if(console) console.update()
		close_door()
			state &= ~STATE_DOOR
			updateicon()
			for(var/obj/tardis/door/O in world) O.updateicon()
			if(door == 1) door = 0
			if(console) console.update()
		shake(amount)
			spawn
				var/area/tardis/A = locate(/area/tardis)
				for(var/mob/M in A) if(M.client) spawn
					var/client/C = M.client
					for(var/i=1 to amount)
						if(!C) break
						C.pixel_x += rand(-6,6)
						C.pixel_y += rand(-6,6)
						sleep(2)
					if(C)
						C.pixel_x = 0
						C.pixel_y = 0
		updateicon()
			switch(chameleon)
				if(1) . = "bookcasel"
				if(2) . = "stonedoor"
				if(3) . = "door"
				else . = (state & STATE_DEMAT) ? "" : "null"
			if(chameleon && (state & STATE_DEMAT)) . += "-"
			if(state & STATE_DEMAT) . += "demat"

			if(state & STATE_ROT) . += "-rot"
			if(state & STATE_BEACON) . += "-beacon"
			if(state & STATE_DOOR) . += "-door"
			icon_state = .
			overlays = list(overlay_top)
			if(cloaked == 1)
				overlays += image(icon = 'icons/tardis/tardis.dmi', icon_state = "cloak-top", pixel_y = 32, layer = FLY_LAYER + 0.1)
				overlays += image(icon = 'icons/tardis/tardis.dmi', icon_state = "cloak-bottom")
				invisibility = 2
				density = 0
			else
				invisibility = 0
				density = 1
		dematerialize()
			if(dematerialized != 0 || !console || !int_door || !console_column) return
			dematerialized = 2
			spawn
				src.last_departed = get_turf(src)

				if(door == 1) close_door()
				if(state & STATE_BEACON) state &= ~STATE_BEACON
				console.update()
				if(prob(75)) shake(rand(50,150))

				var/list/recp = range(20, get_turf(loc))
				for(var/mob/M in area.contents) recp += M
				console_column.icon_state = "console_column1"
				recp << sound('sounds/tardis/pretakeoff.ogg')
				sleep(rand(20, 30))
				recp << sound('sounds/tardis/takeoff.ogg')

				sleep(28)

				state |= STATE_DEMAT
				updateicon()

				sleep(102)

				Move(locate(VOID_X, VOID_Y, VOID_Z), forced = 1)
				state &= ~STATE_DEMAT
				updateicon()

				sleep(80)

				dematerialized = 1
				console.update()
		materialize()
			if(dematerialized != 1 || !console || !int_door || !console_column) return
			dematerialized = 2
			spawn
				if(prob(50)) shake(rand(25,100))
				var/list/recp = range(20, destination)
				for(var/mob/M in area.contents) recp += M
				for(var/animal/A in recp) A.ActionLock("scared", 200)
				recp << sound('sounds/tardis/landing.ogg')

				sleep(45)

				state |= STATE_DEMAT
				updateicon()
				Move(destination, forced = 1)

				sleep(155)

				dematerialized = 0
				state &= ~STATE_DEMAT
				updateicon()

				sleep(5)

				console.update()
				console_column.icon_state = "console_column"
		hads()
			if(!destination || !loc || destination.z != loc.z || loc == destination || get_dist(loc, destination) < 2 || get_dist(loc, destination) > 100) return 0
			if(ActionLock("hads", 900)) return -1
			if(prob(55)) shake(rand(10,30))
			var/list/recp = range(20, destination)
			for(var/mob/M in range(20, loc)) if(!(M in recp)) recp += M
			for(var/mob/M in area.contents) recp += M
			for(var/animal/A in recp) A.ActionLock("scared", 200)
			recp << sound('sounds/tardis/outsync.ogg')
			Move(destination, forced = 1)
			return 1
		summon(turf/T)
			if(dematerialized == 2 || !console || !int_door || !console_column) return
			destination = T
			spawn
				if(!dematerialized)
					dematerialize()
					sleep(300)
					while(dematerialized != 1) sleep(25)
				materialize()
	attack_hand(mob/M)
		if(chameleon == 1 && usr.chosen != "timelord")
			usr.show_message("<tt>The books seem to be glued to the bookcase!</tt>")
			return
		if(!door && !dematerialized)
			if(ActionLock("door")) return
			open_door()
		else if(door == 1)
			ActionLock("door", 5)
			close_door()
		else usr.show_message("It's locked!")
	Bumped(mob/M)
		if(ActionLock("door_[M.ckey]", 15)) return
		if(door == 1 && M.dir == NORTH && int_door)
			var/turf/T = get_step(int_door, NORTH)
			if(T)
				for(var/atom/movable/A in T)
					if(!A.anchored)
						step(A, NORTH)
						return
				M.Move(T, NORTH)
			return
		return ..()
	hear(mob/M, msg)
		. = ..()
		if(istype(M) && intercom)
			for(var/mob/N in range(int_door)) N.show_message(msg)