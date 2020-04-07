spell_component/portal
	portal
		name = "Create Portal"
		icon_state = "portal"
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
					sleep(150)
					M.movable = 0
				if(M.CheckAlive())
					send_message(ohearers(M), "\blue [M.name] casts <b>Portal!</b>", 1)
					M.show_message("\blue You cast <b>Portal!</b>")
					if(M.Portal2)
						M.Portal2.Move(null, forced = 1)
						M.Portal2 = null
					M.Portal2 = new/obj/portal(M.loc)
					M.Portal2.owner = M
	gate
		name = "Create Portal Gate"
		icon_state = "gate"
		mana_cost = 20
		invoke(mob/M)
			var/area/A = get_area(M)
			if(istype(A, /area/school_of_magic/ghost_area) || istype(A, /area/school_of_magic/ghost_area_2))
				M.show_message("<tt>You can't cast this spell here!</tt>")
				return 1
			if(usr.CheckAlive() && !usr.movable)
				if(!(master.flags & master.FLAG_SUPER))
					send_message(ohearers(M), "\blue [M.name] begins to create a gate.", 1)
					M.show_message("\blue You sit down and meditate.")
					M.movable = 1
					sleep(150)
					M.movable = 0
				if(M.CheckAlive())
					send_message(ohearers(M), "\blue [M.name] casts <b>Gate!</b>", 1)
					M.show_message("\blue You cast <b>Gate!</b>")
					if(M.Portal1)
						M.Portal1.Move(null, forced = 1)
						M.Portal1 = null
					M.Portal1 = new/obj/portal(M.loc)
					M.Portal1.owner = M
	dissolve
		name = "Dissolve Portal"
		icon_state = "dissolve_portal"
		mana_cost = 30
		activate(mob/M)
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on a portal to dissolve.</tt>")
		invoke(mob/M, obj/portal/O)
			if(!istype(O))
				M.show_message("<tt>You did not select a portal. Spell aborted.</tt>")
				return 1
			if(istype(O, /obj/portal/school_of_magic))
				M.show_message("<tt>This portal is magically protected!</tt>")
				return 1
			if(!(master.flags & master.FLAG_SUPER))
				send_message(ohearers(M), "\blue [M.name] begins to dissolve a portal.", 1)
				M.show_message("\blue You begin to dissolve the portal.")
				M.movable = 1
				sleep(O.owner == M ? 150 : 300)
				M.movable = 0
			if(M.CheckAlive())
				send_message(ohearers(M), "\blue [M.name] dissolves the portal!", 1)
				M.show_message("\blue You dissolve the portal!")
				del O //otherwise I gotta search for references anyway

spell/portal
	name = "Portal"
	components = newlist(/spell_component/portal/gate, /spell_component/portal/portal, /spell_component/portal/dissolve)
	flags = FLAG_SPELLBOOK | FLAG_MAGE