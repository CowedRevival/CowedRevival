var/global
	log_name
	chat_log = "<STYLE> body{background:black; color:white}</STYLE>"

world/New()
	..()

mob/var/letters_said=0
var/oocon=1
mob
	/*Bump(mob/M)
		..()
		if(istype(M))
			if(locate(/mob) in get_step(M,M.dir))
				var/mob/M2 = locate(/mob) in get_step(M,src.dir)
				if(M2 && M2.density)
					M.dir = src.dir
					return
			M.dir=src.dir
			step(M,M.dir)*/