spell_component/teleport
	name = "Teleport"
	icon_state = "teleport"
	cooldown = 300
	mana_cost = 90
	activate(mob/M)
		M.selectedSpellComponent = src
		M.show_message("<tt>Click on a location to teleport to.</tt>")
	invoke(mob/M, turf/T)
		T = get_turf(T)
		if(!istype(T) || T.density)
			M.show_message("<tt>You did not select a valid location. Spell aborted.</tt>")
			return 1

		if(M.CheckAlive())
			if(!(master.flags & master.FLAG_SUPER))
				send_message(ohearers(M), "\blue [M.name] sits down and meditates.", 1)
				M.show_message("\blue You sit down and meditate.")
				sleep(100)
			if(M.CheckAlive())
				send_message(ohearers(M), "\blue [M.name] casts <b>Teleport!</b>", 1)
				M.show_message("<font color=blue>You cast <b>Teleport!</b>")
				M.PlaySound('sounds/teleport_u.ogg')
				if(ismob(M.whopull))
					M.whopull.Move(T, forced = 1)
					var/mob/N = M.whopull
					N.PlaySound('sounds/teleport_u.ogg')
				play_sound(M, ohearers(M) - M.whopull, sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))
				M.Move(T, forced = 1)
				play_sound(M, ohearers(M) - M.whopull, sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))

spell/teleport
	name = "Teleport"
	components = newlist(/spell_component/teleport)
	flags = FLAG_SPELLBOOK | FLAG_MAGE