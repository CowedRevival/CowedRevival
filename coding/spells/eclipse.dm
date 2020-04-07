spell_component/eclipse
	name = "Eclipse"
	icon_state = "eclipse"
	mana_cost = 40
	invoke(mob/M)
		if(usr.CheckAlive() && !usr.movable)
			if(!(master.flags & master.FLAG_SUPER))
				send_message(ohearers(M), "\blue [M.name] begins to cast a spell...", 1)
				M.show_message("\blue You begin to cast Eclipse.")
				M.movable = 1
				sleep(50)
				M.movable = 0
			if(M.CheckAlive())
				send_message(ohearers(M), "\blue [M.name] casts <b>Eclipse!</b>", 1)
				M.show_message("\blue You cast <b>Eclipse!</b>")
				solar_eclipse()

spell/eclipse
	name = "Eclipse"
	components = newlist(/spell_component/eclipse)
	flags = FLAG_SPELLBOOK | FLAG_MAGE