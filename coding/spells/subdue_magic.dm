spell_component/subdue_magic
	name = "Subdue Magic"
	icon_state = "subdue_magic"
	mana_cost = 30
	activate(mob/M)
		M.selectedSpellComponent = src
		M.show_message("<tt>Click on a staff to subdue.</tt>")
	invoke(mob/M, item/weapon/staff/T)
		if(!istype(T) || T.disabled)
			M.show_message("<tt>You did not select a staff, or the staff you selected is already being affected by a similar spell, or the staff is immune to the powers of this spell. Spell aborted.</tt>")
			return 1
		else
			if(!(master.flags & master.FLAG_SUPER))
				send_message(ohearers(M), "\blue [M.name] points his finger at the [lowertext(T.name)].", 1)
				M.show_message("\blue You point your finger at the [lowertext(T.name)].")

				M.movable = 1
				sleep(50)
				M.movable = 0

			if(M.CheckAlive() && (T in range(M)))
				send_message(ohearers(M), "\blue [M.name] casts <b>Subdue Magic</b> on the [lowertext(T.name)].", 1)
				M.show_message("\blue You have cast <b>Subdue Magic</b> on the [lowertext(T.name)].")
				T.disable(rand(1200, 3000))

spell/subdue_magic
	name = "Subdue Magic"
	components = newlist(/spell_component/subdue_magic)
	flags = FLAG_SPELLBOOK | FLAG_MAGE