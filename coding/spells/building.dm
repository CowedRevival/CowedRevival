// Fixed it so it only works on one z level.
spell_component/building
	load
		name = "Load Building"
		icon_state = "load_building"
		mana_cost = 60
		cooldown = 50
		activate(mob/M)
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on the lower-left turf to create your building.</tt>")
		invoke(mob/M, turf/T)
			//make sure they clicked a tile and make sure they have a building_id
			if(!istype(T))
				M.show_message("<tt>You did not click on a tile. Spell aborted.</tt>")
				return 1
			var/spell/building/master = src.master
			if(!istype(master))
				M.show_message("<tt>You don't have enough knowledge to master this spell!</tt>")
				return 1

//			T = locate(T.x, T.y, undergroundz) //make sure we have the underground layer

			//get the size and make sure no objs exist within the area -- also make sure no odd turfs pop up
			var
				list/size = SwapMaps_GetSize(master.building_id)
				x
				y
				z

			if(size && size.len == 3)
				x = size[1]
				y = size[2]
				z = size[3]

			//M.show_message("Size: [x], [y], [z]")

			if(!x || !y || !z)
				M.show_message("<tt>Unable to find the map or unable to read size! Are you sure the specified id exists? Spell aborted.</tt>")
				return 1
			for(var/turf/X in block(T, locate(T.x + x, T.y + y, T.z)))//skyz)))
				if(!istype(X, /turf/wooden) && !istype(X, /turf/stone) && !istype(X, /turf/grass) && \
				   !istype(X, /turf/underground) && !istype(X, /turf/sand) && !istype(X, /turf/path) && \
				   !istype(X, /turf/hole) && !istype(X, /turf/stairs) && X.type != /turf && !istype(X, /turf/sky))
					M.show_message("<tt>There is an obstruction (tile) preventing the spell from working. Please check all layers.</tt>")
					return
				var/obj/O
				for(O in X)
					if(M.ckey in developers)
						O.Move(null, forced = 1)
						continue
					break
				if(O)
					M.show_message("<tt>There is an obstruction (object) preventing the spell from working. Please check all layers.</tt>")
					return 1

			var/list/L = new/list()
			for(var/turf/X in block(T, locate(T.x + x, T.y + y, T.z)))//skyz)))
				for(var/mob/N in X)
					L[N] = N.loc
					N.Move(null, forced = 1)

			//now actually load the building
			SwapMaps_LoadChunk(master.building_id, T)
			play_sound(M, hearers(M), sound('sounds/building_load.ogg'))

			for(var/turf/X in block(T, locate(T.x + x, T.y + y, T.z)))//skyz)))
				X.cause = M.key
				for(var/obj/O in X)
					O.cause = M.key
				X.sd_LumUpdate()
			for(var/turf/X in block(T, locate(T.x + x, T.y + y, T.z))) //skyz)))
				if(X.luminosity > 0)
					var/lum = X.luminosity
					X.luminosity = 0
					X.sd_SetLuminosity(lum)
				for(var/obj/O in X)
					if(O.luminosity > 0)
						var/lum = O.luminosity
						O.luminosity = 0
						O.sd_SetLuminosity(lum)

			for(var/mob/N in L)
				N.Move(L[N], forced = 1)
	save
		name = "Save Building"
		icon_state = "save_building"
		mana_cost = 60
		cooldown = 50
		var/turf/locorner
		activate(mob/M)
			if(!(M.ckey in developers))
				M.show_message("<tt>This component will only work for developers. Sorry!</tt>")
				return
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on the lower-left corner of your building.</tt>")
		invoke(mob/M, turf/T)
			//make sure they clicked a tile and make sure they have a building_id
			var/spell/building/master = src.master
			if(!istype(master))
				M.show_message("<tt>You don't have enough knowledge to master this spell!</tt>")
				src.locorner = null
				return 1

			if(!istype(T))
				M.show_message("<tt>You did not click on a tile. Spell aborted.</tt>")
				src.locorner = null
				return 1
			if(!src.locorner)
				src.locorner = T
				M.selectedSpellComponent = src
				M.show_message("<tt>Now click on the upper-right corner of your building.</tt>")
				return 1

			//get the lower-left and upper-right and determine the size
			var
				turf
//					locorner = locate(src.locorner.x, src.locorner.y, undergroundz)
					hicorner = T//locate(T.x, T.y, skyz)
				x = hicorner.x - locorner.x
				y = hicorner.y - locorner.y
			if(locorner.x > hicorner.x || locorner.y > hicorner.y)
				M.show_message("<tt>You did not specify a valid lower-left & upper-right corner. Spell aborted.</tt>")
				src.locorner = null
				return 1
			if(x > 30 || y > 30)
				M.show_message("<tt>The building is too large!</tt>")
				src.locorner = null
				return 1

			for(T in block(locorner, hicorner))
				T.sd_LumReset()

			SwapMaps_SaveChunk(master.building_id, locorner, hicorner)

			for(T in block(locorner, hicorner))
				T.sd_LumUpdate()

			M.show_message("<tt>The map has been saved with ID [master.building_id].</tt>")
			src.locorner = null
	id
		name = "Set Building ID"
		icon_state = "id_building"
		mana_cost = 0
		cooldown = 10
		activate(mob/M)
			var/spell/building/master = src.master
			if(!istype(master))
				M.show_message("<tt>You don't have enough knowledge to master this spell!</tt>")
				return

			var/id = input(M, "Specify the building id in the field below.", "Set Building ID", master.building_id)
			if(id && istype(M) && (src.master in M.spells) && istype(src.master))
				master.building_id = id
				M.show_message("<tt>Building ID set to [id]!</tt>")

spell/building
	name = "Building"
	components = newlist(/spell_component/building/load, /spell_component/building/save, /spell_component/building/id)
	var
		building_id