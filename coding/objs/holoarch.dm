obj/holoarch
	density = 1
	opacity = 1
	anchored = 1
	holoarch
		name = "arch"
		icon = 'icons/holoarch.dmi'
		icon_state = "blank"
		layer = FLY_LAYER
		var
			door //null = no door, 0 = closed, 1 = open
			dooroverride = 1
			obj/holoarch
				door/hdoor
				block
			operating = 0
		New(loc, door = 2)
			. = ..()
			spawn
				play_sound(src, hearers(src), sound('sounds/computer/e-docbeam.ogg'))
				block = new(locate(x + 2, y, z))

				if(door != 2) dooroverride = 0
				if(door)
					hdoor = new(locate(x + 1, y, z))
					src.door = 0
					icon_state = "-door"
					hdoor.icon_state = "-door"
					flick("create-door", src)
					flick("create-door", hdoor)
					if(door == 1)
						spawn(25)
							src.underlays += image(icon = 'icons/Turfs.dmi', icon_state = "holofloor", pixel_x = 32, layer = OBJ_LAYER + 0.1)
							src.underlays += image(icon = 'icons/Turfs.dmi', icon_state = "holofloor", pixel_x = 64, layer = OBJ_LAYER + 0.1)
							opendoor()
				else
					icon_state = ""
					flick("create", src)
		Del()
			if(block) del block
			if(hdoor) del hdoor
			return ..()
		proc
			Destroy()
				play_sound(src, hearers(src), sound('sounds/computer/e-docout.ogg'))
				icon_state = "blank"
				flick("destroy[hdoor ? "-door":]", src)
				spawn(7) del src
			opendoor()
				if(operating || door == null || door == 1) return
				door = 1
				operating = 1
				hdoor.icon_state = "-door-open"
				flick("-door-opening", hdoor)
				play_sound(src, range(src), sound('sounds/holoopen.ogg'))
				hdoor.sd_SetOpacity(computer.holodeck && !dooroverride ? 1 : 0)
				sleep(12)
				hdoor.density = computer.holodeck && !dooroverride ? 1 : 0
				operating = 0
			closedoor()
				if(operating || !door) return
				door = 0
				operating = 1
				hdoor.icon_state = "-door"
				flick("-door-closing", hdoor)
				play_sound(src, range(src), sound('sounds/holoopen.ogg'))
				hdoor.density = 1
				sleep(12)
				hdoor.sd_SetOpacity(1)
				operating = 0
		Click(location, control, params)
			if(!usr || !usr.client || !usr.client.admin) return
			params = params2list(params)
			if(params["ctrl"])
				Destroy()
				return
			ActionLock("click", 10)
			if(door == 1) closedoor()
			else opendoor()
	door
		name = ""
		icon = 'icons/holoarch2.dmi'
		pixel_x = -32
		layer = OBJ_LAYER + 0.5
		Bumped(mob/M)
			var/turf/loc = src.loc
			if(!istype(M) || !istype(loc) || !loc.empty(src)) return
			if(icon_state != "-door-open") return
			M.lastHole = src
			spawn(100) if(M && M.lastHole == src) M.lastHole = null
			if(src.z != 1)
				if(M.dir != NORTH) return
				if(M.client && M.client.eye == M)
					M.client.perspective = EYE_PERSPECTIVE
					M.client.eye = src
					spawn(30)
						M.client.perspective = MOB_PERSPECTIVE
						M.client.eye = M
				M.old_loc = M.loc
				M.Move(locate(150, 160, 1), forced = 1)
				if(M.client && !M.client.admin) M.medal_Award("Photonic Trickery")
			else
				if(M.old_loc)
					M.Move(M.old_loc, forced = 1)
				else
					M.Move(locate(98, 120, worldz), forced = 1)
				M.old_loc = null
			if(M.whopull) M.whopull.loc = M.loc