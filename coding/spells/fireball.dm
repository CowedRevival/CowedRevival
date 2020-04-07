spell_component/fireball
	name = "Fireball"
	icon_state = "fireball"
	cooldown = 25
	mana_cost = 25
	invoke(mob/M)
		send_message(ohearers(M), "\blue [M] begins to wave his hands around swiftly.", 1)
		M.show_message("\blue You begin to wave your hands around swiftly.")
		sleep(6)
		if(M.CheckAlive())
			send_message(ohearers(M), "\blue [M.name] casts <b>Fireball!</b>", 1)
			M.show_message("\blue You cast <b>Fireball!</b>")
			var/obj/Fireball/F = new(M.loc)
			F.dir = M.dir
			play_sound(M, hearers(M), sound(pick('Sounds/spells/fireball_1.ogg', 'Sounds/spells/fireball_2.ogg', 'Sounds/spells/fireball_3.ogg', 'Sounds/spells/fireball_4.ogg', 'Sounds/spells/fireball_5.ogg')))

spell/fireball
	name = "Fireball"
	components = newlist(/spell_component/fireball)
	flags = FLAG_SPELLBOOK | FLAG_MAGE