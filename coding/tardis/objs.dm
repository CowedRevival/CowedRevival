obj/tardis
	icon = 'icons/tardis/tardis.dmi'
	anchored = 1
	var/obj/tardis/tardis/master
	grille
		icon = 'icons/tardis/tardis_grille.dmi'
		pixel_y = 12
		layer = TURF_LAYER
		mouse_opacity = 0
	console_column //central column: animates when TARDIS is in vortex
		icon_state = "console_column"
		pixel_y = 12
		layer = FLY_LAYER + 0.5
		New()
			. = ..()
			overlays += image(icon = 'icons/tardis/tardis.dmi', dir = NORTH, pixel_y = 32)
	consoles //individual segments; refers to main_console
		name = "TARDIS console"
		icon_state = "console_sides"
		var/obj/tardis/main_console/console
		pixel_y = 12
		New()
			. = ..()
			spawn console = locate() in range(1, src)
		attack_hand(mob/M) return console.attack_hand(M)
	consoles_custom
		name = "TARDIS console"
		icon_state = "console_sides"
		pixel_y = 12
		sign
			density = 1
			dir = 8
			layer = 5
			var
				message = "The TARDIS monitor is completely blank."
			attack_hand(mob/M)
				M << output(null, "sign.output")
				winset(M, "sign", "title=\"TARDIS monitor\"")
				winshow(M, "sign")
				M << output(censorText(src.message), "sign.output")
	ramp
		icon_state = "ramp_center"
		anchored = 1
		layer = TURF_LAYER + 0.1
		pixel_y = 8
	single_door
		name = "door"
		icon_state = "door0"
		density = 1
		opacity = 1
		var
			operating = 0
			locked = 0
		attack_hand(mob/M)
			if(locked) return
			density ? open() : close()
		proc
			open()
				if(operating || !density) return
				operating = 1
				icon_state = "door1"
				flick("dooro", src)
				opacity = 0
				spawn(6)
					density = 0
					operating = 0
			close()
				if(operating || density) return
				operating = 1
				icon_state = "door0"
				flick("doorc", src)
				density = 1
				spawn(6)
					opacity = 1
					operating = 0
	door
		name = "TARDIS doors"
		icon_state = "tardis_door0"
		density = 1
		anchored = 1
		New()
			. = ..()
			overlays += image(icon = 'icons/tardis/tardis.dmi', icon_state = "tardis_doortop0", pixel_y = 32, layer = FLY_LAYER)
		proc
			updateicon()
				icon_state = "tardis_door[master.door == 1 ? 0 : 1]"
				overlays = list()
				overlays += image(icon = 'icons/tardis/tardis.dmi', icon_state = "tardis_doortop[master.door == 1 ? 0 : 1]", pixel_y = 32, layer = FLY_LAYER)
		Bumped(mob/M)
			if(master && master.door == 1)
				M.dir = SOUTH
				var/turf/T = get_step(master.loc, SOUTH)
				if(T)
					for(var/atom/movable/A in T)
						if(!A.anchored)
							step(A, SOUTH)
							return
					M.Move(T, SOUTH)
				return
			return ..()
		attack_hand(mob/M) if(master) return master.attack_hand(M)
		hear(mob/M, msg)
			. = ..()
			if(istype(M) && master.intercom == 2)
				for(var/mob/N in range(master)) N.show_message(msg)
		verb
			toggle_lock()
				set src in view(1)
				if(master.door == -2 || master.door == -1)
					master.door = 0
					usr.show_message("Unlocked [master]")
				else if(master.door == 0)
					master.door = -1
					usr.show_message("Locked [master]")
				else
					usr.show_message("You must close the door first!")
					return
