spell_component/ghost
	corporeal
		name = "Turn Incorporeal"
		icon_state = "ghost-i"
		cooldown = 10
		mana_cost = 20
		invoke(mob/M)
			if(!M.CheckAlive()) return 1
			if(M.state == "ghost")
				src.name = "Turn Corporeal"
				src.icon_state = "ghost"
				M.state = "ghost-i"
				M.icon = 'icons/GhostIncorporeal.dmi'
				M.UpdateClothing()
			else if(M.state == "ghost-i")
				src.name = "Turn Incorporeal"
				src.icon_state = "ghost-i"

				M.state = "ghost"
				M.icon = 'icons/GhostCorporeal.dmi'
				M.UpdateClothing()

spell/ghost
	components = newlist(/spell_component/ghost/corporeal)