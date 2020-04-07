var/hud/main/hud_main = new
hud //hud object: contains static screen objects
	var
		list
			static_objects
		screen
			number/reboot_timer
			static_object/reboot_clock
	proc
		DisplayHUD(mob/M)
		DestroyHUD(mob/M)
		UpdateHUD(mob/M)
	main
		var
			list
				spell_objects
				timer_objects
		New()
			. = ..()
			static_objects = new/list()
			static_objects += new/screen/static_object("blankl", "1,1")
			static_objects += new/screen/static_object("blankr", "15,1")
			static_objects += new/screen/static_object("blankr2", "1,17")
			static_objects += new/screen/static_object("blankl2", "15,17")
			static_objects += new/screen/static_object("blank", "2,1 to 14,1") //bottom
			static_objects += new/screen/static_object("blank2", "2,17 to 14,17") //top
			static_objects += new/screen/static_object("blank4", "15,2 to 15,16") //left
			static_objects += new/screen/static_object("blank3", "1,2 to 1,16") //right
			static_objects += new/screen/buttons/say
			static_objects += new/screen/buttons/whisper
			static_objects += new/screen/buttons/emote
			static_objects += new/screen/buttons/OOC
			static_objects += new/screen/buttons/help
			static_objects += new/screen/intent/attack
			static_objects += new/screen/intent/disarm
			static_objects += new/screen/intent/shake
			static_objects += new/screen/intent/examine
			static_objects += new/screen/tabs/hunger
			static_objects += new/screen/tabs/thirst
			static_objects += new/screen/tabs/sleep

		//reboot timer
			reboot_clock = new("rctimer0", "6,17:16")
			static_objects += reboot_clock

			timer_objects = new/list()
			for(var/i = 1 to 5)
				timer_objects += new/screen/number(i, "7:6", "16:28")

		//stats
			static_objects += new/screen/static_object("bg", "1,0 to 15,-1")
			static_objects += new/screen/static_object("blankl", "1,-1")
			static_objects += new/screen/static_object("blankr", "15,-1")
			static_objects += new/screen/static_object("blank3", "1,0")
			static_objects += new/screen/static_object("blank4", "15,0")
			//static_objects += new/screen/static_object("blank2", "2,0 to 5,0")
			static_objects += new/screen/static_object("blank", "2,-1 to 14,-1")

			//Deaths
			static_objects += new/screen/static_object("stat_left", "2,0:10", 20)
			static_objects += new/screen/static_object("stat_middle", "3,0:10 to 6,0:10", 20)
			static_objects += new/screen/static_object("stat_right", "7,0:10", 20)
			static_objects += new/screen/static_object("grave", "2:4,0:10", 21, 'icons/icons.dmi')

			//Royal Blood
			static_objects += new/screen/static_object("stat_left", "2,-1:20", 20)
			static_objects += new/screen/static_object("stat_middle", "3,-1:20 to 6,-1:20", 20)
			static_objects += new/screen/static_object("stat_right", "7,-1:20", 20)
			static_objects += new/screen/static_object("crown", "2:4,-1:20", 21, 'icons/icons.dmi')

			//Taxes
			static_objects += new/screen/static_object("stat_left", "9,0:10", 20)
			static_objects += new/screen/static_object("stat_middle", "10,0:10 to 13,0:10", 20)
			static_objects += new/screen/static_object("stat_right", "14,0:10", 20)
			static_objects += new/screen/static_object("gold", "9:4,0:10", 21, 'icons/icons.dmi')

			//RP Points
			static_objects += new/screen/static_object("stat_left", "9,-1:20", 20)
			static_objects += new/screen/static_object("stat_middle", "10,-1:20 to 13,-1:20", 20)
			static_objects += new/screen/static_object("stat_right", "14,-1:20", 20)
			static_objects += new/screen/static_object("rpp", "9:4,-1:20", 21, 'icons/icons.dmi')

			spell_objects = new/list()
			spell_objects += new/screen/static_object("tabSpells", "17:-16,17")
			spell_objects += new/screen/static_object("block", "17:-16,2 to 17:-16,16")
			spell_objects += new/screen/static_object("tabSpells2", "17:-16,1")
		DisplayHUD(mob/M)
			if(!M.client) return
			var/client/C = M.client
			C.screen += static_objects
			C.screen += timer_objects
			if(M.spells && M.spells.len) C.screen += spell_objects
			else C.screen -= spell_objects

			M.hud_btnMusic = new/screen/buttons/Music
			//M.hud_btnMusic.icon_state = "btnMusic[M.music]"
			M.hud_btnPull = new/screen/buttons/pull
			M.hud_intSelector = new/screen/intent_selector
			M.hud_tabHealth = new/screen/tabs/health
			M.hud_btnCancelAction = new/screen/buttons/Cancel
			M.hud_btnResetRebootTimer = new/screen/buttons/reset_reboot_timer

			C.screen += list(M.hud_btnMusic, M.hud_btnPull, M.hud_btnCancelAction, M.hud_intSelector,
							M.hud_tabHealth, M.hud_btnResetRebootTimer)

			for(var/i = 1 to 15)
				C.screen += new/screen/number(i, 14) //sleep
				C.screen += new/screen/number(i, 10) //hunger
				C.screen += new/screen/number(i, 12) //thirst

				C.screen += new/screen/number(i, "2:24", "-1:24")
				C.screen += new/screen/number(i, "9:24", "-1:24")
				C.screen += new/screen/number(i, "2:24", "-1")
				C.screen += new/screen/number(i, "9:24", "-1")
		DestroyHUD(mob/M)
			var/client/C = M.client
			if(C)
				C.screen -= static_objects
				C.screen -= spell_objects
				C.screen -= timer_objects
				C.screen -= list(M.hud_btnMusic, M.hud_btnPull, M.hud_intSelector, M.hud_tabHealth)

			M.hud_btnMusic = null
			M.hud_btnPull = null
			M.hud_intSelector = null
			M.hud_tabHealth = null
			M.hud_btnCancelAction = null

			if(C) for(var/screen/number/S in C.screen) C.screen -= S
		UpdateHUD(mob/M)
			if(!M.client || !M.client.screen || !M.hud_tabHealth || !M.hud_btnCancelAction) return
			M.hud_tabHealth.icon_state = "[max(0, min(round(M.HP), 100))]"
			M.hud_btnCancelAction.icon_state = M.current_action ? "cancel_action" : ""

			var/player/P = M.client.player
			for(var/screen/number/O in M.client.screen)
				if(O._x == 10) //hunger
					O.icon_state = "[copytext(num2text(round(M.HUNGER),100),O.pposition,O.pposition+1)]"
				if(O._x == 12) //thirst
					O.icon_state = "[copytext(num2text(round(M.THIRST),100),O.pposition,O.pposition+1)]"
				else if(O._x == 14) //sleep
					O.icon_state = "[copytext(num2text(round(M.SLEEP),100),O.pposition,O.pposition+1)]"

				else if(O._x == "2:24" && O._y == "-1:24") //deaths
					O.icon_state = "[copytext("[P ? P.score_deaths : -1]",O.pposition,O.pposition+1)]"
				else if(O._x == "9:24" && O._y == "-1:24") //taxes
					O.icon_state = "[copytext("[P ? P.score_taxes : -1]",O.pposition,O.pposition+1)]"
				else if(O._x == "2:24" && O._y == "-1") //royalty
					O.icon_state = "[copytext("[P ? P.score_royalblood : -1]",O.pposition,O.pposition+1)]"
				else if(O._x == "9:24" && O._y == "-1") //rpp
					O.icon_state = "[copytext("[P ? P.score_rppoints : -1]",O.pposition,O.pposition+1)]"

			M.client.screen -= spell_objects
			if(M.spells && M.spells.len)
				M.client.screen += spell_objects

				var
					i = 0
					spellStart = M.hud_spellStart
				for(var/spell/O in M.spells)
					for(var/spell_component/S in O.components)
						if(--spellStart > 0) continue
						if(++i > 16) break
						S.screen_loc = "17:-16,[17 - i]"
					if(i > 16) break

screen //screen object: goes in client.screen. heh.
	parent_type = /obj
	icon = 'icons/screen.dmi'
	layer = 19
	static_object
		layer = 18
		mouse_opacity = 0
		New(icon_state, screen_loc, layer = 18, icon = 'icons/screen.dmi')
			. = ..()
			src.icon_state = icon_state
			src.screen_loc = screen_loc
			src.layer = layer
			src.icon = icon
	number
		icon = 'icons/screen_numbers.dmi'
		layer = 22
		pixel_y = 16
		var
			pposition = 0
			_x
			_y
		New(pos, x = 14, y = 17)
			_x = x
			_y = y
			pposition = pos
			screen_loc = "[x]:[(pos-1) * 8],[y]"
	buttons
		say
			icon_state = "btnSay"
			screen_loc = "2,1"
			Click() spawn if(usr && usr.client)
				var/t = input(usr, "Say something in-character to anyone within your LOS.", "Say") as null|text
				if(!usr || t == null) return
				usr.say(t)
		whisper
			icon_state = "btnWhisper"
			screen_loc = "3,1"
			Click() spawn if(usr && usr.client)
				var/t = input(usr, "Say something in-character to anyone standing on an adjectant tile.", "Say") as null|text
				if(!usr || t == null) return
				usr.whisper(t)
		emote
			icon_state = "btnEmote"
			screen_loc = "4,1"
			Click() spawn if(usr)
				var/t = input(usr, "Express an emotion using text in-character to anyone within your LOS.", "Emote") as null|text
				if(!usr || t == null) return
				usr.emote(t)
		OOC
			icon_state = "btnOOC"
			screen_loc = "5,1"
			Click() spawn if(usr && usr.client)
				var/t = input(usr, "Say something out-of-character to everyone in the game.", "OOC") as null|text
				if(!usr || t == null) return
				usr.OOC(t)
		Cancel
			icon_state = ""
			screen_loc = "8:4,0"
			Click() spawn if(usr && usr.client) usr.AbortAction()
		Music
			icon_state = "btnMusic1"
			//screen_loc = "15,17"
			/*Click()
				usr.music = !usr.music
				icon_state = "btnMusic[usr.music]"
				usr << sound((usr.music ? 'Myoosik.mid' : null), 1)
				if(usr.client) usr.client.Save()*/
		pull
			icon_state = "btnPull"
			screen_loc = "13,1"
			Click() spawn if(usr && usr.client)
				if(usr.shackled || usr.issleeping)return
				if(usr.whopull || usr.corpse)
					usr.whopull = null
					icon_state = "btnPull"
				else
					var/list/L = new/list()
					for(var/atom/movable/O in orange(1, usr))
						if(istype(O, /obj/shackle_ball) && usr.shackle_ball == O) continue
						if(istype(O, /mob) && O:HP <= 0 && !findtext(O.name, "corpse")) continue
						if(!O.anchored) L += O
					var/atom/movable/O = input(usr, "Pick something to pull out of the list below.", "Pull") as null|anything in L
					if(O == null) return
					if(O && (O in orange(1, usr)) && !O.anchored)
						usr.whopull = O
						icon_state = "btnPull1"
			proc
				reset()
					icon_state = "btnPull"
		help
			icon_state = "btnHelp"
			screen_loc = "14,1"

		reset_reboot_timer
			icon_state = "rtimer0"
			screen_loc = "8,17:16"
			Click()
				if(!game || game.reboot_timer > 3000) return
				if(!game.reboot_votes) game.reboot_votes = new/list()
				if(!(usr.ckey in game.reboot_votes))
					game.reboot_votes += usr.ckey
					send_message(world, "<tt>[usr.key] votes to reset the reboot timer.</tt>", 2)

					var/players = 0
					for(var/client/C) if(C.inactivity < 900) players++
					if(!players || !game.reboot_votes || !game.reboot_votes.len)
						hud_main.reboot_clock.icon_state = "rctimer-3"
					else
						var/perc = game.reboot_votes.len / (players / 100)
						if(perc >= 75)
							game.reboot_timer = initial(game.reboot_timer)
							icon_state = "rctimer0"
						else
							if(perc <= 10) hud_main.reboot_clock.icon_state = "rctimer-3"
							else if(perc <= 20) hud_main.reboot_clock.icon_state = "rctimer-2"
							else if(perc <= 30) hud_main.reboot_clock.icon_state = "rctimer-1"
							else if(perc <= 60) hud_main.reboot_clock.icon_state = "rctimer0"
							else if(perc <= 70) hud_main.reboot_clock.icon_state = "rctimer1"
							else if(perc <= 80) hud_main.reboot_clock.icon_state = "rctimer2"
							else hud_main.reboot_clock.icon_state = "rctimer3"
				icon_state = "rtimer2"
	intent_selector
		icon_state = "intSelector"
	intent
		var/attackmode
		Click() spawn if(usr && usr.client)
			usr.hud_intSelector.screen_loc = src.screen_loc
			usr.attackmode = src.attackmode
		attack
			icon_state = "intAttack"
			screen_loc = "7,1"
			attackmode = "Attack"
		disarm
			icon_state = "intDisarm"
			screen_loc = "8,1"
			attackmode = "Blunt"
		shake
			icon_state = "intShake"
			screen_loc = "9,1"
			attackmode = "Shake"
		examine
			icon_state = "intExamine"
			screen_loc = "10,1"
			attackmode = "Examine"
	tabs
		health
			icon = 'icons/HPScreen.dmi'
			icon_state = "0"
			screen_loc = "2,17"
			Click() spawn if(usr && usr.client)
				send_message(usr, "Health: [usr.HP]", 3)
		hunger
			icon_state = "tabHunger"
			screen_loc = "10,17"
		thirst
			icon_state = "tabThirst"
			screen_loc = "12,17"
		sleep
			icon_state = "tabSleep"
			screen_loc = "14,17"
			Click() spawn if(usr && usr.client) usr.toggle_sleep()
	stats
		HPLeft
			icon_state = "stat_left"
			screen_loc = "1,-1"
		HPRight
			icon_state = "stat_right"
			screen_loc = "2,-1"