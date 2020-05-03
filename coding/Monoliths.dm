obj/monolith
	icon = 'icons/Monolith.dmi'
	icon_state = "monolith_1"
	density = 1
	var
		max_charge
		charge
	var/ready
	var/recharge_time
	var/list/access_list
	var/monolith_type

	New()
		name = "[pick("Strange","Odd", "Imposing", "Powerful", "Useless", "Eldritch", "Maddening", "Devouring", "Quiet", "Humming", "Old", "Frogman", "Cow")] Monolith"
		icon_state = "monolith_[rand(1,6)]"
		recharge_time = rand(1000,10000)
		max_charge = rand(3,9)
		charge = max_charge
		access_list = new()
		spawn()Monolith_Recharge()

	DblClick()
		if(usr.shackled==1) return
		if(get_dist(src,usr) <= 1)
			usr.SetAction(src)

	verb/Check()
		set src in view(1)
		if(prob(usr.skills.research))
			usr << "<small>Could be [monolith_type]</small>"
		else if(prob(33))
			usr << "<small>Could be Beneficial</small>"
		else if(prob(33))
			usr << "<small>Could be Hazardous</small>"
		else
			usr << "<small>Could be Benign</small>"

	proc/ActionLoop(mob/M)
		Invoke_Monolith(M)

	proc/Invoke_Monolith(var/mob/M)
		if(!ready)
			M << "<small>The monolith's power is low, give it some time.</small>"
			M.current_action = null
			return
		if(M.name in access_list)
			hearers(M) << "<small>[M.name] activates the Monolith!</small>"
			spawn() Monolith_Action(M)
			charge = 0
		else
			hearers(M) << "<small>[M.name] begins to study the Monolith!</small>"
			sleep(50)
			if(M && M.current_action == src && loc)
				if(prob((M.skills.research/2) + 5) && !(M.name in access_list))
					M << "<font color=\"red\"><big>You now understand the true power of the monolith!"
					if(!(M.name in access_list)) access_list += M.name
				else
					M << "<small>You fail to study the monolith...</small>"
				if(M.skills.research < 100 && prob(100 - (M.skills.research*0.75)))
					M.skills.research++
		if(M && M.current_action == src && loc)
			if(charge > 0)
				charge--
				M.SLEEP -= 10
				if(M.SLEEP < 0) M.SLEEP = 0
				hearers(src) << "<small>[name] seems to dim a little...</small>"
			if(charge <= 0) spawn() Monolith_Recharge()
			M.current_action = null

	proc/Monolith_Action(var/mob/M)
		return

	proc/Monolith_Recharge()
		sd_SetLuminosity(0)
		src.Play_Sound_Local(pick('sounds/sfx/power_down_v2.ogg'))
		ready = 0
		overlays = new()
		sleep(recharge_time)//rand(1000,5000))
		overlays += image(icon = 'icons/Monolith.dmi', icon_state = "monolith_glow")
		ready = 1
		charge = max_charge
		src.Play_Sound_Local(pick('sounds/sfx/power_up_v2.ogg'))
		sd_SetLuminosity(3)

	Swap_Monolith
		monolith_type = "Benign"
		Monolith_Action(var/mob/M)
			for(var/mob/I in view(5))
				if(M != I && I.HP > 0)
					M << "<small>You've swapped forms with something nearby!</small>"
					if(I.client)
						var/mob/Z = new()
						Z.client = I.client
						I.client = M.client
						M.client = Z.client
						del(Z)
					else
						I.client = M.client
					return
			M << "<small>Nothing happened...</small>"

	Ressurection_Monolith
		monolith_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/mob/I in view(5))
				if(M != I && I.HP <= 0 && I.corpse)
					hearers(src) << "<small>[M.name] returns to life!</small>"
					I.revive()
					return
			M << "<small>Nothing happened...</small>"

	Death_Monolith
		monolith_type = "Hazardous"
		Monolith_Action(var/mob/M)
			if(M.death_mon_curse && M.tag != "Meat Cube") return
			M << "<small>You've gained new powers but feel incredibly odd...</small>"
			M.death_mon_curse = 1
			spawn(1000) Curse(M)

		proc/Curse(var/mob/M)
			sleep(1000)
			if(M.HP <= 0) return
			M << "<font color=\"red\"><small>You don't feel so good...</small>"
			sleep(1000)
			if(M.HP <= 0) return
			M << "<font color=\"red\"><small>Your skin feels wrong...</small>"
			sleep(1000)
			if(M.HP <= 0) return
			M << "<font color=\"red\"><small>The hunger... You need to eat fresh meat...</small>"
			sleep(1000)
			if(M.HP <= 0) return
			M << "<font color=\"red\"><small>Your bones are itchy...</small>"
			sleep(1000)
			hearers(M) << "<font color=\"red\">[M.name]'s skin rots and falls from their body, leaving nothing but a cursed skeletal monster! Now you will know why you fear the night!"
			if(M.HP <= 0) return
			M.name = "[M.name] the Damned One"
			M.tag = "Skeleton"
			M.icon = 'icons/Skeleton.dmi'
			M.MHP = 400
			M.HP = 400
			M.MHUNGER = 99999
			M.MTHIRST = 99999
			M.MSLEEP = 99999
			M.HUNGER = M.MHUNGER
			M.THIRST = M.MTHIRST
			M.SLEEP = M.MSLEEP
			M.corpse = null
			M.icon_state = "alive"
			M.UpdateClothing()
			M.Damned_One()

	Meat_Cube_Monolith
		monolith_type = "Hazardous"
		Monolith_Action(var/mob/M)
			hearers(M) << "<font color=\"red\"><big>[M.name]'s body is crushed by unknown forces till it becomes some kind of cube of meat, how horrifying!"
			M.name = "[M.name] the Meat Cube"
			M.tag = "Meat Cube"
			M.icon = 'icons/meat_cube.dmi'
			M.equip_deny = 1
			M.speech_change = "H-Help meeee..."
			M.speed = 20
			M.MHP = 100
			M.HP = 100
			M.MHUNGER = 99999
			M.MTHIRST = 99999
			M.MSLEEP = 99999
			M.HUNGER = M.MHUNGER
			M.THIRST = M.MTHIRST
			M.SLEEP = M.MSLEEP
			M.UpdateClothing()

	Necromantic_Monolith
		monolith_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/proto_necromancer))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You now understand the secrets of life and death!</small>"
			M.learn_spell(/spell/proto_necromancer, 1)

	Portal_Monolith
		monolith_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/portal))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You now understand the secrets of portals!</small>"
			M.learn_spell(/spell/portal, 1)

	Eclipse_Monolith
		monolith_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/eclipse))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You understand the secrets of darkness!</small>"
			M.learn_spell(/spell/eclipse, 1)

	Fire_Monolith
		monolith_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/fireball))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You understand the secrets of fire!</small>"
			M.learn_spell(/spell/fireball, 1)

	Ice_Monolith
		monolith_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/iceball))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You understand the secrets of ice!</small>"
			M.learn_spell(/spell/iceball, 1)

	Zap_Monolith
		monolith_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/zap))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You understand the secrets of lightning!</small>"
			M.learn_spell(/spell/zap, 1)

	Hunger_Fill_Monolith
		monolith_type = "Beneficial"
		Monolith_Action(var/mob/M)
			M.HUNGER += 50
			if(M.HUNGER > M.MHUNGER) M.HUNGER = M.MHUNGER
			M << "<small>You feel your stomach fill!</small>"

	Hunger_Empty_Monolith
		monolith_type = "Hazardous"
		Monolith_Action(var/mob/M)
			M.HUNGER -= 50
			if(M.HUNGER < 0) M.HUNGER = 0
			M << "<small>You feel your stomach empty!</small>"

	Random_Monolith
		New()
			if(prob(90))
				if(prob(50)) new/obj/monolith/Hunger_Empty_Monolith(src.loc)
				else new/obj/monolith/Hunger_Fill_Monolith(src.loc)
			else if(prob(40))
				if(prob(33)) new/obj/monolith/Swap_Monolith(src.loc)
				else if(prob(33)) new/obj/monolith/Death_Monolith(src.loc)
				else if(prob(33)) new/obj/monolith/Ressurection_Monolith(src.loc)
				else if(prob(1)) new/obj/monolith/Meat_Cube_Monolith(src.loc)
				else new/obj/monolith/Hunger_Fill_Monolith(src.loc)
			else
				if(prob(33)) new/obj/monolith/Zap_Monolith(src.loc)
				else if(prob(33)) new/obj/monolith/Ice_Monolith(src.loc)
				else if(prob(33)) new/obj/monolith/Fire_Monolith(src.loc)
				else if(prob(33)) new/obj/monolith/Eclipse_Monolith(src.loc)
				else if(prob(33)) new/obj/monolith/Portal_Monolith(src.loc)
				else new/obj/monolith/Necromantic_Monolith(src.loc)
			loc = null

/*admin/verb/Posses(mob/M in world)
	M.client = usr.client*/