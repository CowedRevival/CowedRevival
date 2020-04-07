spell_component/school_of_magic
	name = "School of Magic Portal"
	icon_state = "school_of_magic"
	mana_cost = 20
	invoke(mob/M)
		var/area/A = get_area(M)
		if(istype(A, /area/school_of_magic/ghost_area) || istype(A, /area/school_of_magic/ghost_area_2))
			M.show_message("<tt>You can't cast this spell here!</tt>")
			return 1
		if(M.CheckAlive() && !M.movable)
			if(!(master.flags & master.FLAG_SUPER))
				send_message(ohearers(M), "\blue [M.name] begins to create a portal.", 1)
				M.show_message("\blue You sit down and meditate.")
				M.movable = 1
				sleep(50)
				M.movable = 0
			if(M.CheckAlive())
				send_message(ohearers(M), "\blue [M.name] casts <b>Portal!</b>", 1)
				M.show_message("\blue You cast <b>Portal!</b>")
				new/obj/portal/school_of_magic(M.loc, rand(200, 600))

spell/school_of_magic
	name = "School of Magic Portal"
	components = newlist(/spell_component/school_of_magic)
	flags = FLAG_MAGE