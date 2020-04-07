spell_component/heal
	resurrect
		name = "Resurrect"
		icon_state = "resurrect"
		mana_cost = 75
		activate(mob/M)
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on a corpse to resurrect.</tt>")
		invoke(mob/M, mob/T)
			if(!istype(T) || T.HP > 0)
				M.show_message("<tt>You did not select a  Spell aborted.</tt>")
				return 1
			if(!T.corpse || !T.key)
				M.show_message("<tt>The corpse you selected no longer has a soul bound to it... Spell aborted.</tt>")
				return 1
			T.revive()
	heal
		name = "Heal"
		icon_state = "heal"
		cooldown = 25
		mana_cost = 10
		activate(mob/M)
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on a person to heal.</tt>")
		invoke(mob/M, mob/T)
			if(!istype(T))
				M.show_message("<tt>You did not select a person. Spell aborted.</tt>")
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

				if(M.CheckAlive() && (T in range(M, 1)))
					if(T == M)
						send_message(ohearers(M), "\blue [M.name] has healed \himself[M].", 1)
						M.show_message("\blue You have healed yourself.")
					else
						send_message(ohearers(M), "\blue [M.name] has healed [T.name].", 1)
						M.show_message("\blue You have healed [T.name].")

					T.HP += 15
					if(T.HP >= T.MHP) T.HP = T.MHP
					M.SLEEP -= 5

					hud_main.UpdateHUD(M)
					hud_main.UpdateHUD(usr)

spell
	heal
		name = "Heal"
		components = newlist(/spell_component/heal/heal)
	heal_extended
		name = "Heal (extended)"
		components = newlist(/spell_component/heal/heal, /spell_component/heal/resurrect)
		flags = FLAG_SPELLBOOK | FLAG_MAGE