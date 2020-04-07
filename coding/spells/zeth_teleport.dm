spell_component/zeth_teleport
	mark
		name = "Set Teleport Location"
		icon_state = "zeth_mark"
		cooldown = 5
		mana_cost = 0
		invoke(mob/M)
			var/spell/zeth_teleport/Z = master
			if(!M.CheckAlive() || !isturf(M.loc)) return 1
			Z.target = M.loc
			M.show_message("<tt>You have set the teleport destination to your current location.</tt>")
	teleport
		name = "Teleport"
		icon_state = "zeth_teleport"
		cooldown = 300
		mana_cost = 90
		invoke(mob/M)
			var/spell/zeth_teleport/Z = master
			if(!Z.target || !M.CheckAlive()) return 1
			if(!(master.flags & master.FLAG_SUPER))
				for(var/mob/N in ohearers(M))
					N.show_message("\blue [M.name] starts to move his hands...")
				M.show_message("\blue You start to move your hands...")
				var/count = M.moveCount
				sleep(20)
				if(!M.CheckAlive() || M.moveCount != count) return 1
			for(var/mob/N in ohearers(M))
				N.show_message("\blue [M.name] touches [M.gender == FEMALE ? "her":"his"] forehead and disappears[ismob(M.whopull) ? " along with [M.whopull]":]...")
			M.show_message("\blue You touch your forehead and move to a new location!")
			M.PlaySound(sound('sounds/teleport_u.ogg'))
			if(ismob(M.whopull))
				M.whopull.Move(Z.target, forced = 1)
				var/mob/N = M.whopull
				N.PlaySound('sounds/teleport_u.ogg')
			play_sound(M, ohearers(M) - M.whopull, sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))
			M.Move(Z.target, forced = 1)
			play_sound(M, ohearers(M) - M.whopull, sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))
		canInvoke(mob/M)
			var/spell/zeth_teleport/Z = master
			if(!istype(Z) || !Z.target || (Z.target in view(M))) return -2
			return ..()
		Requirements() return "A location set using the \"Set Teleport Location\" component; the location set may not be within LOS."

spell/zeth_teleport
	components = newlist(/spell_component/zeth_teleport/teleport, /spell_component/zeth_teleport/mark)
	var/turf/target
	flags = 0