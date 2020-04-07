mob/AI
	isMonster=1
	chosen=1
	loggedin=1
	checkdead(mob/M)
		if(src.HP<=0)
			if(!client)
				Dead_Stuff()
			else ..()
	proc
		Pre_Loop()
		Loop()
		Dead_Stuff()
			src.density=0
			spawn(200)
				if(src) del src

	New()
		..()
		Pre_Loop()
		if(src) spawn Loop()