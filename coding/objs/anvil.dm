obj/anvil
	icon = 'icons/Anvil.dmi'
	anchored = 0
	density = 1
	verb/toggle_anchor()
		set src in view(1)
		if(anchored) anchored = 0
		else anchored = 1

	attack_hand(mob/M)
		if(M.shackled || M.movable || M.restrained() || M.icon_state == "ghost") return
		var/list/L = new/list()

		var/item/misc/I = locate(/item/misc/ingot/tin_ingot) in M.contents
		if(I)
			L += list("Tin Sword", "Tin Helm", "Tin Helm Top", "Tin Plate", "Tin Shield")

		I = locate(/item/misc/ingot/copper_ingot) in M.contents
		if(I && M.skills.smithing >= 0)
			L += list("Copper Plate", "Copper Helm", "Copper Helm Top", "Copper Sword", "Copper Shield")

		I = locate(/item/misc/ingot/tungsten_ingot) in M.contents
		if(I && M.skills.smithing >= 20)
			L += list("Tungsten Sword", "Tungsten Helm", "Tungsten Helm Top", "Tungsten Plate", "Tungsten Shield")

		I = locate(/item/misc/ingot/iron_ingot) in M.contents
		if(I && M.skills.smithing >= 20)
			L += list("Iron Sword", "Shackles", "Leg Shackles", "Iron Helm", "Iron Helm Top", "Iron Plate", "Iron Shield", "Iron Hand Pick", "Iron Chisel", "Iron Brush")

		I = locate(/item/misc/ingot/silver_ingot) in M.contents
		if(I && M.skills.smithing >= 40)
			L += list("Silver Sword", "Silver Helm", "Silver Helm Top", "Silver Plate", "Silver Shield")

		I = locate(/item/misc/ingot/palladium_ingot) in M.contents
		if(I && M.skills.smithing >= 60)
			L += list("Palladium Sword", "Palladium Helm", "Palladium Helm Top", "Palladium Plate", "Palladium Shield")

		I = locate(/item/misc/ingot/gold_ingot) in M.contents
		if(I && M.skills.smithing >= 40)
			L += list("Gold Sword", "Gold Helm", "Gold Helm Top", "Gold Plate", "Gold Shield")

		I = locate(/item/misc/ingot/mithril_ingot) in M.contents
		if(I && M.skills.smithing >= 60)
			L += list("Mithril Sword", "Mithril Helm", "Mithril Helm Top", "Mithril Plate", "Mithril Shield")

		I = locate(/item/misc/ingot/magicite_ingot) in M.contents
		if(I && M.skills.smithing >= 80)
			L += list("Magicite Sword", "Magicite Helm", "Magicite Plate", "Magicite Hand Pick", "Magicite Chisel", "Magicite Brush")

		I = locate(/item/misc/ingot/adamantite_ingot) in M.contents
		if(I && M.skills.smithing >= 90)
			L += list("Adamantite Sword", "Adamantite Helm", "Adamantite Helm Top", "Adamantite Plate")

		if(!L || !L.len)
			M.show_message("<tt>You need ingots to use this!</tt>")
			return
		var/choice = input(M, "Select an item to craft.", "Anvil :: Select Item") as null|anything in L
		if(choice == null) return
		if(dd_hasprefix(choice, "Gold ")) I = locate(/item/misc/ingot/gold_ingot, M)
		else if(dd_hasprefix(choice, "Tungsten ")) I = locate(/item/misc/ingot/tungsten_ingot, M)
		else if(dd_hasprefix(choice, "Tin ")) I = locate(/item/misc/ingot/tin_ingot, M)
		else if(dd_hasprefix(choice, "Silver ")) I = locate(/item/misc/ingot/silver_ingot, M)
		else if(dd_hasprefix(choice, "Palladium ")) I = locate(/item/misc/ingot/palladium_ingot, M)
		else if(dd_hasprefix(choice, "Mithril ")) I = locate(/item/misc/ingot/mithril_ingot, M)
		else if(dd_hasprefix(choice, "Magicite ")) I = locate(/item/misc/ingot/magicite_ingot, M)
		else if(dd_hasprefix(choice, "Adamantite ")) I = locate(/item/misc/ingot/adamantite_ingot, M)
		else if(dd_hasprefix(choice, "Copper ")) I = locate(/item/misc/ingot/copper_ingot, M)
		else I = locate(/item/misc/ingot/iron_ingot, M)
		if(!I)
			M.show_message("<tt>It seems you no longer have the ability to create that!</tt>")
			return

		if(--I.stacked <= 0) I.Move(null, forced = 1)
		for(var/mob/N in hearers(M))
			N.show_message("\blue [M.name] starts to smith \an [lowertext(choice)].")
		spawn(20)
			if(prob(50 + (M.skills.smithing / 2)))
				for(var/mob/N in hearers(M))
					N.show_message("\blue [M.name] successfully crafts \an [lowertext(choice)].")
				switch(choice)
					if("Tin Plate") M.contents += new/item/armour/body/tin_plate
					if("Tin Helm") M.contents += new/item/armour/face/tin_helm
					if("Tin Helm Top") M.contents += new/item/armour/hat/tin_helm_top
					if("Tin Sword") M.contents += new/item/weapon/tin_sword
					if("Tin Shield") M.contents += new/item/weapon/tin_shield

					if("Copper Plate") M.contents += new/item/armour/body/copper_plate
					if("Copper Helm") M.contents += new/item/armour/face/copper_helm
					if("Copper Helm Top") M.contents += new/item/armour/hat/copper_helm_top
					if("Copper Sword") M.contents += new/item/weapon/copper_sword
					if("Copper Shield") M.contents += new/item/weapon/copper_shield

					if("Shackles") M.contents += new/item/misc/shackles
					if("Leg Shackles") M.contents += new/item/misc/legshackles
					if("Iron Helm") M.contents += new/item/armour/face/iron_helm
					if("Iron Helm Top") M.contents += new/item/armour/hat/iron_helm_top
					if("Iron Plate") M.contents += new/item/armour/body/iron_plate
					if("Iron Sword") M.contents += new/item/weapon/iron_sword
					if("Iron Shield") M.contents += new/item/weapon/iron_shield
					if("Iron Hand Pick") M.contents += new/item/misc/excavation_tool/hand_pick/iron_hand_pick
					if("Iron Chisel") M.contents += new/item/misc/excavation_tool/chisel/iron_chisel
					if("Iron Brush") M.contents += new/item/misc/excavation_tool/brush/iron_brush

					if("Tungsten Plate") M.contents += new/item/armour/body/tungsten_plate
					if("Tungsten Helm") M.contents += new/item/armour/face/tungsten_helm
					if("Tungsten Helm Top") M.contents += new/item/armour/hat/tungsten_helm_top
					if("Tungsten Sword") M.contents += new/item/weapon/tungsten_sword
					if("Tungsten Shield") M.contents += new/item/weapon/tungsten_shield

					if("Silver Plate") M.contents += new/item/armour/body/silver_plate
					if("Silver Helm") M.contents += new/item/armour/face/silver_helm
					if("Silver Helm Top") M.contents += new/item/armour/hat/silver_helm_top
					if("Silver Sword") M.contents += new/item/weapon/silver_sword
					if("Silver Shield") M.contents += new/item/weapon/silver_shield

					if("Palladium Plate") M.contents += new/item/armour/body/palladium_plate
					if("Palladium Helm") M.contents += new/item/armour/face/palladium_helm
					if("Palladium Helm Top") M.contents += new/item/armour/hat/palladium_helm_top
					if("Palladium Sword") M.contents += new/item/weapon/palladium_sword
					if("Palladium Shield") M.contents += new/item/weapon/palladium_shield

					if("Mithril Plate") M.contents += new/item/armour/body/mithril_plate
					if("Mithril Helm") M.contents += new/item/armour/face/mithril_helm
					if("Mithril Helm Top") M.contents += new/item/armour/hat/mithril_helm_top
					if("Mithril Sword") M.contents += new/item/weapon/mithril_sword
					if("Mithril Shield") M.contents += new/item/weapon/mithril_shield

					if("Magicite Plate") M.contents += new/item/armour/body/magicite_plate
					if("Magicite Helm") M.contents += new/item/armour/face/magicite_helm
					if("Magicite Sword") M.contents += new/item/weapon/magicite_sword
					if("Magicite Hand Pick") M.contents += new/item/misc/excavation_tool/hand_pick/magicite_hand_pick
					if("Magicite Chisel") M.contents += new/item/misc/excavation_tool/chisel/magicite_chisel
					if("Magicite Brush") M.contents += new/item/misc/excavation_tool/brush/magicite_brush

					if("Adamantite Plate") M.contents += new/item/armour/body/adamantite_plate
					if("Adamantite Helm") M.contents += new/item/armour/face/adamantite_helm
					if("Adamantite Helm Top") M.contents += new/item/armour/hat/adamantite_helm_top
					if("Adamantite Sword") M.contents += new/item/weapon/adamantite_sword

					if("Gold Sword") M.contents += new/item/weapon/gold_sword
					if("Gold Shield") M.contents += new/item/weapon/gold_shield
					if("Gold Helm") M.contents += new/item/armour/face/gold_guard_helm
					if("Gold Helm Top") M.contents += new/item/armour/hat/gold_guard_helm_top
					if("Gold Plate") M.contents += new/item/armour/body/gold_guard_plate

				if(M.skills.smithing < 100 && prob(100-(M.skills.smithing * 0.75)))
					M.skills.smithing += 1
			else
				for(var/mob/N in hearers(M))
					N.show_message("\blue [M.name] fails to craft \an [lowertext(choice)].")
				if(M.skills.smithing < 100)
					M.skills.smithing += 1