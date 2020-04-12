button //Button object
	parent_type = /obj
	var/list/requirements_list
	var/object_name = ""
	var/object_to_make
	var/object_to_build
	var/const
		ITEM = 0
		OBJECT = 1
		TURF = 2
	var/type_of_object = OBJECT

	Click()
		var/message = "Need: "
		var/length = 0
		for(var/J in requirements_list)
			var/item/I = new J
			if(length >= 1) message += " + "
			message += I.name
			length++
		winset(usr, "crafting_window.lbl_requirement", "text = '[message]'")


	DblClick(/mob/usr)
		Invoke(usr)
		usr.create_crafting()

	proc/Requirements(var/mob/M)
		for(var/J in requirements_list)
			var/item/misc/I = locate(J) in M.contents
			if(!I)
				return 0
		return 1
		M.create_crafting()

	proc/Invoke(var/mob/M)
		for(var/J in requirements_list)
			var/item/misc/I = locate(J) in M.contents
			if(!I)
				winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
				return
		for(var/J in requirements_list)
			var/item/misc/I = locate(J) in M.contents
			if(I)
				if(I.stacked > 1)
					I.stacked--
					I.suffix = "x[I.stacked]"
				else
					del(I)
		if(type_of_object == ITEM)
			M.contents += new object_to_make
		else if(type_of_object == TURF)
			build(M, 0, object_to_make, object_to_build)
		else
			new object_to_make(M.loc)
		if(type_of_object == ITEM || type_of_object == OBJECT)
			M << "You've created a [object_name]!"
		M.create_crafting()

	item
		wood_armor
			icon = 'icons/mob.dmi'
			icon_state = "wood_plate"
			object_name = "Wood Armor"
			type_of_object = ITEM
			object_to_make = /item/armour/body/wood_torso
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_helmet
			icon = 'icons/mob.dmi'
			icon_state = "wood_helmet"
			object_name = "Wood Helmet"
			type_of_object = ITEM
			object_to_make = /item/armour/hat/wood_helmet
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_sword
			icon = 'icons/items.dmi'
			icon_state = "wood_sword"
			object_name = "Wood Sword"
			type_of_object = ITEM
			object_to_make = /item/weapon/wood_sword
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_shield
			icon = 'icons/items.dmi'
			icon_state = "wood_shield"
			object_name = "Wood Shield"
			type_of_object = ITEM
			object_to_make = /item/weapon/wood_shield
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_club
			icon = 'icons/items.dmi'
			icon_state = "wood_club"
			object_name = "Wood Club"
			type_of_object = ITEM
			object_to_make = /item/weapon/wood_club
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		hunting_spear
			icon = 'icons/items.dmi'
			icon_state = "hunting_spear"
			object_name = "Hunting Spear"
			type_of_object = ITEM
			object_to_make = /item/weapon/hunting_spear
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
				requirements_list += /item/misc/stone

		primitive_halberd
			icon = 'icons/items.dmi'
			icon_state = "halberd"
			object_name = "Primitive halberd"
			type_of_object = ITEM
			object_to_make = /item/weapon/halberd
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
				requirements_list += /item/misc/stone

		paper
			icon = 'icons/Supplies.dmi'
			icon_state = "paper empty"
			object_name = "Paper"
			type_of_object = ITEM
			object_to_make = /item/misc/paper
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_bucket
			icon = 'icons/Supplies.dmi'
			icon_state = "empty_bucket"
			object_name = "Wood Bucket"
			type_of_object = ITEM
			object_to_make = /item/misc/wood_bucket
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_shutter
			icon='icons/Supplies.dmi'
			icon_state="window shutters"
			object_name = "Wood Shutter"
			type_of_object = ITEM
			object_to_make = /item/misc/window_shutters
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		rope_bridge
			icon='icons/Supplies.dmi'
			icon_state="rope bridge"
			object_name = "Rope Bridge"
			type_of_object = ITEM
			object_to_make = /item/misc/Rope_Bridge
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
				requirements_list += /item/misc/Rope

		glass_vial
			icon = 'icons/Bushs.dmi'
			icon_state="glass_vial"
			object_name = "Glass_Vial"
			type_of_object = ITEM
			object_to_make = /item/misc/new_berries/glass_vial
			New()
				requirements_list = new()
				requirements_list += /item/misc/molten_glass

		rope
			icon = 'icons/Supplies.dmi'
			icon_state = "rope"
			object_name = "Rope"
			type_of_object = ITEM
			object_to_make = /item/misc/Rope
			New()
				requirements_list = new()
				requirements_list += /item/misc/Hemp
			Click()
				var/message = "Need: Rope + Rope"
				winset(usr, "crafting_window.lbl_requirement", "text = '[message]'")

			Invoke(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
					else if(I.stacked < 2)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(I)
						if(I.stacked > 2)
							I.stacked -= 2
							I.suffix = "x[I.stacked]"
						else
							del(I)
				if(type_of_object == ITEM)
					M.contents += new object_to_make
				else
					new object_to_make(M.loc)
				if(type_of_object == ITEM || type_of_object == OBJECT)
					M << "You've created a [object_name]!"
				M.create_crafting()

			Requirements(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						return 0
					else if(I.stacked < 2)
						return 0
				return 1


	construction
		bed
			icon = 'icons/bed.dmi'
			icon_state = "2"
			object_name = "Bed"
			type_of_object = OBJECT
			object_to_make = /obj/bed
			object_to_build = /obj/bed
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		sign
			icon = 'icons/Turfs.dmi'
			icon_state = "sign"
			object_name = "Sign"
			type_of_object = OBJECT
			object_to_make = /obj/sign
			object_to_build = /obj/sign
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		fence
			icon = 'icons/wood.dmi'
			icon_state = "fence"
			object_name = "Fence"
			type_of_object = OBJECT
			object_to_make = /obj/wooden/fence
			object_to_build = /obj/wooden/fence
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		gate
			icon = 'icons/wood.dmi'
			icon_state = "fence close"
			object_name = "Gate"
			type_of_object = OBJECT
			object_to_make = /obj/wooden/gate
			object_to_build = /obj/wooden/gate
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_wall
			icon = 'icons/wood.dmi'
			icon_state = "wall"
			object_name = "wood wall"
			type_of_object = TURF
			object_to_make = /turf/wooden/wood_wall
			object_to_build = /obj/wooden/wood_wall
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		false_wood_wall
			icon = 'icons/wood.dmi'
			icon_state = "wall"
			object_name = "false wood wall"
			type_of_object = OBJECT
			object_to_make = /obj/falsewall/wood
			object_to_build = /obj/falsewall/wood
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood


		wood_window
			icon = 'icons/wood.dmi'
			icon_state = "none"
			object_name = "wood window"
			type_of_object = TURF
			object_to_make = /turf/wooden/wood_window_wall
			object_to_build = /obj/wooden/wood_window_wall
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_door
			icon = 'icons/wood.dmi'
			icon_state = "closed"
			object_name = "wood door"
			type_of_object = TURF
			object_to_make = /turf/wooden/wood_door
			object_to_build = /obj/wooden/wood_door
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
			Invoke(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(I)
						if(I.stacked > 1)
							I.stacked--
							I.suffix = "x[I.stacked]"
						else
							del(I)
				var
					newkeyname
					list/keys = new/list()
					turf/wooden/wood_door/D = build(M, 0, /turf/wooden/wood_door, /obj/wooden/wood_door, not_on_floor = 2)
				for(var/item/misc/key/K in M.contents)
					if(!K.keyid) continue
					keys += K
				if(D)
					D.gold = 0
					if(keys && keys.len)
						var/item/misc/key/K = input(M, "Which key would you like to bind to this door?\nCancel this popup to make this a public door.", "Select a key") as null|anything in keys
						if(!M || !K || !D || !K.keyid) return
						D.keyslot = K.keyid
						if(K.icon_state == "key") D.gold = 1

					newkeyname = input(M, "What do you want the door to be called?", "Name", "Door") as text
					if(!newkeyname) return
					D.name = "[newkeyname]"
				M.create_crafting()

		chest
			icon = 'icons/Turfs.dmi'
			icon_state = "chest closed"
			object_name = "chest"
			type_of_object = OBJECT
			object_to_make = /obj/chest
			object_to_build = /obj/chest
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
			Invoke(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(I)
						if(I.stacked > 1)
							I.stacked--
							I.suffix = "x[I.stacked]"
						else
							del(I)
				var/obj/chest/W = build(M, 0, /obj/chest, not_on_floor=0)
				if(!W) return
				var/newkeyname
				var/list/KEYS=new/list()
				var/item/misc/key/K = locate() in M
				for(var/item/misc/key/G in M.contents)
					KEYS+=G
				if(K)
					var/Keychosen=input("Which key?","Keys")in KEYS + "Cancel"
					if(Keychosen == "Cancel")
						return
					else
						if(K == Keychosen)
							W.keyslot = K.keyid

				newkeyname = input(M, "What do you want the chest to be called?", "Name", "Chest") as text
				if(!newkeyname)
					return
				W.name = "Chest- '[newkeyname]'"
				M.create_crafting()

		cupboard
			icon = 'icons/wood64x32.dmi'
			icon_state = "cupboard0"
			object_name = "cupboard"
			type_of_object = OBJECT
			object_to_make = /obj/chest/cupboard
			object_to_build = /obj/chest/cupboard
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
			Invoke(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(I)
						if(I.stacked > 1)
							I.stacked--
							I.suffix = "x[I.stacked]"
						else
							del(I)

				var/obj/chest/cupboard/W = build(M, 0, /obj/chest/cupboard, not_on_floor=0)
				if(!W) return
				var/newkeyname
				var/list/KEYS=new/list()
				var/item/misc/key/K = locate() in M
				for(var/item/misc/key/G in M.contents)
					KEYS+=G
				if(K)
					var/Keychosen=input("Which key?","Keys")in KEYS + "Cancel"
					if(Keychosen == "Cancel")
						return
					else
						if(K == Keychosen)
							W.keyslot = K.keyid

				newkeyname = input(M, "What do you want the chest to be called?", "Name", "Chest") as text
				if(!newkeyname)
					return
				W.name = "Cupboard- '[newkeyname]'"
				M.create_crafting()

		trap_door
			icon = 'icons/Trapdoor.dmi'
			icon_state = "trapdoor closed"
			object_name = "trap door"
			type_of_object = TURF
			object_to_make = /turf/trapdoor
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
			Invoke(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(I)
						if(I.stacked > 1)
							I.stacked--
							I.suffix = "x[I.stacked]"
						else
							del(I)
				var/newkeyname
				var/list/KEYS=new/list()
				var/item/misc/key/K = locate() in M
				var/item/misc/trapdoor/D = new(M)
				for(var/item/misc/key/G in M.contents)
					KEYS+=G
				if(K)
					var/Keychosen=input("Which key?","Keys")in KEYS + "Cancel"
					if(Keychosen == "Cancel")
						return
					else
						if(K == Keychosen)
							D.keyslot = K.keyid
				newkeyname = input(M, "What do you want the trapdoor to be called?", "Name", "Trap Door") as text
				if(!newkeyname)
					return
				D.name = "[newkeyname]"
				M.create_crafting()

		fire
			icon = 'icons/Turfs.dmi'
			icon_state = "fire"
			object_name = "Fire"
			type_of_object = OBJECT
			object_to_make = /obj/fire
			object_to_build = /obj/fire
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_floor
			icon = 'icons/wood.dmi'
			icon_state = "floor"
			object_name = "wood floor"
			type_of_object = TURF
			object_to_make = /turf/wooden/wood_floor
			object_to_build = /obj/wooden/wood_floor
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_table
			icon = 'icons/Turfs.dmi'
			icon_state = "table"
			object_name = "wood table"
			type_of_object = TURF
			object_to_make = /turf/table
			object_to_build = /obj/table
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
			Invoke(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(I)
						if(I.stacked > 1)
							I.stacked--
							I.suffix = "x[I.stacked]"
						else
							del(I)
				var/turf/table/W = build(M, 0, /turf/table, /obj/table, not_on_floor=0)
				if(!W) return
				switch(input("Which Direction??")in list ("North","West","East","South","NorthEast","NorthWest","SouthEast","SouthWest","Middle","Alone"))
					if("North")
						W.dir = NORTH
					if("West")
						W.dir = WEST
					if("East")
						W.dir = EAST
					if("South")
						W.dir = SOUTH
					if("NorthEast")
						W.dir = NORTHEAST
					if("NorthWest")
						W.dir = NORTHWEST
					if("SouthEast")
						W.dir = SOUTHEAST
					if("SouthWest")
						W.dir = SOUTHWEST
					if("Middle")
						W.icon_state = "tableM"
					if("Alone")
						W.icon_state = "tableA"
					else
						return
				M.create_crafting()

		wood_chair
			icon = 'icons/Turfs.dmi'
			icon_state = "chair"
			object_name = "wood chair"
			type_of_object = OBJECT
			object_to_make = /obj/chair
			object_to_build = /obj/chair
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood
			Invoke(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(I)
						if(I.stacked > 1)
							I.stacked--
							I.suffix = "x[I.stacked]"
						else
							del(I)
				var/obj/chair/W = build(M, 0, /obj/chair, not_on_floor=0)
				if(!W) return
				switch(input("Which Direction??")in list ("North","West","East","South"))
					if("North")
						W.dir = NORTH
						W.layer=10
					if("West")
						W.dir = WEST
						W.layer=10
					if("East")
						W.dir = EAST
						W.layer=10
					if("South")
						W.dir = SOUTH
					else
						return
				M.create_crafting()

		stone_wall
			icon = 'icons/stone.dmi'
			icon_state = "stone wall"
			object_name = "stone wall"
			type_of_object = TURF
			object_to_make = /turf/stone/stone_wall
			object_to_build = /obj/stone/stone_wall
			New()
				requirements_list = new()
				requirements_list += /item/misc/stone

		stone_false_wall
			icon = 'icons/stone.dmi'
			icon_state = "stone wall"
			object_name = "stone wall"
			type_of_object = OBJECT
			object_to_make = /obj/falsewall/stone
			object_to_build = /obj/falsewall/stone
			New()
				requirements_list = new()
				requirements_list += /item/misc/stone

		stone_floor
			icon = 'icons/stone.dmi'
			icon_state = "stone floor8"
			object_name = "stone floor"
			type_of_object = TURF
			object_to_make = /turf/stone/stone_floor
			object_to_build = /obj/stone/stone_floor
			New()
				requirements_list = new()
				requirements_list += /item/misc/stone

		stone_stairs
			icon = 'icons/Turfs.dmi'
			icon_state = "stairs3"
			object_name = "stone stairs"
			type_of_object = OBJECT
			object_to_make = /obj/stairs
			object_to_build = /obj/stairs
			New()
				requirements_list = new()
				requirements_list += /item/misc/stone

		stone_window
			icon = 'icons/stone.dmi'
			icon_state = "stone window"
			object_name = "stone window"
			type_of_object = TURF
			object_to_make = /turf/stone/stone_window_wall
			object_to_build = /obj/stone/stone_window_wall
			New()
				requirements_list = new()
				requirements_list += /item/misc/stone

		anvil
			icon = 'icons/Anvil.dmi'
			icon_state = ""
			object_name = "Anvil"
			type_of_object = TURF
			object_to_make = /obj/anvil
			object_to_build = /obj/anvil
			New()
				requirements_list = new()
				requirements_list += /item/misc/iron_ingot
				requirements_list += /item/misc/molten_iron

		gravestone
			icon = 'icons/turfs.dmi'
			icon_state = "gsign"
			object_name = "gravestone"
			type_of_object = OBJECT
			object_to_make = /obj/gravestone
			object_to_build = /obj/gravestone
			New()
				requirements_list = new()
				requirements_list += /item/misc/stone

		stone_door
			icon = 'icons/stone.dmi'
			icon_state = "closed2"
			object_name = "stone_door"
			type_of_object = TURF
			object_to_make = /turf/stone/stone_door
			object_to_build = /obj/stone/stone_door
			New()
				requirements_list = new()
				requirements_list += /item/misc/stone
			Invoke(var/mob/M)
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(!I)
						winset(M, "crafting_window.lbl_requirement", "text = 'Missing items!'")
						return
				for(var/J in requirements_list)
					var/item/misc/I = locate(J) in M.contents
					if(I)
						if(I.stacked > 1)
							I.stacked--
							I.suffix = "x[I.stacked]"
						else
							del(I)
				var
					newkeyname
					list/keys = new/list()
					turf/stone/stone_door/D = build(M, 0, /turf/stone/stone_door, /obj/stone/stone_door, not_on_floor = 2)
				for(var/item/misc/key/K in usr.contents)
					if(!K.keyid) continue
					keys += K
				if(D)
					D.gold = 0
					if(keys && keys.len)
						var/item/misc/key/K = input(M, "Which key would you like to bind to this door?\nCancel this popup to make this a public door.", "Select a key") as null|anything in keys
						if(!usr || !K || !D || !K.keyid) return
						D.keyslot = K.keyid
						if(K.icon_state == "key") D.gold = 1

					newkeyname = input(M, "What do you want the door to be called?", "Name", "Door") as text
					if(!newkeyname) return
				M.create_crafting()