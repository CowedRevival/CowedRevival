obj/gate
	icon = 'icons/Turfs.dmi'
	anchored = 1
	var
		id
	gate
		name = "Gate"
		density = 1
		var
			buildinghealth = 120
		gate_l
			icon_state = "gate-l"
		gate_m
			icon_state = "gate-m"
			layer = FLY_LAYER
		gate_r
			icon_state = "gate-r"

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
							for(var/obj/gate/gate/O in range(2, src))
								if(O.id == src.id)
									O.Move(null, forced = 1)
			..()
	lever
		icon_state = "lever0"
		attack_hand(mob/M)
			src.icon_state = src.icon_state == "lever0" ? "lever1" : "lever0"
			for(var/obj/gate/lever/O in world)
				if(O.z != src.z && O.z != undergroundz && O.z != worldz && O.z != skyz) continue
				if(O.id == src.id && O != src) O.icon_state = src.icon_state

			for(var/obj/gate/gate/O in world)
				if(O.z != src.z && O.z != undergroundz && O.z != worldz && O.z != skyz) continue
				if(O.id == src.id)
					O.icon_state = initial(O.icon_state)
					O.density = 1

					if(icon_state == "lever1") //open
						O.icon_state = "[O.icon_state]1"
						if(istype(O, /obj/gate/gate/gate_m)) O.density = 0