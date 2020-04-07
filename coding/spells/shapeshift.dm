// Max wanted it

spell_component/shapeshift
	name = "Shapeshift"
	icon_state = "ghost-i"
	cooldown = 10
	mana_cost = 20
	var
		original_icon
		original_icon_state
		original_name
	invoke(mob/M)
		if(!M.CheckAlive()) return 1
		if(original_name)
			src.name = "Shapeshift"
			src.icon_state = "ghost"
			M.icon = original_icon
			M.icon_state = original_icon_state
			M.name = original_name
			original_name = null
			original_icon = null
			original_icon_state = null
			M.density=1
			M.state="alive"
			M.anchored=0
			M.UpdateClothing()
		else
			src.name = "Shapeshift Back"
			src.icon_state = "ghost-i"

			M.state = "hidden"

			var
				list/possibles=list()
				turf/T = get_turf(M)

			for(var/turf/water/W in orange(1,T))
				possibles += "water"
				// more water around you the more likely you will shift into water.
			if(istype(T,/turf/grass))
				possibles += "grass"
				possibles += "tree"
			if(istype(T,/turf/sand))
				possibles += "sand"
				possibles += "palm"
			if(!possibles.len)
				possibles += "chair"

			original_name = M.name
			original_icon = M.icon
			original_icon_state = M.icon_state
			M.density=0
			M.anchored=0

			var/disguise = pick(possibles)
			switch(disguise)
				if("water")
					M.icon = 'icons/Turfs.dmi'
					M.icon_state = "water"
					M.name = "water"
					M.density=1
					M.anchored=1
				if("grass")
					M.icon = 'icons/Turfs.dmi'
					M.icon_state = "grass"
					M.name = "grass"
					M.anchored=1
				if("tree")
					M.icon = 'icons/Turfs.dmi'
					M.icon_state = "tree"
					M.name = "tree"
					M.density=1
					M.anchored=1
				if("sand")
					M.icon = 'icons/Turfs.dmi'
					M.icon_state = "sand"
					M.name = "sand"
					M.anchored=1
				if("palm")
					M.icon = 'icons/Turfs.dmi'
					M.icon_state = "palm tree"
					M.name = "palm tree"
					M.density=1
					M.anchored=1
				if("chair")
					M.icon = 'icons/Turfs.dmi'
					M.icon_state = "chair"
					M.name = "chair"
			M.UpdateClothing()

spell/shapeshift
	components = newlist(/spell_component/shapeshift)