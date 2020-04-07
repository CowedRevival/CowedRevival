spell_component/glow
	name = "Glow"
	icon_state = "glow"
	mana_cost = 20
	activate(mob/M)
		M.selectedSpellComponent = src
		M.show_message("<tt>Click on a person to make glow.</tt>")
	invoke(mob/M, mob/T)
		if(!istype(T) || T.luminosity)
			M.show_message("<tt>You did not select a person or the person you selected is already being affected by this or a similar spell. Spell aborted.</tt>")
			return 1
		else
			if(!(master.flags & master.FLAG_SUPER))
				if(T == M)
					send_message(ohearers(M), "\blue [M.name] points his finger at \himself[M].", 1)
					M.show_message("\blue You point your finger at yourself.")
				else
					send_message(ohearers(M), "\blue [M.name] points his finger at [T.name].", 1)
					M.show_message("\blue You point your finger at [T.name].")

				M.movable = 1
				sleep(50)
				M.movable = 0

			if(M.CheckAlive() && (T in range(M)))
				if(T == M)
					send_message(ohearers(M), "\blue [M.name] casts <b>Glow</b> on \himself[M].", 1)
					M.show_message("\blue You have cast <b>Glow</b> on yourself.")
				else
					send_message(ohearers(M), "\blue [M.name] casts <b>Glow</b> on [T.name].", 1)
					M.show_message("\blue You have cast <b>Glow</b> on [T.name].")
				T.ActionLock("spell_luminosity", rand(600, 1200))

spell/glow
	name = "Glow"
	components = newlist(/spell_component/glow)