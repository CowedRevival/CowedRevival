spell_component/shield
	name = "Shield"
	icon_state = "shield"
	mana_cost = 0
	var
		mob/target
	activate(mob/M)
		if(target)
			target.spell_shield = null
			M.show_message("<tt>Your shield spell is now disabled.</tt>")
			target.UpdateClothing()
			target = null
		else
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on a person to shield them.</tt>")
	invoke(mob/M, mob/T)
		if(!istype(T) || T.spell_shield)
			M.show_message("<tt>You did not select a person, or the person you selected is already being affected by a similar spell. Spell aborted.</tt>")
			return 1
		else
			if(!(master.flags & master.FLAG_SUPER))
				send_message(ohearers(M), "\blue [M.name] points his finger at the [T.name].", 1)
				M.show_message("\blue You point your finger at the [T.name].")

				M.movable = 1
				sleep(50)
				M.movable = 0

			if(M.CheckAlive() && (T in range(M)))
				send_message(ohearers(M), "\blue [M.name] casts <b>Shield</b> on the [T.name].", 1)
				M.show_message("\blue You have cast <b>Shield</b> on the [T.name].")
				T.spell_shield = M
				src.target = T
				T.UpdateClothing()
	onSleep(mob/M)
		. = ..()
		if(target)
			target.spell_shield = null
			M.show_message("<tt>Your shield spell has worn off.</tt>")
			target.UpdateClothing()
			target = null

spell/shield
	name = "Mana Shield"
	components = newlist(/spell_component/shield)
	flags= FLAG_SPELLBOOK | FLAG_MAGE