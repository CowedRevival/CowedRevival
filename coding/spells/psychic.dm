spell/psychic
	name = "Psychic"
	components = newlist(/spell_component/psychic)
	flags = FLAG_MAGE

spell_component/psychic
	name = "Psychic"
	icon_state = "psychic"
	mana_cost = 10
	cooldown = 300
	activate(mob/M)
		if(!M || !M.effects) return
		M.effects.psychic = min(M.effects.psychic + 20, 80)
		for(var/mob/N in ohearers(M))
			N.show_message("\blue [M.name] touches [M.gender == FEMALE ? "her":"his"] forehead and stops moving...")
		M.show_message("\blue You touch your forehead and connect with the spiritual realm!")