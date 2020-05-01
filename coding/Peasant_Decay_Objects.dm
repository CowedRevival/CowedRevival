obj/Decay_Object
	name = "decay_object"
	invisibility = 101
	icon = 'icons/misc_textures.dmi'
	icon_state = "decay"
	var/radius = 5

	proc/Execute()
		for(var/i = 1 to radius)
			for(var/j = 1 to radius)
				var/x = loc.x + (i - round(radius/2))
				var/y = loc.y  + (j - round(radius/2))
				var/z = loc.z
				if(prob(40))
					new/turf/path(locate(x,y,z))
				else if(prob(20))
					new/turf/wooden/wood_floor(locate(x,y,z))
				if(prob(5))
					new/obj/spawner/monster/Zombie_Spawner(locate(x,y,z))
		del(src)