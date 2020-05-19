/obj/door
	icon = 'icons/wood.dmi'
	var/keyslot
	var/locked=0
	var/gold = 1
	var/mob/enchanted = null

	var/material = null		//The material this door is made of. EX: Wood, Stone, Void
	var/buildinghealth = 1
	name = "door"
	icon_state = "closed"
	density = 1
	opacity = 1
	anchored = 1

	New()
		..()
		new/turf/wooden/wood_floor(src.loc)

	Bump(var/mob/M as mob)
		world << M.name
		open(M)
		..()

	verb/Knock()
		set src in oview(1)
		if(!(src in oview(1, usr)) || usr.CheckGhost()) return
		if(!ActionLock("knock", 5))
			hearers(src) << "\icon[src] *knock* *knock*"

	//try to open the door
	proc/open(var/mob/M)
		if (!density)
			return
		if(locked == 1)
			if (istype(M))
				M.show_message("It's locked!")
			return
		
		density=0
		sd_SetOpacity(0)
		icon_state = "open"

	proc/close(var/mob/M)
		if (density)
			return

		sd_SetOpacity(1)
		density=1
		icon_state = "closed"

	attack_hand(mob/M)
		if (density)
			open(M)
		else
			close(M)

/obj/door/wood
	name = "wooden door"
	icon = 'icons/wood.dmi'
	material = "wood"

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

/obj/door/stone
	name = "stone door"
	icon = 'icons/stone.dmi'
	material = "stone"

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
