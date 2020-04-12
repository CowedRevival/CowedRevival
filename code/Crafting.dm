mob/startingverb/verb
	Construct()
		set name = "Build/Craft"
		create_crafting()
		winset(src,"crafting_window","is-visible=true")


mob/proc/create_crafting()

	//Items
	item_button_list = new()
	item_button_list += new/button/item/rope()
	item_button_list += new/button/item/wood_bucket()
	item_button_list += new/button/item/paper()
	item_button_list += new/button/item/wood_shutter()
	item_button_list += new/button/item/rope_bridge()
	item_button_list += new/button/construction/trap_door()
	item_button_list += new/button/item/glass_vial()

	//Equipment
	equipment_button_list = new()
	equipment_button_list += new/button/item/wood_armor()
	equipment_button_list += new/button/item/wood_helmet()
	equipment_button_list += new/button/item/wood_sword()
	equipment_button_list += new/button/item/wood_shield()
	equipment_button_list += new/button/item/wood_club()
	equipment_button_list += new/button/item/hunting_spear()
	equipment_button_list += new/button/item/primitive_halberd()

	//Building
	building_button_list = new()
	building_button_list += new/button/construction/fire()

	building_button_list += new/button/construction/wood_wall()
	building_button_list += new/button/construction/false_wood_wall()
	building_button_list += new/button/construction/wood_window()
	building_button_list += new/button/construction/wood_door()
	building_button_list += new/button/construction/wood_floor()
	building_button_list += new/button/construction/stone_wall()
	building_button_list += new/button/construction/stone_false_wall()
	building_button_list += new/button/construction/stone_window()
	building_button_list += new/button/construction/stone_door()
	building_button_list += new/button/construction/stone_floor()

	building_button_list += new/button/construction/chest()
	building_button_list += new/button/construction/cupboard()
	building_button_list += new/button/construction/bed()

	building_button_list += new/button/construction/wood_table()
	building_button_list += new/button/construction/wood_chair()

	building_button_list += new/button/construction/fence()
	building_button_list += new/button/construction/gate()


	building_button_list += new/button/construction/stone_stairs()
	building_button_list += new/button/construction/sign()
	building_button_list += new/button/construction/gravestone()

	building_button_list += new/button/construction/anvil()

	var/grid_size = round(item_button_list.len / 2) + 1
	winset(src, "items_pane.items_grid", "cells=0x0")
	winset(src, "items_pane.items_grid", "cells=3x[grid_size]")

	grid_size = round(equipment_button_list.len / 2) + 1
	winset(src, "equipment_pane.equipment_grid", "cells=0x0")
	winset(src, "equipment_pane.equipment_grid", "cells=3x[grid_size]")

	grid_size = round(building_button_list.len / 2) + 1
	winset(src, "construction_pane.construction_grid", "cells=0x0")
	winset(src, "construction_pane.construction_grid", "cells=3x[grid_size]")

	var/grid_x = 1
	var/grid_y = 1
	for(var/button/I in item_button_list)
		if(I.Requirements(usr))
			src << output(I,"items_pane.items_grid:[grid_x], [grid_y]")
			grid_x++
			if(grid_x > 3)
				grid_x = 1
				grid_y++

	grid_x = 1
	grid_y = 1
	for(var/button/I in equipment_button_list)
		if(I.Requirements(usr))
			src << output(I,"equipment_pane.equipment_grid:[grid_x], [grid_y]")
			grid_x++
			if(grid_x > 3)
				grid_x = 1
				grid_y++

	grid_x = 1
	grid_y = 1
	for(var/button/I in building_button_list)
		if(I.Requirements(usr))
			src << output(I,"construction_pane.construction_grid:[grid_x], [grid_y]")
			grid_x++
			if(grid_x > 3)
				grid_x = 1
				grid_y++

	/*src << output(new/button/carpentry/wood_armor,"carpentry_grid:1,1")
	src << output(new/button/carpentry/wood_armor,"carpentry_grid:2,1")
	src << output(new/button/carpentry/wood_armor,"carpentry_grid:1,2")
	src << output(new/button/carpentry/wood_armor,"carpentry_grid:2,2")
	src << output(new/button/carpentry/wood_armor,"carpentry_grid:1,3")*/

mob/var/list/item_button_list
mob/var/list/equipment_button_list
mob/var/list/building_button_list

/*mob/proc/CheckCraft(item/A, item/B, reversed = 0)
	if((!A || !B) || (A == B && A.stacked <= 1)) return
	var/dont_check = 0
	if(src.skills && src.skills.carpenting >= 35)
		if(istype(A, /item/misc/stone))
			if(istype(B, /item/misc/stone))
				dont_check = 1
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				if(--A.stacked <= 0) A.Move(null, forced = 1)
				if(--B.stacked <= 0) B.Move(null, forced = 1)

				if(!prob(src.skills.carpenting + 25))
					src.show_message("<em><small>You failed to craft a <b>Heavy Stone</b>!</small></em>")
					return

				contents += new/item/misc/Heavy_Stone
				for(var/mob/N in ohearers(src))
					N.show_message("<em><small>[name] throws two stones together!</small></em>")
				src.show_message("<em><small>You throw two stones together to get a <b>Heavy Stone</b>!</small></em>")
			else if(istype(B, /item/weapon/knife))
				dont_check = 1
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++

				if(--A.stacked <= 0) A.Move(null, forced = 1)

				if(!prob(src.skills.carpenting + 25))
					src.show_message("<em><small>You failed to craft a <b>Sharp Stone</b>!</small></em>")
					return

				contents += new/item/misc/Sharp_Stone
				for(var/mob/N in ohearers(src))
					N.show_message("<em><small>[name] cuts a piece of stone with a knife!</small></em>")
				src.show_message("<em><small>You cut a piece of stone together with a knife to get a <b>Sharp Stone</b>!</small></em>")
		else if(istype(A, /item/misc/wood))
			if(istype(B, /item/weapon/knife))
				dont_check = 1
				. = input(src, "What would you like to make?", "Craft") as null|anything in list("Pole", "Wooden Statuette")
				if(. == null) return
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				if(--A.stacked <= 0) A.Move(null, forced = 1)

				if(!prob(src.skills.carpenting + 15))
					src.show_message("<em><small>You failed to craft a <b>[.]</b>!</small></em>")
					return
				switch(.)
					if("Pole")
						contents += new/item/misc/Pole
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] carves his wooden log into a pole!</small></em>")
						src.show_message("<em><small>You carve your wooden log to get a <b>Pole</b>!</small></em>")
					if("Wooden Statuette")
						contents += new/item/misc/Wooden_Statuette
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] carves his wooden log into a wooden statuette!</small></em>")
						src.show_message("<em><small>You carve your wooden log to get a <b>Wooden Statuette</b>!</small></em>")
			else if(istype(B, /item/misc/Rope))
				dont_check = 1
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				if(--A.stacked <= 0) A.Move(null, forced = 1)
				if(--B.stacked <= 0) B.Move(null, forced = 1)
				if(!prob(src.skills.carpenting + 20))
					src.show_message("<em><small>You failed to craft a <b>Rope Bridge</b>!</small></em>")
					return
				contents += new/item/misc/Rope_Bridge
				for(var/mob/N in ohearers(src))
					N.show_message("<em><small>[name] attaches some rope to a wooden log!</small></em>")
				src.show_message("<em><small>You attach some rope to your wooden log to get a <b>Rope Bridge</b>!</small></em>")
			else if(istype(B, /item/misc/wool))
				dont_check = 1
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				if(--A.stacked <= 0) A.Move(null, forced = 1)
				if(--B.stacked <= 0) B.Move(null, forced = 1)
				if(!prob(src.skills.carpenting + 20))
					src.show_message("<em><small>You failed to craft a <b>Paint Brush</b>!</small></em>")
					return
				contents += new/item/misc/paint_brush
				for(var/mob/N in ohearers(src))
					N.show_message("<em><small>[name] attaches [src.gender == FEMALE ? "her" : "his"] wool to some wood!</small></em>")
				src.show_message("<em><small>You attach your wool to some wood to get a <b>Paint Brush</b>!</small></em>")
			else if(istype(B, /item/misc/paper))
				dont_check = 1
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				var/item/misc/paper/P = B
				if(P.content)
					src.show_message("<tt>The paper must not be written on.</tt>")
					return
				B.Move(null, forced = 1)
				if(--A.stacked <= 0) A.Move(null, forced = 1)
				if(!prob(src.skills.carpenting + 20))
					src.show_message("<em><small>You failed to craft a <b>Painting</b>!</small></em>")
					return
				contents += new/item/misc/painting
				for(var/mob/N in ohearers(src))
					N.show_message("<em><small>[name] attaches a piece of paper to some wood!</small></em>")
				src.show_message("<em><small>You attach a piece of paper to some wood to get a <b>Painting</b>!</small></em>")
			else if(istype(B, /item/misc/Hemp))
				dont_check = 1
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				if(--A.stacked <= 0) A.Move(null, forced = 1)
				if(--B.stacked <= 0) B.Move(null, forced = 1)
				contents += new/item/misc/arrows/wooden
				contents += new/item/misc/seeds/Hemp_Seeds
				contents += new/item/misc/seeds/Hemp_Seeds
				if(!prob(src.skills.carpenting + 10))
					src.show_message("<em><small>You failed to craft an <b>Arrow</b>!</small></em>")
					return
				for(var/mob/N in ohearers(src))
					N.show_message("<em><small>[name] attaches [src.gender == FEMALE ? "her" : "his"] hemp to some wood!</small></em>")
				src.show_message("<em><small>You attach some hemp to your wood get an <b>Arrow</b>!</small></em>")
			else if(istype(B, /item/misc/wood))
				dont_check = 1
				. = input(src, "What would you like to make?", "Craft") as null|anything in list("Wood Torso", "Wood Club", "Wood Sword", "Wood Shield", "Wood Helmet", "Waterstone Box")
				if(. == null) return
				if(--A.stacked <= 0) A.Move(null, forced = 1)
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				if(!prob(src.skills.carpenting))
					src.show_message("<em><small>You failed to craft a <b>[.]</b>!</small></em>")
					return

				switch(.)
					if("Wood Torso")
						contents += new/item/armour/body/wood_torso
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a wood torso!</small></em>")
						src.show_message("<em><small>You craft wood to get a <b>Wood Torso</b>!</small></em>")
					if("Wood Club")
						contents += new/item/weapon/wood_club
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a wooden club!</small></em>")
						src.show_message("<em><small>You craft wood to get a <b>Wooden Club</b>!</small></em>")
					if("Wood Sword")
						contents += new/item/weapon/wood_sword
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a wooden sword!</small></em>")
						src.show_message("<em><small>You craft wood to get a <b>Wooden Sword</b>!</small></em>")
					if("Wood Shield")
						contents += new/item/weapon/wood_shield
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a wooden shield!</small></em>")
						src.show_message("<em><small>You craft wood to get a <b>Wooden Shield</b>!</small></em>")
					if("Wood Helmet")
						contents += new/item/armour/hat/wood_helmet
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a wooden helmet!</small></em>")
						src.show_message("<em><small>You craft wood to get a <b>Wooden Helmet</b>!</small></em>")
					if("Waterstone Box")
						contents += new/item/misc/waterstone_box
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a box!</small></em>")
						src.show_message("<em><small>You craft wood to get a <b>Waterstone Box</b>!</small></em>")
					if("Fishing Rod")
						contents += new/item/weapon/fishing_rod
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a fishing rod!</small></em>")
						src.show_message("<em><small>You craft wood to get a <b>Fishing Rod</b>!</small></em>")
		else if(istype(A, /item/misc/Pole))
			if(istype(B, /item/misc/Sharp_Stone))
				dont_check = 1
				. = input(src, "What would you like to make?", "Craft") as null|anything in list("Axe", "Hoe", "Pickaxe", "Shovel", "Spear")
				if(. == null) return
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				A.Move(null, forced = 1)
				if(--B.stacked <= 0) B.Move(null, forced = 1)
				if(!prob(src.skills.carpenting + 20))
					src.show_message("<em><small>You failed to craft a <b>[.]</b>!</small></em>")
					return
				switch(.)
					if("Axe")
						contents += new/item/weapon/axe
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts an axe!</small></em>")
						src.show_message("<em><small>You combine a pole and a sharp stone to get an <b>Axe</b>!</small></em>")
					if("Hoe")
						contents += new/item/weapon/hoe
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a hoe!</small></em>")
						src.show_message("<em><small>You combine a pole and a sharp stone to get a <b>Hoe</b>!</small></em>")
					if("Pickaxe")
						contents += new/item/weapon/pickaxe
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a pickaxe!</small></em>")
						src.show_message("<em><small>You combine a pole and a sharp stone to get a <b>Pickaxe</b>!</small></em>")
					if("Shovel")
						contents += new/item/weapon/shovel
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a shovel!</small></em>")
						src.show_message("<em><small>You combine a pole and a sharp stone to get a <b>Shovel</b>!</small></em>")
					if("Spear")
						contents += new/item/weapon/spear
						for(var/mob/N in ohearers(src))
							N.show_message("<em><small>[name] crafts a spear!</small></em>")
						src.show_message("<em><small>You combine a pole and a sharp stone to get a <b>Spear</b>!</small></em>")
		else if(istype(A, /item/misc/Hemp))
			if(istype(B, /item/misc/Hemp))
				dont_check = 1
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				if(--A.stacked <= 0) A.Move(null, forced = 1)
				if(--B.stacked <= 0) B.Move(null, forced = 1)
				contents += new/item/misc/Rope
				contents += new/item/misc/seeds/Hemp_Seeds
				contents += new/item/misc/seeds/Hemp_Seeds
				contents += new/item/misc/seeds/Hemp_Seeds
				if(!prob(src.skills.carpenting + 20))
					src.show_message("<em><small>You failed to craft a <b>Rope</b>!</small></em>")
					return
				for(var/mob/N in ohearers(src))
					N.show_message("<em><small>[name] ties two hemps together!</small></em>")
				src.show_message("<em><small>You tie two hemps together to get <b>Rope</b>!</small></em>")
		else if(istype(A, /item/weapon/spear))
			if(istype(B, /item/misc/Heavy_Stone))
				dont_check = 1
				if(prob(1) && src.skills && src.skills.carpenting >= 35 && src.skills.carpenting < 100) src.skills.carpenting++
				A.Move(null, forced = 1)
				B.Move(null, forced = 1)
				contents += new/item/weapon/halberd
				if(!prob(src.skills.carpenting - 5))
					src.show_message("<em><small>You failed to craft a <b>Halberd</b>!</small></em>")
					return
				for(var/mob/N in ohearers(src))
					N.show_message("<em><small>[name] attaches a heavy rock to his spear!</small></em>")
				src.show_message("<em><small>You attach a heavy rock to your spear to get a <b>Halberd</b>!</small></em>")

	if(istype(A, /item/misc/food/Potato))
		if(istype(B, /item/weapon/sledgehammer))
			dont_check = 1
			if(--A.stacked <= 0) A.Move(null, forced = 1)
			contents += new/item/misc/food/Mashed_Potatos
			for(var/mob/N in ohearers(src))
				N.show_message("<em><small>[name] smashes his potatoes with a sledgehammer!</small></em>")
			src.show_message("<em><small>You smash your potatoes with a sledgehammer to get <b>Mashed Potatoes</b>!</small></em>")
		else if(istype(B, /item/weapon/knife))
			dont_check = 1
			if(--A.stacked <= 0) A.Move(null, forced = 1)
			contents += new/item/misc/food/Skinned_Potato
			contents += new/item/misc/Potato_Skin
			for(var/mob/N in ohearers(src))
				N.show_message("<em><small>[name] cuts his potato into pieces with a knife!</small></em>")
			src.show_message("<em><small>You cut your potato into pieces with your knife to get a <b>Skinned Potato</b>!</small></em>")
	else if(istype(A, /item/misc/food/Wheat))
		if(istype(B, /item/weapon/sledgehammer))
			dont_check = 1
			if(--A.stacked <= 0) A.Move(null, forced = 1)
			contents += new/item/misc/food/Flour
			for(var/mob/N in ohearers(src))
				N.show_message("<em><small>[name] smashes his wheat with a sledgehammer!</small></em>")
			src.show_message("<em><small>You smash your wheat with a sledgehammer to get <b>Flour</b>!</small></em>")

	if(!reversed && !dont_check) //if not reversed yet, reverse it so the order doesn't matter
		CheckCraft(B, A, 1)*/