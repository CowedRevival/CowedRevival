proc
	add_layer(character_handling/container/kingdom, up = 1)
		var
			z = ++world.maxz
			map_object/O = new(locate(1, 1, z))
		O.kingdom = kingdom
		O.map_layer = up ? MaxLayer(kingdom) : MinLayer(kingdom)
		up ? O.map_layer++ : O.map_layer--
		O.name = "cowmalot- '[O.map_layer]'"
		return O.z
	layer_distance(top, bottom)
		var
			layer1 = MapLayer(top)
			layer2 = MapLayer(bottom)
		if(layer1 > layer2) return layer1 - layer2
		return layer2 - layer1

		/*. = top
		if(top > start_z)
			if(bottom > start_z)
				. -= bottom
			else
				. -= start_z
		else //only possible case is if top = skyz
			return 1

		if(bottom == worldz) .++*/
	next_layer(z)
		var/map_object/O = MapObject(z)
		if(O)
			return O.NextLayer()
		/*if(z == worldz) return skyz
		else if(z == skyz) return start_z + 1
		else return z + 1*/
	lower_layer(z)
		var/map_object/O = MapObject(z)
		if(O)
			return O.PrevLayer()
		/*if(z == skyz)
			return worldz
		else if(z - 1 == start_z) return skyz
		else return z - 1*/
turf
	proc
		lower_turf()
			var/map_object/O = lower_layer(src.z)
			if(O)
				var/turf/T = locate(x, y, O.z)
				if(istype(T, /turf/sky) || T.type == /turf) return T.lower_turf()
				return T
			/*
			if(z == skyz) return locate(x, y, worldz)
			else
				var/turf/T = locate(x, y, (z - 1 == start_z ? skyz : z - 1))
				if(!T) return null
				if(istype(T,/turf/sky) || T.type == /turf) return T.lower_turf()
				return T*/
		opaque() // whether this turf is opaque, needed for looking down
			if(opacity)
				return 1
			for(var/atom/A in src) if(A.opacity)
				return 1
			return 0

atom/movable
	/*proc/ascend()
		var/nz
		if(z <= start_z) nz = start_z + 1
		else nz = z + 1
		if(nz > world.maxz) return

		var/turf/T = locate(x,y,nz)
		if(istype(T, /turf/sky) || T.type == world.turf)
			new/area/darkness/sky(T)
			T = new/turf/sky/hole(T)

		var/mob/M = src
		if(istype(M))
			if(M.whopull && get_dist(M, M.whopull) <= 1 && !M.whopull.anchored)
				M.whopull.loc = T
		Move(T)
		loc = T*/

atom
	proc/update_sky()
		if(MapLayer(z) >= 1)
			for(var/turf/T in view(src, 8))
				if(T.type == /turf || T.type == /turf/underground/dirtwall)
					new/area/darkness/sky(T)
					var/turf/sky/S=new(T)
					S.Update()


turf/sky
	icon = 'icons/grid.dmi'
	var/can_build = 0
	var/updating = 0
	New()
		. = ..()
		Update()
		//if(loc && loc.type == /area) new/area/darkness/sky(src)
	Entered(atom/movable/A)
		var/turf/fall_to = lower_turf()
		A.Move(fall_to, forced = 1)

		if(istype(A, /mob))
			var/mob/M = A
			if(layer_distance(z, fall_to.z) >= 3) M.medal_Award("Vertigo")

			M.HP -= 4 * (layer_distance(z, fall_to.z) - 1) ** 2
			if(layer_distance(z, fall_to.z) - 1 > 0)
				A << "You take some damage as you fall onto the ground."
				M.last_hurt = "fall"
			if(M.HP <= 0) M.HP = 0
			M.checkdead(M)

			if(M.whopull && get_dist(M, M.whopull) <= 1 && !M.whopull.anchored)
				M.whopull.Move(fall_to, forced = 1)
				M = M.whopull
				if(istype(M))
					if(layer_distance(z, fall_to.z) >= 3) M.medal_Award("Vertigo")
					M.HP -= 4 * (layer_distance(z, fall_to.z) - 1) ** 2
					if(layer_distance(z, fall_to.z) - 1 > 0)
						M << "You take some damage as you fall onto the ground."
						M.last_hurt = "fall"
					if(M.HP <= 0) M.HP = 0
					M.checkdead(M)
	proc
		Update()
			if(!updating)
				if(!istype(src,/turf/sky)) return
				var/turf/T = lower_turf()
				if(!T) return
				if(layer_distance(z, T.z) == 1)
					var/turf/E
					for(E in range(1, T))
						if(istype(E, /turf/stone/stone_wall) || istype(E, /turf/wooden/wood_wall) || istype(E, /turf/sky/hole))
							break
					if(!E && (istype(T, /turf/stone) || istype(T, /turf/wooden) || istype(T, /turf/sky/hole))) E = T
					if(E)
						icon_state = "can_build"
						can_build = 1
					else
						icon_state = ""
						can_build = 0
				else
					icon_state = "damage"
					can_build = 0
	hole
		icon = 'icons/Turfs.dmi'
		icon_state = "hole2sky"
		Update()
			can_build = 0
			var/turf/T = lower_turf()
			if(istype(T, /turf/stone)) icon_state = "hole2sky2"
			else icon_state = "hole2sky"
			return

proc/refresh_sky(atom/A)
	if(map_loaded)
		var/turf/sky/S = locate(A.x,A.y,next_layer(A.z))
		for(var/turf/sky/T in range(S, 4)) T.Update()
/*
mob/verb/stop_looking()
	if(client&&client.looking_from)
		client.looking_range = 0
		client.looking_from = null
		client.looking_at = null
		client.eye = client.mob

		movable = 0

obj
	scroll
		layer = 699
		up
			screen_loc = "1,9"
			icon_state = "View UP close"
			Click()
				if(usr.client.scroll_up_open)
					usr.client.look_up()
		down
			screen_loc = "1,8"
			icon_state = "View DOWN close"

			Click()
				if(usr.client.scroll_down_open)
					var/turf/sky/S = locate(/turf/sky) in view(usr.client.eye)
					if(!S) return
					usr.client.look_down(S)


client
	var
		looking_range
		turf
			looking_from
			looking_at

		obj
			scroll_up
			scroll_down

		scroll_visible = 0
		scroll_down_open = 0
		scroll_up_open = 0

	proc
		show_scroll()
			if(!scroll_up || !scroll_down) return
			scroll_up.icon = 'icons/screen.dmi'
			scroll_down.icon = 'icons/screen.dmi'
			scroll_visible = 1
		hide_scroll()
			if(!scroll_up || !scroll_down) return
			scroll_up.icon = null
			scroll_down.icon = null
			scroll_visible = 0
		show_scroll_down()
			if(!scroll_up || !scroll_down) return
			if(!scroll_down_open)
				scroll_down.icon_state = "View DOWN open"
				flick("View DOWN close-open", scroll_down)
				scroll_down_open = 1
		hide_scroll_down()
			if(!scroll_up || !scroll_down) return
			if(scroll_down_open)
				scroll_down.icon_state = "View DOWN close"
				flick("View DOWN open-close", scroll_down)
				scroll_down_open = 0
		show_scroll_up()
			if(!scroll_up || !scroll_down) return
			if(!scroll_up_open)
				scroll_up.icon_state = "View UP open"
				flick("View UP close-open", scroll_up)
				scroll_up_open = 1
		hide_scroll_up()
			if(!scroll_up || !scroll_down) return
			if(scroll_up_open)
				scroll_up.icon_state = "View UP close"
				flick("View UP open-close", scroll_up)
				scroll_up_open = 0

		check_layer()
			if(mob.z <= start_z && scroll_visible)
				hide_scroll()
			if(mob.z > start_z && !scroll_visible)
				show_scroll()
			if(mob.z > start_z)
				if(looking_at)
					if(!scroll_up_open)
						show_scroll_up()
					if(looking_at.z > start_z)
						if(!scroll_down_open)
							show_scroll_down()
					else
						if(scroll_down_open)
							hide_scroll_down()
				else
					if(scroll_up_open)
						hide_scroll_up()
					if(!scroll_down_open)
						show_scroll_down()


		look_down(turf/sky/S)
			if(looking_from)
				if(S in range(looking_range, looking_from))
					looking_from = locate(looking_from.x, looking_from.y, lower_layer(looking_from.z))
					looking_at = locate(S.x, S.y, lower_layer(S.z))
					eye = looking_at
			else
				looking_from = locate(mob.x, mob.y, lower_layer(mob.z))
				looking_range = (mob.z - start_z) * 5
				looking_at = locate(S.x, S.y, lower_layer(S.z))
				eye = looking_at
				mob.movable = 1
				perspective = EYE_PERSPECTIVE
			check_layer()
		look_up()
			var/turf/T
			if(looking_at)
				T = looking_at
			if(!T)
				return
			if(next_layer(T.z) == mob.z)
				perspective = MOB_PERSPECTIVE
				looking_from = null
				looking_range = 0
				looking_at = null
				eye = mob
				mob.movable = 0
			else
				looking_from = locate(looking_from.x, looking_from.y, next_layer(looking_from.z))
				looking_at = locate(T.x, T.y, next_layer(T.z))
				eye = looking_at
			check_layer()


	North()
		if(looking_from)
			var/turf/new_turf = get_step(looking_at, NORTH)
			if((new_turf in range(looking_range, looking_from)) && !new_turf.opaque())
				looking_at = new_turf
				eye = looking_at
			looking_at.update_sky()
		else
			..()
		check_layer()
	West()
		if(looking_from)
			var/turf/new_turf = get_step(looking_at, WEST)
			if((new_turf in range(looking_range, looking_from)) && !new_turf.opaque())
				looking_at = new_turf
				eye = looking_at
			looking_at.update_sky()
		else
			..()
		check_layer()
		mob.update_sky()
	East()
		if(looking_from)
			var/turf/new_turf = get_step(looking_at, EAST)
			if((new_turf in range(looking_range, looking_from)) && !new_turf.opaque())
				looking_at = new_turf
				eye = looking_at
			looking_at.update_sky()
		else
			..()
		check_layer()
		mob.update_sky()
	South()
		if(looking_from)
			var/turf/new_turf = get_step(looking_at, SOUTH)
			if((new_turf in range(looking_range, looking_from)) && !new_turf.opaque())
				looking_at = new_turf
				eye = looking_at
			looking_at.update_sky()
		else
			..()
		check_layer()
		mob.update_sky()*/