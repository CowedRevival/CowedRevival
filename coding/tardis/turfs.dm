area/tardis
	sd_lighting = 0
	music = 'sounds/music/tardishum.ogg'
	music_volume = 15
	music_flags = FLAG_REPEAT|FLAG_STREAM

turf/tardis
	icon = 'icons/tardis/tardis.dmi'
	floor
		icon_state = "floor"
	wall
		icon_state = "wall1"
		density = 1
		opacity = 1
	void
		icon_state = "void"
		New()
			. = ..()
			for(var/obj/O in src) O.Move(null, forced = 1)
			for(var/mob/M in src)
				M.HP = 0
				M.checkdead(M)
		Enter(atom/movable/A)
			if(istype(A, /obj/tardis)) return 1
			if(ismob(A))
				var/mob/M = A
				M.HP = 0
				M.checkdead(M)
			else A.Move(null, forced = 1)
	true_void
		name = "void"
		icon_state = "void"
		New()
			. = ..()
			for(var/obj/O in src) O.Move(null, forced = 1)
			for(var/mob/M in src)
				M.HP = 0
				M.checkdead(M)
				spawn(100)
					if(M.loc == src.loc) del M
		Enter(atom/movable/A)
			if(istype(A, /obj/tardis)) return 1
			if(ismob(A))
				var/mob/M = A
				M.HP = 0
				M.checkdead(M)
				spawn(100)
					if(M.loc == src.loc) del M
			else A.Move(null, forced = 1)