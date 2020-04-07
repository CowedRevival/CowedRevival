var/list/sd_dynamic_lighting_turfs
turf
	icon = 'icons/Turfs.dmi'
	Enter(atom/movable/A)
		var/mob/M = A
		if(istype(M) && M.state == "ghost-i") return 1
		return ..()
	New()
		. = ..()
		if(map_loaded && istype(loc, /area/darkness) && sd_dynamic_lighting_turfs && (src in sd_dynamic_lighting_turfs))
			var
				list
					affected = sd_dynamic_lighting_turfs[src][1]
					spill = sd_dynamic_lighting_turfs[src][2]
				atom/A
				turf
					T
					ATurf
			sd_dynamic_lighting_turfs -= src
			if(!sd_dynamic_lighting_turfs.len) sd_dynamic_lighting_turfs = null

			if(opacity)
				for(A in affected)
					ATurf = A
					while(ATurf && !istype(ATurf)) ATurf = ATurf.loc
					if(ATurf)
						for(T in affected[A]-view(A.luminosity, ATurf))
							T.sd_lumcount -= (A.luminosity-get_dist(A,T))
							T.sd_LumUpdate()

					if(src in view(A))
						src.sd_lumcount += (A.luminosity - get_dist(A, src))
						src.sd_LumUpdate()
				for(A in spill)
					if(A.opacity && A!=src) continue
					ATurf = A
					while(ATurf && !istype(ATurf)) ATurf = ATurf.loc
					if(ATurf)
						//spill[A] -= view(sd_light_outside, A)
						for(T in (A==src)?spill[A]:(spill[A]-view(sd_light_outside,ATurf)))
							if(T.loc:sd_outside) continue
							T.sd_lumcount -= (sd_light_outside-get_dist(A,T))
							T.sd_LumUpdate()
				// end new_opacity = 1 block
			else
				for(A in affected)
					ATurf = A
					while(ATurf && !istype(ATurf)) ATurf = ATurf.loc
					if(ATurf)
						for(T in view(A.luminosity, ATurf) - affected[A])
							T.sd_lumcount += (A.luminosity-get_dist(A,T))
							T.sd_LumUpdate()

					if(src in view(A.luminosity, A))
						src.sd_lumcount += (A.luminosity - get_dist(A, src))
						src.sd_LumUpdate()
				for(A in spill)
					if(A.opacity) continue
					ATurf = A
					while(ATurf && !istype(ATurf)) ATurf = ATurf.loc
					if(ATurf)
						for(T in (A==src)?spill[A]:(view(sd_light_outside, ATurf)-spill[A]))
							if(T.loc:sd_outside) continue
							T.sd_lumcount += (sd_light_outside-get_dist(A,T))
							T.sd_LumUpdate()
				// end new_opacity = 0 block

			/*for(A in view(sd_top_luminosity, src))
				if(!A.luminosity) continue
				sd_lumcount += (A.luminosity - get_dist(A, src))
			sd_LumUpdate()*/

			/*if(old_opacity != opacity)
				var/new_opacity = opacity
				opacity = old_opacity
				sd_SetOpacity(new_opacity)*/
	Del()
		if(type == /turf) return ..()
		if(!sd_dynamic_lighting_turfs) sd_dynamic_lighting_turfs = new/list()
		var
			list
				affected = new
				spill
			atom/A
			turf
				T
		affected = new
		for(A in range(sd_top_luminosity,src))
			T = A
			while(T && !istype(T)) T = T.loc
			if(T)
				var/list/V = view(A.luminosity,T)
				if(!(src in V)) continue
				var/turfflag = 0
				if(A == T) turfflag = 1
				if(A.luminosity && get_dist(A,src)<=A.luminosity+turfflag)
					affected[A] = V
				if(sd_light_outside && (A in sd_light_spill_turfs))
					if(!spill) spill=new
					spill[A] = view(sd_light_outside, T)
		sd_dynamic_lighting_turfs[src] = list(affected, spill)
		return ..()
	proc
		GetObstructed()
			if(density) return src
			if(loc.density) return loc
			for(var/obj/O in src) if(O.density) return O
			for(var/mob/M in src) if(M.density) return M
		empty(skip)
			if(density) return 0
			for(var/atom/movable/A in src) if(skip != A && A.density) return 0
			return 1
	underground
		dirtwall
			icon = 'icons/Turfs.dmi'
			icon_state = "dirtwall"
			density = 1
			opacity = 1
			attack_hand(mob/M)
				if(usr.inHand(/item/weapon/shovel) || usr.inHand(/item/weapon/pickaxe))
					if(ActionLock("digging", 10)) return //prevent the tile from being invoked twice
					icon_state = "dirtwall2"
					spawn(2)
						if((usr.inHand(/item/weapon/pickaxe) && prob(10)) || prob(5))
							new/obj/vein(src)
						new/turf/path(src)
		bedrock
			icon = 'icons/Turfs.dmi'
			icon_state = "bedrock"
			density = 1
			opacity = 1

	Dragon_Statue
		icon_state = "dragon statue"
		density = 1
		New()
			. = ..()
			spawn(rand(10, 30))
				while(1)
					sleep(30)
					new/obj/Fireball(locate(src.x,src.y,src.z))
	stairs
		icon_state = "stairs"
		New()
			. = ..()
			spawn
				for(var/obj/stairs/O in src) del O
		Entered(atom/movable/A)
			var/mob/M = A
			if(istype(M))
				M.lastHole = src
				spawn(100) if(M && M.lastHole == src) M.lastHole = null

			var/map_object/O = MapObject(A.z)
			if(O.map_layer < 0) //going up!
				O = O.NextLayer()
				var/turf/T = locate(x, y, O.z)

				if(istype(T, /turf/path) || istype(T, /turf/grass) || istype(T, /turf/sand))
					if(istype(T, /turf/sand))
						new/turf/hole{icon_state = "hole_s"}(T)
					else new/turf/hole(T)
				else if(istype(T, /turf/trapdoor))
					var/turf/trapdoor/P = T
					if(P.icon_state == "trapdoor closed")
						if(P.locked)
							A << "<tt>A trap door seems to be blocking the way. You knock...</tt>"
							if(!ActionLock("knock", 5))
								hearers(P) << "\icon[src] *knock* *knock*"
								hearers(src) << "\icon[src] *knock* *knock*"
						else
							P.icon_state = "trapdoor open"
							A.Move(T, forced = 1)
					else A.Move(T, forced = 1)
				else if(istype(T, /turf/hole) || locate(/obj/family/edison/grandfather_clock, T)) A.Move(T, forced = 1)
				else
					A << "<tt>This area is too hard to get through.</tt>"
		royal_stairs
			icon_state="royal stairs1"
	hole
		icon_state = "hole"
		New()
			. = ..()
			spawn
				var/map_object/O = MapObject(src.z)
				if(!O || !O.kingdom) return
				var/map_object/B = O.PrevLayer()
				if(B) //already exists; just build stairs
					var/turf/T = locate(x, y, B.z)
					if(istype(T, /turf/underground/dirtwall)) new/turf/stairs(T)
					return
				var/new_z = add_layer(O.kingdom, up = 0) //create a new underground layer
				var/turf/T = locate(x, y, new_z)
				new/turf/stairs(T)
		Entered(atom/movable/A)
			var/map_object/O = MapObject(A.z)
			if(!O) return
			O = O.PrevLayer()
			if(!O || O.z == 1) return

			var/turf/T = locate(x, y, O.z)
			if(!istype(T, /turf/stairs) && !istype(T, /turf/path) && !istype(T, /turf/underground/dirtwall) && !(locate(/obj/stairs, T)))
				A << "<tt>This area is too hard to get through.</tt>"
				return
			var/mob/M = A
			if(istype(M))
				M.lastHole = src
				spawn(100) if(M && M.lastHole == src) M.lastHole = null
			A.Move(T, forced = 1)
		attack_hand(mob/M)
			if(!M.inHand(/item/weapon/shovel)) return
			hearers(src) << "<small>[M.name] starts to fill the hole.</small>"
			usr.movable = 1
			sleep(20)
			usr.movable = 0
			hearers(src) << "<small>[M.name] fills up the hole.</small>"
			new/turf/path(src)
	path
		icon_state = "path"
		attack_hand(mob/M)
			if(!M.inHand(/item/weapon/hoe)) return
			hearers(src) << "<small>[M.name] starts to till the earth.</small>"
			M.movable = 1
			sleep(10)
			M.movable = 0
			hearers(src) << "<small>[M.name] tills the earth.</small>"
			new/turf/tilled_soil(src)
	tilled_soil
		icon_state = "tilled soil"
		attack_hand(mob/M)
			if(!M.inHand(/item/weapon/shovel)) return
			hearers(src) << "<small>[M.name] starts to dig up the soil.</small>"
			M.movable = 1
			sleep(10)
			M.movable = 0
			hearers(src) << "<small>[M.name] digs up the soil.</small>"
			new/turf/path(src)
	sand
		icon_state = "sand"
		New()
			. = ..()
			if(prob(3))
				new/obj/Palm_tree(src)
		attack_hand(mob/M)
			if(!M.inHand(/item/weapon/shovel)) return
			hearers(src) << "<small>[M.name] starts to dig up some sand.</small>"
			M.movable = 1
			sleep(10)
			M.movable = 0
			hearers(src) << "<small>[M.name] digs up a clump of sand.</small>"
			var/item/misc/sand_clump/I = locate() in usr
			if(I)
				I.stacked += 1
				I.suffix = "x[I.stacked]"
			else usr.contents += new/item/misc/sand_clump()

	royal_carpet
		name="Royal Carpet"
		north
			icon_state = "royal t"
		east
			icon_state = "royal r"
		south
			icon_state = "royal b"
		west
			icon_state = "royal l"
		northeast
			icon_state = "royal tr"
		northwest
			icon_state = "royal tl"
		southeast
			icon_state = "royal br"
		southwest
			icon_state = "royal bl"
		middle
			icon_state = "royal middle"
	throne
		name = "throne"
		throne
			icon_state = "throne"
		legs
			icon_state = "throne legs"
	portal
		icon_state = ""
		density = 1
		New()
			. = ..()
			spawn
				while(1)
					if(gametype)
						icon_state = "portal"
						density = 0
						break
					sleep(5)
		Enter(mob/M)
			if(!istype(M)) return ..()
			var/mob/N
			for(N in world)
				if(N != M && (N.name == M.name || N.name == "[M.name]'s corpse")) break
			if(N)
				M.show_message("<tt>You may not join the game with that name... please change your name using the Change Name command under the Commands tab.</tt>")
				return 0
			return ..()
		Entered(mob/M)
			if(istype(M))
				M.dir = SOUTH
				if(gametype == "normal")
					M.movable = 1
					M.Move(locate(48, 9, 1), forced = 1)
				else if(gametype == "peasants" || gametype == "premade")
					M.movable = 1
					M.Move(locate(64,9,1), forced = 1)
				else if(gametype == "kingdoms")
					M.movable = 1
					M.Move(locate(80, 9, 1), forced = 1)
	grass
		icon_state = "grass"
		New()
			. = ..()
			if(prob(15))
				new/obj/tree(src)
			else if(prob(1))
				new/obj/bush(src)
			else if(prob(5))
				if(prob(10))
					var/obj/crop/wheat/I = new(src)
					I.icon_state = "wheat_growth_3"
				else if(prob(10))
					var/obj/crop/corn/I = new(src)
					I.icon_state = "corn_growth_3"
				else if(prob(10))
					var/obj/crop/potato/I = new(src)
					I.icon_state = "potato_growth_3"
				else if(prob(10))
					var/obj/crop/tomato/I = new(src)
					I.icon_state = "tomato_growth_3"
				else if(prob(10))
					var/obj/crop/carrot/I = new(src)
					I.icon_state = "carrot_growth_3"
				else if(prob(5))
					var/obj/crop/hemp/I = new(src)
					I.icon_state = "hemp_growth_3"
				else if(prob(5))
					var/obj/crop/watermelon/I = new(src)
					I.icon_state = "wm_growth_3"
				else if(prob(2))
					var/obj/tree/apple_tree/I = new(src)
					I.icon_state = "[current_season_state]apple_tree_2"
			else if(prob(2))
				switch(rand(1,3))
					if(1) new/obj/Flower/Red_Flower(src)
					if(2) new/obj/Flower/Blue_Flower(src)
					if(3) new/obj/Flower/Yellow_Flower(src)
		attack_hand(mob/M)
			if(!M.inHand(/item/weapon/shovel)) return
			hearers(src) << "<small>[M.name] starts to dig a path.</small>"
			M.movable = 1
			sleep(20)
			M.movable = 0
			hearers(src) << "<small>[M.name] digs a path.</small>"
			new/item/misc/seeds/Grass_Seeds(src)
			new/turf/path(src)
	water
		name = "water"
		icon_state = "water"
		density = 0
		Enter(atom/movable/A)
			var/mob/M = A
			if(istype(M) && M.state == "ghost-i") return ..()
			if(type != /turf/water || istype(A, /obj/drawbridge/drawbridge) || locate(/obj/glass_plate, src))
				return ..()
			if(istype(A, /projectile) || istype(A, /obj/cannonball)) return ..()
			if(!(locate(/obj/drawbridge/drawbridge, src)) && !(locate(/obj/boat, src)))
				return 0 //no drawbridge and no boat? no service!
			return ..()
		river_water
			name = "river water"
			verb/Drink(var/mob/usr)
				set src in view(1)
				if(usr.corpse) return
				hearers(src) << "<small>[usr.name] sips water from the river.</small>"
				usr.THIRST += 20
				if(usr.THIRST >= usr.MTHIRST)
					usr.THIRST = usr.MTHIRST
				hud_main.UpdateHUD(usr)
			Enter(atom/movable/A)
				var/mob/M = A
				if(istype(M) && M.state == "ghost-i") return ..()
				if(type != /turf/water/river_water || istype(A, /obj/drawbridge/drawbridge) || locate(/obj/glass_plate, src))
					return ..()
				if(istype(A, /projectile) || istype(A, /obj/cannonball)) return ..()
				if(!(locate(/obj/drawbridge/drawbridge, src)) && !(locate(/obj/boat, src)))
					return 0 //no drawbridge and no boat? no service!
				return ..()

		enchanted
			var
				open = 0
				id
			Enter(atom/movable/A)
				if(open || istype(A, /projectile) || istype(A, /obj/cannonball)) return ..()
				return 0
			controller
				parent_type = /obj
				var
					id
					code
					open = 0
				hear(mob/M, data, text)
					set background = 1 //wtf!
					if(istype(M) && lowertext(text) == code)
						open = !open
						for(var/turf/water/enchanted/T in world)
							if(T != src && T.id == src.id)
								T.open = open
								if(T.type == /turf/water/enchanted)
									if(open)
										T.name = "rope bridge"
										T.icon = 'icons/wood.dmi'
										T.icon_state = "bridge"
									else
										T.name = "water"
										T.icon = 'icons/Turfs.dmi'
										T.icon_state = "water"
		attack_hand(mob/M)
			if(M.inHand(/item/weapon/fishing_rod))
				M << "<small>You cast a line.</small>"
				M.movable = 1
				spawn(20)
					if(!M) return
					M.movable = 0

					var/X = rand(1, 10)
					if(M.skills && M.skills.fishing >= 35 && prob(M.skills.fishing)) X += 4
					if(prob(1) && M.skills && M.skills.fishing >= 35 && M.skills.fishing < 100) M.skills.fishing++
					switch(X)
						if(3 to 6)
							M << "\blue You catch a goldfish!"
							M.contents += new/item/misc/food/Goldfish
						if(7 to 10)
							M << "\blue You catch a bass!"
							M.contents += new/item/misc/food/Bass
						if(11 to 14)
							M << "\blue You catch a shark!"
							M.contents += new/item/misc/food/Shark
						else
							if(prob(99)) M << "\blue You fail to catch anything!"
							else if((M.skills && M.skills.gathering > 35 && prob(M.skills.gathering)) || M.mage || prob(50))
								if(prob(1) && M.skills && M.skills.gathering >= 35 && M.skills.gathering < 100) M.skills.gathering++
								M << "\blue You find a water stone!"
								M.contents += new/item/misc/waterstone //indeed.
							else
								M << "\blue You catch... an old peasants' hat."
								M.contents += new/item/armour/hat/pez_hat //"rare" indeed. =P
			else if(M.inHand(/item/weapon/staff))
				M << "<small>You search the waters...</small>"
				M.movable = 1
				spawn(20)
					if(!M) return
					M.movable = 0

					var/chance = 1
					if(M.mage) chance += 9
					if(prob(chance))
						M << "\blue You find a water stone!"
						M.contents += new/item/misc/waterstone //indeed.
					else
						M << "\blue You don't find anything!"
			else if(M.inHand(/item/weapon/spear))
				M << "<small>You throw your spear.</small>"
				M.movable = 1
				spawn(20)
					if(!M) return
					M.movable = 0

					var/X = rand(1, 20)
					if(M.skills && M.skills.fishing >= 35 && prob(M.skills.fishing)) X += 8
					if(prob(1) && M.skills && M.skills.fishing >= 35 && M.skills.fishing < 100) M.skills.fishing++
					switch(X)
						if(12 to 15)
							M << "\blue You catch a puffer fish!"
							M.contents += new/item/misc/food/Puffer_Fish
						if(16 to 17)
							M << "\blue You catch a carp!"
							M.contents += new/item/misc/food/Carp
						if(18 to 19)
							M << "\blue You catch a koi!"
							M.contents += new/item/misc/food/Koi
						if(20 to 22)
							M << "\blue You catch a swordfish!"
							M.contents += new/item/misc/food/Swordfish
						if(23 to 25)
							M << "\blue You catch a tuna!"
							M.contents += new/item/misc/food/Tuna
						if(26 to 28)
							M << "\blue You catch a <font color=\"#00CC00\">frog man</small>!"
							new/mob/Frogman(M.loc)
		bridgewater
			density = 0
			New()
				spawn for()
					if(bridge == "open")
						src.density = 0
					if(bridge == "closed")
						src.density = 1
					sleep(5)
		bridgewaterl
			density = 0
			New()
				spawn for()
					if(bridgel == "open")
						src.density = 0
					if(bridgel == "closed")
						src.density = 1
					sleep(5)
	pede
		icon_state = "pede"
		layer = MOB_LAYER+10
	metal_fence
		metal_fence
			icon_state = "metal fence"
			density = 1
		fence_gate
			icon_state = "fence closed"
			density=1
			attack_hand(mob/M)
				density = !density
				icon_state = density ? "fence closed" : "fence opened"
	whiteness
		layer=14
		icon='icons/Whiteness.dmi'
	loadin
		luminosity=6
		icon = 'icons/Load screen.dmi'
		starterscreen
			icon_state = "cowed"
			layer = 15
		screenB
			icon_state = "screenB"
			layer = 15
		kingdom
			icon_state = "kingdom"
			layer = 15
		whatjob
			icon = 'icons/questions.dmi'
			icon_state = "what job"
			name = "What Job?"
			layer = 15
		whatclass
			icon = 'icons/questions.dmi'
			icon_state = "what class"
			name = "What Class?"
			layer = 15
		whatkingdom
			icon = 'icons/questions.dmi'
			icon_state = "what kingdom"
			name = "What Kingdom?"
			layer = 15
	holofloor
		name = "floor"
		icon_state = "holofloor"
		//mouse_opacity = 0
	holowall
		name = "wall"
		icon_state = "holowall"
		density = 1
		opacity = 1
		//mouse_opacity = 0
	trekfloor
		name = "floor"
		icon_state = "trekfloor2"
	trapdoor
		icon = 'icons/Trapdoor.dmi'
		icon_state = "trapdoor closed"
		var
			keyslot
			locked=0
			buildinghealth = 15
		New()
			. = ..()
			spawn
				var/map_object/O = MapObject(src.z)
				if(!O || !O.kingdom) return
				var/map_object/B = O.PrevLayer()
				if(B) //already exists; just build stairs
					var/turf/T = locate(x, y, B.z)
					if(istype(T, /turf/underground/dirtwall)) new/turf/stairs(T)
					return
				var/new_z = add_layer(O.kingdom, up = 0) //create a new underground layer
				var/turf/T = locate(x, y, new_z)
				new/turf/stairs(T)
		Entered(atom/movable/A)
			if(icon_state == "trapdoor open")
				var/map_object/O = MapObject(A.z)
				if(!O) return
				O = O.PrevLayer()
				if(!O || O.z == 1) return

				var/turf/T = locate(x, y, O.z)
				if(!istype(T, /turf/stairs) && !istype(T, /turf/path) && !istype(T, /turf/underground/dirtwall) && !(locate(/obj/stairs, T)))
					A << "<tt>This area is too hard to get through.</tt>"
					return
				var/mob/M = A
				if(istype(M))
					M.lastHole = src
					spawn(100) if(M && M.lastHole == src) M.lastHole = null
				A.Move(T, forced = 1)
		Click(mob/M)
			if(usr.shackled==1) return
			if(!usr.inHand(/item/weapon/axe) && get_dist(src,usr) <= 1)
				if(usr.loc == src) return
				if(locked == 1)
					usr.show_message("It's locked!")
					return
				if(icon_state == "trapdoor open")
					icon_state = "trapdoor closed"
				else
					icon_state = "trapdoor open"
		DblClick()
			if(usr.z==1) return
			if(usr.shackled==1) return
			if(get_dist(src,usr) <= 1)
				if(buildinghealth >= 1)
					if(usr.inHand(/item/weapon/axe))
						if(buildinghealth >= 1)
							hearers(usr) <<"[usr] chops the [src]"
							buildinghealth-=1
						if(buildinghealth <= 0)
							hearers(usr) <<"[usr] cuts the [src] down"
							new/turf/hole(src)
						return
			..()
		verb
			Knock()
				set src in oview(1)
				if(!(src in oview(1, usr))) return
				var/turf/T = locate(x, y, 4)
				for(var/mob/N in hearers(src) + hearers(T))
					N.show_message("\icon[src] *knock* *knock*")
	digging
		icon='icons/Turfs.dmi'
		icon_state="digging"
		New()
			..()
			spawn(30) new/turf/hole(src)
	school_of_magic
		test1
			icon = 'icons/stone.dmi'
			icon_state = "open"
			opacity = 1
			start
				name = "Door (Start)"
				Enter(mob/M)
					M.magic_points += M.tmp_magic_points
					var/points = round(M.tmp_magic_points * 2) - M.tmp_magic_points
					if(points > 0)
						M.show_message("<tt>You gain [points] magic points!</tt>")
						M.magic_points += points
					M.tmp_magic_points = 0
					var/turf/school_of_magic/test1/door/T = locate() in world
					if(T) M.Move(locate(T.x, T.y - 1, T.z), SOUTH, forced = 1)
			finish
				name = "Door (Finish)"
				Enter(mob/M)
					M.tmp_magic_points += 2
					M.show_message("<tt>You gain 2 magic points!</tt>")
					var/turf/school_of_magic/test1/start/T = locate() in world
					if(T) M.Move(locate(T.x, T.y + 1, T.z), NORTH, forced = 1)
			door
				name = "Door (Test 1)"
				Enter(mob/M)
					if(!ismob(M) || !M.mage)
						M.show_message("<tt>A magical barrier prevents you from passing through the door!</tt>")
						return 0
					M.tmp_magic_points = 0
					M.tmp_magic_data = 0
					var/turf/school_of_magic/test1/start/T = locate() in world
					if(T) M.Move(locate(T.x, T.y + 1, T.z), NORTH, forced = 1)