turf/Cave_Start

	icon = 'icons/Turfs.dmi'
	icon_state = "cavegenturf"

	var/cave_width = 1
	var/cave_height = 1
	var/birthLimit = 4
	var/deathLimit = 3
	var/list/map_array
	proc/Generate()
		tag = name
		map_array = new()

		for(var/i = 1 to cave_width)
			var/map_section_temp = new/map_section(cave_height)
			map_array += map_section_temp

		for(var/i = 1 to cave_width)
			for(var/j = 1 to cave_height)
				if(prob(45))
					map_array[i].map_array[j] = 1
				else
					map_array[i].map_array[j] = 0

		for(var/i = 1 to 4)
			DoSimulation()

		var/temp_location_x = locate(tag).x
		var/temp_location_y = locate(tag).y
		var/temp_location_z = locate(tag).z

		for(var/i = 1 to cave_width)
			for(var/j = 1 to cave_height)
				var/position_x = temp_location_x + (i-1)
				var/position_y = temp_location_y + (j-1)
				if(map_array[i].map_array[j] == 0 && istype(locate(position_x, position_y, temp_location_z), /turf/underground/dirtwall))
					new/turf/path(locate(position_x, position_y, temp_location_z))
					if(prob(5))
						var/typechosen = rand(1,100)
						switch(typechosen)
							if(1 to 20)
								new/obj/vein/Copper_Vein(locate(position_x, position_y, temp_location_z))
							if(21 to 40)
								new/obj/vein/Tin_Vein(locate(position_x, position_y, temp_location_z))
							if(41 to 55)
								new/obj/vein/Tungsten_Vein(locate(position_x, position_y, temp_location_z))
							if(56 to 68)
								new/obj/vein/Iron_Vein(locate(position_x, position_y, temp_location_z))
							if(69 to 78)
								new/obj/vein/Silver_Vein(locate(position_x, position_y, temp_location_z))
							if(79 to 87)
								new/obj/vein/Palladium_Vein(locate(position_x, position_y, temp_location_z))
							if(88 to 94)
								new/obj/vein/Gold_Vein(locate(position_x, position_y, temp_location_z))
							if(95 to 99)
								new/obj/vein/Mithril_Vein(locate(position_x, position_y, temp_location_z))
							if(100)
								new/obj/vein/Magicite_Vein(locate(position_x, position_y, temp_location_z))
					else if(prob(2))
						var/obj/tree/mushroom/towercap/temp = new(locate(position_x, position_y, temp_location_z))
						temp.icon_state = "false_shroom_[rand(1,3)]"
					else if(prob(1) && prob(10))
						new/mob/Shroom_Monster/Shroom(locate(position_x, position_y, temp_location_z))
		new/turf/underground/dirtwall(locate(temp_location_x, temp_location_y, temp_location_z))

	proc/CountAliveNeighbours(var/x, var/y)
		var/count = 0
		for(var/i = -1 to 1)
			for(var/j = -1 to 1)
				var/n_x = x + i
				var/n_y = y + j
				if(!(i == 0 && j == 0) && (n_x > 0 && n_y > 0))
					if(n_x < 0 || n_y < 0 || n_x >= cave_width || n_y >= cave_height)
						count += 1
					else if(map_array[n_x].map_array[n_y] == 1)
						count += 1
		return count

	proc/DoSimulation()
		var/list/new_map = new()
		for(var/i = 1 to cave_width)
			new_map += new/map_section(cave_height)
		for(var/i = 1 to cave_width)
			for(var/j = 1 to cave_height)
				var/nbs = CountAliveNeighbours(i,j)
				if(map_array[i].map_array[j] == 1)
					if(nbs < deathLimit)
						new_map[i].map_array[j] = 0
					else
						new_map[i].map_array[j] = 1
				else
					if(nbs > birthLimit)
						new_map[i].map_array[j] = 1
					else
						new_map[i].map_array[j] = 0

		for(var/i = 1 to cave_width)
			for(var/j = 1 to cave_height)
				map_array[i].map_array[j] = new_map[i].map_array[j]



map_section
	var/list/map_array
	New(var/size = 1)
		map_array = new()
		for(var/i = 1 to size)
			map_array += 0

mob/verb/TestCaves()
	set background=1
	for(var/turf/Cave_Start/I in world)
		I.Generate()

mob/verb/WhereAmI()
	world << "I'm at: [loc.x], [loc.y], [loc.z]"