mob
	var/isMonster=0
	var/OLDICON
	var/infection=0
	var/as_mob_update_speed = 30
	var/action_timer = 0
mob/Zombie
	icon='icons/Zombie.dmi'
	icon_state="alive"
	HP=30
	defence=1
	strength = 8
	isMonster=1
	New()
		..()
		src.Zombie()
mob/Frogman
	icon='icons/Frogman.dmi'
	icon_state="alive"
	HP=50
	defence=1
	isMonster=1
	var/equipment_chance = 25
	New()
		..()
		if(prob(equipment_chance))
			rhand += new/item/weapon/spear
			contents += new/item/weapon/spear
		else if(prob(equipment_chance))
			rhand += new/item/weapon/cutlass
			contents += new/item/weapon/cutlass

		if(prob(equipment_chance))
			bequipped += new/item/armour/body/wood_torso
			contents += new/item/armour/body/wood_torso
		else if(prob(equipment_chance))
			bequipped += new/item/armour/body/copper_plate
			contents += new/item/armour/body/copper_plate

		UpdateClothing()
		src.Frog()

	Frogman_King
		icon = 'icons/frogman_king.dmi'
		equipment_chance = 0
		HP = 200
		defence = 25

		var
			list/spawned_children
			max_no_of_spawns = 5
			range = 8

		New()
			..()
			name = "Frogman King [Monster_Name_Generator()]"
			tag = name
			if(prob(50))
				rhand += new/item/weapon/palladium_sword
				contents += new/item/weapon/palladium_sword
			else
				rhand += new/item/weapon/gold_sword
				contents += new/item/weapon/gold_sword
			spawn(100)
				Respawn_Mobs()
			UpdateClothing()

		proc/Respawn_Mobs()
			if(HP <= 0) return
			else
				spawn(1000)
					Respawn_Mobs()
			var/mob/Frogman/Frogman_King/spawner = locate(tag)
			if(!spawner.loc) return
			if(!spawned_children) spawned_children = new()
			for(var/mob/I in spawned_children)
				if(I.icon_state == "dead")
					spawned_children -= I
			if(spawned_children.len < max_no_of_spawns)
				var/number_of_spawns = max_no_of_spawns - spawned_children.len
				for(var/i = 1 to number_of_spawns)
					var/x = spawner.loc.x + rand(-range, range)
					var/y = spawner.loc.y + rand(-range, range)
					var/z = spawner.loc.z
					var/turf/g = locate(x, y, z)
					if(!istype(g, /turf/water)) spawned_children += new/mob/Frogman(locate(x,y,z))

mob/proc/Zombie()
	usr=src
	if(icon_state != "dead")
		spawn(world.tick_lag)
			Zombie()
	if (HP <= 0) return
	if(action_timer <= 0)
		action_timer = 100 - speed
		if(action_timer == 0)
			action_timer = 5
		var/mob/m
		for(var/mob/M in oview(10))
			if(!istype(M,/mob/observer) && !istype(M,/mob/Zombie) && icon != 'icons/Skeleton.dmi' && M.HP > 0)
				m=M
		if(m&&src.legshackled==0)
			if(get_dist(src,m) > 1) step_towards(src,m)
		else if(src.legshackled==0)
			step_rand(src)
		for(var/turf/T in oview(1))
			if(T.density == 1&&istype(T,/turf/wooden/))
				for(var/mob/N in ohearers(src))
					N.show_message("[src] attacks [T].")
				var/turf/wooden/t=T
				t.buildinghealth-=1
				if(t.buildinghealth==0)
					new/turf/path(locate(t.x,t.y,t.z))
				break
		for(var/mob/M in oview(1))
			if(!istype(M,/mob/Zombie) && M.HP > 0&&!findtext(M.name,"corpse"))
				if(src.shackled==0)
					attackmode = "Attack"
					attack(M)
					M.last_hurt = "zombie"
					if(prob(100-usr.HP)&&infection_mode)
						M.infection+=1
						if(M.infection==1)
							world<<"<b>[M] has been infected!"
					M.checkdead(M)
					hud_main.UpdateHUD(M)
					M.checkdead(M)
					break
	else
		action_timer--

mob/proc/Frog()
	usr=src
	if(HP <= 0)
		frog_nation_anger += rand(1,3)
		if(frog_nation_anger > 20 && prob(frog_nation_anger))
			for(var/mob/Frogman/Frogman_King/K in world)
				return
			frog_nation_anger = -100
			var/nation_to_rise = pick("frog_nation_1", "frog_nation_2", "frog_nation_3")
			world << "<font color=green><b>The croaks of revolution echo across the land!</b></font>"
			for(var/obj/condition_spawn/frog_nation/I in world)
				if(I.tag == nation_to_rise) I.Execute()

		return
	if(icon_state != "dead")
		spawn(world.tick_lag)
			Frog()
	if(action_timer <= 0)
		action_timer = 100 - speed
		if(action_timer == 0)
			action_timer = 5
		var/mob/m
		for(var/mob/M in oview(10))
			if(!istype(M,/mob/observer) && !istype(M,/mob/Frogman) && M.HP > 0)
				m=M
		if(m&&src.legshackled==0)
			if(get_dist(src,m) > 1) step_towards(src,m)
		else if(src.legshackled==0)
			step_rand(src)
		for(var/mob/M in oview(1))
			if(!istype(M,/mob/Frogman) && M.HP > 0 && !findtext(M.name,"corpse"))
				if(src.shackled==0)
					attackmode = "Attack"
					attack(M)
					M.last_hurt = "frog"
					M.checkdead(M)
					hud_main.UpdateHUD(M)
					M.checkdead(M)
					break
		if(prob(1) && HP > 0)
			var/A=pick("Crooooooooak...","I will get you!","Viva la Frogs!","FROG NATION!")
			hearers(src)<<"<font color=green>Frogman says: [A]"
	else
		action_timer--

mob/proc/msntr()
	usr=src
	if(icon_state != "dead")
		spawn(world.tick_lag)
			msntr()
	if(HP <= 0) return
	if(action_timer <= 0)
		action_timer = 100 - speed
		if(action_timer == 0)
			action_timer = 5
		var/mob/m
		for(var/mob/M in oview(5))
			if(!istype(M,/mob/observer) && !istype(M,src) && M.HP > 0 )
				m=M
		if(m&&src.legshackled==0)
			src.icon=src.OLDICON
			if(get_dist(src,m) > 1) step_towards(src,m)
		else if(src.legshackled==0)
			src.icon='icons/Void Turfs.dmi'
		for(var/mob/M in oview(1))
			if(!istype(M,src) && M.HP > 0 &&!findtext(M.name,"corpse"))
				if(src.shackled==0)
					attackmode = "Attack"
					attack(M)
					M.checkdead(M)
					hud_main.UpdateHUD(M)
					M.checkdead(M)
					break
	else
		action_timer--

mob/Shroom_Monster
	icon='icons/shroom.dmi'
	icon_state="alive"
	var/age = 0
	var/MAXHP
	attack_speed = 5
	New()
		..()
		MAXHP = HP
	Shroom
		icon='icons/shroom.dmi'
		icon_state="alive"
		HP=100
		defence=2
		strength = 8
		isMonster=1
		age = 2
		New()
			..()
			tag = "shroom"
			src.Shroom()
			Shroom_Life_Cycle()

	Shroom_Brute
		icon='icons/shroom_brute.dmi'
		icon_state="alive"
		HP=200
		defence = 2
		strength = 15
		New()
			..()
			tag = "shroom_brute"
			name = "Shroom Brute [Monster_Name_Generator()]"
			src.Shroom()
			Shroom_Life_Cycle()


	Shroomling
		icon='icons/shroomling.dmi'
		icon_state="alive"
		HP=50
		defence=2
		strength = 4
		isMonster=1
		age = 0
		New()
			..()
			tag = "shroomling"
			src.Shroom()
			Shroom_Life_Cycle()
mob/Demon
	icon='icons/Demon.dmi'
	icon_state="alive"
	name = "Hell Spawn"
	HP=250
	defence=2
	strength = 20
	isMonster=1
	New()
		..()
		src.Demon()

mob/proc/Demon()
	if(HP <= 0) return
	if(icon_state != "dead")
		spawn(world.tick_lag)
			Demon()
	if(action_timer <= 0)
		action_timer = 100 - speed
		if(action_timer == 0)
			action_timer = 5
		var/mob/m
		for(var/mob/M in oview(10))
			if(!istype(M,/mob/observer) && !istype(M,/mob/Demon) && M.HP > 0 )
				m=M
		if(m&&src.legshackled==0)
			if(get_dist(src,m) > 1) step_towards(src,m)
		else if(src.legshackled==0)
			step_rand(src)
		for(var/mob/M in oview(1))
			if(!istype(M,/mob/Demon) && M.HP > 0 &&!findtext(M.name,"corpse"))
				if(src.shackled==0)
					attackmode = "Attack"
					attack(M)
					checkdead(M)
					hud_main.UpdateHUD(M)
					M.checkdead(M)
					break
	else
		action_timer--

mob/proc/Shroom()
	if(HP <= 0) return
	spawn(world.tick_lag)
		Shroom()
	if(action_timer <= 0)
		action_timer = 100 - speed
		if(action_timer == 0)
			action_timer = 5
		var/mob/m
		for(var/mob/M in oview(10))
			if(!istype(M,/mob/observer) && !istype(M,/mob/Shroom_Monster) && M.isMonster==0)
				m=M
		if(m&&src.legshackled==0)
			if(get_dist(src,m) > 1) step_towards(src,m)
		else if(src.legshackled==0)
			step_rand(src)
		for(var/mob/M in oview(1))
			if(!istype(M,/mob/Shroom_Monster) && !findtext(M.name,"corpse"))
				if(src.shackled==0)
					attackmode = "Attack"
					attack(M)
					checkdead(M)
					hud_main.UpdateHUD(M)
					M.checkdead(M)
					break
		if(prob(10))
			Play_Sound_Local(pick('sounds/sfx/meep1.ogg','sounds/sfx/meep2.ogg','sounds/sfx/meep3.ogg','sounds/sfx/meep4.ogg','sounds/sfx/meep5.ogg','sounds/sfx/meep6.ogg'))
	else
		action_timer--

mob/Shroom_Monster/proc/Shroom_Life_Cycle()
	if(HP <= 0) return
	spawn(1000)
		Shroom_Life_Cycle()
		age += 1
		HP += 25
		if(HP > MAXHP)
			HP = MAXHP
	if(age > 2 && tag == "shroomling")
		if(prob(80))
			for(var/mob/N in ohearers(src))
				N.show_message("[src] grows into a Shroom!")
			name = "Shroom"
			icon = 'icons/shroom.dmi'
			tag = "shroom"
			MAXHP = 100
			HP = 100
			defence = 2
			strength = 5
		if(prob(10))
			for(var/mob/N in ohearers(src))
				N.show_message("[src] grows into a Shroom Brute, dear god!")
			name = "Shroom Brute [Monster_Name_Generator()]"
			icon = 'icons/shroom_brute.dmi'
			tag = "shroom_brute"
			MAXHP = 200
			HP = 200
			defence = 2
			strength = 8

mob/proc/Monster_Name_Generator()
	var/monster_name = pick("Val", "Varn", "Gorg", "Kar", "Marn", "Morsh", "Zorg", "Zarlg", "Ki", "Glu", "Glox")
	monster_name += pick("kur", "jorg", "ban", "zar", "zol", "man", "harl", "arg", "zak", "lorg", "barn", "glax")
	if(prob(50)) monster_name += pick("carn", "zarn", "orio", "ow", "kal", "sal", "sol", "vol", "tor", "zorg", "tan")
	if(prob(50)) monster_name += pick(" The 1st", " The 2nd", " The 3rd", " The [rand(1,100)]th", " The World's Bane", " The Man Eater" , " The Apocalypse", " The Timid")
	return monster_name
