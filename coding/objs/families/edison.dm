obj/family/edison
	icon = 'icons/families/edison.dmi'
	grandfather_clock
		icon = 'icons/families/edison_clock.dmi'
		layer = FLY_LAYER
		density = 1
		anchored = 1
		var
			locked = 0
			keyslot = "family_edison"
		Bumped(atom/movable/A)
			if(icon_state == "open")
				var/turf/T = locate(x, y, z - 1)
				if(!istype(T, /turf/stairs) && !istype(T, /turf/path) && !istype(T, /turf/underground/dirtwall) && !(locate(/obj/stairs, T)))
					A << "<tt>This area is too hard to get through.</tt>"
					return
				var/mob/M = A
				if(istype(M))
					M.lastHole = src
					spawn(100) if(M && M.lastHole == src) M.lastHole = null
				A.Move(T, forced = 1)
		attack_hand(mob/M)
			if(locked)
				M.show_message("<tt>The door won't budge!</tt>")
				return
			icon_state = icon_state == "open" ? "" : "open"
			overlays = list()
			if(icon_state == "open")
				overlays += image(icon = 'icons/families/edison_clock.dmi', icon_state = "open-overlay", pixel_x = 32)
	chronojohn
		icon = 'icons/families/edison_chronojohn.dmi'
		icon_state = "door"
		layer = FLY_LAYER
		density = 1
		anchored = 1
		pixel_y = -8
		var
			operating = 0
			active = 0
			obj/family/edison/central_unit/master
			turf
				dest
				old_loc
		New()
			. = ..()
			spawn UpdateIcon()
		Bumped(mob/M)
			var/turf/loc = src.loc
			if(!istype(M) || !istype(loc) || !loc.empty(src)) return
			if(M.dir == NORTH && icon_state != "door")
				M.pixel_y = 8
				M.Move(loc, forced = 1)
			else return
		objExit(atom/movable/A)
			if(icon_state == "door" || A.dir != SOUTH || operating) return 0
			if(ismob(A)) A.pixel_y = 0
			return 1
		attack_hand(mob/M)
			if(active || operating) return
			icon_state = icon_state == "door" ? "" : "door"
			UpdateIcon()
		hear(mob/M, msg)
			. = ..()
			if(istype(M) && master)
				var/list/mobs = new/list()
				for(var/obj/family/edison/chronojohn/O in list(master.unit1, master.unit2, master.unit3))
					if(O == src || (O in range(src))) continue
					for(var/mob/N in range(O))
						if(!(N in mobs)) mobs += N
				for(var/mob/N in mobs)
					N.show_message(msg)
		proc
			UpdateIcon()
				overlays = list()
				if(icon_state == "")
					overlays += image(icon = 'icons/families/edison_chronojohn.dmi', icon_state = "overlay", layer = OBJ_LAYER)
			Activate()
				if(active || operating) return
				old_loc = src.loc
				icon_state = "door"
				operating = 1
				active = 1
				overlays = list()
				for(var/mob/M in range(10, src))
					M.PlaySound(sound('sounds/chronojohn/teleport.ogg', repeat = 0, wait = 0, channel = 88))
				spawn(40)
					icon_state = "rotating"
				spawn(82)
					icon_state = "blank"
					for(var/mob/M in src.loc)
						if(istype(M, /mob/eavesdropper) || istype(M, /mob/observer)) continue
						M.invisibility = 99
						M.Move(src, forced = 1)
					flick("warp", src)
				spawn(120)
					operating = 0
					icon_state = "door"
					src.Move(null, forced = 1)
					for(var/mob/M in src) M.invisibility = 0
					spawn(rand(100, 200))
						if(active)
							var/turf/T = dest ? dest : initial(loc)
							dest = old_loc
							Drop(T)
			Drop(turf/destination = src.dest)
				if(!active || operating) return
				operating = 1
				src.Move(destination, forced = 1)
				world << sound(null, channel = 88)
				for(var/mob/M in src) M.Move(src.loc, forced = 1)
				for(var/mob/M in range(10, src))
					M.PlaySound(sound('sounds/chronojohn/timemachine_land.ogg', repeat = 0, wait = 0, channel = 88))
				spawn(25)
					active = 0
					operating = 0
		verb
			set_destination(var/x as num, var/y as num, var/z as num)
				set name = "Set Destination"
				set src in view(usr, 0)
				set category = null
				if(x == 0 && y == 0 && z == 0) dest = initial(loc)
				dest = locate(x, y, z)
			activate()
				set name = "Activate"
				set src in view(usr, 0)
				set category = null
				if(!master || master.icon_state != "on" || !master.orb)
					usr << "<tt>The device is not properly connected to the central unit or the central unit is not active!</tt>"
					return
				if(!dest)
					usr << "<tt>Invalid destination coordinates supplied!</tt>"
					return
				Activate()
	central_unit
		icon = 'icons/families/edison_centralunit.dmi'
		density = 1
		anchored = 1
		pixel_y = -16
		layer = TURF_LAYER
		var
			item/misc/orbs/orb
			obj/family/edison/chronojohn
				unit1
				unit2
				unit3
		New()
			. = ..()
			UpdateIcon()
			spawn
				unit1 = locate(/obj/family/edison/chronojohn) in locate(x, y - 5, z)
				unit2 = locate(/obj/family/edison/chronojohn) in locate(x + 2, y - 5, z)
				unit3 = locate(/obj/family/edison/chronojohn) in locate(x + 4, y - 5, z)

				if(unit1)
					unit1.name = "Chron-ó-John (Unit #1)"
					unit1.master = src
				if(unit2)
					unit2.name = "Chron-ó-John (Unit #2)"
					unit2.master = src
				if(unit3)
					unit3.name = "Chron-ó-John (Unit #3)"
					unit3.master = src
		proc
			UpdateIcon()
				overlays = list()
				if(orb)
					overlays += image(icon = 'icons/families/edison_centralunit.dmi', icon_state = "orb-[orb.icon_state]")
			SoundLoop()
				play_sound(src, hearers(src), sound('sounds/chronojohn/electricity.ogg', channel = 667, volume = 50))
				spawn(10)
					play_sound(src, hearers(src), sound('sounds/chronojohn/timecar_activating.ogg', channel = 667, volume = 50))
				spawn(20)
					var/list/mobs = list()
					while(icon_state == "on")
						var/snd = 'sounds/chronojohn/timecar_active.ogg'

						var/list/L = hearers(loc)
						for(var/mob/M in L)
							if(!M.key) continue
							if(M.key && !M.client)
								mobs -= M
								continue
							if(mobs[M] == snd) continue
							mobs[M] = snd
							M << sound(file = snd, repeat = 1, channel = 667, volume = 50)
						for(var/mob/M in mobs - L)
							mobs -= M
							M << sound(null, channel = 667)

						sleep(5)
					for(var/mob/M in mobs) M << sound(null, channel = 667)
		attack_hand(mob/M)
			if(ActionLock("toggle", 40)) return
			if(icon_state == "on")
				for(var/obj/family/edison/chronojohn/O in list(unit1, unit2, unit3))
					if(O.operating)
						M.show_message("<tt>The lever won't budge!</tt>")
						return

				play_sound(src, hearers(src), sound('sounds/chronojohn/lever.wav'))

				for(var/obj/family/edison/chronojohn/O in list(unit1, unit2, unit3)) spawn(30)
					if(O.active)
						var/turf/T = O.dest
						if(!T || prob(40)) T = locate(rand(44, 206), locate(43, 195), worldz)
						if(prob(10)) T = initial(O.loc)
						O.Drop(T)

				icon_state = ""
			else
				play_sound(src, hearers(src), sound('sounds/chronojohn/lever.wav'))
				icon_state = "on"
				if(orb)
					spawn(15)
						SoundLoop()
		MouseDropped(item/misc/orbs/I)
			if(istype(I) && !orb &&  (usr in range(1, src)) && !usr.restrained() && (I in usr.contents))
				I.Move(src, forced = 1)
				I.dropped(usr)
				orb = I
				UpdateIcon()
				return 1
			else return ..()
		verb
			remove_orb()
				set name = "Remove Orb"
				set src in view(usr, 1)
				if(icon_state == "on")
					usr << "<tt>You can't remove the orb while the device is on!</tt>"
					return
				if(orb)
					orb.Move(src.loc, forced = 1)
					orb = null
					UpdateIcon()
			set_destination(var/obj/family/edison/chronojohn/O in list(unit1, unit2, unit3), var/x as num, var/y as num, var/z as num)
				set name = "Set Destination"
				set src in view(usr, 1)
				set category = null
				O.set_destination(x, y, z)
			activate(var/obj/family/edison/chronojohn/O in list(unit1, unit2, unit3))
				set name = "Activate"
				set src in view(usr, 1)
				set category = null
				O.activate()
			where_is(var/obj/family/edison/chronojohn/O in list(unit1, unit2, unit3))
				set name = "Where Is"
				set src in view(usr, 1)
				set category = null
				usr << "[O]'s location: [O.x], [O.y], [O.z]"
	platform
		icon_state = "platform"
		pixel_y = 4
		anchored = 1
		layer = TURF_LAYER
	pipes
		icon = 'icons/families/edison_pipes.dmi'
		pixel_x = 15
		pixel_y = -16
		anchored = 1
		layer = TURF_LAYER
	safe
		name = "Safe"
		icon_state = "safe0"
		density = 1
		anchored = 1
		var
			combination = "7bd2c22f4a99c387afd22fcb474018da" //1311
		New()
			. = ..()
			spawn
				for(var/item/I in src.loc)
					I.Move(src, forced = 1)
		attack_hand(mob/M)
			if(icon_state == "safe1")
				icon_state = "safe0"
				for(var/item/I in src.loc)
					I.Move(src, forced = 1)
			else
				var/combination = input(usr, "Specify the 4-digit combination to this safe.", "Input Combination") as null|num
				if(md5("[combination][MD5_KEY]") == src.combination)
					icon_state = "safe1"
					for(var/item/I in src)
						I.Move(src.loc, forced = 1)
	radiation_panel
		icon_state = "radiation3"
		anchored = 1
		var
			area/radiation/area
		New()
			. = ..()
			spawn
				area = locate(area)
				UpdateIcon()
		attack_hand(mob/M)
			var/n = input(M, "Specify the setting: \[0-5\]", "Radiation Panel") as null|num
			if(n == null) return
			n = min(5, max(0, n))
			area.level = n
			UpdateIcon()
		proc
			UpdateIcon()
				if(area) icon_state = "radiation[area.level]"
	camera
		anchored = 1
		var/network
		camera
			icon_state = "camera"
			var
				c_tag
		viewer
			icon_state = "camera-laptop"
			attack_hand(mob/M)
				var/list/L = new/list()
				for(var/obj/family/edison/camera/camera/O in world)
					if((O.z == undergroundz || O.z == worldz || O.z == skyz) && O.network == src.network)
						L[O.c_tag] = O
				while(M in range(1, src))
					var/obj/family/edison/camera/camera/O = input(M, "Select a camera to view.", "Camera") as null|anything in L
					if(O == null)
						break
					O = L[O]
					if(istype(O))
						if(M && M.client)
							M.client.perspective = EYE_PERSPECTIVE
							M.client.eye = O
							continue
					break
				if(M && M.client)
					M.client.perspective = MOB_PERSPECTIVE
					M.client.eye = M
	transmitter
		icon = 'icons/families/edison_transmitter.dmi'
		icon_state = "cover"
		density = 0
		var
			obj
				A
				B
				C
		New()
			. = ..()
			spawn
				A = new/obj
				B = new/obj
				C = new/obj
				RelocateObjs()
		proc
			RelocateObjs()
				A.Move(get_step(src, NORTH), forced = 1)
				B.Move(get_step(src, NORTHEAST), forced = 1)
				C.Move(get_step(src, EAST), forced = 1)
			SetDensity(val)
				src.density = val
				A.density = src.density
				B.density = src.density
				C.density = src.density
		Move()
			. = ..()
			if(.) RelocateObjs()
		attack_hand(mob/M)
			if(!(M.ckey in developers)) return
			spawn
				var/sound/S = sound('sounds/wgenerator.ogg')
				for(var/mob/N in range(15, src)) spawn N.PlaySound(S)
			spawn(80)
				icon_state = "idle"
				flick("opening", src)
				SetDensity(1)
			spawn(170)
				icon_state = "delay5"
			spawn(300)
				icon_state = "delay4"
			spawn(330)
				icon_state = "delay3"
			spawn(350)
				icon_state = "delay2"
			spawn(380)
				icon_state = "delay1"
			spawn(415)
				icon_state = "idle"
			spawn(442)
				SetDensity(0)
				for(var/mob/N in range(2, src))
					N.HP = 0
					N.checkdead(N)
				src.Move(null, forced = 1)