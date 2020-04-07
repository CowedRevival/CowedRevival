obj/Cannon
	density=1
	icon='icons/Cannon.dmi'
	dir=SOUTH
	var/loadtype="none"
	verb
		Load_Cannon()
			set category="Cannon"
			set src in oview(1)
			if(usr.shackled==1) return
			if(src.loadtype!="none") return
			switch(input("What type of Ammunition would you like to load?") in list("Field Ball","Grapeshot","Nevermind"))
				if("Field Ball")
					var/item/misc/stone/S=locate() in usr
					if(S)
						if(--S.stacked <= 0) del S
						src.loadtype="field"
					else
						return
				if("Grapeshot")
					var/item/misc/molten_iron/S=locate() in usr
					if(S)
						if(--S.stacked <= 0) del S
						src.loadtype="grape"
					else
						return
				if("Nevermind") return
			for(var/mob/N in ohearers(usr))
				N.show_message("<font color=blue>[usr.name] loads the cannon.")
			usr.show_message("<font color=blue>You load the cannon.")
		Turn_Cannon_Right()
			set category="Cannon"
			set src in oview(1)
			if(usr.shackled==1) return
			src.dir=turn(src.dir,-45)
		Turn_Cannon_Left()
			set category="Cannon"
			set src in oview(1)
			if(usr.shackled==1) return
			src.dir=turn(src.dir,45)
	DblClick()
		if(get_dist(src,usr)>1) return
		if(src.loadtype=="none") return
		if(usr.shackled==1) return
		usr.show_message("<font color=blue>You fire the cannon.")
		for(var/mob/N in ohearers(usr))
			N.show_message("<font color=blue>[usr.name] fires the cannon.")
		play_sound(src, hearers(src, 15), sound(pick('sounds/cannon/cannon_1.ogg', 'sounds/cannon/cannon_2.ogg', 'sounds/cannon/cannon_3.ogg', 'sounds/cannon/cannon_4.ogg', 'sounds/cannon/cannon_5.ogg', 'sounds/cannon/cannon_6.ogg')), falloff = 3)
		var/obj/cannonball/C=new(src.loc)
		C.T=src.loadtype
		C.dir=src.dir
		src.loadtype="none"
obj/cannonball
	icon='icons/Cannon.dmi'
	icon_state="ball"
	var/T
	var/hp=8
	density=1
	New()
		sleep(1)
		spawn for()
			step(src,src.dir)
			sleep(1)
			src.hp--
			if(src.hp==0)
				del src
	Bump(atom/M)
		if(istype(M,/mob/))
			var/mob/m=M
			m.HP-=75
			m.last_hurt = "cannon"
			hud_main.UpdateHUD(m)
			m.checkdead(m)
			del src
		if(istype(M,/turf/))
			if(M.density==1)
				if(M.opacity==1)
					var/turf/t=M
					if(istype(t,/turf/wooden/))
						var/turf/wooden/w=t
						w.buildinghealth-=10
						if(src.T=="grape")
							w.buildinghealth-=30
						if(w.buildinghealth<=0)
							new/turf/path(locate(w.x,w.y,w.z))
					if(istype(t,/turf/stone/))
						var/turf/stone/w=t
						w.buildinghealth-=6
						if(src.T=="grape")
							w.buildinghealth-=18
						if(w.buildinghealth<=0)
							new/turf/path(locate(w.x,w.y,w.z))
					del src
				if(M.opacity==0)
					src.loc=locate(M.x,M.y,M.z)
		if(istype(M,/obj/))
			if(M.density==1)
				if(M.opacity==1)
					var/obj/o=M
					if(istype(o,/obj/wooden/) || istype(o, /obj/chest))
						var/obj/wooden/w=o
						w.buildinghealth-=10
						if(src.T=="grape")
							w.buildinghealth-=30
						if(w.buildinghealth<=0)
							del w
					if(istype(o,/obj/stone/))
						var/obj/stone/w=o
						w.buildinghealth-=6
						if(src.T=="grape")
							w.buildinghealth-=18
						if(w.buildinghealth<=0)
							del w
					del src
				if(M.opacity==0||M.name=="tree")
					src.loc=locate(M.x,M.y,M.z)
