obj
	sign
		name = "sign"
		icon_state = "sign"
		density=1
		anchored=1
		var/Message=""
		var/buildinghealth = 10
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
			usr << output(null, "sign.output")
			winset(usr, "sign", "title=\"[src.name]\"")
			winshow(usr, "sign")
			usr << output(censorText(src.Message), "sign.output")
			..()
		verb
			Engrave()
				set src in view(1)
				if(usr.shackled==1) return
				var/newmsg=input(usr,"What do you want to engrave?","Sign","[src.Message]") as message
				Message=newmsg
		Dungeon_Entrence
			name="Dungeon Ahead!"
			Message = "Welcome to the dungeon"
	gravestone
		name = "gravestone"
		icon = 'icons/turfs.dmi'
		icon_state = "gsign"
		density=1
		anchored=1
		var/Message=""
		var/buildinghealth = 10
		DblClick()
			if(usr.z==1) return
			if(usr.shackled==1) return
			if(get_dist(src,usr) <= 1)
				if(buildinghealth >= 1)
					if(usr.inHand(/item/weapon/sledgehammer))
						if(buildinghealth >= 1)
							hearers(usr) <<"[usr] hits the [src] with his Sledgehammer"
							buildinghealth-=1
						if(buildinghealth == 0)
							hearers(usr) <<"[usr] smashs the [src] down"
							del src
						return
			usr << output(null, "sign.output")
			winset(usr, "sign", "title=\"[src.name]\"")
			winshow(usr, "sign")
			usr << output(censorText(src.Message), "sign.output")
			..()
		verb
			Engrave()
				set src in view(1)
				if(usr.shackled==1) return
				var/newmsg=input(usr,"What do you want to engrave?","Gravestone","[src.Message]") as message
				Message=newmsg
turf
	icon = 'icons/Turfs.dmi'
	proc/Destroy()
	table
		name = "table"
		icon_state = "table"
		density = 1
		var/buildinghealth = 5
		Enter(atom/movable/A)
			if(istype(A, /projectile) || istype(A, /obj/cannonball)) return 1
			return ..()
		DblClick()
			if(!isturf(usr.loc)) return
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
							var/z = src.z
							src.Destroy()
							if(MapLayer(z) <= 0)
								new/turf/path(locate(src.x,src.y,src.z))
							else
								new/turf/sky(locate(src.x,src.y,src.z))
			..()
		north
			icon_state = "table"
			dir = NORTH
			density = 1
		east
			icon_state = "table"
			dir = EAST
			density = 1
		south
			icon_state = "table"
			dir = SOUTH
			density = 1
		west
			icon_state = "table"
			dir = WEST
			density = 1
		alone
			icon_state = "tableA"
			density = 1
		northeast
			icon_state = "table"
			dir = NORTHEAST
			density = 1
		northwest
			icon_state = "table"
			dir = NORTHWEST
			density = 1
		southeast
			icon_state = "table"
			dir = SOUTHEAST
			density = 1
		southwest
			icon_state = "table"
			dir = SOUTHWEST
			density = 1
		middle
			icon_state = "tableM"
			density = 1
obj
	table
		anchored=1
		name = "table"
		icon_state = "table"
		density = 1
		var/buildinghealth = 5
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
			..()
		north
			icon_state = "table"
			dir = NORTH
			density = 1
		east
			icon_state = "table"
			dir = EAST
			density = 1
		south
			icon_state = "table"
			dir = SOUTH
			density = 1
		west
			icon_state = "table"
			dir = WEST
			density = 1
		alone
			icon_state = "tableA"
			density = 1
		northeast
			icon_state = "table"
			dir = NORTHEAST
			density = 1
		northwest
			icon_state = "table"
			dir = NORTHWEST
			density = 1
		southeast
			icon_state = "table"
			dir = SOUTHEAST
			density = 1
		southwest
			icon_state = "table"
			dir = SOUTHWEST
			density = 1
		middle
			icon_state = "tableM"
			density = 1
obj
	icon = 'icons/Turfs.dmi'
	chair
		icon_state = "chair"
		name = "chair"
		anchored = 0
		var/buildinghealth = 5
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
			..()
		verb/rotate()
			set src in view(1)
			if(usr.restrained()) return
			dir = turn(dir, 90)
			if(dir == SOUTH) layer = OBJ_LAYER
			else layer = MOB_LAYER + 10
		south
			dir = SOUTH
		north
			dir = NORTH
			layer = MOB_LAYER+10
		east
			dir = EAST
			layer = MOB_LAYER+10
		west
			dir = WEST
			layer = MOB_LAYER+10

turf
	wooden
		var/buildinghealth = 1
		New()
			. = ..()
			if(buildinghealth == 1)
				buildinghealth = rand(10,15)
			spawn refresh_sky(src)
		Destroy()
			. = ..()
			refresh_sky(src)
		DblClick()
			if(!isturf(usr.loc)) return
			if(usr.shackled==1) return
			if(usr.z==1) return
			if(get_dist(src,usr) <= 1)
				if(buildinghealth >= 1)
					if(usr.inHand(/item/weapon/axe))
						if(buildinghealth >= 1)
							hearers(usr) <<"[usr] cuts the [src]"
							buildinghealth-=1
						if(buildinghealth == 0)
							hearers(usr) <<"[usr] smashs the [src] down"
							var/z = src.z
							src.Destroy()
							if(MapLayer(z) <= 0)
								new/turf/path(locate(src.x,src.y,src.z))
							else
								new/turf/sky(locate(src.x,src.y,src.z))
			..()

		icon = 'icons/wood.dmi'
/*		staircase
			icon_state = "staircase"
			Entered()
				if(usr.z != worldz)
					usr.descend() */
		wood_window_wall
			icon_state = "none"
			density = 1
			name="windowed wood wall"
		wood_windowed_wall
			name="windowed wood wall"
			icon_state = "sclosed"
			density=1
			opacity=1
			Click()
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(icon_state == "sopen")
						icon_state = "sclosed"
						sd_SetOpacity(1)
					else
						icon_state = "sopen"
						sd_SetOpacity(0)
				..()
		wood_wall
			icon_state = "wall"
			density=1
			opacity=1
			DblClick()
				. = ..()
				if(!(src in range(1, usr))) return
				usr.show_message("<tt>You push the wall but nothing happens!</tt>")
		wood_door
			var
				keyslot
				locked=0
				gold = 1
				mob/enchanted
			verb
				Knock()
					set src in oview(1)
					if(!(src in oview(1, usr)) || usr.restrained() || usr.CheckGhost()) return
					if(!ActionLock("knock", 5))
						hearers(src) << "\icon[src] *knock* *knock*"

			Inn_Door
				keyslot="inn"
				locked=1
				Inn_Door1
					keyslot="inn1"
				Inn_Door2
					keyslot="inn2"
				Inn_Door3
					keyslot="inn3"
				Inn_Door4
					keyslot="inn4"
				Inn_Door5
					keyslot="inn5"
				Inn_Door6
					keyslot="inn6"
				Inn_Door7
					keyslot="inn7"
				Inn_Door8
					keyslot="inn8"
				Inn_Door9
					keyslot="inn9"
				Inn_Door10
					keyslot="inn10"
				Inn_Door11
					keyslot="inn11"
				Inn_Door12
					keyslot="inn12"
				Inn_Door13
					keyslot="inn13"
				Inn_Door14
					keyslot="inn14"
			icon_state = "closed"
			density=1
			opacity=1
			attack_hand(mob/M)
				if(locked == 1)
					M.show_message("It's locked!")
					return
				if(icon_state == "open")
					icon_state = "closed"
					sd_SetOpacity(1)
					density=1
				else
					icon_state = "open"
					density=0
					sd_SetOpacity(0)
		wood_floor
			buildinghealth = 2
			icon_state = "floor"
			New()

		rope_bridge
			buildinghealth=5
			icon_state="bridge"
			DblClick()
				if(!isturf(usr.loc)) return
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(buildinghealth >= 1)
						if(usr.inHand(/item/weapon/axe))
							if(buildinghealth >= 1)
								hearers(usr) <<"[usr] cuts the [src]"
								buildinghealth-=1
							if(buildinghealth == 0)
								hearers(usr) <<"[usr] smashs the [src] down"
								var/z = src.z
								src.Destroy()
								if(MapLayer(z) <= 0)
									new/turf/water(locate(src.x,src.y,src.z))
								else
									new/turf/sky(locate(src.x,src.y,src.z))

	stone
		var/buildinghealth = 1
		New()
			. = ..()
			if(buildinghealth == 1)
				buildinghealth = rand(10,15)
			spawn refresh_sky(src)
		Destroy()
			. = ..()
			refresh_sky(src)
		DblClick()
			if(!isturf(usr.loc)) return
			if(usr.z==1) return
			if(usr.shackled==1) return
			if(get_dist(src,usr) <= 1)
				if(buildinghealth >= 1)
					if(usr.inHand(/item/weapon/sledgehammer))
						if(buildinghealth >= 1)
							hearers(usr) <<"[usr] hits the [src] with his Sledgehammer"
							buildinghealth-=1
						if(buildinghealth == 0)
							hearers(usr) <<"[usr] smashs the [src] down"
							var/z = src.z
							src.Destroy()
							if(MapLayer(z) <= 0)
								new/turf/path(locate(src.x,src.y,src.z))
							else
								new/turf/sky(locate(src.x,src.y,src.z))
			..()
		icon='icons/stone.dmi'
		stone_wall
			icon_state = "stone wall"
			density = 1
			opacity = 1
			DblClick()
				. = ..()
				if(!(src in range(1, usr))) return
				usr.show_message("<tt>You push the wall but nothing happens!</tt>")
		stained_glass_window
			var/hits = 0
			icon_state = "stwindow"
			density = 1
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(src.icon_state == "stwindow")
						if(hits <= 4)
							hearers() << "[usr] hits the stained glass window!"
							hits += 1
						else
							hearers() << "[usr] shatters the stained glass window!"
							src.icon_state = "stwindows"
							src.name = "stone wall"
				..()
		stone_floor
			buildinghealth = 2
			icon_state = "stone floor8"
		stone_door
			var
				keyslot
				locked=0
				gold = 1
				mob/enchanted
			Guard_Door
				keyslot=1
				locked=1
			Royal_Guard_Door
				keyslot=2
				locked=1
			Royal_Archer_Door
				keyslot=3
				locked=1
			Cook_Door
				keyslot=4
				locked=1
			Cell_Door
				keyslot=5
				locked=0
			Royal_Room_Door
				keyslot=6
				locked=0
			Watchman_Door
				keyslot=7
				locked=1
			Noble_Guard_Door
				keyslot=8
				locked=1
			Noble_Archer_Door
				keyslot=9
				locked=1
			Chef_Door
				keyslot=10
				locked=1
			Dungeon_Door
				keyslot = "cow_jailer"
				locked=0
			Royal_Door
				keyslot=12
				locked=0
			Inn_Door
				locked=1
				Inn_Door1
					keyslot="inn1"
				Inn_Door2
					keyslot="inn2"
				Inn_Door3
					keyslot="inn3"
				Inn_Door4
					keyslot="inn4"
				Inn_Door5
					keyslot="inn5"
				Inn_Door6
					keyslot="inn6"
				Inn_Door7
					keyslot="inn7"
				Inn_Door8
					keyslot="inn8"
				Inn_Door9
					keyslot="inn9"
				Inn_Door10
					keyslot="inn10"
				Inn_Door11
					keyslot="inn11"
				Inn_Door12
					keyslot="inn12"
				Inn_Door13
					keyslot="inn13"
				Inn_Door14
					keyslot="inn14"
			Necromancer
				keyslot = "necromancer"

			icon_state = "closed"
			density=1
			opacity=1
			attack_hand(mob/M)
				if(locked == 1)
					M.show_message("It's locked!")
					return
				if(icon_state == "open")
					icon_state = "closed"
					sd_SetOpacity(1)
					density=1
				else
					icon_state = "open"
					density=0
					sd_SetOpacity(0)
			verb
				Knock()
					set src in oview(1)
					if(!(src in oview(1, usr)) || usr.CheckGhost()) return
					if(!ActionLock("knock", 5))
						hearers(src) << "\icon[src] *knock* *knock*"
		stone_window_wall
			icon_state = "none"
			density = 1
			name="windowed stone wall"
		stone_windowed_wall
			name="windowed stone wall"
			icon_state = "sclosed"
			density=1
			opacity=1
			Click()
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(icon_state == "sopen")
						icon_state = "sclosed"
						sd_SetOpacity(1)
					else
						icon_state = "sopen"
						sd_SetOpacity(0)
				..()



obj
	wooden
		anchored=1
		fence
			name="Fence"
			icon_state = "fence"
			density=1
			buildinghealth=4
		gate
			name="Gate"
			icon_state = "fence close"
			density=1
			buildinghealth=4
			Click()
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(icon_state == "fence open")
						icon_state = "fence close"
						density=1
					else
						icon_state = "fence open"
						density=0
				..()
		var/buildinghealth = 1
		New()
			..()
			if(buildinghealth == 1)
				buildinghealth = rand(10,15)
		DblClick()
			if(usr.shackled==1) return
			if(get_dist(src,usr) <= 1)
				if(buildinghealth >= 1)
					if(usr.inHand(/item/weapon/axe))
						if(buildinghealth >= 1)
							hearers(usr) <<"[usr] cuts the [src]"
							buildinghealth-=1
						if(buildinghealth == 0)
							hearers(usr) <<"[usr] smashs the [src] down"
							del src
			..()

		icon = 'icons/wood.dmi'
		wood_window_wall
			icon_state = "none"
			density = 1
			name="windowed wood wall"
		wood_windowed_wall
			name="windowed wood wall"
			icon_state = "sclosed"
			density = 1
			opacity=1
			Click()
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(icon_state == "sopen")
						icon_state = "sclosed"
						density = 1
						sd_SetOpacity(1)
					else
						icon_state = "sopen"
						density = 1
						sd_SetOpacity(0)
				..()
		wood_wall
			icon_state = "wall"
			density = 1
			opacity=1
		wood_door
			var
				keyslot
				locked=0
				gold = 1
				mob/enchanted
			icon_state = "closed"
			density = 1
			opacity=1
			attack_hand(mob/M)
				if(locked == 1)
					M.show_message("It's locked!")
					return
				if(icon_state == "open")
					icon_state = "closed"
					sd_SetOpacity(1)
					density=1
				else
					icon_state = "open"
					density=0
					sd_SetOpacity(0)
			verb
				Knock()
					set src in oview(1)
					if(!(src in oview(1, usr)) || usr.CheckGhost()) return
					if(!ActionLock("knock", 5))
						hearers(src) << "\icon[src] *knock* *knock*"
		wood_floor
			buildinghealth = 2
			icon_state = "floor"

	stone
		anchored=1
		var/buildinghealth = 1
		New()
			if(buildinghealth == 1)
				buildinghealth = rand(10,15)
		DblClick()
			if(usr.shackled==1) return
			if(get_dist(src,usr) <= 1)
				if(buildinghealth >= 1)
					if(usr.inHand(/item/weapon/sledgehammer))
						if(buildinghealth >= 1)
							hearers(usr) <<"[usr] hits the [src] with his Sledgehammer"
							buildinghealth-=1
						if(buildinghealth == 0)
							hearers(usr) <<"[usr] smashs the [src] down"
							del src
			..()
		icon='icons/stone.dmi'
		stone_wall
			icon_state = "stone wall"
			density = 1
			opacity = 1
		stained_glass_window
			var/hits = 0
			icon_state = "stwindow"
			density = 1
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(src.icon_state == "stwindow")
						if(hits <= 4)
							hearers() << "[usr] hits the stained glass window!"
							hits += 1
						else
							hearers() << "[usr] shatters the stained glass window!"
							src.icon_state = "stwindows"
							src.name = "stone wall"
				..()
		stone_floor
			buildinghealth = 2
			icon_state = "stone floor8"
		stone_door
			var
				keyslot
				locked=0
				gold = 1
				mob/enchanted

			icon_state = "closed"
			density=1
			opacity=1
			attack_hand(mob/M)
				if(locked == 1)
					M.show_message("It's locked!")
					return
				if(icon_state == "open")
					icon_state = "closed"
					sd_SetOpacity(1)
					density=1
				else
					icon_state = "open"
					density=0
					sd_SetOpacity(0)
			verb
				Knock()
					set src in oview(1)
					if(!(src in oview(1, usr)) || usr.CheckGhost()) return
					if(!ActionLock("knock", 5))
						hearers(src) << "\icon[src] *knock* *knock*"
		stone_window_wall
			icon_state = "none"
			density = 1
			name="windowed stone wall"
		stone_windowed_wall
			name="windowed stone wall"
			icon_state = "sclosed"
			density = 1
			opacity=1
			Click()
				if(usr.shackled==1) return
				if(get_dist(src,usr) <= 1)
					if(icon_state == "sopen")
						icon_state = "sclosed"
						sd_SetOpacity(1)
					else
						icon_state = "sopen"
						sd_SetOpacity(0)
				..()
turf
	Misc
		Void_Wall
			name = ""
			icon = 'Void Wall.dmi'
			icon_state = "stone floor8"
			density = 1
			opacity = 1