var/reboot_vote_on = 0
var/reboot_votes
var/voted_players

var/game/game = new
game
	var
		list
			kingdoms
		started = 0
		reboot_timer = 42000
		reboot_timer_critical
		reboot_timer_old
	proc
		Loop()
			set background = 1
			while(1)
				sleep(10)
				src.reboot_timer -= 10

				var
					reboot_timer = round(src.reboot_timer / 600)
				if(reboot_timer < 1)
					reboot_timer = round(src.reboot_timer / 10)

				if(src.reboot_timer <= 3000)
					if(!reboot_timer_critical)
						reboot_timer_critical = 1
						hud_main.reboot_clock.icon_state = "rctimer-3"
						for(var/mob/M in world)
							if(M.hud_btnResetRebootTimer && M.hud_btnResetRebootTimer.icon_state != "rtimer2")
								M.hud_btnResetRebootTimer.icon_state = "rtimer1"

				else
					if(reboot_timer_critical)
						reboot_timer_critical = 0
						hud_main.reboot_clock.icon_state = "rctimer0"
						for(var/mob/M in world)
							if(M.hud_btnResetRebootTimer)
								M.hud_btnResetRebootTimer.icon_state = "rtimer0"

				reboot_timer++
				if(src.reboot_timer_old != reboot_timer) //don't change it if we don't need to
					reboot_timer_old = reboot_timer
					for(var/screen/number/O in hud_main.timer_objects)
						O.icon = src.reboot_timer < 600 ? 'icons/screen_numbers_r.dmi' : 'icons/screen_numbers.dmi'
						O.icon_state = "[copytext(num2text(round(reboot_timer),100),O.pposition,O.pposition+1)]"

				/*if(src.reboot_timer <= 0)
					src.reboot_timer = initial(src.reboot_timer)
					var/players = 0
					for(var/client/C) if(C.inactivity <= 900 || (C.ckey in reboot_votes)) players++

					var/perc = 0
					if(players && reboot_votes && reboot_votes.len) perc = round(reboot_votes.len / (players / 100))
					if(!players || !reboot_votes || perc < 50)
						world << "<b>Rebooting because only [perc]% out of [players] active players wanted to cancel."
						admin.reboot()
					else
						world << "<b>Resetting reboot timer because [perc]% out of [players] active players voted to cancel."
					src.reboot_votes = null*/

				if(src.reboot_timer <= 300 && !reboot_vote_on)
					reboot_vote_on = 1
					reboot_votes = 0
					for(var/mob/M in world)
						if(M.client)
							var/reboot_vote = input(M, "Reboot server?")in list("Yes","No")
							voted_players++
							if(reboot_vote == "Yes")
								reboot_votes++

				if(src.reboot_timer <= 0)
					var/percentage_votes = (reboot_votes / voted_players) * 100
					if(percentage_votes >= 50 || voted_players == 0)
						world << "<b>Rebooting server as [percentage_votes]% out of [voted_players] wanted to reboot."
						admin.reboot()
					else
						world << "<b>Resetting reboot timer because [percentage_votes]% out of [voted_players] voting players did not want to reboot."
					src.reboot_timer = 42000
					reboot_vote_on = 0

				life_time += 10
				for(var/mob/M in world) M.Life()

				if(!(life_time % 3000))
					for(var/ban_record/B in bans) B.check_ban()

				if(!(life_time % 500) && Hour != -1)
					Hour++
					TimeCheck()
					//sleep(200)
		TimeCheck()
			set background=1
			if(Hour >= 24)
				Hour = 0
				world << "<b>The wolves howel at midnight.</b>"
			if(!Hour) Day++
			if(Day > 3)
				Month++
				world << "<b>Another month passes...</b>"
				Day = 1
			if(Month > 4)
				world << "<b>Another year passes...</b>"
				Month = 1
			TimeLight()
		TimeLight()
			if(Hour >= 0 && Hour <= 4) sd_OutsideLight(0)
			else if(Hour >= 5 && Hour < 8) sd_OutsideLight(1)
			else if(Hour >= 8 && Hour < 11) sd_OutsideLight(2)
			else if(Hour >= 12 && Hour < 18) sd_OutsideLight(4)
			else if(Hour >= 18 && Hour < 21) sd_OutsideLight(2)
			else if(Hour >= 21 && Hour <= 24) sd_OutsideLight(1)
		Start()
			if(started) return
			started = 1
			var/map_object/M = locate("map_[gametype]")
			if(M)
				undergroundz = M.z
				worldz = M.z + 1
				skyz = M.z + 2

			spawn
				for(var/animal/A in world)
					if(A.z == 1 || A.z == undergroundz || A.z == worldz || A.z == skyz)
						//spawn A.Populate()
					else
						A.Move(null, forced = 1)

			kingdoms = new/list()
			kingdoms += new/character_handling/container/bovinia
			/*var/list/base_types = typesof(/character_handling/container)
			base_types -= /character_handling/container
			for(var/type in base_types)
				base_types -= typesof(type)
				base_types += type

			for(var/type in base_types) kingdoms += new type*/

			sd_OutsideLight(5)

			for(var/obj/portal/school_of_magic/O in world) spawn O.Load()

			spawn Loop()