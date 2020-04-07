projectile
	parent_type = /obj
	animate_movement = NO_STEPS
	density = 1
	var
		show_angle=1
		mob/owner
		atom/target
		speed = 32
		range = 8
		same_turf = 1
		delay = 1
		turf/initial_loc
	New(mob/owner,atom/target)
		src.owner = owner
		src.target = target
		if(!owner || !target) del src
		src.loc = owner.loc
		src.initial_loc = src.loc
		if(isnum(target))
			if(owner.dir == NORTH) src.target += 90
			else if(owner.dir == SOUTH) src.target -= 90
			else if(owner.dir == WEST) src.target += 180
			spawn Loop(src.target)
		else spawn Loop()
	Bump(atom/A) return
	Move(turf/newloc,newdir,forced=0)
		if(newloc == loc || !newloc) return

		. = ..()

		for(var/atom/movable/A in newloc)
			if(A != src && A.density) Hit(A)
		if(loc != newloc) Hit(newloc)

		same_turf = 0
	proc
		Hit(atom/A)
		Loop(override_angle)
			if(!isnum(target) && !isturf(target)) target = get_turf(target)
			if(!target) del src
			var
				angle = override_angle ? override_angle : angle(src,target)
				_x = isnum(target) ? (cos(angle) * 8) : (target.x - owner.x) * 32 + (target.pixel_x - owner.pixel_x)
				_y = isnum(target) ? (sin(angle) * 8) : (target.y - owner.y) * 32 + (target.pixel_y - owner.pixel_y)
				px_dist = sqrt((_x * _x) + (_y * _y))
				dx = (_x * speed) / px_dist
				dy = (_y * speed) / px_dist

				cx = 16
				cy = 16

				ox = 16
				oy = 16
			if(angle && show_angle) icon = turn(icon,angle)
			while(target)
				cx += dx
				while(cx >= 32)
					cx -= 32
					var/turf/T = locate(x+1,y,z)
					if(!T) del src
					Move(T)
				while(cx <= 0)
					cx += 32
					var/turf/T = locate(x-1,y,z)
					if(!T) del src
					Move(T)
				pixel_x = cx - ox

				cy += dy
				while(cy >= 32)
					cy -= 32
					var/turf/T = locate(x,y+1,z)
					if(!T) del src
					Move(T)
				while(cy <= 0)
					cy += 32
					var/turf/T = locate(x,y-1,z)
					if(!T) del src
					Move(T)
				pixel_y = cy - oy

				if(--range <= 0) del src
				sleep(delay)
	arrow
		icon = 'icons/Arrow.dmi'
		Hit(atom/movable/A)
			var/mob/M = A
			if(istype(M))
				if(istype(M, /animal)) M.ActionLock("aggressive", 100)

				var
					dist = get_dist(initial_loc, loc)
					restdmg
				if(dist <= 3) restdmg = 7
				else if(dist <= 6) restdmg = 6
				else if(dist <= 10) restdmg = 5
				else restdmg = 4
				restdmg = (restdmg - M.defence) * 3
				if(restdmg >= 1)
					if(M.spell_shield && (get_dir(M, src) & M.dir))
						M.spell_shield.SLEEP -= (restdmg / 1.5)
						hud_main.UpdateHUD(M.spell_shield)
						if(M.spell_shield.SLEEP <= 0)
							M.spell_shield.SLEEP = 0
							M.spell_shield.toggle_sleep(1)
					else
						M.HP -= restdmg
						M.last_hurt = "arrow"
						hud_main.UpdateHUD(M)
						M.checkdead(M)
			del src
	bullet
		icon = 'icons/Bullet.dmi'
		Hit(atom/movable/A)
			var/mob/M = A
			if(istype(M))
				if(istype(M, /animal)) M.ActionLock("aggressive", 100)

				var
					dist = get_dist(initial_loc, loc)
					restdmg
				if(dist <= 3) restdmg = 32
				else if(dist <= 6) restdmg = 24
				else if(dist <= 10) restdmg = 14
				else restdmg = 9
				restdmg = (restdmg - M.defence) * 3
				if(restdmg >= 1)
					if(M.spell_shield && (get_dir(M, src) & M.dir))
						M.spell_shield.SLEEP -= (restdmg / 1.5)
						hud_main.UpdateHUD(M.spell_shield)
						if(M.spell_shield.SLEEP <= 0)
							M.spell_shield.SLEEP = 0
							M.spell_shield.toggle_sleep(1)
					else
						M.HP -= restdmg
						M.last_hurt = "bullet"
						hud_main.UpdateHUD(M)
						M.checkdead(M)
			else
				play_sound(usr, hearers(16, A), sound(file='sounds/ric3.ogg'))
			del src
	minigun_bullet
		icon = 'icons/Bullet.dmi'
		var/crit = 0
		New(mob/owner, mob/target, crit = 0)
			. = ..()
			src.crit = crit
		Hit(atom/movable/A)
			var/mob/M = A
			if(istype(M))
				if(istype(M, /animal)) M.ActionLock("aggressive", 100)

				var
					dist = get_dist(initial_loc, loc)
					restdmg
				if(crit)
					if(dist <= 3) restdmg = 32
					else if(dist <= 6) restdmg = 24
					else if(dist <= 10) restdmg = 14
					else restdmg = 9
				else
					if(dist <= 3) restdmg = 24
					else if(dist <= 6) restdmg = 14
					else if(dist <= 10) restdmg = 9
					else restdmg = 4
				restdmg = (restdmg - M.defence) * 3
				if(restdmg >= 1)
					if(M.spell_shield && (get_dir(M, src) & M.dir))
						M.spell_shield.SLEEP -= (restdmg / 1.5)
						hud_main.UpdateHUD(M.spell_shield)
						if(M.spell_shield.SLEEP <= 0)
							M.spell_shield.SLEEP = 0
							M.spell_shield.toggle_sleep(1)
					else
						M.HP -= restdmg
						M.last_hurt = "bullet"
						hud_main.UpdateHUD(M)
						M.checkdead(M)
			del src