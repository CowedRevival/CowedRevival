var/animal/myAwesomeAnimal
animal
	parent_type = /mob
	attackmode = "Attack"
	var
		const
			MOOD_SCARED = -1 //flees from enemy
			MOOD_PEACEFUL = 0 //doesn't attack unless attacked
			MOOD_CURIOUS = 1 //wanders around
			MOOD_ANGRY = 2 //attacks an enemy
			MOOD_BLOODTHIRSTY = 3 //attacks on sight, very aggressive
		mood
		natural_mood = MOOD_PEACEFUL
		order
		const
			ORDER_NONE = 0
			ORDER_FOLLOW = 1
			ORDER_ATTACK = 2
		mob
			enemy

		//list of enemies & friends
		list
			enemies
			friends

		base_type
		const
			TYPE_CARNIVORE = 1
			TYPE_HERBIVORE = 2 //does not attack humans; eats good berries and all food
			TYPE_OMNIVORE = 3
		animal_type = TYPE_HERBIVORE
		runAI = TRUE
		mob/master
		age
		mood_timer = 0
		tmp
			there_can_be_only_one = 0
			pregnant = 0 //oh dear
			min_pop = 10
			max_pop = 25
	New(loc, disperse = 0)
		. = ..()
		verbs -= /mob/verb/loot
		if(map_loaded) there_can_be_only_one = TRUE
		spawn(25)
			//if(!worldz || (undergroundz != src.z && worldz != src.z && skyz != src.z)) return
			gender = pick(MALE, FEMALE, FEMALE)
			if(age == null) age = rand(0, 24)
			ActionLock("Age", rand(3000, 6000))
			CheckAge()

			if(disperse)
				if(!myAwesomeAnimal) myAwesomeAnimal = src
				do
					step_rand(src)
				while(prob(5))

			spawn AI()
	/*Life()
		. = ..()
		if(!ActionLock("check", 300))
			var/mob/check = locate() in range(20, src)
			runAI = check ? TRUE : FALSE*/
	proc
		Populate()
			if(!there_can_be_only_one)
				for(var/i = 1 to rand(min_pop, max_pop))
					new src.type(src.loc, disperse = 1)
				Move(null, forced = 1)
		CheckAge()
			if(age == -1) return
			speed = initial(speed)
			strength = initial(strength)
			switch(age)
				if(0 to 4) //baby stage: speed slightly buffed, less damage (less experience)
					speed *= 1.05
					strength *= 0.95
				//if(5 to 12) //maturity stage: normal stats
				if(13 to 20) //adult stage: normal speed, slightly buffed strength
					strength *= 1.05
				if(21 to 24) //old stage: low speed, low strength
					speed *= 0.90
					strength *= 0.95
		Age()
			if(++age > 24)
				age = 24
				if(prob(1)) //die of natural causes
					HP = 0
					src.checkdead(src)

			CheckAge()
		SeeViolence(mob/attacker, mob/target)
			if(attacker == src) return
			if((target == src) || (target in friends) && attacker != master)
				if(attacker in friends) //that's not very nice :(
					friends -= attacker
					if(!friends.len) friends = null

				if(!enemies) enemies = new/list()
				if(!(attacker in enemies)) enemies += attacker
				if(!enemy || target == src) enemy = attacker
				if(mood == MOOD_CURIOUS || mood == MOOD_PEACEFUL)
					mood = MOOD_SCARED
					mood_timer = 200
					base_speed = speed
					speed *= 2.5
					if(speed > 90) speed = 90

		SeeDeath(mob/target)
			if(target == enemy)
				enemy = null
				mood = natural_mood

			if((HP < MHP * 0.25) && prob(25)) mood = MOOD_SCARED
		SeeFoodDrop(item/misc/food/I, mob/M)
			if(SLEEP < 75 && M && prob(5))
				if(!friends) friends = new/list()
				if(!(M in friends)) friends += M //yay!
			if(mood == natural_mood && SLEEP <= 50 && prob(25)) mood = MOOD_CURIOUS //hmm... what is that?
		AI()
			if(HP > 0 && !corpse)
				spawn(world.tick_lag)
					AI()
			if(action_timer <= 0)
				action_timer = 100 - speed
				if(action_timer == 0)
					action_timer = 5
				switch(mood)
					if(MOOD_ANGRY)
						if(HP <= 0) return
						if(!enemy || enemy && get_dist(src, enemy) > 15)
							var/smallest_dist = 999
							var/view_distance = 10
							if(istype(src, /animal/wolf) && Hour >= 20 || istype(src, /animal/wolf) && Hour <= 4)
								view_distance = 40
							for(var/mob/I in view(view_distance))
								var/dist = get_dist(src, I)
								if(dist < smallest_dist && !istype(I, src) && !istype(I, /mob/observer) && I.HP > 0)
									smallest_dist = dist
									enemy = I
						if(!issleeping && (stunned + weakened <= 0) && !corpse && enemy && (enemy in range(src)) && enemy.HP > 0)
							spawn(step_to(src, enemy, 1, 1))
								if(src in oview(1, enemy))
									src.attack(enemy)
									HUNGER += 30
									if(HUNGER > MHUNGER)
										HUNGER = MHUNGER
						else
							Step(pick(NORTH, SOUTH, EAST, WEST))
					if(MOOD_CURIOUS, MOOD_PEACEFUL)
						if(HP <= 0) return
						if(HUNGER < 90)
							var/item/misc/food/food_desire
							var/lowest_dist = 999
							for(var/item/misc/food/I in view(6))
								var/dist = get_dist(src, I)
								if(dist < lowest_dist)
									if(!(I.FoodType != "Vege" && animal_type == TYPE_HERBIVORE))
										food_desire = I
										lowest_dist = get_dist(src, I)
							if(food_desire)
								spawn(step_to(src, food_desire, 1, 1))
								if(get_dist(src,food_desire) <= 1)
									food_desire.consume(src)
									HUNGER *= 100
									if(HUNGER > MHUNGER)
										HUNGER = MHUNGER
									THIRST *= 100
									if(THIRST > MTHIRST)
										THIRST = MTHIRST
							else
								Step(pick(NORTH, SOUTH, EAST, WEST))
						else
							Step(pick(NORTH, SOUTH, EAST, WEST))
					if(MOOD_SCARED)
						mood_timer--
						if(mood_timer <= 0)
							mood = natural_mood
							speed = base_speed
						if(HP <= 0) return
						if(!enemy)
							var/smallest_dist = 999
							var/view_distance = 10
							for(var/mob/I in view(view_distance))
								var/dist = get_dist(src, I)
								if(dist < smallest_dist && !istype(I, src) && !istype(I, /mob/observer) && I.HP > 0)
									smallest_dist = dist
									enemy = I
						if(!issleeping && (stunned + weakened <= 0) && !corpse && enemy && (enemy in range(src)))
							spawn(world.tick_lag)
								Step_Away(enemy)
						else
							Step(pick(NORTH, SOUTH, EAST, WEST))
			else
				action_timer--
		Step(dir)
			if(HP <= 0 || corpse) return 100
			if(_c_speed != speed)
				_c_speed = speed
				_speed = (1 / (speed / 100))
			if(ActionLock("moving", _speed)) return _speed

			if(isnum(dir))
				spawn step(src, dir)
			else if(istype(dir, /atom))
				if(get_dist(src, dir) <= 1) spawn step_towards(src, dir)
				else spawn step_to(src, dir, 0)
			return _speed
		Step_Away(mob/M)
			if(HP <= 0 || corpse) return 100
			if(_c_speed != speed)
				_c_speed = speed
				_speed = (1 / (speed / 100))
			if(ActionLock("moving", _speed)) return _speed
			step_away(src, M, 20)
			return _speed
		/*AI() spawn
			var/i = 0
			while(HP > 0)
				if(i && i <= 50) i++
				else if(i) i = null

				if(!runAI || ismob(loc))
					sleep(250)
					continue
				if(HP <= 0 || icon_state == "dead") //clinically dead, ACT LIKE IT
					break
				if(SLEEP >= MSLEEP || (SLEEP >= 25 && prob(1)))
					toggle_sleep(0)
				if(issleeping)
					sleep(100)
					continue

				if(master) //someone tamed me!
					if(state == STATE_FOLLOW)
						while(master && !ActionLock("scared") && state == STATE_FOLLOW && !ismob(loc))
							if(!(master in oview(src)))
								if(master.lastHole)
									sleep(Step(master.lastHole))
								else break
							else if(get_dist(src, master) > 2)
								sleep(Step(master))
								//step_towards(src, master)
							else
								step(src, pick(NORTH, SOUTH, EAST, WEST))
								sleep(15) //15 + 10 = 25
						state = STATE_CURIOUS
					else if(state == STATE_ATTACK)
						if(target)
							var/mob/M = target
							while((M in oview(src)) && ((src.strength - M.defence) * 3) > 0 && state == STATE_ATTACK && !ismob(loc))
								. = 0

								if(HP <= (MHP * 0.1) && (M.HP >= (M.MHP * 0.3)))
									ActionLock("scared", 300)
									break
								else if(src in oview(1, M))
									src.attack(M)
									sleep(5)
								else
									sleep(Step(M))

								if(.) break
							if(M && (M in oview(src))) ActionLock("scared", 50)
							target = null
						if(!target) state = STATE_CURIOUS //nothing left to do
				else
					//where am I? what is that? what is THAT? oo that thing has buttons on it!\
					do you smell something burning? ARGGGGH
					if(animal_type == TYPE_HERBIVORE)
						if(HP <= (MHP * 0.9) || prob(2)) //only go hunting for food when needed
							var/item/misc/food/O
							for(O in oview(src)) break
							if(O) //oh boy there's food!
								while(O in view(src))
									if(src in O.loc)
										O.consume(src)
										break
									else
										step_towards(src, O)
									sleep(5)

					if(animal_type == TYPE_CARNIVORE || ActionLock("aggressive"))
						var/mob/M
						for(M in oview(src))
							if(istype(M, /mob/corpse) || istype(M, /mob/eavesdropper)) continue
							var/restdmg = (src.strength - M.defence) * 3
							if(restdmg <= 0)
								if(ActionLock("aggressive"))
									ActionLock("scared", 100)
									M = null
									break
								continue //player is too strong for me
							break
						if(M) //oh boy there's food! :D
							while(M in oview(src) && ((src.strength - M.defence) * 3) > 0)
								. = 0

								if(HP <= (MHP * 0.1) && (M.HP >= (M.MHP * 0.3)))
									ActionLock("scared", 300)
									break
								else if(src in oview(1, M))
									src.attack(M)
									sleep(5)
								else
									sleep(Step(M))

								if(.) break
							if(M in oview(src)) ActionLock("scared", 50)

				if(!master && (ActionLock("scared") || HP <= (MHP * 0.1))) //RUN FOR IT! coward mode: ON
					ActionLock("scared", 400) //if we weren't previously scared, we're certainly scared now!
					var/mob/M
					for(M in view(src))
						if(M == src) continue
						break
					if(M)
						while(M in view(10, src))
							step_away(src, M, 10)
							sleep(5)

				if(prob(60))
					step(src, pick(NORTH, SOUTH, EAST, WEST))
				sleep(master ? rand(10, 40) : rand(10, 175))*/
	Life()
		if(HP <= 0) //dead? nothing!
			if(icon_state != "dead")
				icon_state = "dead"
				UpdateClothing()
			return

		if(issleeping) //sleeping? let's increase sleep over time
			SLEEP++
			if(SLEEP >= MSLEEP)
				SLEEP = MSLEEP
				toggle_sleep(0) //wake up!

		if(effects) //handle effects/chemicals
			if(effects.caffeine > 0)
				effects.caffeine--
				SLEEP += rand(0.5, 3)
				if(SLEEP >= 40 && prob(5))
					HP--
					last_hurt = "coffee"
				if(SLEEP >= 20 && prob(20))
					HUNGER -= rand(0.75, 4)

		if(!(life_time % 240))
			HUNGER -= 1
			if(HUNGER <= 1)
				src.HUNGER += 10
				src.HP -= 1
				src.last_hurt = "hunger"
				checkdead(src)

		if(src.poisoned >= 1)
			if(prob(poisoned))
				src.HP -= rand(round(src.poisoned * 0.5), round(src.poisoned * 1.5))
				last_hurt = "poison"
				checkdead(src)

		if(stunned > 0) stunned--
		if(weakened > 0) weakened--

		if(issleeping || weakened > 0 || HP <= 0)
			if(icon_state != "dead")
				icon_state = "dead"
				UpdateClothing()
		else
			if(icon_state != "alive")
				icon_state = "alive"
				UpdateClothing()

		if(ActionLock("spell_luminosity"))
			if(luminosity != 12) src.sd_SetLuminosity(12)
		else
			if(luminosity != 0) src.sd_SetLuminosity(0)
	/*verb
		Mount()
			set src in oview(1, usr)
			if(master != usr || usr.mounted) return
			if(HP <= 0 || icon_state == "dead")
				usr.show_message("<tt>You can't mount dead animals!</tt>")
				return
			usr.Move(src.loc, forced = 1)
			src.Move(usr, forced = 1)
			usr.mounted = src
			usr.UpdateClothing()
			usr.show_message("<tt>You mount [src].</tt>")
		Unmount()
			set src in usr.contents
			src.Move(usr.loc, forced = 1)
			usr.mounted = null
			usr.UpdateClothing()
			usr.show_message("<tt>You get off [src].</tt>")*/
	goat
		icon = 'icons/Goat.dmi'
		slowness = 10
		smell = 30
		strength = 3
		speed = 40
		HP = 40
		MHP = 40
		natural_mood = MOOD_CURIOUS
		mood = MOOD_CURIOUS
	sheep
		icon = 'icons/Sheep.dmi'
		var/wool = 15
		speed = 40
		natural_mood = MOOD_CURIOUS
		mood = MOOD_CURIOUS
		attack_hand(mob/M)
			if(wool > 0 && M.inHand(/item/weapon/shears))
				new/item/misc/wool(M)
				if(--wool <= 0)
					wool = 0
					src.icon = 'icons/Sheep1.dmi'
			else return ..()
		Life()
			. = ..()
			if(HP > 0 && prob(5))
				icon = 'icons/Sheep.dmi'
				wool += rand(1, 3)
				if(wool >= 15) wool = 15
	turtle
		icon = 'icons/Turtle.dmi'
		slowness = 10
		smell = 20
		strength = 1
		defence = 5
		speed = 5
		HP = 120
		MHP = 120
		there_can_be_only_one = 1
	pig
		icon = 'icons/Pig.dmi'
		smell = 60
		strength = 2
		defence = 2
		speed = 40
		natural_mood = MOOD_CURIOUS
		mood = MOOD_CURIOUS
		animal_type = TYPE_OMNIVORE
	bear
		icon = 'icons/Bear.dmi'
		smell = 90
		strength = 6
		defence = 6
		HP = 160
		MHP = 160
		animal_type = TYPE_CARNIVORE
		speed = 40
		there_can_be_only_one = 1

	wolf
		icon = 'icons/Wolf.dmi'
		smell = 90
		strength = 5
		defence = 1
		HP = 60
		MHP = 60
		animal_type = TYPE_CARNIVORE
		speed = 80
		natural_mood = MOOD_ANGRY
		mood = MOOD_ANGRY

		New()
			..()
			if(prob(2))
				name = "Maneater"
				HP = 120
				MHP = 120
				strength = 7
				speed = 85
				icon = 'icons/Dire_Wolf.dmi'

		Maneater
			name = "Maneater"
			HP = 120
			MHP = 120
			strength = 7
			speed = 85
			icon = 'icons/Dire_Wolf.dmi'