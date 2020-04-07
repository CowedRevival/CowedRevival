npc/school_of_magic
	proc
		Step(dir)
			if(HP <= 0 || corpse) return 100
			if(_c_speed != speed)
				_c_speed = speed
				_speed = (1 / (speed / 100))
			if(ActionLock("moving", _speed)) return _speed

			if(isnum(dir))
				spawn step(src, dir)
			else if(istype(dir, /atom))
				if(get_dist(src, dir) <= 1) spawn step_towards(src, dir)
				else spawn step_to(src, dir, 0)
			return _speed
		Step_Away(mob/M)
			if(HP <= 0 || corpse) return 100
			if(_c_speed != speed)
				_c_speed = speed
				_speed = (1 / (speed / 100))
			if(ActionLock("moving", _speed)) return _speed
			step_away(src, M, 20)
			return _speed
	ghost
		name = "Ghost"
		icon = 'icons/Cow.dmi'
		icon_state = "ghost_b"
		speed = 40
		density = 1
		anchored = 1
		var
			direction
		New()
			. = ..()
			spawn(30) AI()
		attack() return
		checkdead() return
		proc
			AI()
				spawn while(1)
					direction = pick(NORTH, SOUTH, EAST, WEST)
					var
						turf/T = get_step(src, direction)
						area/school_of_magic/ghost_area/A = T ? T.loc : null
					if(istype(A))
						while(direction)
							if(direction == EAST || direction == WEST)
								T = get_step(src, SOUTH)
								if(T && istype(T.loc, /area/school_of_magic/ghost_area) && prob(25))
									direction = SOUTH
									continue

								T = get_step(src, NORTH)
								if(T && istype(T.loc, /area/school_of_magic/ghost_area) && prob(25))
									direction = NORTH
									continue

							sleep(src.Step(direction))
							T = get_step(src, direction)
							A = T ? T.loc : null
							if(!T || !istype(A)) break
					sleep(rand(5, 10))
		Move(turf/newloc, newdir, forced = 0)
			if(forced) return ..()
			var/mob/M = locate() in newloc
			if(M && M.key)
				M.show_message("<tt>The ghost attacks you!</tt>")
				if(++M.tmp_magic_data >= 4)
					M.show_message("<tt>You have failed the test! You lose [M.tmp_magic_points] magic points.</tt>")
					var/turf/school_of_magic/test1/door/T = locate() in world
					if(T) M.Move(locate(T.x, T.y - 1, T.z), SOUTH, forced = 1)
				direction = turn(direction, 180)
				return 0
			loc = newloc
			return 1
		Bumped(mob/M)
			if(istype(M, /mob/observer))
				Move(M.loc, forced = 1)
			else if(M && M.key)
				M.show_message("<tt>The ghost attacks you!</tt>")
				if(++M.tmp_magic_data >= 4)
					M.show_message("<tt>You have failed the test! You lose [M.tmp_magic_points] magic points.</tt>")
					var/turf/school_of_magic/test1/door/T = locate() in world
					if(T) M.Move(locate(T.x, T.y - 1, T.z), SOUTH, forced = 1)
				direction = turn(direction, 180)