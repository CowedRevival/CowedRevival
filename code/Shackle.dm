obj/shackle_ball
	name = "ball"
	icon = 'icons/Leg_Shackle.dmi'
	icon_state = "ball"
	anchored = 0
	density = 1
	var
		mob/shackled_person
	Move(newloc, newdir, forced = 0)
		var/turf/old_loc = loc
		. = ..()
		if(old_loc.z != loc.z)
			shackled_person.Move(src.loc, forced = 1)
			if(prob(20)) shackled_person.weakened = max(shackled_person.weakened, 3)
		else
			if(get_dist(shackled_person, src) > 3)
				step_to(shackled_person, src)
				if(get_dist(shackled_person, src) > 3)
					if(get_dist(shackled_person, old_loc) > 3) //uh-oh!
						var
							dir = get_dir(src, shackled_person)
							turf/T = get_step(src, dir)
						for(var/i = 1 to 3) T = get_step(T, dir)
						if(T)
							shackled_person.Move(T, forced = 1)
						else
							shackled_person.Move(old_loc, forced = 1)
					else
						src.Move(old_loc, forced = 1)
						for(var/mob/M in range(1, src)) if(M.whopull == src) M.whopull = null
			if(prob(40)) shackled_person.weakened = max(shackled_person.weakened, 3)
		shackled_person.update_chains()


obj/chain
	anchored = 1
	var
		obj/chain
			behind
			front


		obj/front_overlay
		obj/behind_overlay
		front_state
		back_state

	animate_movement = 0

	New()
		..()
		var/icon/O = icon('icons/Leg_Shackle.dmi', "N")
		front_overlay = O
		overlays += O
		O = icon('icons/Leg_Shackle.dmi', "N")
		behind_overlay = O
		overlays += O

	proc
		follow(atom/A)
			if(!(src in orange(1,A)))
				src.Move(get_step_towards(src,A), forced = 1)
				var/obj/chain/C = behind
				if(istype(C))
					C.follow(src)
				else
					move_back()
			update_icon()

		move_back()
			if(!(src in orange(1,behind)))
				src.Move(get_step_towards(src,behind), forced = 1)
				if(istype(front, /obj/chain))
					front.move_back()
				else if(istype(front, /mob))
					var/mob/M = front
					M.line_chains()
			update_icon()


		update_icon()
			var/d = get_dir(src, front)
			var/s = get_icon_state(d)
			if(s)
				if(s!=front_state)
					front_state = s
					overlays -= front_overlay
					front_overlay = icon('icons/Leg_Shackle.dmi', s)
					overlays += front_overlay
			d = get_dir(src, behind)
			s = get_icon_state(d)
			if(s)
				if(s!=back_state)
					back_state = s
					overlays -= behind_overlay
					behind_overlay = icon('icons/Leg_Shackle.dmi', s)
					overlays += behind_overlay

		get_icon_state(d)
			if(d == NORTH)
				return "N"
			if(d == SOUTH)
				return "S"
			if(d == WEST)
				return "W"
			if(d == EAST)
				return "E"
			if(d == NORTHWEST)
				return "NW"
			if(d == NORTHEAST)
				return "NE"
			if(d == SOUTHWEST)
				return "SW"
			if(d == SOUTHEAST)
				return "SE"

			return 0


mob
	var/obj/shackle_ball/shackle_ball
	var/obj/chain/chain
	var/list/chains = new

	proc/shackle_ball()
		var/mob/M = src
		var/obj/shackle_ball/S = new(M.loc)
		S.shackled_person = M
		M.shackle_ball = S
		var/obj/chain/C = new(M.loc)
		chain = C
		chains += C
		C.front = M
		C.behind = new/obj/chain(M.loc)
		C.behind.front = C
		C = C.behind
		chains += C
		C.behind = S

		M.verbs+=/mob/proc/unlock

	proc/update_chains()
		if(get_dist(src, shackle_ball) == 3)
			line_chains()
		else
			chain.follow(src)

	proc/line_chains()
		var/turf/T = loc
		var/n = 0
		while(T!=shackle_ball.loc)
			var/map_object/O = MapObject(shackle_ball.z)
			if(O)
				T = locate(T.x, T.y, O.z)
			/*if(istype(T, /turf/hole))
				T = locate(T.x, T.y, undergroundz)
			else if(istype(T, /turf/stairs) || locate(/obj/stairs, T))
				if(T.z == undergroundz) T = locate(T.x, T.y, worldz)
				else if(T.z == worldz) T = locate(T.x, T.y, skyz)
				else if(T.z == skyz) T = locate(T.x, T.y, start_z)
				else if(T.z > start_z) T = locate(T.x, T.y, T.z + 1)*/
			else
				T = get_step_towards(T,shackle_ball)

			if(T == shackle_ball.loc)
				break
			n++
			if(chains && chains.len >= n)
				var/obj/chain/C = chains[n]
				C.Move(T, forced = 1)
			else break
		for(var/obj/chain/C in chains)
			C.update_icon()

	proc/unlock()
		set src in oview(1)
		del shackle_ball
		new/item/misc/shackle_ball(usr)
		for(var/obj/chain/C in chains)
			del C
		verbs-=/mob/proc/unlock