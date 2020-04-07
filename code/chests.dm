turf/flooring
	icon='icons/Turfs.dmi'
	icon_state="florring"
var/currentkeynumber=30
obj/Misc

obj
	icon = 'icons/Turfs.dmi'
	chest
		var
			buildinghealth = 20
			list/opened_by
		New()
			..()
			spawn(1)
				for(var/atom/movable/E in src.loc)
					if(istype(E,/obj))
						if(!E.anchored)
							E.loc=src
		Del()
			for(var/mob/M in src.contents)
				M.Move(src.loc, forced = 1)
			return ..()
		proc
			open()
				icon_state = "chest open"
				for(var/atom/movable/E in src.contents)
					E.Move(src.loc, forced = 1)
			close()
				icon_state = "chest closed"
				for(var/atom/movable/E in src.loc)
					if(E != src && !E.anchored) E.Move(src, forced = 1)
		Guard_Chest
			keyslot=1
			locked=1
		Royal_Guard_Chest
			keyslot=2
			locked=1
		Royal_Archer_Chest
			keyslot=3
			locked=1
		Cook
			keyslot=4
			locked=1
		Watchman_Chest
			keyslot=7
			locked=1
		Noble_Guard_Chest
			keyslot=8
			locked=1
		Noble_Archer_Chest
			keyslot=9
			locked=1
		Chef
			keyslot=10
			locked=1
		Jailer_Chest
			keyslot="bov_jailer"
			locked=1
		BCM_Chest
			keyslot = "bov_bcm"
			locked = 1
			cowmalot
				keyslot = "cow_bcm"


		icon = 'icons/Turfs.dmi'
		icon_state = "chest closed"
		layer = OBJ_LAYER -0.5
		density=1
		var
			keyslot
			locked=0
		Click(mob/M)
			if(usr.shackled==1) return
			if(get_dist(src,usr) <= 1)
				if(usr.loc == src) return
				if(locked == 1)
					usr.show_message("It's locked!")
					return
				if(icon_state == "chest closed" && !locked)
					if(!opened_by) opened_by = new/list()
					if(!(usr.key in opened_by)) opened_by += usr.key
					open()
				else if(icon_state == "chest open") close()
		present
			var/present = 0
			New()
				. = ..()
				present = rand(1, 3)
				icon_state = "present[present] closed"
			Click(mob/M)
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(usr.loc == src) return
					if(locked == 1)
						usr.show_message("It's locked!")
						return
					if(icon_state == "present[present] closed" && !locked) open()
					else if(icon_state == "present[present] open") close()
			open()
				icon_state = "present[present] open"
				for(var/atom/movable/E in src.contents)
					E.Move(src.loc, forced = 1)
			close()
				icon_state = "present[present] closed"
				for(var/atom/movable/E in src.loc)
					if(E != src && !E.anchored) E.Move(src, forced = 1)
		cupboard
			icon = 'icons/wood64x32.dmi'
			icon_state = "cupboard0"
			pixel_x = -16
			pixel_y = 4
			density = 1
			anchored = 1
			DblClick()
				if(usr.z==1) return
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(buildinghealth >= 1)
						if(usr.inHand(/item/weapon/axe))
							if(buildinghealth >= 1)
								hearers(usr) <<"[usr] chops the [src]"
								buildinghealth-=1
							if(buildinghealth == 0)
								hearers(usr) <<"[usr] cuts the [src] down"
								del src
							return
				..()
			New()
				. = ..()
				overlays += image(icon = 'icons/wood.dmi', icon_state = "cupboard", pixel_x = 20, pixel_y = 32)
			Click(mob/M)
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(usr.loc == src) return
					if(locked == 1)
						usr.show_message("It's locked!")
						return
					if(icon_state == "cupboard0" && !locked) open()
					else if(icon_state == "cupboard1") close()
			open()
				icon_state = "cupboard1"
				for(var/atom/movable/E in src.contents)
					E.Move(src.loc, forced = 1)
			close()
				icon_state = "cupboard0"
				for(var/atom/movable/E in src.loc)
					if(E != src && !E.anchored) E.Move(src, forced = 1)