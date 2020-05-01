turf/Cave_Start

	icon = 'icons/Turfs.dmi'
	icon_state = "cavegenturf"

	var/cave_width = 1
	var/cave_height = 1
	var/birthLimit = 4
	var/deathLimit = 3
	var/list/map_array
	var/list/new_map
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
		DoSimulation()
		var/temp_location_x = locate(tag).x
		var/temp_location_y = locate(tag).y
		var/temp_location_z = locate(tag).z
		var/monster_count = 0
		for(var/i = 1 to cave_width)
			for(var/j = 1 to cave_height)
				var/position_x = temp_location_x + (i-1)
				var/position_y = temp_location_y + (j-1)
				if(new_map[i].map_array[j] == 0 && istype(locate(position_x, position_y, temp_location_z), /turf/underground/dirtwall))
					new/turf/path(locate(position_x, position_y, temp_location_z))
					if(prob(5))
						new/obj/vein(locate(position_x, position_y, temp_location_z))
					else if(prob(2))
						new/obj/tree/mushroom/towercap(locate(position_x, position_y, temp_location_z))
					else if(prob(1) && prob(10) && monster_count < 50)
						new/mob/Shroom_Monster/Shroomling(locate(position_x, position_y, temp_location_z))
						monster_count++
				else if(new_map[i].map_array[j] == 0 && istype(locate(position_x, position_y, temp_location_z), /turf/underground/deep_dirtwall))
					if(prob(1) && prob(5))
						new/turf/hard_floor/cracked_hard_floor(locate(position_x, position_y, temp_location_z))
					else
						new/turf/hard_floor(locate(position_x, position_y, temp_location_z))
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
					else if(prob(3))
						new/obj/tree/mushroom/towercap(locate(position_x, position_y, temp_location_z))
					else if(prob(1) && prob(10) && monster_count < 50)
						new/mob/Shroom_Monster/Shroomling(locate(position_x, position_y, temp_location_z))
						monster_count++
				else if(new_map[i].map_array[j] == 0 && istype(locate(position_x, position_y, temp_location_z), /turf/underground/chaos_stone))
					new/turf/chaos_brick(locate(position_x, position_y, temp_location_z))
					if(prob(1) && prob(50))
						new/obj/vein/Adamantite_Vein(locate(position_x, position_y, temp_location_z))
					else if(prob(2))
						new/obj/vein/Magicite_Vein(locate(position_x, position_y, temp_location_z))
					else if(prob(1) && prob(10) && monster_count < 50)
						new/mob/Demon(locate(position_x, position_y, temp_location_z))
						monster_count++
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
		new_map = new()
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





map_section
	var/list/map_array
	New(var/size = 1)
		map_array = new()
		for(var/i = 1 to size)
			map_array += 0

