map_editor_obj
	icon = 'icons/map_editor.dmi'
	parent_type = /obj
	nothing
		name = "Nothing"
		icon_state = "n/a"
	delete
		name = "Delete"
		icon_state = "delete"
	wooden
		name = ""
		icon_state = "wood"
	stone
		name = ""
		icon_state = "stone"
	misc
		name = ""
		icon_state = "misc"
	turf
		var/real_type
		New(real_type)
			if(dd_hasprefix("[real_type]", "/turf"))
				var/turf/T = new real_type(locate(world.maxx, world.maxy, 1))
				src.real_type = T.type
				src.name = T.name
				src.icon = T.icon
				src.icon_state = T.icon_state
				del T
			else
				var/obj/O = new real_type
				src.real_type = O.type
				src.name = O.name
				src.icon = O.icon
				src.icon_state = O.icon_state
map_editor
	var
		list
			dragInfo
		action
		const
			ACTION_PLACE = 1
			ACTION_DELETE = 2 //objs/mobs only, excludes players
			ACTION_DELETE_ALL = 3 //excludes players
			ACTION_DUPLICATE = 4
		place_type
		client/client
		image/selector
		global
			list
				turfs
				objects
	New(client/C)
		src.selector = new/image(icon = 'icons/map_editor.dmi', icon_state = "selector")

		src.client = C
		C.verbs += typesof(/map_editor/verb)
		var/mob/M = C.mob
		if(!M.sight_override) M.sight = SEE_SELF | SEE_MOBS | SEE_OBJS | SEE_TURFS
		if(!turfs)
			turfs = new/list()
			turfs += new/map_editor_obj/nothing
			turfs += new/map_editor_obj/delete
			turfs += null
			turfs += null
			turfs += null
			turfs += new/map_editor_obj/wooden
			var/i = 4
			for(var/X in typesof(/turf/wooden) - typesof(/turf/wooden/wood_door) + /turf/wooden/wood_door - /turf/wooden)
				if(--i <= 0) i = 5
				turfs += new/map_editor_obj/turf(X)
			if(i != 5) for(var/x = 1 to i) turfs += null

			turfs += new/map_editor_obj/stone
			i = 4
			for(var/X in typesof(/turf/stone) - typesof(/turf/stone/stone_door) + /turf/stone/stone_door)
				if(--i <= 0) i = 5
				turfs += new/map_editor_obj/turf(X)
			if(i != 5) for(var/x = 1 to i) turfs += null

			turfs += new/map_editor_obj/misc

			var/list
				forbidden = list(
					/turf=1, /turf/water=2, /turf/table=1, /turf/wooden, /turf/stone, /turf/sky, /turf/digging,
					/turf/whiteness, /turf/loadin, /turf/tardis=1, /obj/family
				)
				L = typesof(/turf)
			for(var/forb in forbidden)
				if(forbidden[forb] == 2)
					L -= typesof(forb)
					L += forb
				else if(forbidden[forb] == 1) L -= forb
				else L -= typesof(forb)

			for(var/X in L)
				turfs += new/map_editor_obj/turf(X)
		if(!objects)
			objects = new/list()
			objects += new/map_editor_obj/nothing
			objects += new/map_editor_obj/delete
			objects += null
			objects += null
			objects += null
			objects += new/map_editor_obj/wooden
			var/i = 4
			for(var/X in typesof(/obj/wooden) - /obj/wooden)
				if(--i <= 0) i = 5
				objects += new/map_editor_obj/turf(X)
			if(i != 5) for(var/x = 1 to i) objects += null

			objects += new/map_editor_obj/stone
			i = 4
			for(var/X in typesof(/obj/stone) - /obj/stone)
				if(--i <= 0) i = 5
				objects += new/map_editor_obj/turf(X)
			if(i != 5) for(var/x = 1 to i) objects += null

			objects += new/map_editor_obj/misc

			var/list
				forbidden = list(
					/obj/wooden, /obj/stone, /item, /obj/test, /obj/tardis,
					/obj/chair=1, /obj/Misc=1, /obj/vein=1, /obj/Weather, /obj/Flower=1, /character_handling,
					/obj/shackle_ball, /obj/chain, /obj/Fireball, /obj/Iceball, /obj/Electrozap,
					/obj/lever, /obj/leverl, /obj/boat, /projectile, /obj/drawbridge,
					/map_editor_obj, /spell_component, /obj/portal, /obj/landmark, /obj/falsewall=1, /screen,
					/obj=1
				)
				L = typesof(/obj)
			for(var/forb in forbidden)
				if(forbidden[forb] == 2)
					L -= typesof(forb)
					L += forb
				else if(forbidden[forb] == 1) L -= forb
				else L -= typesof(forb)

			for(var/X in L)
				objects += new/map_editor_obj/turf(X)
				if(++i > 4) i = 1

		if(client)
			client << selector
			winshow(client, "admin/mapeditor")
			var/list/L = list(
				"admin/mapeditor.grdTurfs.cells" = "5x[round(turfs.len / 5) + 1]",
				"admin/mapeditor.grdObjects.cells" = "5x[round(objects.len / 5) + 1]",
				"admin/mapeditor.on-close" = "byond://?src=\ref[src];cmd=close"
			)
			winset(client, null, list2params(L))
			var
				i = 0
				y = 1
			for(var/X in turfs)
				if(++i > 5)
					i = 1
					y++
				if(X == null) continue
				client << output(X, "admin/mapeditor.grdTurfs:[i],[y]")

			i = 0
			y = 1
			for(var/X in objects)
				if(++i > 5)
					i = 1
					y++
				if(X == null) continue
				client << output(X, "admin/mapeditor.grdObjects:[i],[y]")
	Del()
		if(client)
			client.images -= selector
			winshow(client, "admin/mapeditor", 0)
			client.verbs -= typesof(/map_editor/verb)
			var/mob/M = client.mob
			if(M && !M.sight_override) M.sight = SEE_SELF
		return ..()
	Topic(href, href_list[])
		if(usr && usr.client && usr.client != src.client) return
		if(href_list["cmd"] == "close") del src
	proc
		MouseDrag(atom/src_object, atom/over_object, turf/src_location, turf/over_location)
			if(!src_object || !src_object.z || !over_location)
				if(dragInfo && ("images" in dragInfo))
					for(var/image/I in dragInfo["images"]) del I
				dragInfo = null
				return
			if(!dragInfo) dragInfo = new/list()

			if(!("start" in dragInfo)) dragInfo["start"] = src_location
			dragInfo["end"] = over_location
			if(!isturf(dragInfo["start"]) || !isturf(dragInfo["end"]))
				if("images" in dragInfo) for(var/image/I in dragInfo["images"]) del I
				dragInfo["images"] = list()
				return

			var
				turf
					start = dragInfo["start"]
					end = dragInfo["end"]
				x1 = start.x < end.x ? start.x : end.x
				x2 = start.x < end.x ? end.x : start.x
				y1 = start.y < end.y ? start.y : end.y
				y2 = start.y < end.y ? end.y : start.y

			if("images" in dragInfo) for(var/image/I in dragInfo["images"]) del I
			dragInfo["images"] = list()

			/*for(var/x = x1 + 1 to x2 - 1)
				dragInfo["images"] += new/image(icon = 'icons/map_editor.dmi', loc = locate(x, y1, start.z), icon_state = "line", dir = SOUTH)
				dragInfo["images"] += new/image(icon = 'icons/map_editor.dmi', loc = locate(x, y2, start.z), icon_state = "line", dir = NORTH)
			for(var/y = y1 + 1 to y2 - 1)
				dragInfo["images"] += new/image(icon = 'icons/map_editor.dmi', loc = locate(x1, y, start.z), icon_state = "line", dir = WEST)
				dragInfo["images"] += new/image(icon = 'icons/map_editor.dmi', loc = locate(x2, y, start.z), icon_state = "line", dir = EAST)*/
			dragInfo["images"] += new/image(icon = 'icons/map_editor.dmi', loc = locate(x1, y1, start.z), icon_state = "line", dir = SOUTHWEST)
			dragInfo["images"] += new/image(icon = 'icons/map_editor.dmi', loc = locate(x2, y1, start.z), icon_state = "line", dir = SOUTHEAST)
			dragInfo["images"] += new/image(icon = 'icons/map_editor.dmi', loc = locate(x1, y2, start.z), icon_state = "line", dir = NORTHWEST)
			dragInfo["images"] += new/image(icon = 'icons/map_editor.dmi', loc = locate(x2, y2, start.z), icon_state = "line", dir = NORTHEAST)

			for(var/image/I in dragInfo["images"]) usr << I
		MouseDrop(atom/src_object, atom/over_object, turf/src_location, turf/over_location)
			if(!dragInfo || !("start" in dragInfo) || !("end" in dragInfo) || !dragInfo["start"] || !dragInfo["end"])
				if(dragInfo && ("images" in dragInfo)) for(var/image/I in dragInfo["images"]) del I
				dragInfo = null
				return 0
			var
				turf
					start = dragInfo["start"]
					end = dragInfo["end"]
				list/L = (start.y < end.y || (start.y == end.y && start.x < end.x)) ? block(start,end) : block(end,start)

			if("images" in dragInfo) for(var/image/I in dragInfo["images"]) del I
			dragInfo = null

			for(var/turf/T in L) ProcessTurf(T)
			/*if(isturf(src_location) && isturf(over_location))
				for(var/turf/T in block(src_location, over_location)) ProcessTurf(T)*/
		Click(atom/O, location, control, params)
			if(control == "admin/mapeditor.grdTurfs" || control == "admin/mapeditor.grdObjects")
				if(istype(O, /map_editor_obj/nothing))
					action = 0
					usr << "No action will be performed upon click."
					src.selector.loc = null
				else if(istype(O, /map_editor_obj/delete))
					action = ACTION_DELETE
					usr << "Now deleting all objects/animals."
					src.selector.loc = O
				else
					var/map_editor_obj/turf/T = O
					if(istype(T))
						src.selector.loc = O
						place_type = T.real_type
						action = ACTION_PLACE
						usr << "Now placing objects of type [place_type]"
			var/turf/T = get_turf(O)
			if(!T) return
			ProcessTurf(T)
		ProcessTurf(turf/T)
			switch(action)
				if(ACTION_PLACE) new place_type(T)
				if(ACTION_DELETE, ACTION_DELETE_ALL)
					var/list/skip = list(
						/obj/stone, /obj/wooden
					)
					for(var/obj/O in T)
						if(action != ACTION_DELETE_ALL)
							var/type
							for(type in skip) if(istype(O, type)) break
							if(type) continue
						del O
					for(var/mob/M in T) if(!M.key && !istype(M, /mob/eavesdropper)) del M
					if(action == ACTION_DELETE_ALL) new/turf/grass(T)
					else
						skip = list(
							/turf/stone/stone_wall, /turf/stone/stone_windowed_wall, /turf/stone/stone_door, /turf/stone/stone_floor,
							/turf/wooden/wood_wall, /turf/wooden/wood_windowed_wall, /turf/wooden/wood_door, /turf/wooden/wood_floor,
							/turf/grass, /turf/digging, /turf/underground/dirtwall
						)
						var/type
						for(type in skip) if(istype(T, type)) break
						if(!type)
							if(istype(T, /turf/wooden)) T = new/turf/wooden/wood_floor(T)
							else if(istype(T, /turf/stone)) T = new/turf/stone/stone_floor(T)
				if(ACTION_DUPLICATE)
					var/atom/movable/A = place_type
					if(isturf(A) || isarea(A))
						var/list/L = new/list()
						for(var/atom/movable/O in T)
							L += O
							O.Move(null, forced = 1)
						A = A.duplicate(T)
						for(var/atom/movable/O in L) O.Move(T, forced = 1)
					else if(A)
						A = A.duplicate()
						A.loc = T
	verb
		place(var/type in typesof(/turf) + typesof(/obj) + typesof(/mob) + typesof(/area))
			set category = null
			var/map_editor/M = usr.client.map_editor
			M.action = M.ACTION_PLACE
			M.place_type = type
			usr << "Now placing objects of type [type]"
		delete_all()
			set category = null
			var/map_editor/M = usr.client.map_editor
			M.action = M.ACTION_DELETE_ALL
			usr << "Now deleting all objects."
		Duplicate(atom/A in world)
			set name = "duplicate"
			set category = null
			var/map_editor/M = usr.client.map_editor
			M.action = M.ACTION_DUPLICATE
			M.place_type = A