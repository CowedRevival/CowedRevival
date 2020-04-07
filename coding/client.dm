client
	var
		list/windows
		verbose_logout = 1
		admin_pm/pm
		admin/admin
		player/player
		muted = 0
	New()
		if(!dta_ckey2key) dta_ckey2key = new/list()
		if(key && !(ckey in dta_ckey2key)) dta_ckey2key[ckey] = key

		for(var/client/C)
			if(C && C.key && C != src && C.computer_id == src.computer_id)
				send_message(src, "You may only access this server once at a time! Please don't try to cheat the system.")
				del src
				return

		if(winexists(src, "adminmenu")) winset(src, "adminmenu", "parent=")
		CheckAdmin()
		if(key)
			for(player in global.admin.players)
				if(player.ckey == src.ckey) break
			if(!player)
				player = new(src)
				if(!global.admin.players) global.admin.players = new/list()
				global.admin.players += player
			player.Login(src)
		else return

		if(!admin && max_players != -1)
			var/count = 0
			for(var/client/C) if(C.key) count++
			if(count > max_players)
				if(max_players > 0)
					send_message(src, "The server has reached its maximum player limit of [max_players] players. Please try again later.", 3)
				else
					send_message(src, "The server is in maintenance mode. Please try again later.", 3)
				del src
				return

		if(player) player.CheckPunishments()

		spawn(6) if(src)
			if(!(ckey in developers))
				send_message(world, "<b>[key] logged in!</b>", 3)
			world.log << "LOGIN: [key] @ [address] ([computer_id])"

		. = ..()
		world.update_status()
		if(!(ckey in developers)) changes()
		if(music) src << music

		spawn
			src << browse_rsc('interface/cowed_style.css')
		spawn
			CheckFamily()

		for(var/admin_pm/P in admin_pms)
			if(!P.target && P.name == src.key)
				pm = P
				break
		if(pm)
			pm.target = src
			pm.showWindow(src)
			pm.echo("<b>[key]</b> has rejoined the chatroom.")
	Del()
		if(admin) admin.Logout(src)
		if(player) player.Logout(src)
		if(pm) pm.echo("<b>[key]</b> has logged out. Messages will be sent when [gender == FEMALE ? "she" : "he"] logs back in.")
		if(verbose_logout && !(ckey in developers))
			send_message(world, "<b>[key] logged out!</b>", 3)
		world.log << "LOGOUT: [key] @ [address] ([computer_id])"
		return ..()
	verb
		toggle_chat()
			set hidden = 1
			//.winset "input.command="!say \"" ? input.command="!ooc \"" toggleOOC.text="OOC" : input.command="!say \"" toggleOOC.text="Say""
			var
				text = winget(src, "default/game.toggleOOC", "text")
				result
			switch(text)
				if("Say") result = "OOC"
				if("OOC")
					result = admin ? "GMSay" : "Say"
				if("GMSay") result = "Say"
			var/list/L = list("default/game.toggleOOC.text" = result, "input.command" = "![lowertext(result)] \"")
			winset(src, null, list2params(L))
		switch_map()
			var/X = winget(src, "map", "icon-size")
			if(X == "32")
				winset(src, "map", "icon-size=0")
				send_message(src, "<tt>Now stretching the map to fit the screen.</tt>", 3)
			else
				winset(src, "map", "icon-size=32")
				send_message(src, "<tt>Now keeping the map to scale.</tt>", 3)
		changes()

		down()
			set hidden = 1
			if(!mob.legshackled && !mob.stunned) mob.dir = SOUTH
		up()
			set hidden = 1
			if(!mob.legshackled && !mob.stunned) mob.dir = NORTH
		left()
			set hidden = 1
			if(!mob.legshackled && !mob.stunned) mob.dir = WEST
		right()
			set hidden = 1
			if(!mob.legshackled && !mob.stunned) mob.dir = EAST
		northr()
			set name = ".northr"
			set instant = 1
			return src.Move(get_step(mob, NORTH), NORTH, running = 1)
		southr()
			set name = ".southr"
			set instant = 1
			return src.Move(get_step(mob, SOUTH), SOUTH, running = 1)
		eastr()
			set name = ".eastr"
			set instant = 1
			return src.Move(get_step(mob, EAST), EAST, running = 1)
		westr()
			set name = ".westr"
			set instant = 1
			return src.Move(get_step(mob, WEST), WEST, running = 1)

		pm(ref as text, t as text)
			set hidden = 1
			if(!t) return
			var/admin_pm/P = locate(ref)
			if(!P) return
			if(!admin && P.target != src) return

			if(length(t) > 1200) t = copytext(t, 1, 1201)
			t = html_encode(t)
			t = dd_replacetext(t, "\n", "\\n")
			t = "<b>[src.key]</b>: [t]"
			P.echo(t)
		familypanel()
			set name = ".familypanel"
			//var/family/F = input(usr, "Select a family.") as null|anything in usr.GetFamilies(0)
			//if(F) F.ShowPanel(usr)
	proc
		CheckFamily()
			verbs -= /family/verb/add_family_member
			verbs -= /family/verb/remove_family_member
			verbs -= /family/verb/list_family_members
			verbs -= /family/verb/show_family_gold
			verbs -= /family/verb/set_family_gold
			var/family/F
			for(F in global.admin.families)
				if(F.founder == key) break
			if(F || (ckey in developers))
				verbs += new/family/verb/add_family_member
				verbs += new/family/verb/remove_family_member

			if(!F) for(F in global.admin.families)
				if(key in F.members) break
			if(F || (ckey in developers))
				verbs += new/family/verb/list_family_members
				verbs += new/family/verb/show_family_gold

			if(ckey in developers)
				verbs += /family/verb/set_family_gold
		AddWindow(t)
			if(!windows) windows = new/list()
			windows += t
		RemoveWindow(t)
			if(windows)
				windows -= t
				if(!windows.len) windows = null
	AllowUpload(filename, filelength)
		//yes, ckey=="androiddata":if you trust yourself not to upload large files, add yourself
		if(ckey != "tomeno" && filelength > 1048576) return 0
		//if(ckey != "androiddata" && (dd_hassuffix(filename, ".mid") || dd_hassuffix(filename, ".midi"))) return 0
		return 1
	MouseDrag(atom/src_object, atom/over_object, turf/src_location, turf/over_location)
		if(freeze_players && !admin) return 0
		if(!map_editor) return ..()
		return map_editor.MouseDrag(src_object, over_object, src_location, over_location)
	MouseDrop(atom/src_object, atom/over_object, turf/src_location, turf/over_location, control, params)
		if(freeze_players && !admin) return 0
		if(!map_editor)
			if(over_object && over_object.MouseDropped(src_object, src_location, over_location, control, params))
				return 0
			return ..()
		return map_editor.MouseDrop(src_object, over_object, src_location, over_location)
	Click(atom/O, location, control, params)
		if(freeze_players && !admin) return 0
		if(control == "tardis/popup.lstPlayers" || control == "tardis/popup.lstLandmarks")
			var/obj/tardis/main_console/C = locate() in range(1, mob)
			if(C) C.Select(O, mob)
			return
		if(control == "admin/viewscreen.lstPlayers")
			var/obj/admin/computer/viewscreen/C = locate() in range(1, mob)
			if(C) C.Select(O, mob)
			return
		if(!map_editor) return ..()
		return map_editor.Click(O, location, control, params)
	Move(loc, dir, forced = 0, running = 0)
		if(freeze_players && !admin) return 0
		if(mob && mob.moveRelay)
			if(running) return
			if(hascall(mob.moveRelay, "moveRelay")) call(mob.moveRelay, "moveRelay")(mob, loc, dir)
			return
		if(istype(mob, /mob/observer))
			return mob.Move(loc, dir, forced = 1)
		if(!mob || (mob.stunned > 0 || mob.weakened > 0 || mob.legshackled || mob.issleeping)) return 0
		if(mob.effects && (mob.effects.psychic > 3)) return 0
		if(mob.SLEEP <= 15 && running) running = 0
		if(mob._c_speed != mob.speed)
			mob._c_speed = mob.speed
			mob._speed = (1 / (mob.speed / 100))
		if((running && mob.ActionLock("moving", mob._speed / 1.5)) || (!running && (mob.ActionLock("moving", mob._speed)))) return 0
		if(running)
			mob.SLEEP -= 2
			hud_main.UpdateHUD(mob)
			if(mob.SLEEP <= 0)
				mob.toggle_sleep(1)
		return ..()
	Northeast() return
	Northwest() return
	Southeast() return
	Southwest() return