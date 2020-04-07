obj/drawbridge
	icon = 'icons/Turfs.dmi'
	anchored = 1
	var
		id
	drawbridge
		icon = 'icons/Turfs.dmi'
		top
			animate_movement = SYNC_STEPS
			pixel_step_size = 3
			var
				list/bridge_objs
				bridge_icon_state
				operating = 0
			proc
				extend()
					if(operating || bridge_objs) return
					operating = 1
					spawn
						bridge_objs = new/list()
						var/turf/T = get_step(src, SOUTH)
						while(T && istype(T, /turf/water))
							var/obj/drawbridge/drawbridge/O = new(src.loc)
							O.icon_state = "[icon_state]p"
							bridge_objs += O
							step(src, SOUTH)
							sleep(2)
							T = get_step(src, SOUTH)
						operating = 0
				retract()
					if(operating || !bridge_objs) return
					operating = 1
					spawn
						for(var/i = bridge_objs.len, i >= 1, i--)
							var/obj/drawbridge/drawbridge/O = bridge_objs[i]
							step(src, NORTH)
							sleep(1)
							if(i == 1) sleep(10)
							if(O) O.Move(null, forced = 1)
						bridge_objs = null
						operating = 0
			left
				icon_state = "bridge-l"
				animate_movement = FORWARD_STEPS
			middle
				icon_state = "bridge-m"
			right
				icon_state = "bridge-r"
			Move(turf/newloc, newdir, forced = 0)
				var/turf/oldloc = src.loc
				. = ..()
				if(loc != oldloc)
					for(var/atom/movable/A in oldloc)
						if(istype(A, /obj/drawbridge/drawbridge)) continue
						A.Move(src.loc, forced = 1)
	lever
		icon = 'icons/Turfs.dmi'
		icon_state = "lever0"
		attack_hand(mob/M)
			for(var/obj/drawbridge/drawbridge/top/O in world)
				if(O.z != src.z && O.z != undergroundz && O.z != worldz && O.z != skyz) continue
				if(O.operating) return

			src.icon_state = src.icon_state == "lever0" ? "lever1" : "lever0"
			for(var/obj/drawbridge/lever/O in world)
				if(O.z != src.z && O.z != undergroundz && O.z != worldz && O.z != skyz) continue
				if(O.id == src.id && O != src) O.icon_state = src.icon_state

			for(var/obj/drawbridge/drawbridge/top/O in world)
				if(O.z != src.z && O.z != undergroundz && O.z != worldz && O.z != skyz) continue
				if(O.id == src.id) icon_state == "lever1" ? O.extend() : O.retract()