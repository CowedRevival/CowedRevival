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
		animal_type = TYPE_HERBIVORE
		runAI = TRUE
		mob/master
		mountable = 0
		age
		tmp
			there_can_be_only_one = 0
			pregnant = 0 //oh dear
			min_pop = 10
			max_pop = 25
	New(loc, disperse = 0)
		. = ..()
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

				if(HP < MHP * 0.1) mood = MOOD_SCARED
				else mood = MOOD_ANGRY
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
			spawn while(HP > 0 && !corpse)
				if(!ActionLock("Age", rand(3000, 6000))) Age()
				if(!runAI || (stunned + weakened > 0) || !isturf(loc))
					sleep(100)
					continue
				if(issleeping)
					if(++SLEEP >= 5 && prob(5))
						issleeping = 0
					sleep(50)
					continue

				switch(mood)
					if(MOOD_ANGRY)
						//attack enemy
						while(!issleeping && (stunned + weakened <= 0) && !corpse && enemy && (enemy in range(src)))
							if(HP < (MHP * 0.1))
								mood = MOOD_SCARED
								break
							if(src in oview(1, enemy))
								src.attack(enemy)
								sleep(5)
							else sleep(Step(enemy))
						enemy = null
						if(mood == MOOD_ANGRY)
							mood = natural_mood
							if(mood == MOOD_ANGRY) mood = MOOD_CURIOUS
					if(MOOD_SCARED)
						//flee from enemy
						while(!issleeping && (stunned + weakened <= 0) && !corpse && enemy && (enemy in range(src)))
							sleep(Step_Away(enemy))
						enemy = null
						mood = natural_mood
						if(mood == MOOD_SCARED)
							mood = natural_mood
							if(mood == MOOD_SCARED) mood = MOOD_CURIOUS
					if(MOOD_BLOODTHIRSTY)
						//find a new target to attack
						var/list/L = range(src)
						//proritize on known enemies
						for(var/mob/M in L)
							if(M in enemies)
								enemy = M
								break
						if(!enemy)
							for(var/mob/M in L)
								if(!(M in friends))
									enemy = M
									break

						if(enemy) mood = MOOD_ANGRY
						sleep(10)
					if(MOOD_CURIOUS, MOOD_PEACEFUL)
						//wander around
						if(master && order) //I have been ordered to do something!
							if(prob(10)) //10% chance I'll ignore it
								order = null
							else
								switch(order)
									if(ORDER_FOLLOW) //yay let's follow him/her around
										mood = MOOD_PEACEFUL
										while(!issleeping && (stunned + weakened <= 0) &&!corpse && order == ORDER_FOLLOW && mood == MOOD_PEACEFUL)
											while(!(src in range(3, master)))
												sleep(Step(master))
											sleep(Step(pick(NORTH, SOUTH, EAST, WEST)))
											if(speed > 30) sleep(rand(25, 75)) //rate limit for curious movement
									if(ORDER_ATTACK) //grrr...
										mood = MOOD_ANGRY
										order = null
										continue

						var/need_food = SLEEP / (MSLEEP / 100)
						if(!prob(need_food))
							var/item/misc/food/I
							for(I in view(src))
								if(animal_type == TYPE_CARNIVORE || I.herbivore_friendly)
									break
							while(!issleeping && (stunned + weakened <= 0) &&!corpse && I)
								if(src.loc == I.loc)
									I.consume(src)
									need_food = SLEEP / (MSLEEP / 100)
									if(prob(need_food))
										break
								sleep(Step(I))
							if(I) continue
						if(friends && friends.len && prob(25))
							var/mob/M
							for(M in friends)
								if(M in range(src)) break
							while(!issleeping && (stunned + weakened <= 0) &&!corpse && !(M in range(3, src)))
								sleep(Step(M))
						/*if(prob(2) && gender == MALE && age >= 14 && age <= 20)
							var/animal/A
							for(A in oview(src))
								if(A.type == src.type && A.gender == FEMALE && A.age >= 14 && A.age <= 20 && !A.pregnant) break
							if(A)
								while(!corpse && (A in range(src)) && get_dist(A, src) > 1)
									sleep(Step(A))
								if(get_dist(A, src) <= 1)
									A.ActionLock("pregnant", rand(3000, 6000))
									A.pregnant = prob(25) ? 1 : 0
						else if(gender == FEMALE && pregnant && !ActionLock("pregnant"))
							var/animal/A = new src.type(src.loc)
							A.age = 0
							if(!friends) friends = new/list()
							friends += A //watch over your children
							*/
						sleep(Step(pick(NORTH, SOUTH, EAST, WEST)))
						if(speed > 30) sleep(rand(25, 75)) //rate limit for curious movement
						if(mood == MOOD_CURIOUS) mood = natural_mood
					else sleep(100)
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
		add_contents() //called upon death to add the contents
			if(age >= 18)
				contents = newlist(/item/misc/food/Meat)
				if(prob(75)) contents += new/item/misc/hide
			else
				contents = newlist(/item/misc/hide, /item/misc/food/Meat, /item/misc/food/Meat)
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
			THIRST -= 1
			if(HUNGER <= 1)
				src.HUNGER += 10
				src.HP -= 10
				src.last_hurt = "hunger"
				checkdead(src)
			if(THIRST <= 1)
				src.HP -= 5
				src.last_hurt = "thirst"
				checkdead(src)


		if(src.poisoned >= 1)
			if(prob(poisoned))
				src.HP -= rand(round(src.poisoned * 0.5), round(src.poisoned * 1.5))
				last_hurt = "poison"
				checkdead(src)

		if(SLEEP <= 0) toggle_sleep(1) //immediate sleep caused by spells/hunger.
		if(!issleeping && !(life_time % 480) && --SLEEP <= 0) toggle_sleep(1)

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
	Click()
		if(src.master == usr && !(src in oview(1, usr)))
			var/list/L = list("Follow", "Wander", "Attack")
			if(animal_type != TYPE_CARNIVORE) L -= "Attack"

			var/choice = input(usr, "What would you like this animal to do?", "[src]") as null|anything in L
			if(!choice) return
			switch(choice)
				if("Follow") order = ORDER_FOLLOW
				if("Attack")
					var/mob/M = input(usr, "Specify a target for the animal.", "[src] :: Attack") as null|mob in view(src) - src - usr
					if(M && (M in view(src)))
						enemy = M
						order = ORDER_ATTACK
				else order = ORDER_NONE
			if(choice != "Attack" && enemy) enemy = null
		else return ..()
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
		HP = 40
		MHP = 40
		natural_mood = MOOD_CURIOUS
		mood = MOOD_CURIOUS
	sheep
		icon = 'icons/Sheep.dmi'
		var/wool = 15
		speed = 5
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
		HP = 120
		MHP = 120
		there_can_be_only_one = 1
		add_contents() return
	pig
		icon = 'icons/Pig.dmi'
		smell = 60
		strength = 2
		defence = 2
		contents = newlist(/item/misc/food/Meat, /item/misc/food/Meat, /item/misc/food/Meat, /item/misc/food/Meat)
		natural_mood = MOOD_CURIOUS
		mood = MOOD_CURIOUS
		add_contents()
			. = ..()
			contents += new/item/misc/food/Meat
	bear
		icon = 'icons/Bear.dmi'
		smell = 90
		strength = 9
		defence = 6
		HP = 160
		MHP = 160
		animal_type = TYPE_CARNIVORE
		mountable = TRUE
		speed = 67
		there_can_be_only_one = 1
		add_contents()
			. = ..()
			contents += new/item/misc/food/Meat
			contents += new/item/misc/food/Meat
			contents += new/item/misc/food/Meat