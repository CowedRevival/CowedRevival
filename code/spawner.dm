obj/spawner
	name = "Spawner"
	invisibility = 101
	icon = 'Goat.dmi'
	icon_state = "alive"

	var
		list/spawned_children
		max_no_of_spawns = 3
		range = 3

	New()
		..()
		tag = "[rand(1,99999)][rand(1,99999)][rand(1,99999)][rand(1,99999)]"

	proc/Respawn()

	animal
		var/animal/animal_type
		Respawn()
			var/obj/spawner = locate(tag)
			if(!spawner.loc) return
			if(!spawned_children) spawned_children = new()
			for(var/animal/I in spawned_children)
				if(I.icon_state == "dead")
					spawned_children -= I
			if(spawned_children.len < max_no_of_spawns)
				var/number_of_spawns = max_no_of_spawns - spawned_children.len
				for(var/i = 1 to number_of_spawns)
					var/x = spawner.loc.x + rand(-range, range)
					var/y = spawner.loc.y + rand(-range, range)
					var/z = spawner.loc.z
					var/turf/g = locate(x, y, z)
					if(istype(g, /turf/grass)) spawned_children += new animal_type(locate(x,y,z))

		Goat_Spawner
			animal_type = /animal/goat
			range = 3
			max_no_of_spawns = 3

		Sheep_Spawner
			icon = 'icons/Sheep.dmi'
			animal_type = /animal/sheep
			range = 3
			max_no_of_spawns = 3

		Pig_Spawner
			icon = 'icons/Pig.dmi'
			animal_type = /animal/pig
			range = 3
			max_no_of_spawns = 3

		Wolf_Spawner
			icon = 'icons/Wolf.dmi'
			animal_type = /animal/wolf
			range = 3
			max_no_of_spawns = 3

	monster
		icon = 'Zombie.dmi'
		icon_state = "alive"
		var/mob/mob_type
		Respawn()
			var/obj/spawner = locate(tag)
			if(!spawner.loc) return
			if(!spawned_children) spawned_children = new()
			for(var/mob/I in spawned_children)
				if(I.icon_state == "dead")
					spawned_children -= I
			if(spawned_children.len < max_no_of_spawns)
				var/number_of_spawns = max_no_of_spawns - spawned_children.len
				for(var/i = 1 to number_of_spawns)
					var/x = spawner.loc.x + rand(-range, range)
					var/y = spawner.loc.y + rand(-range, range)
					var/z = spawner.loc.z
					spawned_children += new mob_type(locate(x,y,z))

		Zombie_Spawner
			mob_type = /mob/Zombie
			range = 3
			max_no_of_spawns = 3

	frogman_rising
		icon = 'icons/Frogman_King.dmi'
		icon_state = "alive"
		range = 5
		max_no_of_spawns = 3
		var/mob/mob_type = /mob/Frogman
		Respawn()
			for(var/mob/Frogman/Frogman_King/K in world)
				var/obj/spawner = locate(tag)
				if(!spawner.loc) return
				if(!spawned_children) spawned_children = new()
				for(var/mob/I in spawned_children)
					if(I.icon_state == "dead")
						spawned_children -= I
				if(spawned_children.len < max_no_of_spawns)
					hearers(src)<<"<font color=green>A Frogman hops out of the water!"
					var/number_of_spawns = max_no_of_spawns - spawned_children.len
					for(var/i = 1 to number_of_spawns)
						var/x = spawner.loc.x + rand(-range, range)
						var/y = spawner.loc.y + rand(-range, range)
						var/z = spawner.loc.z
						var/turf/g = locate(x, y, z)
						if(istype(g, /turf/grass) || istype(g, /turf/sand)) spawned_children += new mob_type(locate(x,y,z))
				return
