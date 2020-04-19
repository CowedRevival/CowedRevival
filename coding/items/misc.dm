item/misc
	icon = 'icons/Turfs.dmi'
	fire_stone
		icon = 'icons/items.dmi'
		name = "fire stone"
		icon_state = "fire_stone"
		var
			id
			global/_id = 5
			flags = 0
			const
				FLAG_ENCHANTED = 1
				FLAG_ACTIVE = 2
		Click()
			. = ..()
			if((src in usr.contents) && (flags & FLAG_ENCHANTED) && !usr.selectedSpellComponent)
				flags ^= FLAG_ACTIVE
				suffix = "[(flags & FLAG_ACTIVE) ? "Active" : ""]"
		proc
			other()
				if(id)
					for(var/item/misc/fire_stone/I in world)
						if(I.id == src.id && I != src) return I
					flags &= ~FLAG_ENCHANTED
					flags &= ~FLAG_ACTIVE
					suffix = ""
		verb
			label(t as text) name = "fire stone[t ? "- '[t]'":]"
	shackles
		icon = 'icons/shackles.dmi'
		layer = MOB_LAYER+8
		stacked = 1
		verb
			shackle(mob/M in orange(1))
				if(ActionLock("shackling", 10) || usr.restrained()) return
				for(var/mob/N in hearers(usr) - M)
					N.show_message("<b>[usr.name]</b> tries to shackle [M.name]...</b>")
				usr.show_message("<b>You try to shackle [M.name]...</b>")
				M.show_message("<b>[usr.name] is trying to shackle you.</b>")
				var
					M_move = M.moveCount
					usr_move = usr.moveCount
				spawn(100)
					if(!usr.restrained() && (M in range(1, usr)) && M.moveCount == M_move && usr.moveCount == usr_move && !M.shackled)
						M.shackled = 1
						M.UpdateClothing()
						for(var/mob/N in hearers(usr) - M)
							N.show_message("<b>[usr.name]</b> shackles [M.name]!</b>")
						usr.show_message("<b>You shackle [M.name]!</b>")
						M.show_message("<b>[usr.name] shackles you!</b>")
						if(--stacked <= 0) Move(null, forced = 1)
	legshackles
		icon = 'icons/mob.dmi'
		icon_state = "leg_shackles"
		layer = MOB_LAYER+8
		stacked = 1
		verb
			shackle_legs(mob/M in orange(1))
				if(ActionLock("shackling", 10) || usr.restrained()) return
				for(var/mob/N in hearers(usr) - M)
					N.show_message("<b>[usr.name]</b> tries to shackle [M.name]'s legs...</b>")
				usr.show_message("<b>You try to shackle [M.name]'s legs...</b>")
				M.show_message("<b>[usr.name] is trying to shackle your legs.</b>")
				var
					M_move = M.moveCount
					usr_move = usr.moveCount
				spawn(100)
					if(!usr.restrained() && (M in range(1, usr)) && M.moveCount == M_move && usr.moveCount == usr_move && !M.legshackled)
						M.legshackled = 1
						M.UpdateClothing()
						for(var/mob/N in hearers(usr) - M)
							N.show_message("<b>[usr.name]</b> shackles [M.name]'s legs!</b>")
						usr.show_message("<b>You shackle [M.name]'s legs!</b>")
						M.show_message("<b>[usr.name] shackles your legs!</b>")
						if(--stacked <= 0) Move(null, forced = 1)
	hide
		icon='icons/Supplies.dmi'
		icon_state="Hide"
		stacked = 1
		paintable = 1
		verb
			create_whip()
				if(usr.chosen != "hunter" && usr.chosen != "trainer")
					usr << "<tt>You can't use this; you must be a hunter or the animal trainer!</tt>"
					return
				if(stacked < 2)
					usr << "<tt>You need more hide!</tt>"
					return
				usr.contents += new/item/weapon/whip
				stacked -= 2
				if(stacked <= 0) Move(null, forced = 1)
	wool
		icon = 'icons/items.dmi'
		icon_state = "wool"
		stacked = 1
		verb
			create_toga()
				set category = "wool"
				if(usr.skills.tailoring < 25)
					usr << "<tt>You must have 25 tailoring skill!</tt>"
					return
				if(stacked <= 5)
					usr << "<tt>You need more wool!</tt>"
					return
				var/i = input(usr, "Which style? \[1-5\]", "Create Toga :: Specify Style", 1) as null|num
				if(i == null) return
				if(i <= 0) i = 1
				if(i > 5) i = 5
				var/item/armour/body/toga/I = new(usr)
				I.icon_state = "toga[i]"
				usr.show_message("<tt>You create a toga!</tt>")
				stacked -= 5
				if(stacked <= 0) Move(null, forced = 1)
				if(usr.skills.tailoring < 100) usr.skills.tailoring++
			create_wedding_gown()
				set category = "wool"
				if(usr.skills.tailoring < 75)
					usr << "<tt>You must have 75 tailoring skill!</tt>"
					return
				if(stacked <= 10)
					usr << "<tt>You need more wool!</tt>"
					return
				new/item/armour/body/weddinggown(usr)
				usr.show_message("<tt>You create a wedding gown!</tt>")
				stacked -= 10
				if(stacked <= 0) Move(null, forced = 1)
				if(usr.skills.tailoring < 100) usr.skills.tailoring++
			create_herald_clothes()
				set category = "wool"
				if(usr.skills.tailoring < 50)
					usr << "<tt>You must have 50 tailoring skill!</tt>"
					return
				if(stacked <= 10)
					usr << "<tt>You need more wool!</tt>"
					return
				new/item/armour/body/herald(usr)
				usr.show_message("<tt>You create a set of herald clothes!</tt>")
				stacked -= 10
				if(stacked <= 0) Move(null, forced = 1)
				if(usr.skills.tailoring < 100) usr.skills.tailoring++
			create_shirt()
				set category = "wool"
				if(stacked <= 5)
					usr << "<tt>You need more wool!</tt>"
					return
				var/i = input(usr, "Which color?", "Create Shirt :: Specify Color", 1) as null|anything in list("blue", "red", "green")
				if(i == null) return
				var/item/armour/body/shirts/I = new(usr)
				I.icon_state = "shirt-[i]"
				I.name = "[uppertext(copytext(i, 1, 2))][copytext(i, 2)] Shirt"
				usr.show_message("<tt>You create a shirt!</tt>")
				stacked -= 5
				if(stacked <= 0) Move(null, forced = 1)
				if(usr.skills.tailoring < 100) usr.skills.tailoring++
	seeds
		icon='icons/Supplies.dmi'
		icon_state="seeds"
		stacked = 1
		var/GrowType
		var/Length
		var/GS1, GS2 = "crop_growth_1"
		var/isDel=0
		verb
			Plant()
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(T.icon_state=="tilled soil")
						var/obj/seeded_soil/S = new(locate(usr.x,usr.y,usr.z))
						if(--stacked <= 0) Move(null, forced = 1)
						spawn(src.Length)
							if(!S || !GrowType) return
							new GrowType(locate(S.x,S.y,S.z))
							if(src.isDel==0)
								new/turf/tilled_soil(locate(S.x,S.y,S.z))
							S.Move(null, forced = 1)
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Wheat_Seeds
			GrowType=/obj/crop/wheat
			GS1 = "wheat_growth_2"
			GS2 = "wheat_growth_3"
			Plant()
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(T.icon_state=="tilled soil")
						if(--stacked <= 0) Move(null, forced = 1)
						var/obj/crop/wheat/S = new(locate(usr.x,usr.y,usr.z))
						S.player_planted = 1
						spawn(S.length)
							S.icon_state = GS1
							spawn(S.length)
								S.icon_state = GS2
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Corn_Seeds
			GrowType=/obj/crop/corn
			GS1 = "corn_growth_2"
			GS2 = "corn_growth_3"
			Plant()
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(T.icon_state=="tilled soil")
						if(--stacked <= 0) Move(null, forced = 1)
						var/obj/crop/corn/S = new(locate(usr.x,usr.y,usr.z))
						S.player_planted = 1
						spawn(S.length)
							S.icon_state = GS1
							spawn(S.length)
								S.icon_state = GS2
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Tomato_Seeds
			GrowType=/obj/crop/tomato
			GS1 = "tomato_growth_2"
			GS2 = "tomato_growth_3"
			Plant()
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(T.icon_state=="tilled soil")
						if(--stacked <= 0) Move(null, forced = 1)
						var/obj/crop/tomato/S = new(locate(usr.x,usr.y,usr.z))
						S.player_planted = 1
						spawn(S.length)
							S.icon_state = GS1
							spawn(S.length)
								S.icon_state = GS2
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Potato_Seeds
			GrowType=/obj/crop/potato
			GS1 = "potato_growth_2"
			GS2 = "potato_growth_3"
			Plant()
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(T.icon_state=="tilled soil")
						if(--stacked <= 0) Move(null, forced = 1)
						var/obj/crop/potato/S = new(locate(usr.x,usr.y,usr.z))
						S.player_planted = 1
						spawn(S.length)
							S.icon_state = GS1
							spawn(S.length)
								S.icon_state = GS2
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Watermelon_Seeds
			GrowType=/obj/crop/watermelon
			GS1 = "wm_growth_2"
			GS2 = "wm_growth_3"
			Plant()
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(T.icon_state=="tilled soil")
						if(--stacked <= 0) Move(null, forced = 1)
						var/obj/crop/watermelon/S = new(locate(usr.x,usr.y,usr.z))
						S.player_planted = 1
						spawn(S.length)
							S.icon_state = GS1
							spawn(S.length)
								S.icon_state = GS2
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Carrot_Seeds
			GrowType=/obj/crop/carrot
			GS1 = "carrot_growth_2"
			GS2 = "carrot_growth_3"
			Plant()
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(T.icon_state=="tilled soil")
						if(--stacked <= 0) Move(null, forced = 1)
						var/obj/crop/carrot/S = new(locate(usr.x,usr.y,usr.z))
						S.player_planted = 1
						spawn(S.length)
							S.icon_state = GS1
							spawn(S.length)
								S.icon_state = GS2
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Apple_Seeds
			GrowType=/item/misc/food/Apple
			Length=2000
			Plant()
				set category="Seeds"
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(istype(T,/turf/tilled_soil))
						T.icon_state = "seeded soil"
						T.name = "seeded soil"
						spawn(Length)
							var/turf/H = new/turf/path(T)
							var/obj/tree/apple_tree/S = new(H)
							S.icon_state = "apple_tree_1"
							S.icon_state_base = "apple_tree_1"
							S.density = 1
							spawn(Length)
								S.icon_state = "apple_tree_2"
								S.icon_state_base = "apple_tree_2"
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Hemp_Seeds
			GrowType=/item/misc/Hemp
			Length=10
			GS1 = "hemp_growth_2"
			GS2 = "hemp_growth_3"
			Plant()
				if(usr.CheckGhost() || usr.corpse || !GrowType) return
				if(current_season_state == "snow ")
					usr.show_message("<small>You can't grow crops in winter!")
					return
				for(var/obj/seeded_soil/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/obj/crop/S in range(0))
					if(S)
						usr.show_message("<small>Something is already planted here.")
						return
				for(var/turf/T in range(0))
					if(T.icon_state=="tilled soil")
						if(--stacked <= 0) Move(null, forced = 1)
						var/obj/crop/hemp/S = new(locate(usr.x,usr.y,usr.z))
						S.player_planted = 1
						spawn(S.length)
							S.icon_state = GS1
							spawn(S.length)
								S.icon_state = GS2
					else
						usr.show_message("<small>You cannot plant seeds here.")
						return
				suffix = "x[stacked]"
		Tree_Seeds
			GrowType=/obj/tree
			Length=1500
		Grass_Seeds
			GrowType=/turf/grass
			Length=500
			isDel=1
		Palm_Seeds
			GrowType=/obj/Palm_tree
			Length=1250
		Red_Seedlette
			GrowType=/obj/Flower/Red_Flower
			Length=800
			icon_state="red"
		Yellow_Seedlette
			GrowType=/obj/Flower/Yellow_Flower
			Length=800
			icon_state="yellow"
		Blue_Seedlette
			GrowType=/obj/Flower/Blue_Flower
			icon_state="blue"
			Length=800
		Black_Berry_Seeds
			Length = 1200
			GrowType = /obj/bush/blackbb
		Red_Berry_Seeds
			Length = 1200
			GrowType = /obj/bush/redbb
		Blue_Berry_Seeds
			Length = 1200
			GrowType = /obj/bush/bluebb
		White_Berry_Seeds
			Length = 1200
			GrowType = /obj/bush/whitebb
		Yellow_Berry_Seeds
			Length = 1200
			GrowType = /obj/bush/yellowbb
		Green_Berry_Seeds
			Length = 1200
			GrowType = /obj/bush/greenbb
	orbs
		icon='icons/Orbs.dmi'
		stacked = 1
		Red_Orb
			icon_state="r"
		Blue_Orb
			icon_state="b"
		Green_Orb
			icon_state="g"
		Yellow_Orb
			icon_state="y"
		Orange_Orb
			icon_state="o"
		Frog_Orb
			icon_state="f"
	books
		icon='icons/Supplies.dmi'
		icon_state="book"
		Healer
			icon_state="alchemy"
			name="Alchemy Book"
			verb
				read()
					usr<< browse(berries,"window=Berrys;display=1; size=300x300;border=0;can_close=1; can_resize=1;can_minimize=0;titlebar=1")
		Necro
			icon_state="necro"
			name="Necromancy Book"
			var/list/bound
			proc
				bind(mob/M, mob/user)
					if(!istype(M) || !M.corpse) return
					var/mob/C = M.corpse
					if(!C)
						usr.show_message("<tt>The soul has already left the corpse; there is nothing which the book can bind...</tt>")
						return 0
					else
						M.revive()

						var/verbose = 0
						if(!bound) bound = new/list()
						if(!(M in bound))
							bound += M
							verbose = 1

						if(user && (user.state == "ghost" || user.state == "ghost-i"))
							M.icon = 'icons/Skeleton.dmi'
							M.state = "skeleton"
							if(verbose) M.show_message("<tt>You are now bound into the ghostly army of [user.name].</tt>")
						else
							if(verbose) M.show_message("<tt>You are now bound by the Necromancer, and are brainwashed to obey him.</tt>")
							if(M.icon == 'icons/Cow.dmi') M.icon = 'icons/Zombie.dmi'
							//else if(C.icon == 'icons/Zombie.dmi') C.icon = 'icons/Skeleton.dmi'
						return 1
				kill(mob/M)
					if(!(M in bound)) return 0
					M.HP = 0
					M.checkdead(M)

					bound -= M
					if(!bound.len) bound = null
					return 1
				unbind(mob/M)
					if(!(M in bound)) return 0
					bound -= M
					if(!bound.len) bound = null
					M.show_message("<tt>Your soul has been freed; you are no longer under bound by the Necromancers' book.</tt>")
					return 1
			verb
				_Read()
					set name = "Read"
					if(!bound)
						usr.show_message("<tt>Apart from the reanimation spell, the book is empty...</tt>")
					else
						usr.show_message("<tt>The following names have been magically inscribed into the book:</tt>")
						for(var/mob/M in bound)
							usr.show_message("\t <tt>[M.name]</tt> [M.icon == 'icons/Skeleton.dmi' ? "the skeleton" : (M.icon == 'icons/Zombie.dmi' ? "the zombie" : "the human")]")
		Healer
			icon_state="alchemy"
		True_Holy
			name="The True Holy Book"
			icon_state="true_holy"
			verb
				Heal(mob/M in view())
					if(M == usr)
						for(var/mob/N in ohearers(usr))
							N.show_message("<font color=blue>[usr] points his finger at himself.")
						usr.show_message("<font color=blue>You point your finger at yourself.")
						M.HP+=15
						if(M.HP >= 100)
							M.HP = 100
						usr.SLEEP-=5
						hud_main.UpdateHUD(M)
						hud_main.UpdateHUD(usr)
						return
					else
						for(var/mob/N in ohearers(usr))
							N.show_message("<font color=blue>[usr] points his finger at [M].")
						usr.show_message("<font color=blue>You point your finger at [M].")
						M.HP+=15
						if(M.HP >= 100)
							M.HP = 100
						usr.SLEEP -= 5
						hud_main.UpdateHUD(M)
						hud_main.UpdateHUD(usr)
				Resurrect(mob/M in view())
					usr.show_message("You start chanting words out of a book.")
					for(var/mob/N in ohearers(usr))
						N.show_message("[usr] starts to chant words out of a book.")
					M.revive()
		Holy
			name="Holy Book"
			icon_state="holy"
			verb
				Heal(mob/M in view())
					if(M == usr)
						for(var/mob/N in ohearers(usr))
							N.show_message("<font color=blue>[usr] points his finger at himself.")
						usr.show_message("<font color=blue>You point your finger at yourself.")
						M.HP+=15
						if(M.HP >= 100)
							M.HP = 100
						usr.SLEEP-=5
						hud_main.UpdateHUD(M)
						hud_main.UpdateHUD(usr)
						return
					else
						for(var/mob/N in ohearers(usr))
							N.show_message("<font color=blue>[usr] points his finger at [M].")
						usr.show_message("<font color=blue>You point your finger at [M].")
						M.HP+=15
						if(M.HP >= 100)
							M.HP = 100
						usr.SLEEP -= 5
						hud_main.UpdateHUD(M)
						hud_main.UpdateHUD(usr)
	window_shutters
		icon='icons/Supplies.dmi'
		icon_state="window shutters"
		stacked = 1
		MouseDrop(obj/over_object,src_location,over_location,src_control,over_control,params)
			if(!(over_object in range(1, usr))) return
			if(istype(over_object,/turf/wooden/wood_window_wall))
				var/turf/wooden/wood_window_wall/C=over_object
				new/turf/wooden/wood_windowed_wall(locate(C.x,C.y,C.z))
				if(--stacked <= 0) Move(null, forced = 1)
				return
			if(istype(over_object,/turf/stone/stone_window_wall))
				var/turf/stone/stone_window_wall/C=over_object
				new/turf/stone/stone_windowed_wall(locate(C.x,C.y,C.z))
				if(--stacked <= 0) Move(null, forced = 1)
				return
			if(istype(over_object,/obj/stone/stone_window_wall))
				var/obj/stone/stone_window_wall/C=over_object
				new/obj/stone/stone_windowed_wall(locate(C.x,C.y,C.z))
				del C
				if(--stacked <= 0) Move(null, forced = 1)
				return
			if(istype(over_object,/obj/wooden/wood_window_wall))
				var/obj/wooden/wood_window_wall/C=over_object
				new/obj/wooden/wood_windowed_wall(locate(C.x,C.y,C.z))
				del C
				if(--stacked <= 0) Move(null, forced = 1)
				return
			..()
	ultra_wood
		icon = 'icons/wood.dmi'
		icon_state = "3"
		DblClick()
			usr.show_message("OMG!!! you clicked the magical wood!!")
			spawn for()
				usr.contents += new/item/misc/wood
				sleep(5)
	ultra_stone
		icon = 'icons/wood.dmi'
		icon_state = "5"
		DblClick()
			usr.show_message("OMG!!! you clicked the magical stone!!")
			spawn for()
				usr.contents += new/item/misc/stone
				sleep(5)

	stone
		icon = 'icons/wood.dmi'
		icon_state = "4"
		stacked = 1
		/*verb
			build_stone_wall()
				set category = "build"
				if(!build(usr, 0, /turf/stone/stone_wall, /obj/stone/stone_wall)) return
				if(--stacked <= 0) Move(null, forced = 1)
			build_stone_false_wall()
				set category = "build"
				if(!build(usr, 0, /obj/falsewall/stone, /obj/falsewall/stone)) return
				if(--stacked <= 0) Move(null, forced = 1)
			build_stairs()
				set category = "build"
				if(!build(usr, 0, /obj/stairs, not_on_floor=0)) return
				if(--stacked <= 0) Move(null, forced = 1)
			build_stone_windowed_wall()
				set category = "build"
				if(!build(usr, 0, /turf/stone/stone_window_wall, /obj/stone/stone_window_wall)) return
				if(--stacked <= 0) Move(null, forced = 1)
			build_stone_floor()
				set category = "build"
				if(!build(usr, 1, /turf/stone/stone_floor, /obj/stone/stone_floor)) return
				if(--stacked <= 0) Move(null, forced = 1)
			build_stone_door()
				set category = "build"
				var
					newkeyname
					list/keys = new/list()
					turf/stone/stone_door/D = build(usr, 0, /turf/stone/stone_door, /obj/stone/stone_door, not_on_floor = 2)
				for(var/item/misc/key/K in usr.contents)
					if(!K.keyid) continue
					keys += K
				if(D)
					D.gold = 0
					if(keys && keys.len)
						var/item/misc/key/K = input(usr, "Which key would you like to bind to this door?\nCancel this popup to make this a public door.", "Select a key") as null|anything in keys
						if(!usr || !K || !D || !K.keyid) return
						D.keyslot = K.keyid
						if(K.icon_state == "key") D.gold = 1

					newkeyname = input(usr, "What do you want the door to be called?", "Name", "Door") as text
					if(!newkeyname) return
					D.name = "[newkeyname]"
					if(--stacked <= 0) Move(null, forced = 1)
			build_gravestone()
				set category = "build"
				if(!build(usr, 0, /obj/gravestone, not_on_floor=0)) return
				if(--stacked <= 0) Move(null, forced = 1)*/
	wood
		icon = 'icons/wood.dmi'
		icon_state = "1"
		wood_log
			icon = 'icons/wood.dmi'
			icon_state = "1"
			stacked = 1

		towercap_log
			icon = 'icons/mushroom_objects.dmi'
			icon_state = "towercap_log"
			stacked = 1
		/*verb
			create_paper()
				set category = "build"
				new/item/misc/paper(usr)
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_bed()
				set category = "build"
				if(!build(usr, 0, /obj/bed, not_on_floor=0)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_sign()
				set category = "build"
				if(!build(usr, 0, /obj/sign, not_on_floor=0)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_fence()
				set category = "build"
				if(!build(usr, 0, /obj/wooden/fence, not_on_floor=0)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_gate()
				set category = "build"
				if(!build(usr, 0, /obj/wooden/gate, not_on_floor=0)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_wood_wall()
				set category = "build"
				if(!build(usr, 0, /turf/wooden/wood_wall, /obj/wooden/wood_wall)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_wood_false_wall()
				set category = "build"
				if(!build(usr, 0, /obj/falsewall/wood, /obj/falsewall/wood)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_windowed_wood_wall()
				set category = "build"
				if(!build(usr, 0, /turf/wooden/wood_window_wall, /obj/wooden/wood_window_wall)) return
				if(--stacked <= 0) Move(null, forced = 1)
				suffix = "x[stacked]"
			build_wood_door()
				set category = "build"
				var
					newkeyname
					list/keys = new/list()
					turf/wooden/wood_door/D = build(usr, 0, /turf/wooden/wood_door, /obj/wooden/wood_door, not_on_floor = 2)
				for(var/item/misc/key/K in usr.contents)
					if(!K.keyid) continue
					keys += K
				if(D)
					D.gold = 0
					if(keys && keys.len)
						var/item/misc/key/K = input(usr, "Which key would you like to bind to this door?\nCancel this popup to make this a public door.", "Select a key") as null|anything in keys
						if(!usr || !K || !D || !K.keyid) return
						D.keyslot = K.keyid
						if(K.icon_state == "key") D.gold = 1

					newkeyname = input(usr, "What do you want the door to be called?", "Name", "Door") as text
					if(!newkeyname) return
					D.name = "[newkeyname]"
					if(--stacked <= 0) Move(null, forced = 1)
					suffix = "x[stacked]"
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
/*	berrys
		icon = 'icons/Bushs.dmi'
		stacked = 1
		var/SeedType
		red
			name="Red Berry"
			icon_state = "redb"
			SeedType = /item/misc/seeds/Red_Berry_Seeds
		blue
			name="Blue Berry"
			icon_state = "blueb"
			SeedType = /item/misc/seeds/Blue_Berry_Seeds
		yellow
			name="Yellow Berry"
			icon_state = "yellowb"
			SeedType = /item/misc/seeds/Yellow_Berry_Seeds
		white
			name="White Berry"
			icon_state = "whiteb"
			SeedType = /item/misc/seeds/White_Berry_Seeds
		black
			name="Black Berry"
			icon_state = "blackb"
			SeedType = /item/misc/seeds/Black_Berry_Seeds
		verb
			mix()
				if(usr.CheckGhost() || usr.corpse) return
				var/list/Posthings = new/list()
				for(var/item/misc/food/F in usr)
					if(istype(F,/item/misc/food/))
						Posthings+=F
				Posthings+="Cancel"
				var/Chosen=input(usr,"What do you want to mix it with?","Mix")in Posthings
				if(Chosen=="Cancel") return
				else
					var/item/misc/food/f=Chosen
					f.effects=src.icon_state

			eat()
				if(usr.CheckGhost() || usr.corpse) return
				consume(usr)
		proc
			consume(mob/M)
				hearers(M) << "\blue [M.name] eats the berry."
				M.berry_effect(icon_state)
				if(--stacked <= 0) Move(null, forced = 1)
				if(isturf(loc)) name = "[initial(name)] (x[stacked])"
				var/item/misc/seeds/I = locate(SeedType) in M.contents
				if(!I) new SeedType(M)
				else I.stacked++*/
	gold
		icon_state="gold"
		icon='icons/Supplies.dmi'
		stacked = 1
//
	molten_copper
		icon_state = "molten copper"
		icon='icons/ores_and_veins.dmi'
		name = "Molten Copper"
		stacked = 1
		MouseDrop(obj/over_object,src_location,turf/over_turf,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_object,/item/misc/key_mold) && (over_object in usr.contents))
				var/item/misc/key_mold/mold = over_object
				new/item/misc/key{icon_state="key_copper"}(usr, mold.keyid)
				if(--stacked <= 0) Move(null, forced = 1)
			else if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/copper_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/copper_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	copper_ingot
		name = "Copper Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Copper Ingot"
		stacked = 1
//
	copper_coin
		icon='icons/Supplies.dmi'
		icon_state = "copper_coin"
		stacked = 1
	molten_stone
		icon_state="molten stone"
		icon='icons/Supplies.dmi'
		stacked = 1
		verb/Create_New_Key_Mold()
			usr.contents += new/item/misc/key_mold
			if(--stacked <= 0) Move(null, forced = 1)
	molten_iron
		icon='icons/ores_and_veins.dmi'
		icon_state="molten iron"
		stacked = 1
		verb
			build_cannon()
				if(stacked >= 10)
					new/obj/Cannon(locate(usr.x,usr.y,usr.z))
					stacked -= 10
		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/iron_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/iron_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()

	iron_ingot
		name = "Iron Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Iron Ingot"
		stacked = 1
//
	molten_tungsten
		name = "Molten Tungsten"
		icon='icons/ores_and_veins.dmi'
		icon_state="molten tungsten"
		stacked = 1
		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/tungsten_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/tungsten_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	tungsten_ingot
		name = "Tungsten Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Tungsten Ingot"
		stacked = 1
//
	molten_silver
		name = "Molten Silver"
		icon='icons/ores_and_veins.dmi'
		icon_state="molten silver"
		stacked = 1
		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/silver_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/silver_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	silver_ingot
		name = "Silver Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Silver Ingot"
		stacked = 1
//
	molten_palladium
		name = "Molten Palladium"
		icon='icons/ores_and_veins.dmi'
		icon_state="molten palladium"
		stacked = 1
		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/palladium_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/palladium_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	palladium_ingot
		name = "Palladium Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Palladium Ingot"
		stacked = 1
//
	molten_mithril
		name = "Molten Mithril"
		icon='icons/ores_and_veins.dmi'
		icon_state="molten mithril"
		stacked = 1
		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/mithril_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/mithril_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	mithril_ingot
		name = "Mithril Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Mithril Ingot"
		stacked = 1
//
	molten_magicite
		name = "Molten Magicite"
		icon='icons/ores_and_veins.dmi'
		icon_state="molten magicite"
		stacked = 1
		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/magicite_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/magicite_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	magicite_ingot
		name = "Magicite Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Magicite Ingot"
		stacked = 1
//
	molten_adamantite
		name = "Molten Adamantite"
		icon='icons/ores_and_veins.dmi'
		icon_state="molten adamantite"
		stacked = 1
		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/adamantite_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/adamantite_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	adamantite_ingot
		name = "Adamantite Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Adamantite Ingot"
		stacked = 1
//
	molten_tin
		name = "Molten Tin"
		icon='icons/ores_and_veins.dmi'
		icon_state="molten tin"
		stacked = 1

		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/tin_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/tin_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	tin_ingot
		name = "Tin Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Tin Ingot"
		stacked = 1

	sand_clump
		name = "Sand Clump"
		icon='icons/ores_and_veins.dmi'
		icon_state="sand clump"
		stacked = 1

	molten_glass
		name = "Molten Glass"
		icon='icons/ores_and_veins.dmi'
		icon_state="molten glass"
		stacked = 1

//
	key_mold
		name="key mold"
		icon='icons/Supplies.dmi'
		icon_state="key mold"
		var/keyid
		New()
			. = ..()
			if(!keyid) keyid = currentkeynumber++
		verb
			label(t as text) name = "key mold[t ? "- '[t]'":]"
//
	molten_gold
		icon='icons/ores_and_veins.dmi'
		icon_state="molten gold"
		name = "Molten Gold"
		stacked = 1
		MouseDrop(obj/over_object,src_location,over_turf,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_object,/item/misc/key_mold) && (over_object in usr.contents))
				var/item/misc/key_mold/mold = over_object
				new/item/misc/key(usr, mold.keyid)
				if(--stacked <= 0) Move(null, forced = 1)
			if(istype(over_turf, /turf/water))
				if(get_dist(src,over_turf)>1) return ..()
				var/item/misc/gold_ingot/I = locate() in usr
				if(I)
					I.stacked += 1
					I.suffix = "x[I.stacked]"
				else usr.contents += new/item/misc/gold_ingot
				if(--stacked <= 0) Move(null, forced = 1)
				else suffix = "x[stacked]"
			else return ..()
	gold_ingot
		name = "Gold Ingot"
		icon='icons/ores_and_veins.dmi'
		icon_state="Gold Ingot"
		stacked = 1
//
	tardis_key
		name = "key"
		icon = 'icons/items.dmi'
		icon_state = "tardis_key"
		var
			obj/tardis/tardis/master
		New(loc, master)
			. = ..()
			mouse_drag_pointer = new/icon(src.icon, src.icon_state)
			src.master = master
		MouseDrop(obj/tardis/tardis/O, src_location, over_location, src_control, over_control, params)
			params = params2list(params)
			if(!master) return ..()
			if(istype(O, /obj/tardis/door) && O.master == src.master && (usr in range(1, O)))
				if(master.door == -2)
					usr.show_message("\blue The door is deadlock sealed! You can't open it from the outside!")
				else if(master.door == -1)
					master.door = 0
					usr.show_message("Unlocked [O]")
				else if(master.door == 0)
					master.door = -1
					usr.show_message("Locked [O]")
				else
					usr.show_message("You must close the door first!")
					return
			else if(istype(O) && src.master == O)
				if(usr in range(1, O)) //regular unlock
					if(master.door == -2)
						usr.show_message("\blue The door is deadlock sealed! You can't open it from the outside!")
					else if(master.door == -1)
						master.door = 0
						usr.show_message("Unlocked [O]")
					else if(master.door == 0)
						master.door = -1
						usr.show_message("Locked [O]")
					else
						usr.show_message("You must close the door first!")
						return
				else if(usr.chosen == "timelord" && (master.door == 0 || master.door == -1) && (usr in range(master))) //they can channel the atron energy
					if(master.door == -1)
						master.door = 0
						usr.show_message("Unlocked [O]")
					else if(master.door == 0)
						master.door = -1
						usr.show_message("Locked [O]")
					flick("null-beacon", master)
					range(master) << sound('sounds/tardis/remotekey.ogg')
				else return ..()
			else return ..()
		Click()
			if(usr.chosen != "timelord" || !master || !(src in usr.contents) || !(master in range(usr))) return ..()
			master.cloaked = !master.cloaked
			usr.show_message("\blue You have [master.cloaked ? "hid the [master.name] a second out of sync" : "revealed the [master.name]"].")
			range(master) << sound('sounds/tardis/outsync.ogg', volume=50)
			master.updateicon()
		verb
			label(t as text) name = "key[t ? "- '[t]'":]"
			mask()
				if(usr.chosen != "timelord")
					usr << "<tt>You cannot do this!</tt>"
					return
				src.icon_state = ""
				src.icon = 'icons/items.dmi'
				src.icon_state = "key"
				src.mouse_drag_pointer=new/icon(src.icon,src.icon_state)
				src.verbs -= /item/misc/tardis_key/verb/mask
	key
		icon = 'icons/items.dmi'
		icon_state = "key"
		var
			keyid=0
		New(loc, keyid)
			..()
			mouse_drag_pointer=new/icon(src.icon,src.icon_state)
			if(keyid) src.keyid = keyid
			if(src.keyid==0)
				keyid=currentkeynumber
				currentkeynumber+=1
		MouseDrop(obj/over_object,src_location,over_location,src_control,over_control,params)
			if(!(usr in range(1, over_object))) return ..()
			if(istype(over_object,/obj/chest))
				var/obj/chest/C=over_object
				if(src.keyid== C.keyslot)
					if(C.locked)
						C.locked=0
						if(!C.opened_by) C.opened_by = new/list()
						if(!(usr.key in C.opened_by)) C.opened_by += usr.key
						usr.show_message("Unlocked [C]")
					else
						C.locked=1
						usr.show_message("Locked [C]")
				else
					usr.show_message("That is the wrong key for that chest")
				return
			if(istype(over_object,/turf/stone/stone_door))
				var/turf/stone/stone_door/C=over_object
				if(src.keyid== C.keyslot)
					if(C.locked)
						C.locked=0
						usr.show_message("Unlocked [C]")
					else
						C.locked=1
						usr.show_message("Locked [C]")
				else
					usr.show_message("That is the wrong key for that door")
				return
			if(istype(over_object,/obj/stone/stone_door))
				var/obj/stone/stone_door/C=over_object
				if(src.keyid== C.keyslot)
					if(C.locked)
						C.locked=0
						usr.show_message("Unlocked [C]")
					else
						C.locked=1
						usr.show_message("Locked [C]")
				else
					usr.show_message("That is the wrong key for that door")
				return
			if(istype(over_object,/turf/trapdoor))
				var/turf/trapdoor/C=over_object
				if(src.keyid== C.keyslot)
					if(C.locked)
						C.locked=0
						usr.show_message("Unlocked [C]")
					else
						C.locked=1
						usr.show_message("Locked [C]")
				else
					usr.show_message("That is the wrong key for that trap door")
				return
			if(istype(over_object,/turf/wooden/wood_door))
				var/turf/wooden/wood_door/C=over_object
				if(src.keyid== C.keyslot)
					if(C.locked)
						C.locked=0
						usr.show_message("Unlocked [C]")
					else
						C.locked=1
						usr.show_message("Locked [C]")
				else
					usr.show_message("That is the wrong key for that door")
				return
			if(istype(over_object,/obj/wooden/wood_door))
				var/obj/wooden/wood_door/C=over_object
				if(src.keyid== C.keyslot)
					if(C.locked)
						C.locked=0
						usr.show_message("Unlocked [C]")
					else
						C.locked=1
						usr.show_message("Locked [C]")
				else
					usr.show_message("That is the wrong key for that door")
				return
			if(istype(over_object, /obj/family/edison/grandfather_clock))
				var/obj/family/edison/grandfather_clock/C = over_object
				if(src.keyid == C.keyslot)
					if(C.locked)
						C.locked = 0
						usr.show_message("Unlocked [C]")
					else
						C.locked = 1
						usr.show_message("Locked [C]")
				else
					usr.show_message("That is the wrong key for that door")
				return
			..()
		verb
			label(t as text) name = "key[t ? "- '[t]'":]"

		Guard_Key
			keyid=1
		Royal_Guard_Key
			keyid=2
		Royal_Archer_Key
			keyid=3
		Cook
			keyid=4
		Cell_Door_Key
			keyid=5
		Royal_Room_Key
			keyid=6
		Watchman_Key
			keyid=7
		Noble_Guard_Key
			keyid=8
		Noble_Archer_Key
			keyid=9
		Chef_Key
			keyid=10
		Dungeon_Door_Key
			keyid = "cow_jailer"
		Jailer_Key
			keyid = "bov_jailer"
		Jailhouse_Key
			keyid = "bov_jailhouse"
		Cowmalot_Royal_Room_Key
			name = "Royal Room Key"
			keyid = 12
		Inn_Keys
			keyid="inn"
			Key_1
				keyid="inn1"
			Key_2
				keyid="inn2"
			Key_3
				keyid="inn3"
			Key_4
				keyid="inn4"
			Key_5
				keyid="inn5"
			Key_6
				keyid="inn6"
			Key_7
				keyid="inn7"
			Key_8
				keyid="inn8"
			Key_9
				keyid="inn9"
			Key_10
				keyid="inn10"
			Key_11
				keyid="inn11"
			Key_12
				keyid="inn12"
			Key_13
				keyid="inn13"
			Key_14
				keyid="inn14"
		Necromancer
			name = "Necromancer's Key"
			keyid = "necromancer"
		Treasurer_Key
			name = "Tresurer's Key"
			keyid = "bov_archduke"
			cowmalot
				keyid = "cow_archduke"
		Keysmith_Key
			name = "Keysmith's Key"
			keyid = "bov_keysmith"
		BCM_Key
			name = "Baron/Count/Margrave key"
			keyid = "bov_bcm"
			cowmalot
				keyid = "cow_bcm"
		Families
			Edison
				name = "Edison Motel Key"
				keyid = "family_edison"
				Edison_Motel_Room_1
					keyid = "family_edison1"
					name = "Edison Motel Key (Room #1)"
				Edison_Motel_Room_2
					keyid = "family_edison2"
					name = "Edison Motel Key (Room #2)"
				Edison_Motel_Room_3
					keyid = "family_edison3"
					name = "Edison Motel Key (Room #3)"
				Edison_Motel_Room_4
					keyid = "family_edison4"
					name = "Edison Motel Key (Room #4)"
			Tonton
				name = "Tonton Mansion Key"
				keyid = "family_tonton"
			Parker
				name = "Parker Family Key"
				keyid = "family_parker"
			Gronko
				name = "Gronko Family Key"
				keyid = "family_gronko"
			Jenkins
				name = "Jenkins Family Key"
				keyid = "family_jenkins"

	wood_bucket
		icon='icons/Supplies.dmi'
		icon_state = "empty_bucket"
		name = "bucket"
		stacked = -1
		MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
			if(!(src in usr.contents)) return ..()
			if(istype(over_turf, /turf/water/river_water))
				if(get_dist(src,over_turf)>1) return ..()
				usr.contents += new/item/misc/wood_bucket/water_bucket
				Move(null, forced = 1)
			else return ..()
		water_bucket
			icon_state = "water_bucket"
			var
				ThirstAdd = 50
			stacked = -1
			verb
				drink()
					if(usr.corpse) return
					consume(usr)
			proc
				consume(mob/M)
					M.THIRST += ThirstAdd
					if(M.THIRST >= 100) M.THIRST = M.MTHIRST
					for(var/mob/N in ohearers(M))
						N.show_message("\blue [M.name] drinks from the bucket.")
					M << "\blue You drink from the bucket."
					hud_main.UpdateHUD(M)
					usr.contents += new/item/misc/wood_bucket
					Move(null, forced = 1)
	bones
		skull
			icon='icons/Supplies.dmi'
			icon_state = "cow_skull"
			stacked = -1
		bone
			icon='icons/Supplies.dmi'
			icon_state = "bone"
			stacked = 1

	food
		var
			HungerAdd
			ThirstAdd = 0
			FoodType
			SeedType
			Cooked = 0
//			effects
			herbivore_friendly = 0
			berry_effects/Effects
		icon='icons/Supplies.dmi'
		stacked = 1
		dropped(mob/M)
			. = ..()
			for(var/animal/A in view(src)) A.SeeFoodDrop(src, M)
		verb
			eat()
				if(usr.corpse) return
				consume(usr)
		proc
			consume(mob/M)
				if(FoodType == "Meat" && !Cooked)
					M << "\red <b>Yuck! Raw meat!</b>"
					M.HP -= 10
					M.checkdead(M)
				else if(FoodType == "Vege")
					if(locate(SeedType) in usr)
						locate(SeedType).stacked += rand(1,2)
						locate(SeedType).suffix = "x[locate(SeedType).stacked]"
					else
						M.contents += new SeedType
						locate(SeedType).stacked += 1
						locate(SeedType).suffix = "x[locate(SeedType).stacked]"

				M.HUNGER += HungerAdd
				M.THIRST += ThirstAdd
				if((M.state == "ghost" || M.state == "ghost-i" || M.state == "skeleton") && (!Effects || Effects.poison < 2))
					M.HP -= round(HungerAdd / 2)
				else
					M.HP += round(HungerAdd / 2)
				if(M.HUNGER>100) M.HUNGER=100
				if(M.HP>100) M.HP=100
				for(var/mob/N in ohearers(M))
					N.show_message("\blue [M.name] eats the [name].")
				M << "\blue You eat the [name]."
				hud_main.UpdateHUD(M)

//				if(effects) M.berry_effect(effects)
				if(Effects)
					if(!M.Effects) M.Effects = new
					if(stacked>1)
						var/berry_effects/E = new
						E.copy_of(Effects)
						E.add_to(M.Effects)
						del(E)
					else
						Effects.add_to(M.Effects)
				if(--stacked <= 0) Move(null, forced = 1)
				if(isturf(loc)) name = "[initial(name)] (x[stacked])"
		Skinned_Potato
		Mashed_Potatos
		Corn
			icon_state="corn"
			HungerAdd=10
			FoodType="Vege"
			SeedType=/item/misc/seeds/Corn_Seeds
			herbivore_friendly = 1
		Potato
			icon_state="potato"
			HungerAdd=5
			FoodType="Vege"
			SeedType=/item/misc/seeds/Potato_Seeds
			herbivore_friendly = 1
		Tomato
			icon_state="tomato"
			HungerAdd=7
			ThirstAdd=5
			FoodType="Vege"
			SeedType=/item/misc/seeds/Tomato_Seeds
			herbivore_friendly = 1
		Carrot
			icon_state="carrot"
			HungerAdd=10
			FoodType="Vege"
			SeedType=/item/misc/seeds/Carrot_Seeds
			herbivore_friendly = 1
		Apple
			icon_state="apple"
			HungerAdd=15
			ThirstAdd=5
			FoodType="Vege"
			SeedType=/item/misc/seeds/Apple_Seeds
			herbivore_friendly = 1
		Watermelon
			icon_state="watermelon"
			HungerAdd=20
			ThirstAdd=15
			FoodType="Vege"
			SeedType=/item/misc/seeds/Watermelon_Seeds
			herbivore_friendly = 1
		Meat
			icon_state="meat"
			HungerAdd=10
			FoodType="Meat"
		Strange_Meat
			icon_state="strange_meat"
			HungerAdd=25
			FoodType="Meat"
		Frog_Meat
			icon_state="frog meat"
			HungerAdd=15
			FoodType="Meat"
		Cooked_Meat
			icon_state="cooked meat"
			HungerAdd=25
			FoodType="none"
		Cooked_Strange_Meat
			icon_state="cooked strange_meat"
			HungerAdd=100
			FoodType="none"
		Goldfish
			icon_state="goldfish"
			HungerAdd=3
			FoodType="Meat"
		Bass
			icon_state="bass"
			HungerAdd=9
			FoodType="Meat"
		Shark
			icon_state="shark"
			HungerAdd=15
			FoodType="Meat"
		Puffer_Fish
			icon_state="puffer"
			HungerAdd=2
			FoodType="Meat"
		Koi
			icon_state="koi"
			HungerAdd=8
			FoodType="Meat"
		Carp
			icon_state="carp"
			HungerAdd=5
			FoodType="Meat"
		Swordfish
			icon_state="sword"
			HungerAdd=12
			FoodType="Meat"
		Tuna
			icon_state="tuna"
			HungerAdd=20
			FoodType="Meat"
		Cooked_Goldfish
			icon_state="cooked goldfish"
			HungerAdd=5
			FoodType="none"
		Cooked_Bass
			icon_state="cooked bass"
			HungerAdd=12
			FoodType="none"
		Cooked_Shark
			icon_state="cooked shark"
			HungerAdd=20
			FoodType="none"
		Cooked_Puffer_Fish
			icon_state="cooked puffer"
			HungerAdd=2
			FoodType="none"
		Cooked_Koi
			icon_state="cooked koi"
			HungerAdd=8
			FoodType="none"
		Cooked_Carp
			icon_state="cooked carp"
			HungerAdd=5
			FoodType="none"
		Cooked_Swordfish
			icon_state="cooked sword"
			HungerAdd=12
			FoodType="none"
		Cooked_Tuna
			icon_state="cooked tuna"
			HungerAdd=20
			FoodType="none"
		Cooked_Frog_Meat
			icon_state="cooked frog meat"
			HungerAdd=30
			FoodType="none"
		Wheat
			icon_state="wheat"
			HungerAdd=3
			FoodType="Vege"
			SeedType=/item/misc/seeds/Wheat_Seeds
			herbivore_friendly = 1
		Flour
			icon_state="flour"
			HungerAdd=2
			FoodType="none"
			MouseDrop(turf/over_location)
				if(istype(over_location,/turf/water) && get_dist(usr, over_location) <= 1)
					new/item/misc/food/Dough(locate(over_location.x,over_location.y,over_location.z))
					if(--src.stacked<=0) del src
					return
				..()
		Dough
			icon_state="dough"
			HungerAdd=6
			FoodType="none"
		Cake
			icon_state="cake"
			HungerAdd=25
			FoodType="none"
		Pie
			icon_state="pie"
			HungerAdd=25
			ThirstAdd=2
			FoodType="none"
		Scone
			icon_state="scone"
			HungerAdd=8
			FoodType="none"
	Potato_Skin
	Heavy_Stone
		icon='icons/Supplies.dmi'
		icon_state="heavy stone"
		stacked = 1
	Sharp_Stone
		icon='icons/Supplies.dmi'
		icon_state="sharp stone"
		stacked = 1
	Pole
		icon='icons/Supplies.dmi'
		icon_state="pole"
		stacked = 1
	Long_Pole
		icon='icons/Supplies.dmi'
		icon_state="long pole"
		stacked = 1
	Wooden_Statuette
		icon='icons/Supplies.dmi'
		icon_state="statuette"
		stacked = 1
	Hemp
		icon='icons/Supplies.dmi'
		icon_state="hemp"
		stacked = 1
	Rope
		icon='icons/Supplies.dmi'
		icon_state="rope"
		stacked = 1
	Rope_Bridge
		icon='icons/Supplies.dmi'
		icon_state="rope bridge"
		stacked = 1
		MouseDrop(over_location)
			var/turf/water/T=over_location
			if(istype(T) && !istype(T, /turf/water/enchanted) && get_dist(usr, T) <= 1)
				oview () <<"<small>[usr] creates a rope bridge."
				usr.show_message("<small>You create a rope bridge.")
				new/turf/wooden/rope_bridge(locate(T.x,T.y,T.z))
				if(--stacked <= 0) Move(null, forced = 1)
			else
				..()
	spellbook
		icon = 'icons/Supplies.dmi'
		icon_state = "book"
		var/inscribed
		proc
			Inscribe()
				set src in usr.contents
				var/mob/M = usr
				if(!M.movable)
					var/list/L = new
					for(var/spell/S in M.spells)
						if(!(S.flags & S.FLAG_SPELLBOOK)) continue
						L += S.name

					if(!L.len)
						usr.show_message("You do not know any spells you could inscribe!")
						return

					M.movable = 1

					var/txt = input(M, "What spell do you wish to inscribe?", "Inscribe") in L

					M << "You begin inscribing the spell [txt]..."

					var/spell/S

					for(var/spell/S2 in M.spells)
						if(S2.name == txt)
							S = S2
							break

					spawn(S.learning_time)
						M << "You have successfully inscribed the spell [S.name]!"
						M.movable = 0
						var/item/misc/spellbook/Spellbook/I = new(M)
						I.inscribed = S.type
						I.name = "Spellbook: [S.name]"
						if(--stacked <= 0) Move(null, forced = 1)
			Study()
				set src in usr.contents
				var/spell/S = new inscribed
				if(!usr.mage && (S.flags & S.FLAG_MAGE))
					usr.show_message("Only a true mage can learn this spell!")
					return
				for(var/spell/S2 in usr.spells)
					if(S2.type == inscribed)
						usr.show_message("You have already learned [S2.name]!")
						return

				if(!(src in usr.progress))
					usr.progress[src] = 0

				if(!usr.movable)
					usr.show_message("You start studying the book.")
					for(var/mob/N in ohearers(usr))
						N.show_message("<font color=blue>[usr] starts reading.")
					usr.movable = 1


					var/learn = min(usr.concentration, S.learning_time - usr.progress[src])
					usr.concentration -= learn
					usr.progress[src] += learn

					spawn(learn * 2)
						if(usr.progress[src] < S.learning_time)
							usr.show_message("You lose concentration.")

						if(usr.progress[src] >= S.learning_time)
							usr.medal_Report("apprentice")
							usr.show_message("You have acquired the spell [S.name]!")
							usr.learn_spell(S.type, 0)
							if(!usr.mage)
								usr.mage_counter++
								if(usr.mage_counter >= 3)
									usr.show_message("<font color=blue>You feel magical power running through your veins!")
									usr.mage = 1
							if(S.flags & S.FLAG_MAGE)
								spawn
									sleep(5)
									usr.show_message("The Spell Book falls to pieces!") // powerful spell, y'know
									usr.movable = 0
									del src

						usr.movable = 0
		Empty_Spellbook
			stacked = 1
			New()
				..()
				verbs += /item/misc/spellbook/proc/Inscribe
		Spellbook
			New()
				..()
				verbs += /item/misc/spellbook/proc/Study

			Spellbook_Portal
				name = "Spellbook: Portal"
				inscribed = /spell/portal
			Spellbook_Heal
				name = "Spellbook: Heal"
				inscribed = /spell/heal
			Spellbook_Fireball
				name = "Spellbook: Fireball"
				inscribed = /spell/fireball
			Spellbook_Iceball
				name = "Spellbook: Iceball"
				inscribed = /spell/iceball
			Spellbook_Eclipse
				name = "Spellbook: Eclipse"
				inscribed = /spell/eclipse
			Spellbook_Portal
				name = "Spellbook: Portal"
				inscribed = /spell/portal
			Spellbook_Glow
				name = "Spellbook: Glow"
				inscribed = /spell/glow
			Spellbook_Message
				name = "Spellbook: Message"
				inscribed = /spell/message
			Spellbook_Teleport
				name = "Spellbook: Teleport"
				inscribed = /spell/teleport
			Spellbook_Enchant
				name = "Spellbook: Enchant"
				inscribed = /spell/enchant
			Spellbook_Lockpick
				name = "Spellbook: Lockpick"
				inscribed = /spell/lockpick
			Spellbook_Zap
				name = "Spellbook: Zap"
				inscribed = /spell/zap
			Spellbook_School
				name = "Spellbook: School of Magic Portal"
				inscribed = /spell/school_of_magic
	paper
		icon = 'icons/Supplies.dmi'
		icon_state = "paper empty"
		paintable = 1
		var
			content
			label
		verb
			Write_()
				set name = "Write"
				set src in usr.contents
				if(usr.restrained() || usr.shackled) return
				var/n = input(usr, "What would you like to add to this paper?", "[name] :: Write") as null|message
				if(n == null) return
				content += html_encode(n)
				if(length(content)) icon_state = "paper"
			Read_()
				set name = "Read"
				set src in view(1)
				if(content == 1)
					usr << browse_rsc(icon(src.icon, src.icon_state), "\ref[src].png")
					usr << browse("<html><head><title>[name]</title><link rel=\"stylesheet\" type=\"text/css\" href=\"cowed_style.css\" /></head><body><img src=\"\ref[src].png\" /></body></html>", "window=\ref[src]")
				else
					usr << browse("<html><head><title>[name]</title><link rel=\"stylesheet\" type=\"text/css\" href=\"cowed_style.css\" /></head><body>[dd_replacetext(content, "\n", "<br />")]</body></html>", "window=\ref[src]")

			Make_Book()
				set src in usr.contents
				if(usr.restrained() || usr.shackled) return
				if(usr.chosen != "librarian")
					usr.show_message("<tt>You cannot do this; only librarians know how to do this!</tt>")
					return
				. = 0
				for(var/item/misc/paper/P in usr.contents)
					if(P.content) continue
					.++
				if(. >= 10)
					new/item/misc/book(usr)
					. = 0
					for(var/item/misc/paper/P in usr.contents)
						if(P.content) continue
						if(++. > 10) break
						P.Move(null, forced = 1)
				else
					usr.show_message("<tt>You need ten unwritten pieces of paper!</tt>")
			Make_Spellbook()
				set src in usr.contents
				if(usr.restrained() || usr.shackled) return
				if(usr.chosen != "librarian")
					usr.show_message("<tt>You cannot do this; only librarians know how to do this!</tt>")
					return
				. = 0
				for(var/item/misc/paper/P in usr.contents)
					if(P.content) continue
					.++
				if(. >= 20)
					new/item/misc/spellbook/Empty_Spellbook(usr)
					. = 0
					for(var/item/misc/paper/P in usr.contents)
						if(P.content) continue
						if(++. > 20) break
						P.Move(null, forced = 1)
				else
					usr.show_message("<tt>You need twenty unwritten pieces of paper!</tt>")
			label(t as text)
				name = "paper[t ? "- '[t]'":]"
				label = t
		painted(paint_window/W, mob/M)
			src.verbs -= /item/misc/paper/verb/Make_Book
			src.verbs -= /item/misc/paper/verb/Make_Spellbook
			src.verbs -= /item/misc/paper/verb/Write_
			src.content = 1
	book
		icon = 'icons/Supplies.dmi'
		icon_state = "book"
		var
			updated
			approved = 0
			author //key of author
		MouseDropped(item/misc/paper/I)
			if(istype(I) && (src in usr.contents) && (I in usr.contents) && !usr.restrained())
				src.contents += I
				usr.show_message("<tt>You bind [I.name] into the book.</tt>")
			else return ..()
		verb
			Remove(var/i as num)
				if(contents && contents.len >= i)
					var/item/misc/paper/I = contents[i]
					I.Move(usr)
					usr.show_message("<tt>You scrap [I.name] from the book.</tt>")
				else
					usr.show_message("<tt>This book doesn't have that many pages!</tt>")
			Read_(var/i as num)
				set name = "Read"
				if(contents && contents.len >= i)
					var/item/misc/paper/I = contents[i]
					I.Read_()
				else
					usr.show_message("<tt>This book doesn't have that many pages!</tt>")
			Table()
				usr.show_message("<tt>Table Of Contents:</tt>")
				var/i = 0
				for(var/item/misc/paper/I in contents)
					usr.show_message("\t <tt>#[++i]: [I.label || I.name]</tt>")
			label(t as text) name = "book[t ? "- '[t]'":]"
	ores
		icon='icons/ores_and_veins.dmi'
		stacked = 1
		gold_ore
			icon_state="Raw Gold"
		iron_ore
			icon_state="Raw Iron"
		copper_ore
			icon_state="Raw copper"
		tin_ore
			icon_state="Raw tin"
		tungsten_ore
			icon_state="Raw Tungsten"
		silver_ore
			icon_state="Raw Silver"
		palladium_ore
			icon_state="Raw Palladium"
		mithril_ore
			icon_state="Raw Mithril"
		magicite_ore
			icon_state="Raw Magicite"
		adamantite_ore
			icon_state="Raw Adamantite"
	shackle_ball
		icon = 'icons/Leg_Shackle.dmi'
		icon_state = "ball"
		stacked = 1
		verb/shackle_ball(mob/M in orange(1))
			if(ActionLock("shackling", 10) || usr.restrained()) return
			for(var/mob/N in hearers(usr) - M)
				N.show_message("<b>[usr.name]</b> tries to shackle [M.name]'s legs...</b>")
			usr.show_message("<b>You try to shackle [M.name]'s legs...</b>")
			M.show_message("<b>[usr.name] is trying to shackle your legs.</b>")
			var
				M_move = M.moveCount
				usr_move = usr.moveCount
			spawn(100)
				if(!usr.restrained() && (M in range(1, usr)) && M.moveCount == M_move && usr.moveCount == usr_move && !M.shackle_ball)
					M.shackle_ball()
					M.UpdateClothing()
					for(var/mob/N in hearers(usr) - M)
						N.show_message("<b>[usr.name]</b> shackles [M.name]'s legs!</b>")
					usr.show_message("<b>You shackle [M.name]'s legs!</b>")
					M.show_message("<b>[usr.name] shackles your legs!</b>")
					if(--stacked <= 0) Move(null, forced = 1)
	trapdoor
		icon = 'icons/Trapdoor.dmi'
		icon_state = "trapdoor closed"
		stacked = 1
		var
			keyslot
		MouseDrop(obj/over_object,src_location,over_location,src_control,over_control,params)
			if(istype(over_object,/turf/hole))
				var/turf/hole/C=over_object
				var/item/misc/trapdoor/K = locate() in usr
				var/turf/trapdoor/D = new(locate(C.x,C.y,C.z))
				D.name = src.name
				D.keyslot = K.keyslot
				if(--stacked <= 0) Move(null, forced = 1)
			..()
	paint_brush
		icon = 'icons/items.dmi'
		icon_state = "paint_brush"
		verb
			paint(obj/O in view(1, usr))
				set src = usr.contents
				if(!O.paintable)
					usr << "<tt>You cannot paint on this object!</tt>"
					return
				if(usr.paint_window)
					usr << "<tt>You are already painting on something!</tt>"
					return
				new/paint_window(usr, O)
	painting
		icon = 'icons/items.dmi'
		icon_state = "painting"
		paintable = 1
		New()
			. = ..()
			overlays += image(icon = 'icons/items.dmi', icon_state = "paintingo")
	arrows
		stacked = 1
		MouseDrop(item/misc/quiver/I)
			if(istype(I))
				I.DropArrow(usr, src)
				return
			return ..()
		wooden
			name = "wood arrow"
			icon = 'icons/items.dmi'
			icon_state = "arrow_wood"
	quiver
		icon = 'icons/items.dmi'
		icon_state = "quiver"
		Click()
			. = ..()
			if((src in usr.contents) && !usr.selectedSpellComponent && !ActionLock("getting"))
				if(usr.rolling || usr.shackled) return
				var/item/misc/arrows/I = input(usr, "What would you like to remove?", "Remove from quiver") as null|anything in contents
				if(I && !usr.rolling && !usr.shackled && (src in usr.contents))
					I.Move(usr, forced = 1)
					I.getting(usr)

				CountArrows()
		MouseDrop(item/misc/arrows/I)
			if(istype(I))
				DropArrow(usr, I)
				return
			return ..()
		getting()
			. = ..()
			ActionLock("getting", 10)
		proc
			DropArrow(mob/M, item/misc/arrows/I)
				if((src in M.contents) && (I in M.contents) && !M.restrained())
					if(I.stacked >= 1)
						if(I.stacked > 1)
							var/amnt = input(M, "How much would you like to add to the quiver? (Max: [I.stacked])", "Add [I.name]") as null|num
							if(amnt == null) return
							amnt = round(amnt)
							if(amnt <= 0) amnt = 1
							if(amnt >= I.stacked) amnt = I.stacked

							if(amnt < I.stacked)
								var/item/I2 = new I.type(src)
								I2.stacked = amnt
								I2.name = "[initial(I2.name)][I2.stacked > 1 ? " (x[I2.stacked])":]"
								I2.dropped(usr)
								I.stacked -= amnt
								CountArrows()
								return
						if(stacked > 1) name = "[initial(name)] (x[stacked])"
						else name = initial(name)
					I.Move(src, forced = 1)
					I.dropped(usr)
				CountArrows()
			CountArrows()
				. = 0
				for(var/item/misc/arrows/I in contents)
					I.name = "[initial(I.name)] (x[I.stacked])"
					. += I.stacked
				suffix = " ([.] arrows)"
		archer
			name = "quiver"
			New()
				. = ..()
				contents = newlist(/item/misc/arrows/wooden{stacked=20})
				CountArrows()
	waterstone
		icon = 'icons/items.dmi'
		icon_state = "waterstone"
		var
			enchanted = 0
			active = 0
			mob/lastTouched
			item/misc/waterstone/secondStone
			global/id = 0
			activeCount = 0
		proc
			toggle(verbose_sound = 0)
				. = 1
				if(!enchanted || !lastTouched || !secondStone || !secondStone.lastTouched || lastTouched == secondStone.lastTouched)
					. = 0
				if(active && (lastTouched.corpse || secondStone.lastTouched.corpse)) . = 0
				var/item/misc/waterstone/O
				for(O in world)
					if(O != src && O != secondStone && O.active &&\
					  (O.lastTouched == lastTouched || O.lastTouched == secondStone.lastTouched ||\
					  O.secondStone.lastTouched == lastTouched || O.secondStone.lastTouched == secondStone.lastTouched))
						break
				if(O) . = 0

				if(!.)
					active = 0
					icon_state = "waterstone"
					return
				active = !active
				secondStone.active = src.active
				icon_state = "waterstone[active ? "1":]"
				secondStone.icon_state = src.icon_state
				var/mob/dummy/M = new
				M.key = secondStone.lastTouched.key
				secondStone.lastTouched.key = lastTouched.key
				lastTouched.key = M.key
				lastTouched.show_message("<tt>You suddenly control another body...</tt>")
				secondStone.lastTouched.show_message("<tt>You suddenly control another body...</tt>")
				var/list/L = new/list()
				L += lastTouched
				L += secondStone.lastTouched
				for(var/mob/N in range(10, loc))
					if((verbose_sound || N.mage) && !(N in L)) L += N
				for(var/mob/N in L)
					spawn N.PlaySound(sound('sounds/transition.ogg', volume = 50))
				if(active)
					spawn CheckConnection()
					spawn secondStone.CheckConnection()
				var/item/misc/waterstone_box/I = loc
				if(istype(I))
					I.update_icon()
				I = secondStone.loc
				if(istype(I)) I.update_icon()
			deactivate() if(active && secondStone && lastTouched && secondStone.lastTouched) toggle()
			CheckConnection()
				var
					count = ++activeCount
					hp = 10
				while(active && activeCount == count)
					var/item/misc/waterstone_box/I = loc
					if(istype(I) && ismob(I.loc))
						if(--hp <= 0)
							toggle()
							return
					sleep(100)
		Del()
			deactivate()
			return ..()
		verb
			examine()
				set src in view()
				usr << "\t \icon[src] <b>[src.name]</b>"
				if(usr.mage)
					usr << "\t This is a waterstone! [active ? "It is currently active. ":]Your instincts tell you this particular stone [lastTouched ? " was last touched by [lastTouched.name]" : "has no fresh imprints of any person"]."
				else
					usr << "\t It looks like a stone filled with water.[active ? " It seems to be glowing.":]"
		getting()
			if(enchanted)
				//if(active) toggle()
				if(!active)
					spawn(30) if(!active && ismob(loc)) src.lastTouched = loc
			return ..()
	waterstone_box
		name = "wooden box"
		icon = 'icons/items.dmi'
		icon_state = "waterstone_box"
		var
			enchanted = 0
			item/misc/waterstone/stone
		proc
			enchant()
				enchanted = 1
				icon_state = "waterstone_box1"
			update_icon()
				overlays = list()
				if(stone)
					name = "[stone.name]"
					overlays += stone
				else
					name = "wooden box"
		verb
			remove_stone()
				set src in oview(1)
				if(stone)
					stone.Move(src.loc, forced = 1)
					stone = null
					update_icon()
			toggle()
				set src in oview(1)
				if(!stone)
					usr.show_message("<tt>There is no stone inserted into the box!</tt>")
					return
				if(!enchanted)
					usr.show_message("<tt>The box must be enchanted by a mage first!</tt>")
					return
				usr.show_message("<tt>You press the button...</tt>")
				stone.toggle(1)
		MouseDropped(item/misc/waterstone/O, src_location, over_location, src_control, over_control, params)
			if(!usr || !get_dist(usr, src) > 1) return ..()
			if(istype(O) && !stone)
				stone = O
				O.Move(src, forced = 1)
				update_icon()
				return 1

	new_berries
		icon = 'icons/Bushs.dmi'
		stacked = 1
		var
			SeedType
			berry_effects/Effects
			EffectsNo = 0 // the number of
		New()
			.=..()
			if(EffectsNo)
				var/Type = Berry_Effects[EffectsNo]
				Effects = new Type
			else Effects = new
		red
			name="Red Berry"
			icon_state = "redb"
			EffectsNo = 1
			SeedType = /item/misc/seeds/Red_Berry_Seeds
		blue
			name="Blue Berry"
			icon_state = "blueb"
			EffectsNo = 2
			SeedType = /item/misc/seeds/Blue_Berry_Seeds
		yellow
			name="Yellow Berry"
			icon_state = "yellowb"
			EffectsNo = 3
			SeedType = /item/misc/seeds/Yellow_Berry_Seeds
		white
			name="White Berry"
			icon_state = "whiteb"
			EffectsNo = 4
			SeedType = /item/misc/seeds/White_Berry_Seeds
		black
			name="Black Berry"
			icon_state = "blackb"
			EffectsNo = 5
			SeedType = /item/misc/seeds/Black_Berry_Seeds
		green
			name = "Green Berry"
			icon_state = "greenb"
			EffectsNo = 6
			SeedType = /item/misc/seeds/Green_Berry_Seeds
		verb
			mix()
				if(usr.CheckGhost() || usr.corpse) return
				var/list/Posthings = new/list()
				for(var/item/misc/new_berries/glass_vial/F in usr)
					if(istype(F,/item/misc/new_berries/glass_vial/))
						Posthings+=F
				Posthings+="Cancel"
				var/Chosen=input(usr,"What do you want to mix it with?","Mix")in Posthings
				if(Chosen=="Cancel") return
				else
					var/item/misc/new_berries/glass_vial/f=Chosen
					if(!f.Effects) f.Effects = new
					usr<<"\blue You mix [src] with [f]."
					if(stacked>1)
						var/item/misc/new_berries/N = new src.type
						N.Effects.add_to(f.Effects)
						del(N)
						stacked --
						suffix = "x[stacked]"
					else
						src.Effects.add_to(f.Effects)
						del(src)
					if(f.icon_state == "glass_vial")
						f.icon_state = "glass_vial_[rand(1,3)]"
						f.verbs += /item/misc/new_berries/glass_vial/verb/mix_into
						f.verbs += /item/misc/new_berries/glass_vial/verb/drink

			eat()
				if(usr.CheckGhost() || usr.corpse) return
				consume(usr)
				if(usr.skills.medicine < 100) usr.skills.medicine++

			examine()
				var/possible_type = ""
				if(prob(usr.skills.medicine)) possible_type = Effects.name
				else
					if(prob(16)) possible_type = "Poison"
					else if(prob(16)) possible_type = "Sleep"
					else if(prob(16)) possible_type = "Caffeine"
					else if(prob(16)) possible_type = "Hunger"
					else if(prob(16)) possible_type = "Alcohol"
					else possible_type = "Food"
				usr << "\blue This berry could have the effect of [possible_type]!"

		proc
			consume(mob/M)
				hearers(M) << "\blue [M.name] eats the berry."
				if(!M.Effects) M.Effects = new
				if(stacked>1)
					var/item/misc/new_berries/N = new src.type
					N.Effects.add_to(M.Effects)
					del(N)
				else
					src.Effects.add_to(M.Effects)
				if(--stacked <= 0) Move(null, forced = 1)
				if(isturf(loc)) name = "[initial(name)] (x[stacked])"
				var/item/misc/seeds/I = locate(SeedType) in M.contents
				if(!I) new SeedType(M)
				else I.stacked++
		glass_vial
			icon_state = "glass_vial"
			stacked = -1
			name = "Glass Vial"

			New()
				verbs -= /item/misc/new_berries/glass_vial/verb/mix_into
				verbs -= /item/misc/new_berries/glass_vial/verb/drink
				verbs -= /item/misc/new_berries/verb/eat
				verbs -= /item/misc/new_berries/verb/mix
				..()

			verb/label_vial(var/x as text)
				set name = "label vial"
				if(usr.CheckGhost() || usr.corpse) return
				name = x

			verb/drink()
				set name = "drink"
				if(usr.CheckGhost() || usr.corpse) return
				consume(usr)

			verb/mix_into()
				set name = "mix into"
				if(usr.CheckGhost() || usr.corpse) return
				var/list/Posthings = new/list()
				for(var/item/misc/food/F in usr)
					if(istype(F,/item/misc/food/))
						Posthings+=F
				Posthings+="Cancel"
				var/Chosen=input(usr,"What do you want to mix it into?","Mix Into")in Posthings
				if(Chosen=="Cancel") return
				else
					var/item/misc/food/f=Chosen
					if(!f.Effects) f.Effects = new
					usr<<"\blue You mix [src] with [f]."
					src.Effects.add_to(f.Effects)
					Effects = new()
					icon_state = "glass_vial"
					verbs -= /item/misc/new_berries/glass_vial/verb/mix_into
					verbs -= /item/misc/new_berries/glass_vial/verb/drink
			examine()
				var/possible_type = ""
				if(prob(usr.skills.medicine)) possible_type = Effects.name
				else
					if(prob(16)) possible_type = "Poison"
					else if(prob(16)) possible_type = "Sleep"
					else if(prob(16)) possible_type = "Caffeine"
					else if(prob(16)) possible_type = "Hunger"
					else if(prob(16)) possible_type = "Alcohol"
					else possible_type = "Food"
				usr << "\blue This vial could have the effect of [possible_type]!"

			consume(mob/M)
				hearers(M) << "\blue [M.name] drinks the vial."
				if(!M.Effects) M.Effects = new
				src.Effects.add_to(M.Effects)
				Effects = new()
				icon_state = "glass_vial"
				verbs -= /item/misc/new_berries/glass_vial/verb/mix_into
				verbs -= /item/misc/new_berries/glass_vial/verb/drink



	tree_root
		icon_state = "tree_root"
	beer
		name = "grog"
		icon_state = "beer"
		var/amount = 4
		verb
			Drink()
				if(amount <= 0)
					usr.show_message("<tt>The jug is empty!</tt>")
					return
				usr.show_message("<tt>You take a sip of grog...</tt>")
				for(var/mob/N in oviewers(usr))
					N.show_message("<tt>[usr.name] takes a sip of grog...</tt>")

				amount--
				usr.effects.alcohol = max(usr.effects.alcohol + 20, 60)
				if(icon_state == "root_beer")
					usr.effects.alcohol = max(usr.effects.alcohol + 40, 60)
				update_icon()
		proc
			update_icon()
				if(amount <= 0) icon_state = "beer_empty"
		MouseDropped(mob/M, src_location, over_location, src_control, over_control, params)
			if(!usr || !get_dist(usr, src) > 1) return ..()
			if(istype(M) && M.state == "ghost" && amount > 0)
				M.HP = 0
				M.checkdead(M)
				M.Move(null, forced = 1)

				amount--
				update_icon()
				return 1