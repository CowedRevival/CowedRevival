/*mob/Goat
	icon = 'icons/Goat.dmi'
	slowness = 10
	smell = 30
	walk = 1
	New()
		src.Walk()

	proc
		Walk()
			if(src.walk)
				spawn(src.slowness) src.Walk()
				if(!src.Attack_Active&&!src.Search_active)
					step_rand(src)
		Attack()
			if(src.Attack_Active)
				spawn(src.slowness) src.Attack()
				for(var/mob/M in orange(src.smell))
					if(M == src.enemy)
						step_towards(src,M)
				for(var/mob/M in get_step(src,src.dir))
					if(M == src.enemy)
						hearers()<<"[src] attacks [M]!"
		Search2Food()
			if(src.Search_active)
				spawn(src.slowness) src.Search2Food()
				for(var/item/misc/food/F in oview(src.smell))
					step_towards(src,F)
					break
				for(var/item/misc/food/E in oview(1))
					hearers()<<"[src] devours the [E]."
					del(E)
					break
	Click()
		if(usr == src.owner)
			switch(input("What is it's command?","Command")in list("Attack Toggle","Set Free","Forage for Food Toggle"))
				if("Attack Toggle")
					if(!src.Attack_Active)
						src.enemy = input(usr,"Which mob?","Attack2Mob") as mob in oview()
						src.Attack_Active = 1
						src.Attack()
					else
						src.Attack_Active = 0
				if("Set Free")
					alert("Are you sure?","","Yes","No")
					if("Yes")
						src.owner = null
						src.Walk()
				if("Forage for Food Toggle")
					if(!src.Search_active)
						src.Search_active = 1
						src.Search2Food()
					else
						src.Search_active = 0
mob/verb
	Tame(mob/M in oview(1))
		M.owner = usr
		M.walk = 0*/
mob
	var/slowness = 0
	var/smell = 0
	var/Attack_Active = 0
	var/Search_active = 0
	var/mob/owner
	var/walk
/*mob/Pig
	icon = 'icons/Pig.dmi'
	slowness = 15
	smell = 50
	walk = 1
	New()
		src.Walk()

	proc
		Walk()
			if(src.walk)
				spawn(src.slowness) src.Walk()
				if(!src.Attack_Active&&!src.Search_active)
					step_rand(src)
		Attack()
			if(src.Attack_Active)
				spawn(src.slowness) src.Attack()
				for(var/mob/M in orange(src.smell))
					if(M == src.enemy)
						step_towards(src,M)
				for(var/mob/M in get_step(src,src.dir))
					if(M == src.enemy)
						hearers()<<"[src] attacks [M]!"
		Search2Food()
			if(src.Search_active)
				spawn(src.slowness) src.Search2Food()
				for(var/item/misc/food/F in oview(src.smell))
					step_towards(src,F)
					break
				for(var/item/misc/food/E in oview(1))
					hearers()<<"[src] devours the [E]."
					del(E)
					break
	Click()
		if(usr == src.owner)
			switch(input("What is it's command?","Command")in list("Attack Toggle","Set Free","Forage for Food Toggle"))
				if("Attack Toggle")
					if(!src.Attack_Active)
						src.enemy = input(usr,"Which mob?","Attack2Mob") as mob in oview()
						src.Attack_Active = 1
						src.Attack()
					else
						src.Attack_Active = 0
				if("Set Free")
					alert("Are you sure?","","Yes","No")
					if("Yes")
						src.owner = null
						src.Walk()
				if("Forage for Food Toggle")
					if(!src.Search_active)
						src.Search_active = 1
						src.Search2Food()
					else
						src.Search_active = 0
mob/Chicken
	icon = 'icons/Chicken.dmi'
	slowness = 5
	smell = 5
	walk = 1
	New()
		src.Walk()

	proc
		Walk()
			if(src.walk)
				spawn(src.slowness) src.Walk()
				if(!src.Attack_Active&&!src.Search_active)
					step_rand(src)
		Attack()
			if(src.Attack_Active)
				spawn(src.slowness) src.Attack()
				for(var/mob/M in orange(src.smell))
					if(M == src.enemy)
						step_towards(src,M)
				for(var/mob/M in get_step(src,src.dir))
					if(M == src.enemy)
						hearers()<<"[src] attacks [M]!"
		Search2Food()
			if(src.Search_active)
				spawn(src.slowness) src.Search2Food()
				for(var/item/misc/food/F in oview(src.smell))
					step_towards(src,F)
					break
				for(var/item/misc/food/E in oview(1))
					hearers()<<"[src] devours the [E]."
					del(E)
					break
	Click()
		if(usr == src.owner)
			switch(input("What is it's command?","Command")in list("Attack Toggle","Set Free","Forage for Food Toggle"))
				if("Attack Toggle")
					if(!src.Attack_Active)
						src.enemy = input(usr,"Which mob?","Attack2Mob") as mob in oview()
						src.Attack_Active = 1
						src.Attack()
					else
						src.Attack_Active = 0
				if("Set Free")
					alert("Are you sure?","","Yes","No")
					if("Yes")
						src.owner = null
						src.Walk()
				if("Forage for Food Toggle")
					if(!src.Search_active)
						src.Search_active = 1
						src.Search2Food()
					else
						src.Search_active = 0
mob/Sheep
	icon = 'icons/Sheep.dmi'
	slowness = 15
	smell = 50
	walk = 1
	New()
		src.Walk()

	proc
		Walk()
			if(src.walk)
				spawn(src.slowness) src.Walk()
				if(!src.Attack_Active&&!src.Search_active)
					step_rand(src)
		Attack()
			if(src.Attack_Active)
				spawn(src.slowness) src.Attack()
				for(var/mob/M in orange(src.smell))
					if(M == src.enemy)
						step_towards(src,M)
				for(var/mob/M in get_step(src,src.dir))
					if(M == src.enemy)
						hearers()<<"[src] attacks [M]!"
		Search2Food()
			if(src.Search_active)
				spawn(src.slowness) src.Search2Food()
				for(var/item/misc/food/F in oview(src.smell))
					step_towards(src,F)
					break
				for(var/item/misc/food/E in oview(1))
					hearers()<<"[src] devours the [E]."
					del(E)
					break
	Click()
		if(usr == src.owner)
			switch(input("What is it's command?","Command")in list("Attack Toggle","Set Free","Forage for Food Toggle"))
				if("Attack Toggle")
					if(!src.Attack_Active)
						src.enemy = input(usr,"Which mob?","Attack2Mob") as mob in oview()
						src.Attack_Active = 1
						src.Attack()
					else
						src.Attack_Active = 0
				if("Set Free")
					alert("Are you sure?","","Yes","No")
					if("Yes")
						src.owner = null
						src.Walk()
				if("Forage for Food Toggle")
					if(!src.Search_active)
						src.Search_active = 1
						src.Search2Food()
					else
						src.Search_active = 0*/