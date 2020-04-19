
mob/AI/Zombie
	name="Zombie"
	icon='icons/Zombie.dmi'
	icon_state="alive"
	HP=60
	see_in_dark=10

	checkdead(mob/M)
		if(src.HP<=0)
			if(client)
				for(var/mob/AI/Zombie/Z in world)
					if(Z != src && Z.z == src.z)
						Z.key = src.key
						break
			del(src)

	Pre_Loop()
		HP = rand(50,90)

	Loop()
		while(src && HP>0)
			sleep(5)
			if(legshackled || client) continue

			var/mob/target
			for(var/mob/M in view(20,src))
				var/item/misc/books/Necro/N = locate() in M
				if(!istype(M,/mob/observer) && M != src && !istype(M,/mob/AI/Zombie) && M.name!="Zombie"&& !M.isMonster && !N && !findtext(M.name,"corpse"))
					target = M
					break

			if(!target)
				for(var/mob/M in range(10,src))
					var/item/misc/books/Necro/N = locate() in M
					if(!istype(M,/mob/observer) && prob(40) && M != src && !istype(M,/mob/AI/Zombie) && M.name!="Zombie"&& !M.isMonster && !N && !findtext(M.name,"corpse"))
						target = M
						break

			if(target)
				step_to(src,target,1)
				if(get_dist(src,target)<=1 && prob(60))
					ohearers(src)<<"\red<b>[src] attacks [target].</b>"
					target.HP-=3
					if(prob(100-target.HP)&&infection_mode=="on")
						target.infection+=1
						if(target.infection==1)
							world<<"<b>[target] has been infected!"
					target.checkdead(target)
					hud_main.UpdateHUD(target)
					continue

			else if(prob(20))
				step(src,pick(NORTH,EAST,SOUTH,WEST))

			// break down wooden stuff
			var/idle = TRUE
			for(var/turf/wooden/T in oview(1))
				if(T.density && prob(40))
					ohearers(src)<<"[src] attacks [T]."
					T.buildinghealth-=1
					if(T.buildinghealth<=0) new/turf/path(T)
					idle=FALSE
					break
			if(idle)
				for(var/obj/wooden/T in oview(1))
					if(T.density && prob(40))
						ohearers(src)<<"[src] attacks [T]."
						T.buildinghealth-=1
						if(T.buildinghealth<=0) del(T)
						idle=FALSE
						break
			if(prob(1))
				if(prob(2))
					hearers()<<"<b>[name]</b> growns..."
				else
					hearers()<<"<b>[name]</b> groans..."
