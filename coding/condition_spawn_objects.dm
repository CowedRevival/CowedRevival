obj/condition_spawn
	name = "condition_spawner"
	invisibility = 101
	icon = 'icons/misc_textures.dmi'
	icon_state = "condition_spawner"
	var/obj/create_object
	var/mob/create_mob
	var/turf/create_turf
	var/chance_object = 100
	var/chance_mob = 100
	var/chance_turf = 100

	proc/Execute()
		if(create_object && prob(chance_object)) new create_object(loc)
		if(create_mob && prob(chance_mob)) new create_mob(loc)
		if(create_turf && prob(chance_turf)) new create_turf(loc)
		del(src)


	frog_nation
		icon_state = "condition_spawner_frog"

		//Walls
		wood_wall
			create_turf = /turf/wooden/wood_wall

		stone_wall
			create_turf = /turf/stone/stone_wall

		//Doors
		stone_door
			create_turf = /obj/door/stone

		//Floors
		wood_floor
			create_turf = /turf/wooden/wood_floor

		stone_floor
			create_turf = /turf/stone/stone_floor

		//King Instant Spawner
		frogman_king
			create_mob = /mob/Frogman/Frogman_King


admin/verb/Force_Structures()
	set category = "Admin"
	for(var/obj/condition_spawn/I in world)
		I.Execute()