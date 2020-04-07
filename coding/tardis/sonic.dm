item/misc/sonic_screwdriver
	icon = 'icons/items.dmi'
	icon_state = "sonic_screwdriver"
	New(loc)
		. = ..()
		mouse_drag_pointer = new/icon(src.icon, src.icon_state)
	proc
		toggle_lock(mob/M, obj/chest/O)
			switch(M.attackmode)
				if("Attack") O.locked = 1
				else
					O.locked = !O.locked
					M.show_message("<tt>[O.locked ? "Locked" : "Unlocked"] [O]</tt>")
					if(istype(O) && !O.locked)
						if(!O.opened_by) O.opened_by = new/list()
						if(!(M.key in O.opened_by)) O.opened_by += M.key
	MouseDrop(obj/over_object,src_location,over_location,src_control,over_control,params)
		if(usr.chosen == "timelord")
			if((usr in range(1, over_object)))
				//secondary use no. 2: un-fuse the TARDIS coordinates
				if(istype(over_object, /obj/tardis/consoles))
					var/obj/tardis/consoles/O2 = over_object
					var/obj/tardis/main_console/O = O2.console
					if(O.ActionLock("coordinate_fuse", 50) && O.master.fused_coordinates)
						O.master.fused_coordinates = FALSE
						usr.show_message("\blue You have un-fused the TARDIS coordinates.")
						hearers(usr) << sound('sounds/tardis/sonicscrewdriver.ogg')
					else
						usr.show_message("\blue You can't fuse the coordinates!")
					return
			else
				//secondary use: fuse the TARDIS coordinates/ground the TARDIS
				if(istype(over_object, /obj/tardis/tardis) || istype(over_object, /obj/tardis/door))
					var/obj/tardis/tardis/O = over_object
					O = O.master
					if(O.console.ActionLock("coordinate_fuse", 600) && O.last_departed)
						O.fused_coordinates = TRUE
						usr.show_message("\blue You have fused the TARDIS coordinates.")
						hearers(usr) << sound('sounds/tardis/sonicscrewdriver.ogg')
					else
						usr.show_message("\blue You can't fuse the coordinates!")
					return
		if((usr in range(1, over_object)))
			//primary use: opening/closing doors
			if(istype(over_object, /obj/chest) || istype(over_object, /turf/stone/stone_door) || \
			   istype(over_object, /turf/wooden/wood_door) || istype(over_object, /obj/stone/stone_door) || \
			   istype(over_object, /obj/wooden/wood_door) || istype(over_object, /turf/trapdoor) || \
			   istype(over_object, /obj/family/edison/grandfather_clock) || istype(over_object, /obj/tardis/single_door))
				hearers(usr) << sound('sounds/tardis/sonicscrewdriver2.ogg')
				toggle_lock(usr, over_object)
				return

			//primary use no. 2: overriding the TARDIS door if it's not deadlocked
			if(istype(over_object, /obj/tardis) || istype(over_object, /obj/tardis/door))
				var/obj/tardis/tardis/O = over_object
				O = O.master
				if(O.door == -2)
					usr.show_message("\blue The door is deadlock sealed! You can't open it from the outside!")
				else if(O.door == -1)
					O.door = 0
					usr.show_message("Unlocked [O]")
				else if(O.door == 0)
					O.door = -1
					usr.show_message("Locked [O]")
				else
					usr.show_message("You must close the door first!")
				hearers(usr) << sound('sounds/tardis/sonicscrewdriver2.ogg')
				return
		//else
		return ..()