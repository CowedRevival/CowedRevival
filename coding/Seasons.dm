var/current_season_state = ""

world
	New()
		..()

game
	TimeCheck()
		..()
		var/season_change = 0
		if(Month == 3 && Day == 1 && Hour == 0)//Autumn
			current_season_state = "autumn "
			season_change = 1

		else if(Month == 4 && Day == 1 && Hour == 0)//Winter
			current_season_state = "snow "
			season_change = 1

		else if(Month == 1 && Day == 1 && Hour == 0)//Normal
			current_season_state = ""
			season_change = 1

		if(season_change == 1) //Season Change Code
			var/list/spawners_list = new()
			var/list/grass_turfs = new()
			var/list/tree_list = new()
			var/list/bush_list = new()
			var/list/palm_list = new()
			var/list/crop_list = new()

			for(var/obj/spawner/I in world)
				spawners_list += I

			for(var/obj/tree/I in world)
				tree_list += I

			for(var/turf/grass/I in world)
				grass_turfs += I

			for(var/obj/bush/I in world)
				bush_list += I

			for(var/obj/Palm_tree/I in world)
				palm_list += I

			for(var/obj/crop/I in world)
				crop_list += I


			for(var/obj/spawner/I in spawners_list)
				I.Respawn()
			for(var/turf/I in grass_turfs)
				if(istype(I,/turf/grass))
					I.icon_state = current_season_state + "grass"
			for(var/obj/tree/I in tree_list)
				I.icon_state = current_season_state + I.icon_state_base
			for(var/obj/bush/I in bush_list)
				I.icon_state = current_season_state + I.icon_state_base
			for(var/obj/Palm_tree/I in palm_list)
				I.icon_state = current_season_state + "palm tree"
			for(var/obj/crop/I in crop_list)
				if(Month == 4)
					if(I.player_planted == 1) del(I)
					else I.invisibility = 101
				else I.invisibility = 0

obj
	tree
		New()
			if(prob(33))
				icon_state = "tree_2"
				icon_state_base = icon_state
			else if(prob(33))
				icon_state = "tree_3"
				icon_state_base = icon_state
			else
				icon_state = "tree_1"
				icon_state_base = icon_state
			..()

/*mob/verb/next_month()
	Month = 2
	Day = 10
	Hour = 23*/