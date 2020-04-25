obj/vein
	icon = 'icons/ores_and_veins.dmi'
	icon_state = "empty"
	anchored = 1
	density = 1
	var
		consist
		amountleft
		orename
		hp = 5
	New()
		. =..()
		if(type == /obj/vein)
			if(prob(90))
				var/typechosen = rand(1,100)
				switch(typechosen)
					if(1 to 20)
						new/obj/vein/Copper_Vein(src.loc)
					if(21 to 40)
						new/obj/vein/Tin_Vein(src.loc)
					if(41 to 55)
						new/obj/vein/Tungsten_Vein(src.loc)
					if(56 to 68)
						new/obj/vein/Iron_Vein(src.loc)
					if(69 to 78)
						new/obj/vein/Silver_Vein(src.loc)
					if(79 to 87)
						new/obj/vein/Palladium_Vein(src.loc)
					if(88 to 94)
						new/obj/vein/Gold_Vein(src.loc)
					if(95 to 99)
						new/obj/vein/Mithril_Vein(src.loc)
					if(100)
						new/obj/vein/Magicite_Vein(src.loc)
				loc = null
			else
				new/obj/vein/Clay_Vein(src.loc)
				loc = null
		else if(!amountleft) amountleft = rand(2, 10)
	proc
		ActionLoop(mob/M)
			while(M && M.current_action == src && loc && amountleft > 0 && M.inHand(/item/weapon/pickaxe))
				for(var/mob/N in hearers(M))
					N.show_message("<b>[M.name]</b> swings [M.gender == FEMALE ? "her" : "his"] pickaxe at the [src]...")
				sleep(10)
				if(M && M.current_action == src && loc && amountleft > 0)
					amountleft--
					if((M.skills && M.skills.mining >= 35 && prob(M.skills.mining) && prob(5)) || prob(1))
						M.show_message("<tt>You have found a <b>fire stone</b>!</tt>")
						M.contents += new/item/misc/fire_stone(M)
					else if(prob(60))
						M.show_message("<tt>You have found some <b>stone</b>!</tt>")
						var/item/misc/stone/I = locate() in usr
						if(I)
							I.stacked += 1
							I.suffix = "x[I.stacked]"
						else usr.contents += new/item/misc/stone(M)
					else
						M.show_message("<tt>You have found <b>[orename]</b>!</tt>")
						var/no_of_ore = 1
						if(M.skills.mining >= 50 && prob(M.skills.mining)) no_of_ore += 1
						if(locate(consist) in usr)
							locate(consist).stacked += no_of_ore
							locate(consist).suffix = "x[locate(consist).stacked]"
						else
							M.contents += new consist
							locate(consist).stacked += no_of_ore
							locate(consist).suffix = "x[locate(consist).stacked]"
					if(prob(20) && M.skills.mining < 100) M.skills.mining++
					M.movable = 0
					if(amountleft <= 0) loc = null
				else break
				sleep(10)
			if(M && M.current_action == src) M.AbortAction() //abort the action if we ran out of wood
	attack_hand(mob/M)
		if(M.inHand(/item/weapon/pickaxe))
			if(!M.current_action) M.SetAction(src)
		/*if(M.inHand(/item/weapon/pickaxe))
			M.movable = 1
			for(var/mob/N in hearers(M))
				N.show_message("<b>[M.name]</b> swings [M.gender == FEMALE ? "her" : "his"] pickaxe at the [src]...")
			spawn(10)
				amountleft--
				if(prob(60))
					if((M.chosen == "gatherer" && prob(12)) || prob(3))
						M.show_message("<tt>You have found a <b>fire stone</b>!</tt>")
						M.contents += new/item/misc/fire_stone(M)
					else
						M.show_message("<tt>You have found some <b>stone</b>!</tt>")
						M.contents += new/item/misc/stone(M)
				else
					M.show_message("<tt>You have found <b>[orename]</b>!</tt>")
					if(M.chosen == "gatherer") M.contents += new src.consist
					M.contents += new src.consist
				M.movable = 0
				if(amountleft <= 0) loc = null*/
		else if(M.inHand(/item/weapon/sledgehammer))
			if(--hp <= 0)
				for(var/mob/N in hearers(src))
					N.show_message("<tt>[M.name] smashes the vein to pieces!</tt>")
					Move(null, forced = 1)
			else
				for(var/mob/N in hearers(src))
					N.show_message("<tt>[M.name] hits the vein with [M.gender == FEMALE ? "her" : "his"] sledgehammer!</tt>")
		else
			M.show_message("<tt>You need to equip a pickaxe to mine for ore!</tt>")
	Gold_Vein
		icon_state="Golden Rocks"
		orename="Gold"
		consist=/item/misc/ores/gold_ore
	Iron_Vein
		icon_state="Iron Rocks"
		orename="Iron"
		consist=/item/misc/ores/iron_ore
	Copper_Vein
		icon_state="Copper Rocks"
		orename="Copper Rock"
		consist=/item/misc/ores/copper_ore
	Tin_Vein
		icon_state="Tin Rocks"
		orename="Tin"
		consist=/item/misc/ores/tin_ore
	Magicite_Vein
		icon_state="Magicite Rocks"
		orename="Magicite"
		consist=/item/misc/ores/magicite_ore
	Palladium_Vein
		icon_state="Palladium Rocks"
		orename="Palladium"
		consist=/item/misc/ores/palladium_ore
	Silver_Vein
		icon_state="Silver Rocks"
		orename="Silver"
		consist=/item/misc/ores/silver_ore
	Mithril_Vein
		icon_state="Mithril Rocks"
		orename="Mithril"
		consist=/item/misc/ores/mithril_ore
	Adamantite_Vein
		icon_state="Adamantite Rocks"
		orename="Adamantite"
		consist=/item/misc/ores/adamantite_ore
	Tungsten_Vein
		icon_state="Tungsten Rocks"
		orename="Tungsten"
		consist=/item/misc/ores/tungsten_ore
	Clay_Vein
		icon_state="Clay Rocks"
		orename="Clay"
		consist=/item/misc/Raw_Clay