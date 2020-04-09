item/weapon
	layer = OBJ_LAYER
	icon = 'icons/items.dmi'
	var
		two_handed = 0 //if set, no other weapons may be equipped
	Click()
		. = ..()
		if((src in usr.contents) && !usr.selectedSpellComponent)
			if(usr.rolling || usr.shackled) return
			if(usr.lhand != src && usr.rhand != src)
				if(two_handed && (usr.lhand || usr.rhand))
					usr << "<tt>This is a two-handed weapon! Unequip your other weapons first!"
					return
				if((usr.lhand && usr.lhand.two_handed) || (usr.rhand && usr.rhand.two_handed))
					usr << "<tt>Unequip your two-handed weapon first!"
					return
			if(usr.lhand == src)
				usr.lhand = null
				if(!usr.rhand) usr.rhand = src
			else if(usr.rhand == src)
				usr.rhand = null
			else if(!usr.lhand) usr.lhand = src
			else if(!usr.rhand) usr.rhand = src

			suffix = (usr.lhand == src || usr.rhand == src) ? "Equipped[two_handed ? " (hands)":]" : ""
			usr.UpdateClothing()
	unequip()
		var/mob/M = loc
		if(!istype(M) || (M.lhand != src && M.rhand != src)) return
		if(M.lhand == src) M.lhand = null
		if(M.rhand == src) M.rhand = null
		suffix = ""
		M.UpdateClothing()
	custom
		var
			lstate = "left"
			rstate = "right"
		New()
			name = input("Choose a name") as text
			icon = input("Select icon") as icon
			icon_state = input("Inventory icon state") as text|null
			lstate = input("Left hand icon state", "lstate", lstate) as text
			rstate = input("Right hand icon state", "rstate", rstate) as text
			armour = (input("Armour") as num|null) || armour
			attackpow = (input("Attack power") as num|null) || attackpow
	torch
		icon = 'icons/items.dmi'
		icon_state = "torch"
		luminosity = 6
		getting()
			src.sd_SetLuminosity(0)
		dropped()
			src.sd_SetLuminosity(6)
	axe
		icon_state = "axe"
	bow
		icon_state = "bow"
	revolver
		icon = 'icons/weapons.dmi'
		icon_state = "revolver"
		two_handed = TRUE
		var/bullets = 5
		New()
			. = ..()
			suffix = "[bullets] bullets left!"
		Click()
			. = ..()
			suffix = "[bullets] bullets left!" + ((usr.lhand == src || usr.rhand == src) ? " Equipped[two_handed ? " (hands)":]" : "")
	minigun
		icon = 'icons/weapons.dmi'
		//icon_state = "minigun"
		icon_state = "revolver"
		s_istate = "minigun"
		two_handed = TRUE
		var
			bullets = 400
			state = 3 //1 = spinning, 2 = firing, 3 = crit firing
		New()
			. = ..()
			suffix = "[bullets] bullets left!"
		Click()
			. = ..()
			state = 0
			suffix = "[bullets] bullets left!" + ((usr.lhand == src || usr.rhand == src) ? " Equipped[two_handed ? " (hands)":]" : "")
		verb
			spin()
				if(usr.lhand != src && usr.rhand != src) return
				if(ActionLock("state", 40)) return
				if(state)
					state = 0
					s_istate = "minigun"
					usr.UpdateClothing()
				else
					s_istate = "minigun1"
					usr.UpdateClothing()
					ActionLock("fire", 20)
					state = 1
					spawn loop()
			fire()
				if(usr.lhand != src && usr.rhand != src) return
				if(ActionLock("fire", 30)) return
				if(state == 1)
					state = 2
					s_istate = "minigun2"
					usr.UpdateClothing()
					//spawn firing()
				else if(state == 2)
					state = 1
					s_istate = "minigun1"
					usr.UpdateClothing()
		proc
			loop()
				play_sound(usr, hearers(usr), sound('sounds/minigun_wind_up.ogg', channel = 666, volume = 25))
				spawn(20)
					var/list/mobs = list()
					while(state)
						var/snd
						if(state >= 2 && bullets <= 0)
							snd = 'sounds/minigun_empty.ogg'
							if(s_istate != "minigun1")
								s_istate = "minigun1"
								var/mob/M = loc
								if(istype(M)) M.UpdateClothing()
						else if(state == 3 || ActionLock("crit"))
							snd = 'sounds/minigun_shoot_crit.ogg'
						else if(state == 2)
							snd = 'sounds/minigun_shoot.ogg'
						else if(state)
							snd = 'sounds/minigun_spin.ogg'
						var/list/L = hearers(loc)
						for(var/mob/M in L)
							if(!M.key) continue
							if(M.key && !M.client)
								mobs -= M
								continue
							if(mobs[M] == snd) continue
							mobs[M] = snd
							M << sound(file = snd, repeat = 1, channel = 666, volume = 25)
						for(var/mob/M in mobs - L)
							mobs -= M
							M << sound(null, channel = 666)

						if(state >= 2 && bullets > 0)
							if(s_istate != "minigun2")
								s_istate = "minigun2"
								var/mob/M = loc
								if(istype(M)) M.UpdateClothing()
							bullets -= 5
							suffix = "[bullets] bullets left!" + ((loc:lhand == src || loc:rhand == src) ? " Equipped[two_handed ? " (hands)":]" : "")
							new/projectile/minigun_bullet(loc, 1, (state == 3 || ActionLock("crit") ? 1 : 0))
							new/projectile/minigun_bullet(loc, -12, (state == 3 || ActionLock("crit") ? 1 : 0))
							new/projectile/minigun_bullet(loc, 12, (state == 3 || ActionLock("crit") ? 1 : 0))
							new/projectile/minigun_bullet(loc, -24, (state == 3 || ActionLock("crit") ? 1 : 0))
							new/projectile/minigun_bullet(loc, 24, (state == 3 || ActionLock("crit") ? 1 : 0))
							if(prob(2)) ActionLock("crit", rand(20, 50))

						var/mob/M = loc
						if(!istype(M) || M.weakened > 0 || M.HP <= 0 || M.corpse)
							state = 0
							break
						sleep(5)
					ActionLock("state", 20)
					for(var/mob/M in mobs)
						M << sound(null, channel = 666)
						M << sound('sounds/minigun_wind_down.ogg', channel = 666, volume = 25)
	fishing_rod
		icon_state = "rod"
	hoe
		icon_state = "hoe"
	sledgehammer
		attackpow=2
		icon_state = "sledgehammer"
	pickaxe
		icon_state = "pickaxe"
	knife
		icon_state = "knife"
	shears
		icon_state = "shears"
	excowlibur
		attackpow=15
		name="Excowlibur"
		icon_state = "excowlibur"
		two_handed = TRUE
	katana
		attackpow=6
		name="Katana"
		icon_state = "katana"
	gold_sword
		attackpow=4
		icon_state = "gold_sword"
		name = "Gold Sword"
	gold_shield
		icon_state = "gold_shield"
		name = "Gold Shield"
		armour = 2
	iron_sword
		attackpow=2
		icon_state = "iron_sword"
		name = "Iron Sword"
	tin_sword
		attackpow=1.5
		icon_state = "tin_sword"
		name = "Tin Sword"
	copper_sword
		attackpow=1.75
		icon_state = "copper_sword"
		name = "Copper Sword"
	tungsten_sword
		attackpow=1.9
		icon_state = "tungsten_sword"
		name = "Tungsten Sword"
	silver_sword
		attackpow=2.5
		icon_state = "silver_sword"
		name = "Silver Sword"
	palladium_sword
		attackpow=3
		icon_state = "palladium_sword"
		name = "Palladium Sword"
	mithril_sword
		attackpow=5
		icon_state = "mithril_sword"
		name = "Mithril Sword"
	magicite_sword
		attackpow=10
		icon_state = "magicite_sword"
		name = "Magicite Sword"
		two_handed = TRUE
	adamantite_sword
		attackpow=20
		icon_state = "adamantite_sword"
		name = "Adamantite Blood Blade"
		two_handed = TRUE
	cutlass
		attackpow=2
		icon_state = "cutlass"
	iron_shield
		icon_state = "iron_shield"
		armour = 1
		name = "Iron Shield"
	iron_club
		attackpow=2
		icon_state = "iron_club"
	grandius
		name="Grandius"
		attackpow=8
		icon_state = "grandius"
		two_handed = TRUE
	red_tinted_sword
		icon_state = "noble_sword"
	red_tinted_shield
		icon_state = "noble_shield"
	watchman_sword
		icon_state = "watchman_sword"
	watchman_shield
		icon_state = "watchman_shield"
	tin_shield
		armour = 0.25
		icon_state = "tin_shield"
		name = "Tin Shield"
	copper_shield
		armour = 0.5
		icon_state = "copper_shield"
		name = "Copper Shield"
	tungsten_shield
		armour = 0.75
		icon_state = "tungsten_shield"
		name = "Tungsten Shield"
	silver_shield
		armour = 1.25
		icon_state = "silver_shield"
		name = "Silver Shield"
	palladium_shield
		armour = 1.75
		icon_state = "palladium_shield"
		name = "Palladium Shield"
	mithril_shield
		armour = 2.25
		icon_state = "mithril_shield"
		name = "Mithril Shield"
	staff
		attackpow=2
		name="Red Staff"
		icon_state = "rstaff"
		var
			mob/owner
			disabled = 0
			disableCount = 0
		New(loc, mob/owner, color)
			. = ..()
			src.owner = owner
			icon_state = "[lowertext(copytext(color, 1, 2))]staff"
			name = "[color] Staff"
		proc
			disable(time = rand(600, 1200))
				if(++disableCount > 255) disableCount = 0
				var/count = disableCount

				if(owner && !disabled)
					disabled = 1
					owner.show_message("<i>Your powers have been subdued!</i>")
					for(var/spell/S in owner.spells)
						S.flags |= S.FLAG_DISABLED
					hud_main.UpdateHUD(owner)

				if(time > 0)
					spawn(time) if(count == disableCount) enable()
			enable()
				if(!disabled) return
				disabled = 0
				if(owner)
					owner.show_message("<i>You regain control of your powers.</i>")
					for(var/spell/S in owner.spells)
						S.flags &= ~S.FLAG_DISABLED
					hud_main.UpdateHUD(owner)
	archduke_staff
		name = "Archduke Staff"
		icon_state = "archduke"
		attackpow = 2.5
	bstaff
		attackpow=2
		name="Blue Staff"
		icon_state = "bstaff"
		portal_staff
			var
				turf/target
			verb
				open_portal()
					var/turf/T = usr.loc
					. = 0
					while(T && . <= 2)
						T = get_step(T, usr.dir)
						.++
					if(T && src.target)
						var
							target = locate(src.target.x, src.target.y, (usr.z == worldz || usr.z == 4 ? src.target.z : worldz))
							obj/portal
								O = new(T)
								O2 = new(target)
						O.target = target
						O2.target = T
						for(var/mob/M in hearers(20, O))
							M << sound('sounds/sliders_timer.ogg')
						for(var/mob/M in hearers(20, O2))
							M << sound('sounds/sliders_timer.ogg')
						spawn(380)
							del O
							del O2
				set_target()
					usr.show_message("Target coordinates saved into staff!")
					var/z
					switch(gametype)
						if("peasants") z = 3
						if("kingdoms") z = 5
						else z = 2
					target = locate(usr.x, usr.y, z)
	hunting_spear
		attackpow=2
		icon_state = "hunting_spear"
		two_handed = TRUE
	watchman_club
		attackpow=1
		icon_state = "watchman_club"
	wood_sword
		attackpow=1
		icon_state = "wood_sword"
	wood_shield
		icon_state = "wood_shield"
	wood_club
		attackpow=1
		icon_state = "wood_club"
	//rod
	//	icon_state = "rod"
	shovel
		icon_state = "shovel"
		verb
			dig_hole()
				if(usr.inHand(/item/weapon/shovel))
					if(MapLayer(usr.z) < -4) return
					if(istype(usr.loc, /turf/sand))
						new/turf/digging(usr.loc)
						usr.movable=1
						sleep(40)
						usr.movable=0
						return
					if(istype(usr.loc, /turf/path))
						new/turf/digging(usr.loc)
						usr.movable=1
						sleep(40)
						usr.movable=0
						return
					if(istype(usr.loc, /turf/grass))
						new/turf/digging(usr.loc)
						usr.movable=1
						sleep(40)
						usr.movable=0
						return
					else
						return
				else
					usr.show_message("You need to be holding a shovel to do that!")
	spear
		icon_state = "spear"
		attackpow=4
		two_handed = TRUE
	halberd
		icon_state = "halberd"
		attackpow=6
		two_handed = TRUE
	whip
		icon_state = "whip"
		attackpow = 3
	torch
		inv_type = 3
		icon_state = "torch"
		luminosity = 4
	coffee
		inv_type = 3
		icon = 'icons/l_items.dmi'
		icon_state = "coffee"
		var/amount = 4
		verb
			Drink()
				if(amount <= 0)
					usr.show_message("<tt>The coffee cup is empty!</tt>")
					return
				usr.show_message("<tt>You take a sip of coffee...</tt>")
				for(var/mob/N in oviewers(usr))
					N.show_message("<tt>[usr.name] takes a sip of coffee...</tt>")

				amount--
				usr.effects.caffeine = max(usr.effects.caffeine + 20, 60)