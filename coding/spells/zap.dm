spell_component/zap
	name = "Zap!"
	icon_state = "zap"
	cooldown = 25
	mana_cost = 25
	invoke(mob/M)
		send_message(ohearers(M), "\blue [M] begins to wave his hands around swiftly.", 1)
		M.show_message("\blue You begin to wave your hands around swiftly.")
		sleep(6)
		if(M.CheckAlive())
			send_message(ohearers(M), "\blue [M.name] casts <b>Zap!</b>", 1)
			M.show_message("\blue You cast <b>Zap!</b>")
			var/obj/Electrozap/F = new(M.loc)
			F.dir = M.dir
			play_sound(M, hearers(M), sound(pick('Sounds/spells/electrozap_1.ogg', 'Sounds/spells/electrozap_2.ogg', 'Sounds/spells/electrozap_3.ogg')))

spell/zap
	name = "Zap!"
	components = newlist(/spell_component/zap)
	flags= FLAG_SPELLBOOK | FLAG_MAGE