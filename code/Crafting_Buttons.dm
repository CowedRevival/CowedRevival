button //Button object
	parent_type = /obj
	var/list/requirements_list
	var/object_name = ""
	var/object_to_make
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

	DblClick()
		Invoke(usr)

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
		else
			new object_to_make(M.loc)
		if(type_of_object == ITEM || type_of_object == OBJECT)
			M << "You've created a [object_name]!"

	carpentry

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


	construction
		bed
			icon = 'icons/bed.dmi'
			icon_state = "2"
			object_name = "Bed"
			type_of_object = OBJECT
			object_to_make = /obj/bed
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		sign
			icon = 'icons/Turfs.dmi'
			icon_state = "sign"
			object_name = "Sign"
			type_of_object = OBJECT
			object_to_make = /obj/sign
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		fence
			icon = 'icons/wood.dmi'
			icon_state = "fence"
			object_name = "Fence"
			type_of_object = OBJECT
			object_to_make = /obj/wooden/fence
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		gate
			icon = 'icons/wood.dmi'
			icon_state = "gate"
			object_name = "Gate"
			type_of_object = OBJECT
			object_to_make = /obj/wooden/gate
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_wall
			icon = 'icons/wood.dmi'
			icon_state = "wall"
			object_name = "wood wall"
			type_of_object = TURF
			object_to_make = /turf/wooden/wood_wall
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		false_wood_wall
			icon = 'icons/wood.dmi'
			icon_state = "wall"
			object_name = "false wood wall"
			type_of_object = OBJECT
			object_to_make = /obj/falsewall/wood
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood


		wood_window
			icon = 'icons/wood.dmi'
			icon_state = "window"
			object_name = "wood window"
			type_of_object = TURF
			object_to_make = /turf/wooden/wood_window_wall
			New()
				requirements_list = new()
				requirements_list += /item/misc/wood

		wood_door
			icon = 'icons/wood.dmi'
			icon_state = "door"
			object_name = "wood door"
			type_of_object = TURF
			object_to_make = /turf/wooden/wood_door
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
				if(type_of_object == ITEM || type_of_object == OBJECT)
					M << "You've created a [object_name]!"
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

		/*
			build_chest()
				set category = "build"
				var/obj/chest/W = build(usr, 0, /obj/chest, not_on_floor=0)
				if(!W) return
				var/newkeyname
				var/list/KEYS=new/list()
				var/item/misc/key/K = locate() in usr
				for(var/item/misc/key/G in usr.contents)
					KEYS+=G
				if(K)
					var/Keychosen=input("Which key?","Keys")in KEYS + "Cancel"
					if(Keychosen == "Cancel")
						return
					else
						if(K == Keychosen)
							W.keyslot = K.keyid

				newkeyname = input(usr, "What do you want the chest to be called?", "Name", "Chest") as text
				if(!newkeyname)
					return
				W.name = "Chest- '[newkeyname]'"
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_cupboard()
				set category = "build"
				var/obj/chest/cupboard/W = build(usr, 0, /obj/chest/cupboard, not_on_floor=0)
				if(!W) return
				var/newkeyname
				var/list/KEYS=new/list()
				var/item/misc/key/K = locate() in usr
				for(var/item/misc/key/G in usr.contents)
					KEYS+=G
				if(K)
					var/Keychosen=input("Which key?","Keys")in KEYS + "Cancel"
					if(Keychosen == "Cancel")
						return
					else
						if(K == Keychosen)
							W.keyslot = K.keyid

				newkeyname = input(usr, "What do you want the chest to be called?", "Name", "Chest") as text
				if(!newkeyname)
					return
				W.name = "Cupboard- '[newkeyname]'"
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			// --------Trap Doors--------
			create_trap_door()
				set category = "build"
				var/newkeyname
				var/list/KEYS=new/list()
				var/item/misc/key/K = locate() in usr
				var/item/misc/trapdoor/D = new(usr)
				for(var/item/misc/key/G in usr.contents)
					KEYS+=G
				if(K)
					var/Keychosen=input("Which key?","Keys")in KEYS + "Cancel"
					if(Keychosen == "Cancel")
						return
					else
						if(K == Keychosen)
							D.keyslot = K.keyid
				newkeyname = input(usr, "What do you want the trapdoor to be called?", "Name", "Trap Door") as text
				if(!newkeyname)
					return
				D.name = "[newkeyname]"
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
				// --------Trap Doors--------
			create_wood_bucket()
				set category = "build"
				usr.contents += new/item/misc/wood_bucket
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_wood_floor()
				set category = "build"
				if(!build(usr, 1, /turf/wooden/wood_floor, /obj/wooden/wood_floor)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"

			create_fire()
				set category = "build"
				if(!build(usr, 0, /obj/fire, not_on_floor=0)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"

			create_window_shutters()
				set category = "build"
				new/item/misc/window_shutters(usr)
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_table()
				set category = "build"
				var/turf/table/W = build(usr, 0, /turf/table, /obj/table, not_on_floor=0)
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
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_wood_chair()
				set category = "build"
				var/obj/chair/W = build(usr, 0, /obj/chair, not_on_floor=0)
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
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"*/