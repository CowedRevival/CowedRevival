obj/monolith
	icon = 'icons/Monolith.dmi'
	icon_state = "monolith_1"
	density = 1
	var
		max_charge = 3
		charge = 0
		charge_cost = 1

	var/charge_condition
	var/recharge_time
	var/recharge_counter
	var/const
		MOON_CHARGE = 1
		SUN_CHARGE = 2
		CORPSE_CHARGE = 3
		GEM_CHARGE = 4

	var/required_gem
	var/socketed_gem
	var/const
		RUBY = 1
		EMERALD = 2
		AMETHYST = 3

	var/range

	//Effects
	var/obj/Monolith_Effects
		pass
		fail

	New()
		name = "[pick("Strange","Odd", "Imposing", "Powerful", "Useless", "Eldritch", "Maddening", "Devouring", "Quiet", "Humming", "Old", "Frogman", "Cow")] Monolith"
		icon_state = "monolith_[rand(1,12)]"
		recharge_time = rand(1500, 6000)
		recharge_counter = 0
		charge_cost = rand(1,3)
		charge_condition = rand(1,4)
		charge = max_charge
		required_gem = rand(1,3)
		verbs -= /obj/monolith/verb/Remove_Gem
		range = rand(1,2)
		Generate_Effects()
		spawn()Monolith_Recharge()

	DblClick()
		if(usr.shackled==1) return
		if(get_dist(src,usr) <= 1)
			usr.SetAction(src)

	verb/Check()
		set src in view(1)
		if(prob(usr.skills.research))
			usr << "<small>Could be [pass.monolith_effect_type]</small>"
		else if(prob(33))
			usr << "<small>Could be Beneficial!</small>"
		else if(prob(33))
			usr << "<small>Could be Hazardous!</small>"
		else
			usr << "<small>Could be Benign!</small>"

		var/gem_type = rand(1,3)
		if(prob(usr.skills.research))
			gem_type = required_gem
		if(gem_type == 1)
			usr << "<small>Could require Ruby!</small>"
		else if(gem_type == 2)
			usr << "<small>Could require Emerald!</small>"
		else if(gem_type == 3)
			usr << "<small>Could require Amethyst!</small>"

	verb/Label(var/x as text)
		set src in view(1)
		if(usr.CheckGhost() || usr.corpse) return
		name = x

	verb/Remove_Gem()
		set src in view(1)
		if(socketed_gem)
			if(socketed_gem == RUBY)
				usr.contents += new/item/misc/gem/ruby
			else if(socketed_gem == EMERALD)
				usr.contents += new/item/misc/gem/emerald
			else if(socketed_gem == AMETHYST)
				usr.contents += new/item/misc/gem/amethyst
			socketed_gem = 0
			hearers(usr) << "<small>[usr.name] removes the gem from the Monolith!</small>"
			src.Play_Sound_Local(pick('sounds/sfx/power_down_v2.ogg'))
			verbs -= /obj/monolith/verb/Remove_Gem


	proc/ActionLoop(mob/M)
		Invoke_Monolith(M)

	proc/Invoke_Monolith(var/mob/M)
		if(socketed_gem)
			if(charge >= charge_cost)
				hearers(M) << "<small>[M.name] activates the Monolith!</small>"
				if(socketed_gem == required_gem)
					spawn() pass.Monolith_Action(M)
				else
					spawn() fail.Monolith_Action(M)
				if(charge >= charge_cost)
					charge -= charge_cost
					hearers(src) << "<small>[name] seems to dim a little...</small>"
					src.Play_Sound_Local(pick('sounds/sfx/power_down_v2.ogg'))
				var/color = rand(1,2)
				var/temp_range = (range * 2) + 1
				if(temp_range == 1) temp_range = 0
				for(var/I = 1 to temp_range)
					for(var/J = 1 to temp_range)
						var/loc_x = loc.x - (range+1)
						var/loc_y = loc.y - (range+1)
						if(color == 1)
							spawn() new/obj/monolith_area/yellow(locate(loc_x+I, loc_y+J, loc.z))
						else if(color == 2) spawn() new/obj/monolith_area/blue(locate(loc_x+I, loc_y+J, loc.z))
			else
				M << "<small>The monolith's power is low, give it some time.</small>"
		else
			usr << "<small>Please socket a gem in the monolith!</small>"
		M.current_action = null

	proc/Monolith_Recharge()
		if(charge < max_charge && !socketed_gem)
			var/proceed = 0
			if(charge_condition == MOON_CHARGE)
				if(Hour < 6 || Hour >= 17)
					proceed += 1
			else if(charge_condition == SUN_CHARGE)
				if(Hour >= 6 && Hour < 17)
					proceed += 1
			else if(charge_condition == CORPSE_CHARGE)
				for(var/mob/O in range(2, src))
					if(O.tag == "Dead Player" && O.HP <= 0)
						proceed += 1
			else if(charge_condition == GEM_CHARGE)
				for(var/item/misc/gem/O in range(2, src))
					if(!O.drained)
						proceed += 1
			if(proceed > 0)
				recharge_counter += proceed
				if(recharge_counter > recharge_time)
					charge += 1
					recharge_counter = 0
					src.Play_Sound_Local(pick('sounds/sfx/power_up_v2.ogg'))
					if(charge_condition == CORPSE_CHARGE)
						for(var/mob/O in range(2, src))
							if(O && O.HP <= 0)
								O.icon = 'Skeleton.dmi'
								O.tag = "Skeleton"
					else if(charge_condition == GEM_CHARGE)
						for(var/item/misc/gem/O in range(2, src))
							if(O.drained <= 0)
								O.name = "[name] drained"
								O.icon_state = "[O.icon_state]_drained"
								O.drained = 1
			else
				recharge_counter = 0

		overlays = new()
		if(socketed_gem)
			if(socketed_gem == RUBY)
				overlays += image(icon = 'icons/Monolith.dmi', icon_state = "ruby")
			else if(socketed_gem == EMERALD)
				overlays += image(icon = 'icons/Monolith.dmi', icon_state = "emerald")
			else if(socketed_gem == AMETHYST)
				overlays += image(icon = 'icons/Monolith.dmi', icon_state = "amethyst")
			if(charge > 0) overlays += image(icon = 'icons/Monolith.dmi', icon_state = "monolith_charge_[charge]")
			if(charge >= charge_cost)
				sd_SetLuminosity(2)
				overlays += image(icon = 'icons/Monolith.dmi', icon_state = "monolith_glow")
			else
				sd_SetLuminosity(0)
		else
			sd_SetLuminosity(0)
		spawn(world.tick_lag) Monolith_Recharge()


	MouseDropped(item/misc/gem/I, src_location, over_location, control, params)
		if(!(usr in range(1, src)) || !(I in usr.contents)) return
		if(socketed_gem)
			usr << "Please remove the socketed gem!"
			return
		else if(istype(I, /item/misc/gem))
			if(I.drained)
				usr << "Drained gems won't work here!"
				return
			if(istype(I, /item/misc/gem/ruby))
				socketed_gem = RUBY
			else if(istype(I, /item/misc/gem/emerald))
				socketed_gem = EMERALD
			else if(istype(I, /item/misc/gem/amethyst))
				socketed_gem = AMETHYST
			if(I.stacked <= 0) I.Move(null, forced = 1)
			if(charge >= charge_cost)
				src.Play_Sound_Local(pick('sounds/sfx/power_up_v2.ogg'))
			verbs += /obj/monolith/verb/Remove_Gem
			return

	proc/Generate_Effects()
		if(prob(7))
			pass = new/obj/Monolith_Effects/Hunger_Fill
			range = 0
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Necromantic_Power
			range = 0
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Portal_Power
			range = 0
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Eclipse_Power
			range = 0
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Fire_Power
			range = 0
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Ice_Power
			range = 0
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Zap_Power
			range = 0
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Swap_Monolith
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Ressurection
		else if(prob(7))
			pass = new/obj/Monolith_Effects/Summon_Monster
		else if(prob(3))
			pass = new/obj/Monolith_Effects/Death
			range = 0
		else if(prob(3))
			pass = new/obj/Monolith_Effects/Meat_Cube_Range
		else
			pass = new/obj/Monolith_Effects/Hunger_Empty
			range = 0
		pass.range = range
		pass.source = src

		if(prob(5))
			fail = new/obj/Monolith_Effects/Death
			range = 0
		else if(prob(5))
			fail = new/obj/Monolith_Effects/Meat_Cube
			range = 0
		else if(prob(75))
			fail = new/obj/Monolith_Effects/Hunger_Empty
			range = 0
		else
			fail = new/obj/Monolith_Effects/Summon_Monster
		fail.range = range
		fail.source = src

obj/Monolith_Effects
	var/monolith_effect_type
	var/obj/monolith/source
	var/range

	proc/Monolith_Action(var/mob/M)
		return
	//-BENEFICIAL MONOTLITHS-
	//Generic Beneficial Monolith
	Hunger_Fill
		monolith_effect_type = "Beneficial"
		Monolith_Action(var/mob/M)
			M.HUNGER += 50
			if(M.HUNGER > M.MHUNGER) M.HUNGER = M.MHUNGER
			M << "<small>You feel your stomach fill!</small>"

	//Power Effects
	Necromantic_Power
		monolith_effect_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/proto_necromancer))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You now understand the secrets of life and death!</small>"
			M.learn_spell(/spell/proto_necromancer, 1)

	Portal_Power
		monolith_effect_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/portal))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You now understand the secrets of portals!</small>"
			M.learn_spell(/spell/portal, 1)

	Eclipse_Power
		monolith_effect_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/eclipse))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You understand the secrets of darkness!</small>"
			M.learn_spell(/spell/eclipse, 1)

	Fire_Power
		monolith_effect_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/fireball))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You understand the secrets of fire!</small>"
			M.learn_spell(/spell/fireball, 1)

	Ice_Power
		monolith_effect_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/iceball))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You understand the secrets of ice!</small>"
			M.learn_spell(/spell/iceball, 1)

	Zap_Power
		monolith_effect_type = "Beneficial"
		Monolith_Action(var/mob/M)
			for(var/spell/S in M.spells)
				if(istype(S,/spell/zap))
					M << "<small>There is nothing more to learn...</small>"
					return
			M << "<small>You understand the secrets of lightning!</small>"
			M.learn_spell(/spell/zap, 1)

	//-GENERIC-BENIGN-EFFECTS-
	Swap_Monolith
		monolith_effect_type = "Benign"
		Monolith_Action(var/mob/M)
			for(var/mob/I in range(range, source))
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

	Ressurection
		monolith_effect_type = "Benign"
		Monolith_Action(var/mob/M)
			for(var/mob/I in range(range, source))
				if(M != I && I.HP <= 0 && I.corpse)
					hearers(src) << "<small>[M.name] returns to life!</small>"
					I.revive()
					return
			M << "<small>Nothing happened...</small>"

	//-DANGEROUS EFFECTS-
	Death
		monolith_effect_type = "Hazardous"
		Monolith_Action(var/mob/M)
			if(M.death_mon_curse && M.meat_cube_curse) return
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

	Meat_Cube
		monolith_effect_type = "Hazardous"
		Monolith_Action(var/mob/M)
			if(M.death_mon_curse && M.meat_cube_curse) return
			hearers(M) << "<font color=\"red\"><big>[M.name]'s body is crushed by unknown forces till it becomes some kind of cube of meat, how horrifying!"
			M.name = "[M.name] the Meat Cube"
			M.meat_cube_curse = 1
			M.icon = 'icons/meat_cube.dmi'
			M.speed = 20
			M.MHP = 100
			M.HP = 100
			M.MHUNGER = 99999
			M.MTHIRST = 99999
			M.MSLEEP = 99999
			M.HUNGER = M.MHUNGER
			M.THIRST = M.MTHIRST
			M.SLEEP = M.MSLEEP
			M.equip_deny_head = 1
			M.equip_deny_mask = 1
			M.equip_deny_body = 1
			M.equip_deny_hood = 1
			M.equip_deny_cloak = 1
			M.equip_deny_left_hand = 1
			M.equip_deny_right_hand = 1
			M.hair = ""
			M.beard = ""
			M.UpdateClothing()

	Meat_Cube_Range
		monolith_effect_type = "Hazardous"
		Monolith_Action(var/mob/M)
			for(var/mob/O in range(range, source))
				if(!O.death_mon_curse && !O.meat_cube_curse)
					hearers(O) << "<font color=\"red\"><big>[M.name]'s body is crushed by unknown forces till it becomes some kind of cube of meat, how horrifying!"
					O.name = "[M.name] the Meat Cube"
					O.meat_cube_curse = 1
					O.icon = 'icons/meat_cube.dmi'
					O.speed = 20
					O.MHP = 100
					O.HP = 100
					O.MHUNGER = 99999
					O.MTHIRST = 99999
					O.MSLEEP = 99999
					O.HUNGER = M.MHUNGER
					O.THIRST = M.MTHIRST
					O.SLEEP = M.MSLEEP
					O.equip_deny_head = 1
					O.equip_deny_mask = 1
					O.equip_deny_body = 1
					O.equip_deny_hood = 1
					O.equip_deny_cloak = 1
					O.equip_deny_left_hand = 1
					O.equip_deny_right_hand = 1
					M.hair = ""
					M.beard = ""
					O.UpdateClothing()

	Hunger_Empty
		monolith_effect_type = "Hazardous"
		Monolith_Action(var/mob/M)
			M.HUNGER -= 50
			if(M.HUNGER < 0) M.HUNGER = 0
			M << "<small>You feel your stomach empty!</small>"

	Summon_Monster
		monolith_effect_type = "Hazardous"
		var/monster_type
		New()
			..()
			if(prob(20))
				monster_type = /mob/Demon
			else if(prob(20))
				monster_type = /mob/Zombie
			else if(prob(10))
				monster_type = /mob/Shroom_Monster/Shroom_Brute
			else if(prob(50))
				monster_type = /mob/Shroom_Monster/Shroom
			else
				monster_type = /mob/Frogman
		Monolith_Action(var/mob/M)
			var/x = loc.x + rand(-range, range)
			var/y = loc.y + rand(-range, range)
			var/z = loc.z
			new monster_type(locate(x,y,z))

obj/boulder
	icon = 'icons/Boulders.dmi'
	icon_state = "boulder_1"
	density = 1
	var/HP = 3
	var/step, step_requirement

	var/const
		HAND_PICK = 1
		CHISEL = 2
		BRUSH = 3

	New()
		icon_state = "boulder_[rand(1,3)]"
		step = rand(2,4)
		step_requirement = rand(1,3)
		HP = rand(3,6)



	MouseDropped(item/misc/excavation_tool/I, src_location, over_location, control, params)
		if(!(usr in range(1, src)) || !(I in usr.contents)) return
		var/probability = 0
		var/fail = 1
		var/fumble = 0
		I.to_drop = 0
		src.Play_Sound_Local(pick('sounds/sfx/mining1.ogg', 'sounds/sfx/mining2.ogg', 'sounds/sfx/mining3.ogg', 'sounds/sfx/mining4.ogg', 'sounds/sfx/mining5.ogg',
		'sounds/sfx/mining6.ogg', 'sounds/sfx/mining8.ogg', 'sounds/sfx/mining9.ogg', 'sounds/sfx/mining10.ogg'))
		sleep(30)
		if(usr in range(1, src))
			if(step_requirement == HAND_PICK)
				if(istype(I, /item/misc/excavation_tool/hand_pick))
					if(I.material == "magicite")
						probability = 100
					else
						probability = 75
					if(prob(probability))
						hearers(usr) << "<small>[usr] manages to chip away a layer of the boulder!</small>"
						fail = 0
					else
						fumble = 1
			else if(step_requirement == CHISEL)
				if(istype(I, /item/misc/excavation_tool/chisel))
					if(I.material == "magicite")
						probability = 100
					else
						probability = 75
					if(prob(probability))
						hearers(usr) << "<small>[usr] manages to chisel away a layer of the boulder!</small>"
						fail = 0
					else
						fumble = 1
			else if(step_requirement == BRUSH)
				if(istype(I, /item/misc/excavation_tool/brush))
					if(I.material == "magicite")
						probability = 100
					else
						probability = 75
					if(prob(probability))
						hearers(usr) << "<small>[usr] manages to brush away a layer of the boulder!</small>"
						fail = 0
					else
						fumble = 1
			if(!fail)
				step--
				if(step == 0)
					hearers(usr) << "<small>[usr] removes the remaining layer of the boulder, revealing a Monolith!</small>"
					new/obj/monolith(loc)
					del(src)
				else
					step_requirement = rand(1,3)
			else
				if(fumble)
					hearers(usr) << "<small>[usr] damages the boulder a little due to fumbling their tool!</small>"
				else
					hearers(usr) << "<small>[usr] damages the boulder a little due to using the wrong tool!</small>"
				HP--
				if(HP <= 0)
					hearers(usr) << "<small>[usr] has destroyed the boulder!</small>"
					new/item/misc/stone(loc)
					del(src)

obj/monolith_area
	icon = 'icons/Monolith.dmi'
	icon_state = "area_1"

	New()
		name = ""
		sleep(30)
		del(src)
	yellow
		icon_state = "area_1"
	blue
		icon_state = "area_2"

/*hearers(usr) << "<small>[usr] damages the boulder a little!</small>"
				HP--*/
/*admin/verb/Posses(mob/M in world)
	M.client = usr.client*/