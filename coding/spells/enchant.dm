spell_component/enchant
	name = "Enchant"
	icon_state = "enchant"
	mana_cost = 30
	var
		atom/target
	activate(mob/M)
		M.selectedSpellComponent = src
		M.show_message("<tt>Click on the object to enchant.</tt>")
	invoke(mob/M, atom/A)
		if(!target && istype(A, /obj/gong))
			var/obj/gong/O = A
			if(O.ActionLock("enchanted"))
				M.show_message("<tt>The gong is already enchanted!</tt>")
				return 1
			O.enchant()
		else if(istype(A, /item/misc/fire_stone) && (!target || istype(target, /item/misc/fire_stone)) && A != target)
			if(!target)
				var/item/misc/fire_stone/I = A
				if(I.flags & I.FLAG_ENCHANTED)
					M.show_message("<tt>That fire stone is already enchanted! Spell aborted.</tt>")
					return 1
				target = A
				M.selectedSpellComponent = src
				M.show_message("<tt>Now click on another fire stone to connect them.</tt>")
				return 1
			else
				var/item/misc/fire_stone
					S1 = target
					S2 = A
				target = null
				if((S1.flags & S1.FLAG_ENCHANTED) || (S2.flags & S2.FLAG_ENCHANTED))
					M.show_message("<tt>That fire stone is already enchanted! Spell aborted.</tt>")
					return 1
				S1.flags |= S1.FLAG_ENCHANTED
				S2.flags |= S2.FLAG_ENCHANTED
				S1.id = ++S1._id
				S2.id = S1.id
				M.show_message("<tt>The fire stones are now linked.</tt>")
		else if(istype(A, /item/misc/waterstone))
			var/item/misc/waterstone/W = A
			if(!W.enchanted)
				if(!target)
					target = A
					M.selectedSpellComponent = src
					M.show_message("<tt>Now click on another water stone to connect them.</tt>")
					return 1
				else
					var/item/misc/waterstone/E = target
					target = null
					if(istype(W) && istype(E) && !W.enchanted && !E.enchanted)
						W.enchanted = 1
						E.enchanted = 1
						W.secondStone = E
						E.secondStone = W
						var/id = ++W.id
						W.name = "waterstone- '[id]'"
						E.name = "waterstone- '[id]'"
						return 0
					M.show_message("<tt>You did not select another water stone or one of them has already been enchanted! Spell aborted.</tt>")
					return 1
			else
				if(!W.ActionLock("toggle_magics", 50))
					M.show_message("<tt>You attempt to trigger the water stone's inherent magic...</tt>")
					W.toggle()
				else
					M.show_message("<tt>You can't enchant this water stone yet; please try again later!</tt>")
		else if(istype(A, /item/misc/waterstone_box))
			var/item/misc/waterstone_box/O = A
			if(O.enchanted)
				M.show_message("<tt>The box is already enchanted!</tt>")
				return 1
			O.enchant()
		else if(istype(A, /obj/portal/school_of_magic))
			var/obj/portal/school_of_magic/O = A
			if(O.enchanted || O.ActionLock("enchanted"))
				M.show_message("<tt>The portal is already enchanted!</tt>")
				return 1
			O.enchant()
		else if(istype(A, /obj/door))
			var/obj/door/T = A
			if(T.enchanted == M)
				T.enchanted = null
			else if(T.enchanted)
				if(M.CheckAlive())
					if(!(master.flags & master.FLAG_SUPER))
						send_message(ohearers(M), "\blue [M.name] sits down and meditates.", 1)
						M.show_message("\blue You sit down and meditate.")
						sleep(T.gold ? 300 : 200)
					if(M.CheckAlive())
						send_message(ohearers(M), "\blue [M.name] casts <b>Enchant!</b>", 1)
						M.show_message("<font color=blue>You cast <b>Enchant!</b>")
						if(!T.gold || prob(25))
							M.show_message("<tt>The door is no longer enchanted.</tt>")
							T.enchanted = null
						else
							M.show_message("<tt>The spell fizzles! Try again!</tt>")
			else
				if(M.CheckAlive())
					if(!(master.flags & master.FLAG_SUPER))
						send_message(ohearers(M), "\blue [M.name] sits down and meditates.", 1)
						M.show_message("\blue You sit down and meditate.")
						sleep(T.gold ? 300 : 200)
					if(M.CheckAlive())
						send_message(ohearers(M), "\blue [M.name] casts <b>Enchant!</b>", 1)
						M.show_message("<font color=blue>You cast <b>Enchant!</b>")
						if(!T.gold || prob(25))
							M.show_message("<tt>The door is now enchanted.</tt>")
							T.enchanted = M
						else
							M.show_message("<tt>The spell fizzles! Try again!</tt>")
		else
			M.show_message("<tt>You did not select a compatible target. Spell aborted.</tt>")
			target = null
			return 1

spell/enchant
	name = "Enchant"
	components = newlist(/spell_component/enchant)
	flags = FLAG_SPELLBOOK