
mob/AI/Frogman
	name="Frogman"
	icon='icons/Frogman.dmi'
	icon_state="alive"
	HP=60
	defence=2

	checkdead(mob/M)
		if(src.HP<=0)
			if(client)
				for(var/mob/AI/Frogman/Z in world)
					if(Z != src && Z.z == src.z)
						Z.key = src.key
						break
			Dead_Stuff()
			del(src)

	Pre_Loop()
		HP = rand(60,90)

	Dead_Stuff()
		density=0
		name="Frogman's corpse"
		contents+=new/item/misc/food/Frog_Meat
		if(prob(50))
			contents+=new/item/misc/orbs/Frog_Orb
		if(prob(30))
			contents+=new/item/misc/seeds/Red_Seedlette
		if(prob(30))
			contents+=new/item/misc/seeds/Yellow_Seedlette
		if(prob(30))
			contents+=new/item/misc/seeds/Blue_Seedlette
		spawn(200)
			if(src) del src

	Loop()
		while(src && HP>0)
			sleep(5)
			if(legshackled || client) continue

			var
				mob/target
				turf/water/W = locate() in view(20,src)
			for(var/mob/M in view(20,src))
				if(!istype(M,/mob/observer) && M != src && !M.isMonster && !findtext(M.name,"corpse") && M.HP)
					target = M
					break

			if(target)
				step_to(src,target,1)
				if(get_dist(src,target)<=1 && prob(40))
					ohearers(src)<<"\red<b>[src] attacks [target].</b>"
					target.HP-=7
					target.checkdead(target)
					hud_main.UpdateHUD(target)
					continue

			else if(W && get_dist(src,W)>=10)
				step_to(src,W)

			else if(prob(20))
				step(src,pick(NORTH,EAST,SOUTH,WEST))

			if(prob(1))
				var/A=pick("Crooooooooak...","I will get you!","Viva la Frogs!","FROG NATION!","Stop stealing our fish!")
				hearers()<<"<font color=green>Frogman says: [A]"