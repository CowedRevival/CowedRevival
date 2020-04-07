obj/spawner
	name = "Spawner"
	invisibility = 101
	icon = 'Goat.dmi'
	icon_state = "alive"

	var
		list/spawned_children
		max_no_of_spawns = 3
		range = 3

	proc/Respawn()

	animal
		var/animal/animal_type
		Respawn()
			if(!spawned_children) spawned_children = new()
			for(var/animal/I in spawned_children)
				if(I.icon_state == "dead")
					spawned_children -= I
			if(spawned_children.len < max_no_of_spawns)
				var/number_of_spawns = max_no_of_spawns - spawned_children.len
				for(var/i = 1 to number_of_spawns)
					var/x = loc.x + rand(-range, range)
					var/y = loc.y + rand(-range, range)
					var/z = loc.z
					spawned_children += new animal_type(locate(x,y,z))

		Goat_Spawner
			animal_type = /animal/goat
			range = 3
			max_no_of_spawns = 3

		Sheep_Spawner
			animal_type = /animal/sheep
			range = 3
			max_no_of_spawns = 3

		Pig_Spawner
			animal_type = /animal/pig
			range = 3
			max_no_of_spawns = 3

	monster
		icon = 'Zombie.dmi'
		icon_state = "alive"
		var/mob/mob_type
		Respawn()
			if(!spawned_children) spawned_children = new()
			for(var/mob/I in spawned_children)
				if(I.icon_state == "dead")
					spawned_children -= I
			if(spawned_children.len < max_no_of_spawns)
				var/number_of_spawns = max_no_of_spawns - spawned_children.len
				for(var/i = 1 to number_of_spawns)
					var/x = loc.x + rand(-range, range)
					var/y = loc.y + rand(-range, range)
					var/z = loc.z
					spawned_children += new mob_type(locate(x,y,z))

		Zombie_Spawner
			mob_type = /mob/Zombie
			range = 3
			max_no_of_spawns = 3