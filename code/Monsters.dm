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
	HP=100
	defence=2
	isMonster=1
	New()
		..()
		src.Frog()

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
			if(!istype(M,/mob/observer) && M.name!="Zombie"&&M.isMonster==0)
				m=M
		if(m&&src.legshackled==0)
			step_towards(src,m)
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
			if(M.name!="Zombie"&&!findtext(M.name,"corpse"))
				if(src.shackled==0&&M.isMonster==0)
					for(var/mob/N in ohearers(src))
						N.show_message("[src] attacks [M].")
					M.HP-=3
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
	if(icon_state != "dead")
		spawn(world.tick_lag)
			Frog()
	if(HP <= 0) return
	if(action_timer <= 0)
		action_timer = 100 - speed
		if(action_timer == 0)
			action_timer = 5
		var/mob/m
		for(var/mob/M in oview(10))
			if(!istype(M,/mob/observer) && M.name!="Frogman"&&M.isMonster==0)
				m=M
		if(m&&src.legshackled==0)
			step_towards(src,m)
		else if(src.legshackled==0)
			step_rand(src)
		for(var/mob/M in oview(1))
			if(M.name!="Frogman"&&!findtext(M.name,"corpse"))
				if(src.shackled==0&&M.isMonster==0)
					for(var/mob/N in ohearers(src))
						N.show_message("[src] attacks [M].")
					M.HP-=7
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
			if(!istype(M,/mob/observer) && M.name!="[src.name]"&&M.isMonster==0)
				m=M
		if(m&&src.legshackled==0)
			src.icon=src.OLDICON
			step_towards(src,m)
		else if(src.legshackled==0)
			src.icon='icons/Void Turfs.dmi'
		for(var/mob/M in oview(1))
			if(M.name!="[src.name]"&&!findtext(M.name,"corpse"))
				if(src.shackled==0&&M.isMonster==0)
					for(var/mob/N in ohearers(src))
						N.show_message("[src] attacks [M].")
					M.HP-=src.strength
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
		strength = 5
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
		strength = 8
		speed = 40
		as_mob_update_speed = 20
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
		strength = 2
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
			if(!istype(M,/mob/observer) && M.name!="Hell Spawn"&&M.isMonster==0)
				m=M
		if(m&&src.legshackled==0)
			step_towards(src,m)
		else if(src.legshackled==0)
			step_rand(src)
		for(var/mob/M in oview(1))
			if(M.name!="Hell Spawn"&&!findtext(M.name,"corpse"))
				if(src.shackled==0&&M.isMonster==0)
					for(var/mob/N in ohearers(src))
						N.show_message("[src] attacks [M].")
					M.HP-=15
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
			step_towards(src,m)
		else if(src.legshackled==0)
			step_rand(src)
		for(var/mob/M in oview(1))
			if(!istype(M,/mob/Shroom_Monster) && !findtext(M.name,"corpse"))
				if(src.shackled==0&&M.isMonster==0)
					for(var/mob/N in ohearers(src))
						N.show_message("[src] attacks [M].")
					M.HP-=7
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
			HP = 100
			defence = 2
			strength = 5
		if(prob(20))
			for(var/mob/N in ohearers(src))
				N.show_message("[src] grows into a Shroom Brute, dear god!")
			name = "Shroom Brute [Monster_Name_Generator()]"
			icon = 'icons/shroom_brute.dmi'
			tag = "shroom_brute"
			HP = 200
			defence = 2
			strength = 8
			speed = 40

mob/proc/Monster_Name_Generator()
	var/monster_name = pick("Val", "Varn", "Gorg", "Kar", "Marn", "Morsh", "Zorg", "Zarlg", "Ki", "Glu", "Glox")
	monster_name += pick("kur", "jorg", "ban", "zar", "zol", "man", "harl", "arg", "zak", "lorg", "barn", "glax")
	if(prob(50)) monster_name += pick("carn", "zarn", "orio", "ow", "kal", "sal", "sol", "vol", "tor", "zorg", "tan")
	if(prob(50)) monster_name += pick(" The 1st", " The 2nd", " The 3rd", " The [rand(1,100)]th", " The World's Bane", " The Man Eater" , " The Apocalypse", " The Timid")
	return monster_name
