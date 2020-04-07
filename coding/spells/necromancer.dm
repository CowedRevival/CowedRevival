spell_component/necromancer
	/*teleport
		name = "Teleport To Sanctuary"
		icon_state = "necro_teleport"
		cooldown = 300
		mana_cost = 90
		invoke(mob/M)
			if(!M.CheckAlive()) return 1
			if(!(master.flags & master.FLAG_SUPER))
				for(var/mob/N in ohearers(M))
					N.show_message("\blue [M.name] starts to move his hands...")
				M.show_message("\blue You start to move your hands...")
				var/count = M.moveCount
				sleep(20)
				if(!M.CheckAlive() || M.moveCount != count) return 1
			for(var/mob/N in ohearers(M))
				N.show_message("\blue [M.name] closes [M.gender == FEMALE ? "her":"his"] eyes and disappears[ismob(M.whopull) ? " along with [M.whopull]":]...")
			M.show_message("\blue You close your eyes and move to your safehouse!")
			M.PlaySound(sound('sounds/teleport_u.ogg'))
			var/turf/target = locate(89, 134, 3)
			if(ismob(M.whopull))
				M.whopull.Move(target, forced = 1)
				var/mob/N = M.whopull
				N.PlaySound('sounds/teleport_u.ogg')
			play_sound(M, ohearers(M) - M.whopull, sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))
			M.Move(target, forced = 1)
			play_sound(M, ohearers(M) - M.whopull, sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))*/
	reanimate
		name = "Reanimate Corpse"
		icon_state = "reanimate"
		cooldown = 50
		mana_cost = 30
		activate(mob/M)
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on a corpse to resurrect.</tt>")
		invoke(mob/M, mob/T)
			var/item/misc/books/Necro/B = locate() in M.contents
			if(!B)
				M.show_message("<tt>You can only use this spell if you are in possession of a Necromancer's Book.</tt>")
				return 1

			if(!istype(T) || T.HP > 0)
				M.show_message("<tt>You did not select a  Spell aborted.</tt>")
				return 1
			var/name = T.name
			if(B.bind(T, M))
				M.show_message("<tt>You have reanimated [name]'s </tt>")
			else
				M.show_message("<tt>You were unable to reanimate [name]'s .. no soul could not be found.</tt>")
		canInvoke(mob/M)
			var/item/misc/books/Necro/B = locate() in M.contents
			if(!B) return -2
			return ..()
		Requirements() return "Necromancer's Book in inventory."
	kill
		name = "Kill Minion"
		icon_state = "necro_kill"
		cooldown = 100
		mana_cost = 5
		activate(mob/M)
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on a minion to kill.</tt>")
		invoke(mob/M, mob/T)
			var/item/misc/books/Necro/B = locate() in M.contents
			if(!B)
				M.show_message("<tt>You can only use this spell if you are in possession of a Necromancer's Book.</tt>")
				return 1

			if(!istype(T) || !(T in B.bound))
				M.show_message("<tt>You did not select a minion. Spell aborted.</tt>")
				return 1
			M.show_message("<tt>You have killed off [T.name].</tt>")
			B.kill(T)
		canInvoke(mob/M)
			var/item/misc/books/Necro/B = locate() in M.contents
			if(!B) return -2
			return ..()
		Requirements() return "Necromancer's Book in inventory."
	kill_remote
		name = "Kill Minion (Remotely)"
		icon_state = "necro_killr"
		cooldown = 120
		mana_cost = 40
		invoke(mob/M)
			var/item/misc/books/Necro/B = locate() in M.contents
			if(!B)
				M.show_message("<tt>You can only use this spell if you are in possession of a Necromancer's Book.</tt>")
				return 1
			var/list/L = new/list()
			for(var/mob/N in B.bound) if(N.HP > 0) L += N
			if(!L || !L.len)
				M.show_message("You do not have any live minions to kill.")
				return 1
			var/mob/N = input(M, "Select a minion from the list below.", "Kill Minion") as null|anything in L
			if(!N) return 1
			if((B in M.contents) && N.HP > 0)
				M.show_message("<tt>You have killed off [N.name].</tt>")
				B.kill(N)
			else
				M.show_message("<tt>You are no longer in possession of the book, or the minion is already dead... Spell aborted.</tt>")
				return 1
		canInvoke(mob/M)
			var/item/misc/books/Necro/B = locate() in M.contents
			if(!B) return -2
			return ..()
		Requirements() return "Necromancer's Book in inventory."
	unbind
		name = "Unbind Minion"
		icon_state = "necro_unbind"
		cooldown = 100
		mana_cost = 5
		activate(mob/M)
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on a minion to unbind. This action cannot be undone!</tt>")
		invoke(mob/M, mob/T)
			var/item/misc/books/Necro/B = locate() in M.contents
			if(!B)
				M.show_message("<tt>You can only use this spell if you are in possession of a Necromancer's Book.</tt>")
				return 1

			if(!istype(T) || !(T in B.bound))
				M.show_message("<tt>You did not select a minion. Spell aborted.</tt>")
				return 1
			M.show_message("<tt>You have unbound [T.name] from the book. [T.gender == "female" ? "She" : "He"] is no longer under your control.</tt>")
			B.unbind(T)
		canInvoke(mob/M)
			var/item/misc/books/Necro/B = locate() in M.contents
			if(!B) return -2
			return ..()
		Requirements() return "Necromancer's Book in inventory."

spell/necromancer
	components = newlist(/*/spell_component/necromancer/teleport,*/ /spell_component/necromancer/reanimate, /spell_component/necromancer/kill, /spell_component/necromancer/kill_remote, /spell_component/necromancer/unbind)