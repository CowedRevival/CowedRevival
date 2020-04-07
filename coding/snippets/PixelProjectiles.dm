//modified version!
proc/FirePixelProjectile(atom/owner, destination, proj_type = /projectile)
	if(!owner) return
	var/projectile/P = new proj_type()
	P.owner = owner
	P.loc = P.TurfOf(owner)
	P.pixel_x = P.cx
	P.pixel_y = P.cy

	if(isnum(destination)) //angle
		P.dx = cos(destination) * P.speed
		P.dy = sin(destination) * P.speed
		if(P.show_angle) P.icon = turn(P.icon, destination)
	else if(istype(destination, /atom))
		var
			atom/A = destination
			dx = (A.x - P.x) * 32 + A.pixel_x - P.cx
			dy = (A.y - P.y) * 32 + A.pixel_y - P.cy
			px_dist = sqrt(dx * dx + dy * dy)
		world << {"Ordered to move to [A].
		Formula: dx = (A.x - P.x) * 32 + A.pixel_x - P.cx
		[A.x] - [P.x] = [A.x-P.x]
		([A.x-P.x]) * 32 = [(A.x-P.x)*32]
		[A.pixel_x] - [P.cx] = [A.pixel_x-P.cx]
		[A.x-P.x*32] + [A.pixel_x-P.cx] = [dx]

		Formula: dy = (A.y - P.y) * 32 + A.pixel_y - P.cy
		[A.y] - [P.y] = [A.y-P.y]
		([A.y-P.y]) * 32 = [(A.y-P.y)*32]
		[A.pixel_y] - [P.cy] = [A.pixel_y-P.cy]
		[(A.y-P.y)*32] + [A.pixel_y-P.cy] = [dy]

		px_dist = [px_dist]

		P.dx = [P.speed * dx / px_dist]
		P.dy = [P.speed * dy / px_dist]"}
		if(P.show_angle) P.icon = turn(P.icon, angle(P,A))
		if(px_dist) // unit vector times P.speed
			P.dx = P.speed * dx / px_dist
			P.dy = P.speed * dy / px_dist
		else	// owner and target in exact same position
			P.Hit(A)
			return P

	else
		world.log << "Invalid destination: FirePixelProjectile([owner], [destination], \
			[proj_type])"
		del(P)
		return

	if(P)
		spawn(P.delay)	// so this proc can return normally
			while(P)
				P.UpdatePosition()
				//if(P && (alert("[P.x]:[P.cx], [P.y]:[P.cy]",,"Ok", "Delete")=="Delete"))
				//	del(P)
				if(P) sleep(P.delay)

	return P

proc/FireSpread(atom/owner, destination, proj_type = \
	/projectile, pellets = 1, spread = 0)
	var/base_angle
	if(isnum(destination))
		base_angle = destination
	else if(istype(destination,/atom))
		var
			atom/A = destination
			dx = (A.x - owner.x) * 32 + A.pixel_x - owner.pixel_x
			dy = (A.y - owner.y) * 32 + A.pixel_y - owner.pixel_y

		// Arctan courtesy of Lummox JR
		if(!dx && !dy) base_angle = 0    // the only special case
		else
			var/a=arccos(dx/sqrt(dx*dx+dy*dy))
			base_angle = (dy>=0)?(a):(-a)

	if(spread<=0)	// random spread
		for(var/loop = 1 to pellets)
			FirePixelProjectile(owner, base_angle + rand(spread, -spread), proj_type)
	else if(pellets>1)	// uniform spread
		var/d_angle = spread*2/(pellets-1)
		base_angle -= spread
		for(var/loop = 0 to pellets - 1)
			FirePixelProjectile(owner, base_angle + loop * d_angle, proj_type)
	else
		FirePixelProjectile(owner, base_angle, proj_type)

projectile
	parent_type = /obj
	layer = FLY_LAYER
	animate_movement = NO_STEPS
	density=1
	var/tmp
		show_angle = 1
		range = 7	// number of cycles this projectile will fly
		speed = 32	// px per update cycle
		delay = 1	// ticks between updates
		cx = 0	// starting/current pixel_x
		cy = 0	// starting/current pixel_y

		////////////////////////////////////////////////////////
		// INTERNAL VARS: You shouldn't mess with the vars below
		////////////////////////////////////////////////////////
		dx	// change in cx per update cycle (derived from speed)
		dy	// change in cy per update cycle (derived from speed)
		owner	// who/what the projectile belongs to
		same_turf = 1	// cleared when proj leaves start turf

	Read()
		// somehow ended up saved to a file. delete it
		. = ..()
		spawn(2) del(src)
	Bump(atom/A) return Hit(A)

	proc
		CheckHit(turf/T)
			if(T == loc) T.Exit(src)
			else T.Enter(src)
		dist(atom/A)
			// returns the square of the pixel distance between src and A
			if(!istype(A)) return 0
			var/sx = (A.x - x) * 32 + A.pixel_x - pixel_x
			var/sy = (A.y - y) * 32 + A.pixel_y - pixel_y
			return sx * sx + sy * sy

		Hit(atom/A)
			// the projectile just hit A
			// Override to fit into your program
			world << "[owner]'s [src] hit [A] at ([A.x], [A.y])."

			// Hit() should ALWAYS end with the following line:
			//del(src)

		Intercept()
			/* checks the path between current postion and new
				position
				RETURNS: the first dense blockage encountered or
					null */
			world << "Intercepting..."
			var
				n; d
				mx; my	// overall change
				sx; sy	// change per step
				offset
				turf/T
				atom
					N; M	// atoms encountered
			mx = dx / 32
			my = dy / 32

			world << "dx = [dx]; dy = [dy]\nmx = [mx]"
			if(mx && round(mx)==mx)
				sx = sgn(mx)
				sy = my/mx * sx
				n = 0
				d = abs(mx)
				offset = pixel_y/32
				while(!N && (++n <= d))
					T = locate(round(x + sx * n), \
						round(y + offset + sy * n), z)
					//world << "mx [mx] #[n]: x = [round(x + sx * n)], y = [round(y + offset + sy * n)], z = [z]"
					if(!T) break
					N = CheckHit(T)

			if(N)
				d = dist(N)
			else
				d = abs(my)

			world << "my = [my]"
			if(my && round(my)==my)
				sy = sgn(my)
				sx = mx/my * sy
				n = 0
				offset = pixel_x/32
				while(!M && (++n <= d))
					T = locate(round(x + offset + sx * n), \
						round(y + sy * n), z)
					//world << "my [my] #[n]: x = [round(x + sx * n)], y = [round(y + offset + sy * n)], z = [z]"
					if(!T) break
					M = CheckHit(T)

			// return the closest of the two
			if(!M || N && (dist(N) < dist(M)))
				return N
			else
				return M

		sgn(n)
			if(n<0) return -1
			else if(n>0) return 1
			return 0

		Terminate()
			/* overide if you want the missile to do something
				if it reaches range without hitting something */
			del(src)

		TurfOf(atom/A)
			if(istype(A)) return locate(A.x, A.y, A.z)

		UpdatePosition()
			if(isturf(loc)) // in case anything new is in T
				var/H = CheckHit(loc)
				if(H) Hit(H)
			var/atom/A = Intercept()
			if(A) Hit(A)

			cx += dx
			while(cx >= 32)
				same_turf = 0
				cx -= 32
				if(++x > world.maxx)
					del(src)
			while(cx < 0)
				same_turf = 0
				cx += 32
				if(--x < 1)
					del(src)
			pixel_x = cx

			cy += dy
			while(cy >= 32)
				same_turf = 0
				cy -= 32
				if(++y > world.maxy)
					del(src)
			while(cy < 0)
				same_turf = 0
				cy += 32
				if(--y < 1)
					del(src)
			pixel_y = cy

			if(--range<=0)
				Terminate()