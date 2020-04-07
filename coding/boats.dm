boat
	var
		obj/boat/steeringwheel/wheel
		dir = 0
		moving = FALSE
		size = 1
		list/components[0]
	New(turf/loc, size)
		. = ..()
		src.size = size
		var
			centerY = loc.y + size - 1
			turf/center = locate(loc.x, centerY, loc.z)
		wheel = new(center, src)
		for(var/turf/water/T in range(loc, size))
			if(T != center) new/obj/boat/boatfloor(T, src)
		spawn Loop()
	Topic(href, href_list[])
		if(usr.restrained() || usr.issleeping || !(usr in range(1, wheel)))
			if(usr.using == src) usr.using = null
			winshow(usr, "boat_control", 0)
			return
		usr.using = src
		if(href_list["dir"])
			var/dir = text2num(href_list["dir"])
			if(dir & (dir - 1)) return
			src.dir = dir
		else if(href_list["cmd"] == "toggle_moving")
			src.moving = !src.moving
		RefreshWindow(usr)
	proc
		Loop()
			while(1)
				if(moving && dir)
					Move(dir)
				sleep(10)
		RefreshWindow(mob/M)
			if(M.using != src)
				winshow(M, "boat_control", 0)
				return
			var/list/L = list(
				"boat_control.btnNorth.image" = (dir == NORTH ? 'interface/boat_control/north1.png' : 'interface/boat_control/north.png'),
				"boat_control.btnSouth.image" = (dir == SOUTH ? 'interface/boat_control/south1.png' : 'interface/boat_control/south.png'),
				"boat_control.btnEast.image" = (dir == EAST ? 'interface/boat_control/east1.png' : 'interface/boat_control/east.png'),
				"boat_control.btnWest.image" = (dir == WEST ? 'interface/boat_control/west1.png' : 'interface/boat_control/west.png'),
				"boat_control.btnCenter.image" = (!moving ? 'interface/boat_control/anchor1.png' : 'interface/boat_control/anchor.png'),

				"boat_control.btnNorth.command" = "byond://?src=\ref[src];dir=[NORTH]",
				"boat_control.btnSouth.command" = "byond://?src=\ref[src];dir=[SOUTH]",
				"boat_control.btnEast.command" = "byond://?src=\ref[src];dir=[EAST]",
				"boat_control.btnWest.command" = "byond://?src=\ref[src];dir=[WEST]",
				"boat_control.btnCenter.command" = "byond://?src=\ref[src];cmd=toggle_moving"
			)
			winset(M, null, list2params(L))
		Move(dir)
			if(!dir) return
			//verify we can move here
			var/obj/boat/O
			for(O in components)
				var/turf/T = get_step(O.loc, dir)
				if(!istype(T, /turf/water) || T.icon != 'icons/Turfs.dmi' || T.icon_state != "water") break
				var/obj/boat/B = locate() in T
				if(B && B.master != src) break
			if(O)
				moving = FALSE
				for(var/mob/M in range(1, wheel)) if(M.using == src) RefreshWindow(M)
				return

			//we can, so let's allow movement
			var/list/L = new/list()
			for(O in components)
				var/turf/T = get_step(O.loc, dir)
				for(var/atom/movable/A in O.loc)
					if(A in L) continue
					L += A
					A.Move(T, forced = 1)
		Destroy()
			wheel.master = null
			for(var/obj/boat/O in components)
				for(var/obj/wooden/A in O) A.Move(null, forced = 1)
				for(var/obj/stone/A in O) A.Move(null, forced = 1)
				O.Move(null, forced = 1)

obj/boat
	anchored = 1
	density = 0
	layer = OBJ_LAYER - 0.7
	icon = 'icons/boat.dmi'
	var/boat/master
	New(loc, master)
		. = ..()
		src.master = master
		if(src.master) src.master.components += src
	boatfloor
		icon_state = "boat floor"
	boatbr
		icon_state = "boat br"
		density = 1
	boatbl
		icon_state = "bl"
		density = 1
	left
		icon_state = "boat left"
	right
		icon_state = "boat right"
	steeringwheel
		icon_state = "steerwheel"
		density = 1
		attack_hand(mob/M)
			M.using = master
			winshow(M, "boat_control")
			master.RefreshWindow(M)
		Del()
			master.Destroy()
			return ..()
	end1
		icon_state = "end1"
		density = 1
	end2
		icon_state = "end2"
		density = 1
	creator_object
		icon_state = "steerwheel"
		var/size = 1
		New()
			. = ..()
			spawn
				new/boat(src.loc, size)
				del src
turf/water
	verb
		Build_Boat()
			set src in view(1)
			var
				size = input(usr, "What is the size of the boat you'd like to make?", "Build Boat :: Boat Size", 1) as num|null
			if(size == null) return
			size = round(size)
			if(size > 10) size = 10
			if(size <= 0) size = 1

			var
				sizeSide = size
				//steerplace = size - 1
				woodNeeded = size * 30
			var/item/misc/wood/I = locate() in usr.contents
			if(!I || I.stacked < woodNeeded)
				usr.show_message("<tt>You require [woodNeeded] wood to build a boat of this size!")
				return

			var/turf
				T
				X
			var/obj/boat/B

			switch(usr.dir)
				if(EAST) T = locate(src.x + sizeSide, src.y, src.z)
				if(WEST) T = locate(src.x - sizeSide, src.y, src.z)
				if(NORTH) T = locate(src.x, src.y + sizeSide, src.z)
				if(SOUTH) T = locate(src.x, src.y - sizeSide, src.z)
			if(!T)
				usr.show_message("<tt>There is not enough room to build a boat of that size here.</tt>")
				return

			for(X in range(size, T)) if(!istype(X, /turf/water)) break
			for(B in range(size, T)) break
			if(X || B)
				usr.show_message("<tt>There is not enough room to build a boat of that size here.</tt>")
				return
			new/boat(T, size)
			I.stacked -= woodNeeded
			if(I.stacked <= 0) I.Move(null, forced = 1)