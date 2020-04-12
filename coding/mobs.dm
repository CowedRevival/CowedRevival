mob_effects
	var
		caffeine = 0
		psychic = 0
		alcohol = 0
mob_skills
	var
		hunting = 0
		farming = 0
		fishing = 0
		mining = 0
		recycling = 0
		looting = 35
		smithing = 0
		tailoring = 0
		medicine = 0

mob
	anchored = 0
	var
		hair
		beard
	var
		state = "alive" //possible values: alive, ghost, ghost-i, zombie, skeleton, hidden
		mob_skills/skills = new
		screen
			intent_selector/hud_intSelector
			buttons
				Music/hud_btnMusic
				pull/hud_btnPull
				Cancel/hud_btnCancelAction
				reset_reboot_timer/hud_btnResetRebootTimer
			tabs/health/hud_tabHealth
		music
		hud_spellStart = 1
		spell_component/selectedSpellComponent //selected spell component (for use in click spell + click object)


		shackled=0
		legshackled=0
		last_msg
		spam_times = 0

		item
			armour
				hat/hequipped
				face/fequipped
				body/bequipped
				cloak/cequipped
				hood/mequipped
			weapon
				lhand
				rhand
		list
			spells
			player_log //contains a log of recent activities (stores up to 65535 records)
		stunned = 0
		weakened = 0
		moveCount = 0
		speed = 40 //speed in percent; 100 is super fast
		_c_speed //cached speed
		_speed //actual speed
		_d_speed //movement delay
		mob/spell_shield
		datum/using
		tmp/sight_override = 0

		defence = 0
		strength = 1

		base_defence = 0
		base_strength = 1
		base_speed = 40

		atom/old_loc
		stealproof = 0
		mob/corpse
		animal/mounted
		atom
			lastHole //last hole/thing I jumped into (for animals to follow or homing missiles)
			moveRelay //what controls my movement?
			current_action //my current action: call current_action.Abort() if it is aborted
		tmp/list/admin_viewports
		character_handling/container/kingdom
		family/family
		chosen
		paint_window/paint_window
		initial_net_worth = 0

		mob_effects/effects = new
		last_hurt
		magic_points = 0
		tmp_magic_points = 0
		tmp_magic_data = 0

		berry_effects/Effects = new

	proc
		RemoveClassImages()
			for(var/character_handling/container/O in game.kingdoms)
				client.images -= O.redx
				client.images -= O.bluex
				for(var/character_handling/container/O2 in O.children)
					client.images -= O2.redx
					client.images -= O2.bluex
					for(var/character_handling/class/C in O2.children)
						client.images -= C.redx
						client.images -= C.bluex
						if(C.img_amount) client.images -= C.img_amount
		CheckGhost() return 0
		GetFamilies(founder_only = 0)
			var/list/L = new/list()
			for(var/family/F in global.admin.families)
				if(ckey in developers) L += F
				else if(founder_only && F.founder == key) L += F
				else if(!founder_only && (key in F.members)) L += F
			return L
		PlaySound(sound/S)
			src << S
			for(var/mob/M in src) M.PlaySound(S) //relay
		Log(t)
			if(!key) return
			if(!player_log) player_log = new/list()
			if(player_log.len > 65535) player_log -= player_log[1]
			player_log += t
		inHand(type)
			return (istype(lhand, type) || istype(rhand, type))
		isEquipped(item/I)
			if(lhand == I || rhand == I) return 1
			if(hequipped == I || fequipped == I || bequipped == I || cequipped == I || mequipped == I) return 2
			return 0
		restrained() return (corpse || shackled || movable || stunned > 0 || weakened > 0)
		make_wizard(color)
			var/item/armour/hat/mage_hat/hat = new(src)
			hat.icon_state = "[lowertext(copytext(color, 1, 2))]mage_hat"
			var/item/armour/body/mage_cloths/cloths = new(src)
			cloths.icon_state = "[lowertext(copytext(color, 1, 2))]mage"
			new/item/weapon/staff(src, src, color)
			src.contents+=new/item/misc/spellbook/Empty_Spellbook

			switch(color)
				if("Red") src.learn_spell(/spell/fireball, 1)
				if("Blue") src.learn_spell(/spell/iceball, 1)
				if("Orange") src.learn_spell(/spell/zap, 1)
				if("Green") src.learn_spell(/spell/heal, 1)
				if("Purple") src.learn_spell(/spell/power_mimic, 1)
			src.learn_spell(/spell/shield, 0)
			src.learn_spell(/spell/enchant, 0)
			src.learn_spell(/spell/school_of_magic, 0)
			src.mage = 1
			src << "<i>You are now the [color] Wizard!</i>"
		equipped(item/I)
			return (hequipped == I || fequipped == I || bequipped == I || cequipped == I || mequipped == I || lhand == I || rhand == I)
	//startingverb/verb
	//	check_address() usr<<"byond://[world.address]:[world.port]"
	verb
		/*ChangeName()
			var/default_name = name
			if(!default_name)
				default_name = "Ben Dover"
			var/charactername
			var/old_name = name
			var/A
			choose_name
			charactername = input(src, "Pick an RP name.", "Name"/*, name*/) as text //to protect (from) nubs.
			A = CheckName(charactername)
			if(!A) goto choose_name

			if (!trimAll(charactername) || trimAll(charactername) == " ")
				// Guess they don't want to create a new character after all, so send them to choose a character.
				alert("No name entered! Try Again!")
				goto choose_name
			if(charactername in names) if(charactername!=name)
				alert("Sorry this name has already been taken")
				goto choose_name
			name = charactername
			client.Save()
			if(chosen)
				send_message(src, "The change will come into effect the next round.", 3)
				name = old_name
			else if(old_name in names)
				names -= old_name
		ChangeGender()
			gender = gender == FEMALE ? MALE : FEMALE
			client.Save()
			if(chosen)
				send_message(src, "The change will come into effect the next round.", 3)
				gender = gender == FEMALE ? MALE : FEMALE

			if(gender == FEMALE) icon = 'icons/CowF.dmi'
			else icon = 'icons/Cow.dmi'*/
		/*ToggleSounds()
			music = !music
			client.Save()
			send_message(src, "You will [music ? "now" : "no longer"] hear sounds or music played by administrators.", 3)
			if(!music) src << sound(null)*/
		Rules() usr << browse(file2text("rules.htm"), "window=rules;size=700x300;can_minimize=0;can_resize=0")
		Medals()
			if(!client || !client.player) return
			var/player/P = client.player
			if(!P.medals || !P.medals.len)
				usr << "<tt>You have no medals.</tt>"
			else
				usr << "<tt>You have received the following medals:</tt>"
				for(var/medal in P.medals) usr << "<tt>\t [medal2text(medal)]</tt>"
				usr << "<tt>See a detailed list on the <a href=\"http://www.byond.com/games/Cowed/Cowed#standings\">Cowed hub</a>.</tt>"
		say(msg as text)
			set hidden = 1
			if(usr && usr.client && (usr.client.muted == 1 || usr.client.muted == 3))
				send_message(usr, "You're muted!", 3)
				return
			if(!msg) return
			if(usr.ActionLock("message", 2)) return
			msg = avoid_spam(msg)

			if(icon_state == "ghost" || HP <= 0 || corpse) //dead
				for(var/mob/M in world)
					if(istype(M.loc, /turf/pede) || M.HP <= 0 || M.icon_state == "ghost" || M.corpse || (M.effects && M.effects.psychic > 5))
						M.show_message("<i>\[dead\] [usr] says: [msg]</i>")
				return

			. = "<b>[name]</b> says, \"[html_encode(msg)]\""
			var/list/hearers = hearers(src)
			if(!(weregoat_goat in hearers)) hearers += weregoat_goat
			for(var/mob/N in hearers)
				N.show_message(., 2)
			for(var/obj/O in range(src)) O.hear(src, ., msg)
			computer.hear(src, msg, 1)

			. = "<i>\[Fire Stone\]</i> [.]"
			var/list/L = new/list()
			for(var/item/misc/fire_stone/I in src.contents + range(src))
				if(I.flags & I.FLAG_ACTIVE)
					var/item/misc/fire_stone/other = I.other()
					if(other)
						flick("fire_stone1", I)
						flick("fire_stone1", other)
						if(ismob(other.loc))
							for(var/mob/N in hearers(other.loc, 3))
								if(!(N in L) && !(N in hearers)) L += N
						else
							for(var/mob/N in hearers(other))
								if(!(N in L) && !(N in hearers)) L += N
			for(var/mob/N in L) N.show_message(., 2)
			chat_log << "\[<font color = green><b>[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\]</b> [html_encode("[usr] - [key] says: [msg]")]</font><br />"
		OOC(msg as text)
			set hidden = 1
			if(usr && usr.client && (usr.client.muted == 2 || usr.client.muted == 3))
				send_message(usr, "You're muted!", 3)
				return

			if(!msg) return
			if(usr.ActionLock("message", 2)) return
			msg = avoid_spam(msg)
			if(oocon==0 && (!usr || !usr.client || !usr.client.admin))
				send_message(usr, "The ooc is turned off", 2)
				return
			. = "<font color=\"#484848\"><strong>"
			if(client && client.admin)
				. += "<font color=\"#764848\">"
				if(client.admin.rank == "Developer") . += "\[D\]"
				else . += "\[A\]"
				. += "</font> "
			. += "OOC: [key]</strong>: "
			if(client && client.admin && dd_hasprefix(msg, ";"))
				. = "* [.]"
				. += html_encode(copytext(msg, 2))
				send_message(world, ., 3)
			else
				. += html_encode(msg)
				send_message(world, ., 2)
			computer.hear(src, msg)
			chat_log << "\[<font color = blue>[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\] [usr] - [key] OOC: [html_encode(msg)]</font><br />"
		emote(T as text)
			if(icon_state == "ghost") return
			if(usr && usr.client && (usr.client.muted == 1 || usr.client.muted == 3))
				send_message(usr, "You're muted!", 3)
				return
			if(!T)
				return
			if(usr.ActionLock("message", 2)) return
			T = avoid_spam(T)
			if(!dd_hassuffix(T, ".") && !dd_hassuffix(T, "!") && !dd_hassuffix(T, "?")) T = "[T]."
			. = "<b>[name]</b> [html_encode(T)]"
			for(var/mob/N in hearers(src)) N.show_message(., 1)
			chat_log << "\[<font color = green><b>[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\]</b> [usr] - [key] emote: [html_encode(T)]</font><br />"

		whisper(T as text)
			if(icon_state == "ghost") return
			if(usr && usr.client && (usr.client.muted == 1 || usr.client.muted == 3))
				send_message(usr, "You're muted!", 3)
				return
			if(!T)
				return
			if(usr.ActionLock("message", 2)) return
			T = avoid_spam(T)
			if(usr.icon_state == "ghost")
				send_message(usr, "You can not talk to the living!", 3)
				return
			. = "<i>[name] whispers, \"[html_encode(T)]\"</i>"
			var/list/hearers = hearers(1, src)
			for(var/mob/N in hearers)
				N.show_message(., 2)

			. = "<i>\[Fire Stone\]</i> [.]"
			var/list/L = new/list()
			for(var/item/misc/fire_stone/I in src.contents + range(src))
				if(I.flags & I.FLAG_ACTIVE)
					var/item/misc/fire_stone/other = I.other()
					if(other)
						flick("fire_stone1", I)
						flick("fire_stone1", other)
						if(ismob(other.loc))
							for(var/mob/N in hearers(2, other.loc))
								if(!(N in L) && !(N in hearers)) L += N
						else
							for(var/mob/N in hearers(2, other))
								if(!(N in L) && !(N in hearers)) L += N
			for(var/mob/N in L) N.show_message(., 2)
			chat_log << "\[<font color = green><b>[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\]</b> [usr] - [key] whisper: [html_encode(T)]</font><br />"
		reboot_check_time()
			if(vote_system.vote_reboot)
				if(vote_system.reboot_time)
					var/timeleft = round((1800 - vote_system.reboot_time) / 60)
					send_message(usr, "[timeleft] minutes until the next vote-to-reboot.", 3)
				else
					send_message(usr, "Vote in progress or game not yet started.", 3)
			else send_message(usr, "Automatic reboot vote is off.", 3)
		loot(mob/M in view(1, src))
			if(!(M in view(1, src))) return
			if(istype(M, /animal) && M.HP > 0) return
			if(restrained() || ActionLock("loot", 100)) return

			var/list/L = new/list()
			for(var/item/I in M.contents)
				if(M.icon_state == "alive" && M.equipped(I)) continue
				L += I
			var/item/I = input(usr, "Which item would you like to take?", "Loot") as null|anything in L
			if(I == null) return
			if(!M || M.icon_state == "alive" && M.equipped(I)) return
			if((!skills || skills.looting < 35) && !M.corpse && M.HP > 0)
				usr.show_message("<tt>You cannot loot items!</tt>")
				return

			var
				loot_chance = M.corpse || M.HP <= 0 ? 100 : skills.looting
				discover_chance
			if((M.weakened + M.stunned) <= 0) loot_chance -= 10
			if(!M.issleeping) loot_chance -= 5

			discover_chance = loot_chance + rand(0, 15)

			for(var/mob/N in hearers(src) - M)
				N.show_message("<b>[src.name]</b> starts to loot [I] from [M.name]...", 1)
			if(prob(discover_chance) || stealproof) M.show_message("<b>[src.name]</b> is trying to steal [I] from you.", 1)
			chat_log << "\<<font color = green><b>[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\]</b>\> [usr] tries to loot [I] from [M]!</font><br />"
			var
				M_moveCount = M.moveCount
				moveCount = src.moveCount
			spawn(rand(40, 100))
				if(!src || !M || moveCount != src.moveCount || M_moveCount != M.moveCount) return
				if(prob(1) && skills && skills.looting >= 35 && skills.looting < 60) M.skills.looting++
				var/fail = 0
				if(stealproof) fail = 1
				else if(M.corpse || M.HP <= 0) fail = 0
				else if(!prob(loot_chance)) fail = 1
				/*else if(M.HP > (M.MHP / 3)) //healty
					if(!M.issleeping && M.HP > (M.MHP / 2)) //more healthy
						if(prob(75)) fail = 1
					else
						if(M.issleeping && prob(50)) fail = 1
						else if(M.SLEEP > 20 && prob(25)) fail = 1
				else
					if(issleeping && prob(18)) fail = 1
					else if(!issleeping && prob(30)) fail = 1*/

				if(fail)
					for(var/mob/N in hearers(src) - M)
						N.show_message("<b>[src.name]</b> fails to loot [I] from [M.name]!", 1)
					M.show_message("<b>[src.name]</b> has failed to take [I] from you.", 1)
					chat_log << "<[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]> [usr] fails to loot [I] from [M]!<br />"
					if(issleeping)
						toggle_sleep(0)
						if(prob(25))
							for(var/mob/N in hearers(src))
								N.show_message("\red <b>[src.name]</b> retaliates against [M.name]!", 1)
							src.HP -= 10
							if(src.HP <= 0) src.HP = 0
							checkdead(src)
				else
					if(M.chosen == "king")
						if(corpse && corpse.client) corpse.medal_Report("king", I)
						else M.medal_Report("king", I)
					I.unequip()
					I.Move(src)
					for(var/mob/N in hearers(src) - M)
						N.show_message("<b>[src.name]</b> successfully loots [I] from [M.name]!", 1)
					M.show_message("<b>[src.name]</b> has successfully taken [I] from your inventory!", 1)
					chat_log << "<[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]> [usr] successfully loots [I] from [M]!<br />"

					M.UpdateClothing()
					src.UpdateClothing()
		Who()
			var
				total = 0
				total_admins = 0
			. = "<center><b>~Keys[client && client.admin ? " & Names" :]~</b><br>"
			for(var/mob/M)
				if(M.client)
					total++
					if(M.client.admin) total_admins++
					. += "<b>[M.key]</b>[client && client.admin ? " - [M.name]" :][istype(M, /mob/character_handling) ? "*":]<br>"
			. += "<br>Players Online: [total]"
			if(total_admins) . += "<br>Admins Online: [total_admins]"
			. += "<br><small>* Currently selecting a class.</small>"
			send_message(src, ., 3)
	Login()
		//Spawns
		for(var/animal/A in world) if(A.master == ckey)
			A.master = src
			if(!A.friends) A.friends = new/list()
			A.friends += A.master

		src.checkdead(src)
		hud_main.DisplayHUD(src)
		if(client)
			for(var/spell_component/O in client.screen) client.screen -= O
			for(var/spell/S in spells)
				for(var/spell_component/O in S.components) client.screen += O
		hud_main.UpdateHUD(src)
		src.verbs += typesof(/mob/startingverb/verb)

		if(!loggedin)
			loggedin = 1

			//send_message(usr, "\red <u><b>READ THE RULES. This is your only warning.", 3)
			send_message(usr, "\blue <center><b><BIG>[dd_replacetext(file2text("motd.txt"), "\n", "<br>")]", 3)
			if(client && client.admin)
				send_message(usr, "\blue <b><u>Welcome Administrator.</u> Below is the admin motd. Please do not share it with the peasants. Thanks!</b>", 3)
				send_message(usr, "\blue <center><b><BIG>[dd_replacetext(file2text("motd_admin.txt"), "\n", "<br>")]", 3)
		vote_system.SendMessage(src)
		winset(src, null, list2params(list(
			"default/game.child.left" = "default/map",
			"map.focus" = "false"
		)))


		/*if(usr.loggedin == 0)
			shackled=1
			Move(locate(8,9,1), forced = 1)
			loggedin = 1
			movable = 1

			var/obj/sp_start/O
			for(O in world) if(O.desc == src.ckey) break
			if(!O && (client && client.admin)) for(O in world) if(O.desc == "(ADMIN)") break
			if(O)
				Move(O.loc, forced = 1)
				shackled = 0
				usr.contents += usr.startingtools

				if(client && client.admin)
					usr.contents += new/item/armour/body/treksuit
					for(var/item/armour/body/treksuit/I in contents) I.Click() //thanks to transferral of usr
			else Move(locate(28, 9, 1), forced = 1)

			/*if(client && client.Jailed())
				old_loc = loc
				var/turf/T = pick(locate(152, 174, 1), locate(160, 167, 1))
				Move(T, forced = 1)
			else */if(!computer.holodeck)
				old_loc = loc
				Move(locate(150, 150, 1), forced = 1)*/
		/*if(!chosen)
			if(gender == FEMALE) icon = 'icons/CowF.dmi'
			else icon = 'icons/Cow.dmi'*/

		return ..()
	Logout()
		if(istype(using, /boat)) using = null
		else if(istype(using, /obj/tardis/main_console) || istype(using, /obj/admin/computer/viewscreen))
			src << link("byond://?src=\ref[using];cmd=close")

		if(shackled && !chosen) del src
	Move(turf/newloc, newdir, forced = 0)
		if(current_action) AbortAction()

		if(state=="hidden")
			src.dir = newdir
			return

		if(forced)
			if(++moveCount >= 65535) moveCount = 0
			. = ..()
			if(. && client && MapLayer(z) >= 1) update_sky()
			return .

		if(newdir) src.dir = newdir

		if(shackled || istype(src.loc, /atom/movable) || get_dist(src, whopull) > 1 || whopull == src)
			whopull = null
			if(hud_btnPull) hud_btnPull.reset()

		if(movable) return 0
		if(shackle_ball && !(newloc in range(3, shackle_ball))) return 0

		if(istype(loc, /obj/chest))
			var/obj/chest/O = loc
			if(!O.locked) O.open()
			else
				if(ActionLock("bang_noise", 50))
					for(var/mob/N in hearers(O))
						N.show_message("\icon[O] <h2>*bang* *bang*</h2>", 2)
			return

		if(density)
			for(var/atom/movable/O in get_step(src, newdir))
				if(O.density && !O.anchored && O != src)
					if(shackle_ball == O)
						SLEEP -= rand(5, 12)
						if(SLEEP <= 0) SLEEP = 0
					spawn step(O, newdir)
					return 0

		var/turf/old_loc = src.loc
		if(++moveCount >= 65535) moveCount = 0

		. = ..()

		if(. && client && MapLayer(z) >= 1) update_sky()

		if(shackle_ball) update_chains()
		if(istype(using, /boat))
			using = null
			if(client) winshow(src, "boat_control", 0)
		else if(istype(using, /obj/tardis/main_console) || istype(using, /obj/admin/computer/viewscreen))
			src << link("byond://?src=\ref[using];cmd=close")

		if(src.loc != old_loc && whopull)
			var/atom/movable/O = whopull
			O.Move(old_loc)
	MouseDrop(obj/chest/O)
		if(istype(O) && O.icon_state == "chest open" && (usr in range(1, O)) && (src in range(1, usr)) && HP > 0)
			for(var/mob/N in hearers(src))
				N.show_message("<b>[usr.name]</b> shoves [src == usr ? (usr.gender == FEMALE ? "herself" : "himself") : "[src.name]"] in the chest!")
			Move(O.loc, forced = 1)
			return
		return ..()
	Stat()
		if(statpanel("Stats"))
			stat("<b>Character Information</b>")
			stat("RP Name:", name)
			stat("HP", "[HP]/[MHP] ([round(HP / (MHP / 100))]%)")
			stat("Fatigue", "[SLEEP]/[MSLEEP] ([round(SLEEP / (MSLEEP / 100))]%)")
			stat("Strength", strength)
			stat("Defense", defence)
			if(skills)
				stat("")
				stat("<b>Skills</b>")
				stat("Hunting", "[skills.hunting]/100")
				stat("Farming", "[skills.farming]/100")
				stat("Fishing", "[skills.fishing]/100")
				stat("Mining", "[skills.mining]/100")
				stat("Smithing", "[skills.smithing]/100")
				stat("Medicine", "[skills.medicine]/100")
				stat("Tailoring", "[skills.tailoring]/100")
			stat("")
			stat("<b>Game Information</b>")
			stat("Mode", gametype)
			stat("Game Time", "[Day] day, [Month] month, [Hour] hour")
			if(vote_system.vote) stat("Vote", "[estimate_time(vote_system.vote_timeout - world.timeofday)]")
			stat("")
			stat("<b>Server Information</b>")
			stat("Host", world.host)
			stat("Address", "[world.url || (world.address + ":[world.port]")]")
		if(statpanel("Armour"))
			for(var/item/O in contents)
				if((O.inv_type == 0 && istype(O, /item/armour)) || O.inv_type == 1)
					stat(O)
		if(statpanel("Weapons/Tools"))
			for(var/item/O in contents)
				if((O.inv_type == 0 && istype(O, /item/weapon)) || O.inv_type == 2)
					stat(O)
		if(statpanel("Misc"))
			for(var/item/O in contents)
				if((O.inv_type == 0 && istype(O, /item/misc)) || O.inv_type == 3)
					stat(O)
/*		if(usr.passworded == 1)
			if(statpanel("Armour"))
				for(var/obj/O in src.contents)
					if(O.WhatInventory == InventoryOne)
						stat(O)
			if(statpanel("Weapons/Tools"))
				for(var/obj/O in src.contents)
					if(O.WhatInventory == InventoryTwo)
						stat(O)
			if(statpanel("Misc"))
				for(var/obj/O in src.contents)
					if(O.WhatInventory == InventoryThree)
						O.checked=0
				for(var/obj/O in src.contents)
					if(O.WhatInventory == InventoryThree)
						if(!(O.type in T))
							if(istype(O,/item/misc/key))
								O.checked=0
								goto skip
							T+=O.type
							var/count=0
							for(var/obj/o in src.contents)
								if(o.type==O.type)
									count++
									if(o!=O)
										o.checked=1

							if(count>1)
								O.suffix="x[count]"
							skip
							if(O.checked!=1)
								stat(O)
					//	O.checked=1
					//stat(O)
			//T=new
			*/
	attack_hand(mob/M)
		if(M.inHand(/item/weapon/knife) && HP <= 0)
			Butcher(M)
			return
		else return M.attack(src)
	proc/Butcher(var/mob/M)
		if(HP > 0) return
		if(tag == "Skeleton")
			usr << "You can't butcher a skeleton. Better bury it."
		for(var/mob/N in hearers(src))
			N.show_message("<b>[M.name]</b> begins to butcher [name]!", 1)
		usr.movable=1
		sleep(40)
		usr.movable=0
		var/hunter_yield = 0
		var/hunter_range = 3
		if(M.skills.hunting == 100)
			hunter_yield += 1
			hunter_range +=1
		if(M.skills.hunting == 75)
			hunter_range +=1
		if(M.skills.hunting == 50)
			hunter_yield += 1
			hunter_range +=1
		if(M.skills.hunting == 25)
			hunter_range +=1
		if(M.skills.hunting == 10)
			hunter_range +=1

		if(key)
			var/item/misc/food/Strange_Meat/MT = new(loc)
			MT.stacked = rand(1,hunter_range) + hunter_yield
			var/item/misc/bones/bone/B = new(loc)
			B.stacked = rand(1,hunter_range) + hunter_yield
			var/item/misc/bones/skull/S = new(loc)
			S.name = "[M.name]'s Skull"
		else if(istype(src, /mob/Frogman))
			var/item/misc/food/Frog_Meat/meat = new(loc)
			meat.stacked = rand(1,hunter_range) + hunter_yield
			var/item/misc/bones/bone/bone = new(loc)
			bone.stacked = rand(1,hunter_range) + hunter_yield
			if(prob(25)) new/item/misc/orbs/Frog_Orb(loc)
		else if(istype(src, /animal/wolf))
			var/item/misc/food/Meat/meat = new(loc)
			meat.stacked = rand(1,hunter_range) + hunter_yield
			var/item/misc/bones/bone/bone = new(loc)
			bone.stacked = rand(1,hunter_range) + hunter_yield
			var/item/misc/hide/hide = new(loc)
			hide.stacked = rand(1,hunter_range) + hunter_yield
		else
			var/item/misc/food/Meat/meat = new(loc)
			meat.stacked = rand(1,hunter_range) + hunter_yield
			var/item/misc/bones/bone/bone = new(loc)
			bone.stacked = rand(1,hunter_range) + hunter_yield
		for(var/item/I in src)
			I.loc = loc
		del(src)

	proc
		toggle_sleep(state = -1) //-1 = toggle, 1 = force on, 0 = force off
			if(icon_state == "ghost") return //can't sleep as a ghost
			if(issleeping && !rolling)
				if(state == 1) return //force on
				issleeping = 0
				if(icon_state == "ghost-corporeal-dead") icon_state = "ghost-corporeal"
				else if(icon_state == "ghost-incorporeal-dead") icon_state = "ghost-incorporeal"
				else icon_state = "alive"
			else if(!issleeping && !rolling)
				if(state == 0) return //force off
				issleeping = 1
				if(icon_state == "ghost-corporeal") icon_state = "ghost-corporeal-dead"
				else if(icon_state == "ghost-incorporeal") icon_state = "ghost-incorporeal-dead"
				else icon_state = "dead"

				for(var/spell/S in spells) S.onSleep(src)

			UpdateClothing()
		avoid_spam(msg)
			if(spam_times >= 10) return
			spam_times++
			spawn(5) spam_times = max(0, spam_times - 1)

			if(length(msg) > 600) msg = copytext(msg, 1, 601)
			msg = dd_replacetext(msg, "\n", "\\n")
			return msg
		UpdateClothing()
			var/list/overlays = list()

			defence = base_defence
			strength = base_strength
			speed = base_speed

			if(state=="hidden")
				src.overlays = list()
				return

			if(beard)
				var/image/I = image(icon = 'icons/Beard.dmi', icon_state = beard)
				overlays += I
			if(hair && !mequipped)
				var/draw_hair = 1
				if(fequipped)
					if(fequipped.hide_hair == 1)
						draw_hair = 0
				else if(hequipped)
					if(hequipped.hide_hair == 1)
						draw_hair = 0
				if(draw_hair == 1)
					var/image/I = image(icon = 'icons/Hair.dmi', icon_state = hair)
					overlays += I

			if(lhand)
				var/image/I
				if (istype(lhand,/item/weapon/custom))
					I = image(icon = lhand.icon, icon_state = lhand:lstate)
				else
					if(lhand.s_istate)
						I = image(icon = 'icons/l_items.dmi', icon_state = "[lhand.s_istate]_b")
					else
						I = image(icon = 'icons/l_items.dmi', icon_state = "[lhand.icon_state]_b")
				if((state == "ghost" || state == "ghost-i"))
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC
				I.layer = 3
				overlays += I

			if(rhand)
				var/image/I
				if (istype(rhand,/item/weapon/custom))
					I = image(icon = rhand.icon, icon_state = rhand:rstate)
				else
					if(rhand.s_istate)
						I = image(icon = 'icons/r_items.dmi', icon_state = "[rhand.s_istate]_b")
					else
						I = image(icon = 'icons/r_items.dmi', icon_state = "[rhand.icon_state]_b")

				if((state == "ghost" || state == "ghost-i"))
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC
				I.layer = 3
				overlays += I

			if(bequipped)
				var/image/I
				if (istype(bequipped,/item/armour/body/custom))
					I = image(icon = bequipped.icon, icon_state = bequipped.icon_state)
				else
					I = image(icon = 'icons/mob.dmi', icon_state = bequipped.s_istate || bequipped.icon_state)
				if((state == "ghost" || state == "ghost-i") || bequipped.color)
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(bequipped.color) IC.Blend(bequipped.color)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC
				I.pixel_x = bequipped.overlay_pixel_x
				I.pixel_y = bequipped.overlay_pixel_y
				overlays += I
				defence += bequipped.armour
			if(fequipped)
				var/image/I
				if (istype(fequipped,/item/armour/face/custom))
					I = image(icon = fequipped.icon, icon_state = fequipped.icon_state)
				else
					I = image(icon = 'icons/mob.dmi', icon_state = fequipped.s_istate || fequipped.icon_state)
				if((state == "ghost" || state == "ghost-i") || fequipped.color)
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(fequipped.color) IC.Blend(fequipped.color)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC
				I.pixel_x = fequipped.overlay_pixel_x
				I.pixel_y = fequipped.overlay_pixel_y
				overlays += I
				defence += fequipped.armour
			if(cequipped)
				var/image/I
				if (istype(cequipped,/item/armour/cloak/custom))
					I = image(icon = cequipped.icon, icon_state = cequipped.icon_state)
				else
					I = image(icon = 'icons/mob.dmi', icon_state = cequipped.s_istate || cequipped.icon_state)
				if((state == "ghost" || state == "ghost-i") || cequipped.color)
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(cequipped.color) IC.Blend(cequipped.color)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC
				I.pixel_x = cequipped.overlay_pixel_x
				I.pixel_y = cequipped.overlay_pixel_y
				overlays += I
				defence += cequipped.armour
			if(hair && !mequipped)
				var/draw_hair = 1
				if(fequipped)
					if(fequipped.hide_hair == 1)
						draw_hair = 0
				else if(hequipped)
					if(hequipped.hide_hair == 1)
						draw_hair = 0
				if(draw_hair == 1)
					var/image/I = image(icon = 'icons/Hair.dmi', icon_state = "[hair]_b")
					overlays += I
			if(hequipped)
				var/image/I
				if (istype(hequipped,/item/armour/hat/custom))
					I = image(icon = hequipped.icon, icon_state = hequipped.icon_state)
				else
					I = image(icon = 'icons/mob.dmi', icon_state = hequipped.s_istate || hequipped.icon_state)
				if((state == "ghost" || state == "ghost-i") || hequipped.color)
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(hequipped.color) IC.Blend(hequipped.color)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC
				I.pixel_x = hequipped.overlay_pixel_x
				I.pixel_y = hequipped.overlay_pixel_y
				overlays += I
				defence += hequipped.armour
			if(mequipped)
				var/image/I
				if (istype(mequipped,/item/armour/hood/custom))
					I = image(icon = mequipped.icon, icon_state = mequipped.icon_state)
				else
					I = image(icon = 'icons/mob.dmi', icon_state = mequipped.s_istate || mequipped.icon_state)
				if((state == "ghost" || state == "ghost-i") || mequipped.color)
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(mequipped.color) IC.Blend(mequipped.color)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC
				I.pixel_x = mequipped.overlay_pixel_x
				I.pixel_y = mequipped.overlay_pixel_y
				overlays += I
				defence += mequipped.armour
			if(lhand)
				var/image/I
				if (istype(lhand,/item/weapon/custom))
					I = image(icon = lhand.icon, icon_state = lhand:lstate)
				else
					I = image(icon = 'icons/l_items.dmi', icon_state = lhand.s_istate || lhand.icon_state)

				if((state == "ghost" || state == "ghost-i"))
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC

				overlays += I
				strength += lhand.attackpow
				defence += lhand.armour
			if(rhand)
				var/image/I
				if (istype(rhand,/item/weapon/custom))
					I = image(icon = rhand.icon, icon_state = rhand:rstate)
				else
					I = image(icon = 'icons/r_items.dmi', icon_state = rhand.s_istate || rhand.icon_state)

				if((state == "ghost" || state == "ghost-i"))
					var/icon/IC = icon(icon = I.icon, icon_state = I.icon_state)
					if(state == "ghost") IC.Blend(rgb(0, 0, 0, 220), ICON_SUBTRACT)
					else if(state == "ghost-i") IC.Blend(rgb(0, 0, 0, 160), ICON_SUBTRACT)
					I.icon = IC

				overlays += I
				strength += rhand.attackpow
				defence += rhand.armour

			if(legshackled)
				if(icon_state == "ghost-incorporeal")
					legshackled = null
					new/item/misc/legshackles(src.loc)
				overlays += image(icon = 'icons/mob.dmi', icon_state = "leg_shackles")
			if(shackled)
				if(icon_state == "ghost-incorporeal")
					shackled = null
					new/item/misc/shackles(src.loc)
				overlays += image('icons/shackles.dmi')

			if(spell_shield) overlays += image(icon = 'icons/mob.dmi', icon_state = "spell_shield")

			underlays = list()
			if(mounted)
				speed = mounted.speed / 1.2
				strength /= 3
				strength = round(strength)
				if(strength < 0) strength = 0
				defence += round(mounted.defence / 3)
				underlays += image(icon = mounted.icon, icon_state = "alive")

			src.overlays = list()
			for(var/image/I in overlays)
				if(icon_state == "dead")
					var/icon/Icon = new/icon(icon = I.icon, icon_state = I.icon_state)
					Icon.Turn(90)
					I.icon = Icon
				src.overlays += I
	/*	berry_effect(state)
			var/effect
			switch(state)
				if("redb") effect = rbeffect
				if("blueb") effect = bbeffect
				if("yellowb") effect = ybeffect
				if("whiteb") effect = wbeffect
				if("blackb") effect = blbeffect

			switch(effect)
				if("Poison")
					poisoned += rand(1, 3)
				if("Heal")
					HP = min(MHP, HP + 10)
					infection = max(0, infection - 10)
					hud_main.UpdateHUD(src)
				if("Hurt")
					HP -= 20
					checkdead(src)
					hud_main.UpdateHUD(src)
				if("Sleep")
					hearers(src) << "\blue [name] sways around dizzily."
					SLEEP = 0
					toggle_sleep(1)
					hud_main.UpdateHUD(src)
				if("Food")
					HUNGER = min(100, HUNGER + 10)*/
		show_message(msg, flags = 0)
			for(var/mob/M in contents) M.show_message(msg, flags)
			if((flags & 1) && (sight & BLIND)) return
			send_message(src, msg, 1)
		Life()
			if(!chosen || corpse || HP <= 0) //ghosts and players who aren't playing get nothing. NOTHING!
				if(HP <= 0 && icon_state != "dead")
					icon_state = "dead"
					UpdateClothing()
				return

			var
				UpdateHUD = 0 //if 1, HUD will be updated at the end

			if(issleeping) //sleeping? let's increase sleep over time
				var/bed = locate(/obj/bed, loc)
				SLEEP++
				if(bed) SLEEP++
				if(SLEEP >= MSLEEP) SLEEP = MSLEEP
				UpdateHUD = 1


			if(issleeping || weakened > 0)
				sight = BLIND
			else if(sight == BLIND)
				sight = SEE_PIXELS

			if(effects) //handle effects/chemicals
				if(effects.caffeine > 0)
					effects.caffeine--
					SLEEP += rand(0.5, 3)
					if(SLEEP >= 40 && prob(5))
						HP--
						last_hurt = "coffee"
					if(SLEEP >= 20 && prob(20))
						HUNGER -= rand(0.75, 4)
					UpdateHUD = 1
				if(effects.psychic > 0)
					effects.psychic--
					if(prob(20))
						SLEEP--
						if(prob(90)) SLEEP -= 4
					if(prob(10))
						HP--
						if(prob(10)) HP -= 4
					UpdateHUD = 1

			if(Effects)
				Effects.on_mob_life(src)

			if(!(life_time % 240))
				HUNGER -= 1
				THIRST -= 1
				UpdateHUD = 1
				if(HUNGER <= 1)
					show_message("You are so hungry you bite yourself and keep chewing on yourself!")
					src.HUNGER += 10
					src.HP -= 10
					src.last_hurt = "hunger"
					UpdateHUD = 1
					checkdead(src)
				if(THIRST <= 1)
					src.HP -= 5
					src.last_hurt = "thirst"
					UpdateHUD = 1
					checkdead(src)

			if(infection_mode && src.infection > 0)
				if(prob(src.infection + 10)) src.infection++
				if(src.infection >= 100)
					src.icon = 'icons/Zombie.dmi'
					src.isMonster = 1
					send_message(world, "<b><font color=\"#00FF00\">[src.name] has become a zombie!</font></b>", 1)

			/*if(!ismob(loc) && gametype == "weregoat")
				if((Hour >= 21 && Hour <= 24) || (Hour >= 0 && Hour <= 5))
					if(istype(src, /mob/weregoat))
						if(weregoat_cow.HP <= 0) weregoat_cow.revive()
						Move(weregoat_cow.loc, forced = 1)
						weregoat_cow.Move(src, forced = 1)
						send_message(weregoat_cow + weregoat_goat, "<i>You transform into a weregoat! AWOOOO!!</i>", 1)
				else if(!istype(src, /mob/weregoat))
					Move(weregoat_goat.loc, forced = 1)
					weregoat_goat.Move(src, forced = 1)
					send_message(weregoat_cow + weregoat_goat, "<i>You revert back to your cow form!</i>", 1)
					if(HP <= 0) revive()*/

			if(src.poisoned >= 1)
				if(prob(poisoned))
					src.HP -= rand(round(src.poisoned * 0.5), round(src.poisoned * 1.5))
					last_hurt = "poison"
					checkdead(src)

			if(SLEEP <= 0) toggle_sleep(1) //immediate sleep caused by spells/hunger.
			if(!issleeping && !(life_time % 480) && --SLEEP <= 0) toggle_sleep(1)

			for(var/spell/O in spells)
				for(var/spell_component/S in O.components)
					S.overlays = list()
					if(S.canInvoke(src) != 1) S.overlays += image(icon = 'icons/screen_spells.dmi', icon_state = "disabled")
					if(S.primary) S.overlays += image(icon = 'icons/screen_spells.dmi', icon_state = "primaryline")

			if(istype(src, /mob/weregoat)) src.see_in_dark = 16
			else if(Hour >= 0 && Hour <= 4) src.see_in_dark = 3
			else if(Hour >= 5 && Hour < 8) src.see_in_dark = 4
			else if(Hour >= 8 && Hour < 11) src.see_in_dark = 6
			else if(Hour >= 12 && Hour < 18) src.see_in_dark = 16
			else if(Hour >= 18 && Hour < 21) src.see_in_dark = 6
			else if(Hour >= 21 && Hour <= 24) src.see_in_dark = 4

			if(!(life_time % 100))
				var/list/L = new/list()
				for(var/item/I in src.contents)
					if(I.type in L) continue
					L += I.type
					I.CheckStacked(src)

			if(stunned > 0) stunned--
			if(weakened > 0) weakened--

			if(issleeping || weakened > 0 || HP <= 0)
				if(icon_state != "dead")
					icon_state = "dead"
					UpdateClothing()
			else
				if(icon_state != "alive" && state != "hidden")
					icon_state = "alive"
					UpdateClothing()

			if(ActionLock("spell_luminosity"))
				if(luminosity != 12) src.sd_SetLuminosity(12)
			else if(istype(lhand, /item/weapon/torch) || istype(rhand, /item/weapon/torch))
				if(luminosity != 6) src.sd_SetLuminosity(6)
			else
				if(luminosity != 0) src.sd_SetLuminosity(0)

			if(client && UpdateHUD) hud_main.UpdateHUD(src)
		attack(mob/M)
			if(issleeping || restrained() || istype(M, /mob/eavesdropper)) return
			if(src.ActionLock("attacking", 5)) return
			if(get_dist(src, M) > 1) return //can't attack when outside of range!
			src.AbortAction()
			switch(attackmode)
				if("Examine")
					if (M.icon_state != "dead") return
					if (!M.corpse)
						show_message("This person isn't dead, just sleeping.")
						return
					switch (M.last_hurt)
						if ("hunger")
							show_message("This person looks real skinny, and some parts have been eaten off!")
						if ("sword")
							show_message("This person has some cuts in the shape of a sword!")
						if ("halberd")
							show_message("This person has a huge piece cut out, must've been a heavy weapon!")
						if ("blunt")
							show_message("This person has some blue and red spots all over his body, almost like someone punched him several times!")
						if ("fire")
							show_message("This person has burn marks all over his body!")
						if ("ice")
							show_message("This person feels real cold, and has a hard cover around him.")
						if ("zap")
							show_message("This person looks shocked and immobilized.")
						if ("frog")
							;
						// etc. WIP
				if("Attack")
					for(var/mob/N in hearers(M))
						N.show_message("\red <b>[src.name] attacks [M.name]!</b>")
					chat_log << "<font color=\"red\">[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]&gt; [src.name][src.key?(" - " + src.key):""] attacks [M.name][M.key?(" - " + M.key):""]!</font><br />"

					if(istype(M, /animal))
						var/animal/A = M
						A.ActionLock("aggressive", 100)
						if(!A.master && A.HP > 0 && src.inHand(/item/weapon/whip) && prob((chosen == "trainer" ? 30 : (chosen == "hunter" ? 20 : 5))))
							A.master = src
							if(!A.friends) A.friends = new/list()
							if(!(src in A.friends)) A.friends += src
							src.show_message("<tt>You have tamed the [M.name].</tt>")
							return

					var/restdmg = (state == "ghost" || state == "ghost-i") ? 0 : ((src.strength - M.defence) * 3)
					if(state == "skeleton") restdmg /= 1.5
					if(restdmg <= 0) restdmg = 1
					if(restdmg > 0)
						M.AbortAction()
						if(M.spell_shield && (get_dir(M, src) & M.dir))
							M.spell_shield.SLEEP -= (restdmg / 1.5)
							hud_main.UpdateHUD(M.spell_shield)
							if(M.spell_shield.SLEEP <= 0)
								M.spell_shield.SLEEP = 0
								M.spell_shield.toggle_sleep(1)
						else if (M.HP > 0)
							M.HP -= restdmg

							if (inHand(/item/weapon/cutlass) || inHand(/item/weapon/excowlibur) || inHand(/item/weapon/gold_sword) \
								|| inHand(/item/weapon/grandius) || inHand(/item/weapon/iron_sword) || inHand(/item/weapon/katana) \
								|| inHand(/item/weapon/red_tinted_sword) || inHand(/item/weapon/watchman_sword) \
								|| inHand(/item/weapon/wood_sword)) M.last_hurt = "sword"
							else if (inHand(/item/weapon/halberd)) M.last_hurt = "halberd"
							else if (inHand(/item/weapon/sledgehammer)) M.last_hurt = "sledge"
							else if (inHand(/item/weapon/hoe)) M.last_hurt = "hoe"
							else if (inHand(/item/weapon/pickaxe)) M.last_hurt = "pickaxe"
							else if (inHand(/item/weapon/axe)) M.last_hurt = "axe"
							else if (inHand(/item/weapon/shovel)) M.last_hurt = "shovel"
							else if (inHand(/item/weapon/knife)) M.last_hurt = "knife"
							else if (inHand(/item/weapon/shears)) M.last_hurt = "shears"
							else if (inHand(/item/weapon/whip)) M.last_hurt = "whip"
							else if (inHand(/item/weapon/archduke_staff) || inHand(/item/weapon/bstaff) \
								|| inHand(/item/weapon/staff)) M.last_hurt = "staff"
							else if (inHand(/item/weapon/hunting_spear) || inHand(/item/weapon/spear)) M.last_hurt = "spear"
							else if (inHand(/item/weapon/torch)) M.last_hurt = "spear"
							else M.last_hurt = "blunt"

							hud_main.UpdateHUD(M)
							M.checkdead(M)

					for(var/animal/A in view(src)) A.SeeViolence(src, M)
				if("Blunt")
					M.AbortAction()
					if(istype(M, /animal)) M.ActionLock("aggressive", 100)
					for(var/mob/N in hearers(M))
						N.show_message("\red <b>[src.name] attacks [M.name] non-deadly!</b>")
					chat_log << "<font color=\"red\">[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]&gt; [src.name] attacks [M.name] non-deadly!</font><br />"

					var/restdmg = (state == "ghost" || state == "ghost-i") ? 0 : (src.strength - M.defence) * 3
					if(state == "skeleton") restdmg /= 1.5
					if(restdmg <= 0) restdmg = 1
					if(restdmg > 0)
						if(M.spell_shield && (get_dir(M, src) & M.dir))
							M.spell_shield.SLEEP -= (restdmg / 2)
							hud_main.UpdateHUD(M.spell_shield)
							if(M.spell_shield.SLEEP <= 0)
								M.spell_shield.SLEEP = 0
								M.spell_shield.toggle_sleep(1)
						else
							M.HP -= restdmg / 8
							if(M.SLEEP <= 90 && prob(25))
								if(M.SLEEP > 50 && prob(75))
									M.stun(max(restdmg * 3, 60))
									for(var/mob/N in hearers(M))
										N.show_message("\red <b>[M.name] is stunned!</b>")
								else
									M.weaken(max(restdmg * 3, 60))
									for(var/mob/N in hearers(M))
										N.show_message("\red <b>[M.name] is knocked out!</b>")
							else M.SLEEP -= 10
							M.last_hurt = "blunt"
							hud_main.UpdateHUD(M)
							M.checkdead(M)

					for(var/animal/A in view(src)) A.SeeViolence(src, M)
				if("Shake")
					for(var/mob/N in hearers(M))
						N.show_message("\blue [src.name] shakes [M.name].")
					if(!M.ActionLock("shake_mob", 25))
						if(M.weakened > 10) M.weakened -= 2
						else if(M.stunned > 10) M.stunned -= 2
		stun(time)
			stunned = 5
		weaken(time)
			weakened = 10
			for(var/spell/S in spells) S.onSleep(src)
			icon_state = "dead"
		checkdead(mob/M)
			if(HP > 0 || istype(src, /mob/observer) || corpse) return
			AbortAction()
			for(var/animal/A in view(src)) A.SeeDeath(src)

			corpse = 1
			for(var/item/misc/waterstone/O in world)
				if(O.active && O.lastTouched == src) O.toggle()

			if(istype(M, /mob/Shroom))
				if(prob(30)) M.contents += new/item/armour/body/mushroom_suit
				if(prob(40)) M.contents += new/item/armour/hat/mushroom_cap
				//spawn(300) del M

			if(istype(M, /mob/Frogman))
				M.contents += new/item/misc/food/Frog_Meat
				if(prob(50)) M.contents += new/item/misc/orbs/Frog_Orb
				if(prob(30)) M.contents += new/item/misc/seeds/Red_Seedlette
				if(prob(30)) M.contents += new/item/misc/seeds/Yellow_Seedlette
				if(prob(30)) M.contents += new/item/misc/seeds/Blue_Seedlette
				//spawn(300) del M

			//if(istype(M, /mob/Zombie)) spawn del M

			chat_log << "\<<font color = orange><b>[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\]</b>\> [src] has died!</font><br />"
			M.show_message("<tt>You fall down dead. [abandon_mob ? "You may respawn in [round((global.admin.respawn_time / 10) / 60)] minute\s." : "You may now observe the game and see what other players are up to."]</tt>")

			if(key)
				corpse = new/mob/observer(src.loc)
				corpse.name = src.name
				corpse.corpse = src
				src.corpse = corpse
				corpse.speed = 1
				corpse.base_speed = 1
				initial_net_worth = src.initial_net_worth
				spawn(rand(4000,5000))
					if(M)
						M.icon = 'Skeleton.dmi'
						tag = "Skeleton"
						return

			src.name = "[src.name]'s corpse"
			src.HP = 0

			if(whopull)
				whopull = null
				if(client)
					var/screen/buttons/pull/P = locate() in client.screen
					if(P) P.icon_state = "btnPull"

			if(chosen == "jester") medal_Award("The Unfunny Man")
			if(locate(/obj/bed, loc) && issleeping) medal_Award("Good Morning")
			score_Add("deaths")

			if(corpse && key) corpse.key = src.key
			else corpse = 1
		AbortAction()
			if(!current_action) return 0
			if(hascall(current_action, "AbortAction"))
				call(current_action, "AbortAction")(src)
			current_action = null
			hud_main.UpdateHUD(src)
		SetAction(obj/O)
			if(current_action) return 0
			current_action = O
			if(hascall(current_action, "ActionLoop"))
				spawn call(current_action, "ActionLoop")(src)
			hud_main.UpdateHUD(src)
	weregoat
		name = "The Weregoat"
		icon = 'icons/Weregoat.dmi'
		speed = 70
		HP = 120
		MHP = 120
		strength = 9
		defence = 7
		base_strength = 9
		base_defence = 7
		base_speed = 70
		see_in_dark = 16
		chosen = "weregoat"
		UpdateClothing()
			strength = 9
			defence = 7
			return
	eavesdropper
		density = 0
		anchored = 1
		invisibility = 100
		show_message(msg, flags)
			for(var/client/C)
				if(C.eye == src)
					var/mob/M = C.mob
					if(M) M.show_message(msg, flags)
		Life() return
		attack() return
		checkdead() return
		restrained() return 0
		PlaySound(sound/S)
			for(var/client/C)
				if(C.eye == src)
					var/mob/M = C.mob
					if(M) M.PlaySound(S)
	dummy
		Login() return
		Life() return
		restrained() return 1
		attack() return
		attack_hand() return
		Logout() return
		UpdateClothing() return
		CheckGhost() return
		Move(newloc, newdir, forced = 0) return
	observer
		see_in_dark = 8
		invisibility = 1
		see_invisible = 1
		shackled = 1
		loggedin = 1
		density = 0
		anchored = 1
		speed = 5
		base_speed = 5

		icon = 'icons/Cow.dmi'
		icon_state = "ghost"
		var/override_am = 0

		restrained() return 1
		attack() return
		checkdead() return
		Life() return
		attack_hand() return
		New(loc, force_am = 0)
			. = ..()
			if(!force_am)
				ActionLock("allow_abandon", global.admin.respawn_time)
				spawn(global.admin.respawn_time)
					if(abandon_mob) src.show_message("<tt>You may now abandon mob.</tt>")
			else override_am = 1
			sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
		Login()
			hud_main.DisplayHUD(usr)
			hud_main.UpdateHUD(usr)
			vote_system.SendMessage(src)
			..()
		Logout()
			return
		UpdateClothing()
			overlays = null
			return
		CheckGhost() return 1
		verb
			abandon_mob()
				if(!override_am && !abandon_mob)
					usr.show_message("<tt>Abandon mob has been disabled by an administrator.</tt>")
					return
				if(ActionLock("allow_abandon"))
					usr.show_message("<tt>You may not abandon mob yet.</tt>")
					return
				var/mob/character_handling/M = new/mob/character_handling
				M.key = src.key
				src.loc = null
				if(src.corpse) src.corpse.corpse = null
				src.corpse = null
			observe()
				var/list/L = new/list()
				for(var/mob/M in world)
					if(M.type == /mob) L[M.name] = M
				var/name = input(usr, "Select the player to observe.") as null|anything in L
				if(name)
					var/mob/M = L[name]
					if(M)
						show_message("<tt>You are now observing [M.name].</tt>")
						Move(M, forced = 1)
			go_up()
				var/map_object/O = MapObject(src.z)
				if(O)
					O = O.NextLayer()
					if(O) src.Move(locate(x, y, O.z), forced = 1)
			go_down()
				var/map_object/O = MapObject(src.z)
				if(O)
					O = O.PrevLayer()
					if(O) src.Move(locate(x, y, O.z), forced = 1)
		Move(turf/newloc, newdir, forced = 0)
			if(!isturf(loc))
				var/turf/T = get_turf(loc)
				if(T)
					loc = T
					show_message("<tt>You enter free-roaming mode.</tt>")
				else
					show_message("<tt>You cannot enter free-roaming mode at this time. Please observe another target.</tt>")
				return
			if(!forced && newdir) return Move(get_step(src, newdir), newdir, forced = 1)
			if(!newloc) newloc = get_step(src, newdir)
			if(newloc) loc = newloc
			if(newdir) dir = newdir