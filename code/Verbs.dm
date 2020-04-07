mob
	startingverb/verb
		unlegshackle(mob/M in orange(1))
			if(M.legshackled == 0)
				usr.show_message("[M] is not leg shackled.")
			else
				if(issleeping==1 || shackled == 1 || rolling == 1) return
				for(var/mob/N in hearers(usr))
					N.show_message("[usr] un-legshackles [M]!")
				M.legshackled = 0
				M.UpdateClothing()
				usr.contents += new/item/misc/legshackles
		unshackle(mob/M in orange(1))
			if(M.shackled == 0)
				usr.show_message("[M] is not shackled.")
			else
				if(issleeping==1 || shackled == 1 || rolling == 1) return
				for(var/mob/N in hearers(usr))
					N.show_message("[usr] unshackles [M]!")
				M.shackled = 0
				M.UpdateClothing()
				usr.contents += new/item/misc/shackles
mob/proc/CheckAlive() return (src.HP > 0 && !src.corpse)