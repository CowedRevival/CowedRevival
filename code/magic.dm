mob
	var
		obj/portal
			Portal1
			Portal2

		used_spells = list()

	proc
		other_portal(portal)
			if(Portal1 == portal)
				return Portal2
			else
				return Portal1
		can_use_spell(type, duration)
			if(!usr.CheckAlive()|| usr.movable)
				return 0
			if(type in used_spells)
				return 0
			else
				used_spells += type
				spawn
					sleep(duration * 10)
					used_spells -= type
				return 1


mob
	var
		concentration = 100
		max_concentration = 100

		list/progress = new

		mage = 0
		mage_counter = 0
		can_inscribe = 1
		can_create_book = 0

	New()
		..()
		spawn while(1)
			concentration += round(max_concentration / 20)
			if(concentration > max_concentration)
				concentration = 100
			sleep(100)

	proc/learn_spell(ty, is_primary = 0)
		var/spell/S = new ty(is_primary = is_primary)
		if(!spells) spells = new/list()
		spells += S
		if(client)
			for(var/spell_component/O in S.components) client.screen += O
		hud_main.UpdateHUD(src)
		/*if(istype(S.spell_verb, /list))
			for(var/T in S.spell_verb)
				usr.verbs += T
		else
			usr.verbs += S.spell_verb*/
	proc/remove_spell(spell/S)
		if(!(S in spells)) return
		spells -= S
		if(!spells.len) spells = null
		if(client)
			for(var/spell_component/O in S.components) client.screen -= O
		hud_main.UpdateHUD(src)