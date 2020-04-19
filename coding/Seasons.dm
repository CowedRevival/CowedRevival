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

			for(var/obj/tree/I in world)
				if(!istype(I, /obj/tree/mushroom))
					I.icon_state = current_season_state + I.icon_state_base

			for(var/turf/grass/I in world)
				if(istype(I,/turf/grass))
					I.icon_state = current_season_state + "grass"

			for(var/obj/bush/I in world)
				I.icon_state = current_season_state + I.icon_state_base

			for(var/obj/Palm_tree/I in world)
				I.icon_state = current_season_state + "palm tree"

			for(var/obj/crop/I in world)
				if(Month == 4)
					if(I.player_planted == 1) del(I)
					else I.invisibility = 101
				else I.invisibility = 0

			if(prob(50))
				world << "<b>The moon has a strange glint tonight...</b>"
				for(var/mob/M in world)
					if(M.tag == "Skeleton" && M.HP <= 0)
						M.MHP = 250
						M.HP = 250
						M.MHUNGER = 99999
						M.MTHIRST = 99999
						M.MSLEEP = 99999
						M.HUNGER = M.MHUNGER
						M.THIRST = M.MTHIRST
						M.SLEEP = M.MSLEEP
						M.corpse = null
						M.icon_state = "alive"
						M.UpdateClothing()
						M.Zombie()


		if(Hour == 0)
			for(var/obj/tree/apple_tree/I in world)
				if(prob(20)) I.DropApples()
			for(var/obj/spawner/I in world)
				if(prob(50)) I.Respawn()

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


mob/verb/Change_Month()
	set category = "Admin"
	Month += 1
	Day = 3
	Hour = 23