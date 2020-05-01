client
	var
		map_editor/map_editor
	proc
		CheckAdmin()
			while(!global.admin) sleep(2)
			verbs -= typesof(/sadmin/verb)
			verbs -= typesof(/tadmin/verb)
			verbs -= typesof(/admin/verb)

			if(ckey in developers) verbs += typesof(/sadmin/verb)

			if(ckey in global.admin.admins)
				admin = global.admin.admins[ckey]
				if(!istype(admin))
					admins -= ckey
					admin = null

			if(admin)
				admin.Login(src)

			if(pm) pm.showWindow(src)

			if(mob)
				var/item/armour/body/treksuit/I = mob.bequipped
				if(istype(I)) I.update()

ban_record
	var
		name //name of the original key that got banned
		author //person who originally banned them
		list/associates //list of ckeys, IPs and computer_ids that are caught up in this ban
		reason
		expires = -1 //-1 = infinite
	New(client/C, reason, expires, author)
		if(reason) src.reason = reason
		if(expires) src.expires = expires
		if(author) src.author = author

		if(C)
			add_ban(C.ckey)
			add_ban(C.address)
			add_ban(C.computer_id)
			src.name = C.key
	proc
		check_ban(ckey, address, computer_id)
			if(expires != -1 && expires <= world.realtime) //ban expired, so remove
				bans -= src
				return 0

			if(!ckey && !address && !computer_id) return //called by loop; ignore.

			if(!associates) return
			if(!(ckey in associates) && !(address in associates) && !(computer_id in associates)) return 0
			add_ban(ckey)
			add_ban(address)
			add_ban(computer_id)
			return 1
		add_ban(data)
			if(!data) return
			if(!associates) associates = new/list()
			if(!(data in associates)) associates += data

proc
	add_ban(client/C, reason, expires, author)
		if(!bans || !istype(bans, /list)) bans = new/list()
		bans += new/ban_record(C, reason, expires, author)

admin
				//var/list/L = new/list()
	verb //WARNING: due to the way verbs are being added, "src" does NOT equal the parent /admin object!
		Toggle_Mouse_Movement()
			set category = "Admin"
			var/admin/A = usr.client.admin
			if(istype(A))
				A.mouse_movement = !A.mouse_movement
				usr << "You can [A.mouse_movement ? "now" : "no longer"] move objects with the mouse."
		Edit_Skill(mob/M in world, skill in M.skills.vars)
			set category = "Admin"
			var/new_val = input(usr, "Specify new value:", "Skill for [M] ([skill])", M.skills.vars[skill]) as null|num
			if(new_val == null) return
			M.skills.vars[skill] = new_val
		Rename_Player(client/C in GetClients(1))
			set category = "Admin"
			var/mob/M = C.mob
			if(istype(M, /mob/character_handling)) return
			var/new_name = input(usr, "Specify the new name for the player:", "Rename Player", M.name) as null|text
			if(new_name == null) return
			var/n = trimAll(new_name)
			if(!n || n == " ") return
			names -= M.name
			names += new_name
			M.name = new_name
			var/player/P = M && M.client ? M.client.player : null
			if(P) P.character_name = new_name
		Private_Message(client/C in GetClients(1) - usr.client)
			set category = "Admin"
			if(C.pm)
				C.pm.addAdmin(src)
			else
				new/admin_pm(C, usr.client)
		download_game_log()
			set category = "Admin"
			usr << ftp(chat_log)
		view_game_log()
			set category = "Admin"
			. = file2text(chat_log)
			if(length(.) > 524288)
				. = copytext(., length(.) - 524288)
			usr << browse(., "window=\ref[src]_log;size=500x300")
		list_multikeys()
			set category = "Admin"
			var/list
				L = new/list()
				skip = new/list()
			for(var/client/C)
				if(C in skip) continue
				var/list/L2 = new/list()
				for(var/client/X)
					if(X == C) continue
					if(X.address == C.address || X.computer_id == C.computer_id)
						L2 += X.key
						skip += X
				if(L2.len) L[C.key] = L2
			if(L.len)
				send_message(usr, "<b>Players:</b>", 3)
				. = 0
				for(var/key in L)
					var/list/L2 = L[key]
					if(L2 && L2.len)
						send_message(usr, "\t [key]: [dd_list2text(L2, "; ")]", 3)
						.++
				send_message(usr, "<b>Total multikeyers:</b> [.]", 3)
			else
				send_message(usr, "Unable to find anyone who is multi-keying.", 3)
		Announce(msg as message)
			set category="Admin"
			send_message(world, "<center><big><b><font color = blue>[usr.key] Announces <br>[msg]", 3)
		Color(atom/movable/A in world, c as color|null)
			set category = "Admin"
			A.icon = initial(A.icon)
			if (c)
				var/icon/I = icon(A.icon)
				I.Blend(c, ICON_MULTIPLY)
				I.Blend(c)
				A.icon = I
		Custom(type in list("body", "face", "hat", "cloak", "hood", "weapon"))
			set category = "Admin"
			switch (type)
				if ("body") new/item/armour/body/custom(usr)
				if ("face") new/item/armour/face/custom(usr)
				if ("hat") new/item/armour/hat/custom(usr)
				if ("cloak") new/item/armour/cloak/custom(usr)
				if ("hood") new/item/armour/hood/custom(usr)
				if ("weapon") new/item/weapon/custom(usr)
		Warp(mob/M in world, mob/T as mob in world)
			set category = "Admin"
			if(M.x)
				M.loc=locate(T.x,T.y-1,T.z)
				send_message(usr, "You warped [M] to [T]!", 3)
			else
				M.loc=locate(10,3,1)
				if(M.x)
					M.loc=locate(T.x,T.y-1,T.z)
					send_message(usr, "You warped [M] to [T]!", 3)
				else
					M.loc=locate(10,3,1)
		Make_Vote()
			set category="Admin"
			if(vote_system.vote) return
			var/question = input("What will the question be?", "Question") as text
			var/list/options = list()
			var/option
			var/i = 0
			do
				if(option) options += option
				option = input(usr, "What will option #[++i] be?", "Option [i]") as null|text
			while(option != null && !vote_system.vote)

			if(vote_system.vote) return
			var/vote_data/result = vote_system.Query(question, options)
			if(result.tie)
				var/list/tie_data = new/list()
				for(i in result.tie_list) tie_data += options[i]
				send_message(world, "<b>Tie!</b> between [dd_list2text(tie_data, "; ")]...", 3)
			send_message(world, "Result: <b>[options[result.winner]]</b>", 3)

		Watch(mob/M in world)
			set category="Admin"
			usr.client.eye = M
			usr.client.perspective = EYE_PERSPECTIVE
		StopWatching()
			set category="Admin"
			usr.client.eye = usr
			usr.client.perspective = MOB_PERSPECTIVE

		GMSay(msg as text)
			set category="Admin"
			if(!msg) return
			for(var/client/C)
				if(C.admin)
					C << "<b><font color=\"#848484\">[usr.key] GMSay: [html_encode(msg)]"
			chat_log << "\[<font color = blue>[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\] [usr.name] - [usr.key] GMSay: [html_encode(msg)]</font><br />"
		Revive(mob/M in world)
			set category="Admin"
			M.revive()
		Convert_Mob(mob/M in world, var/race in list("Cow", "Zombie", "Skeleton"))
			set category = "Admin"
			if(M.type != /mob)
				send_message(usr, "<tt>You must select an active player!</tt>", 3)
				return
			switch(race)
				if("Cow") M.icon = 'icons/Cow.dmi'
				if("Zombie") M.icon = 'icons/Zombie.dmi'
				if("Skeleton") M.icon = 'icons/Skeleton.dmi'
		Player_Check()
			set category="Admin"
			set desc="Check player IPs and Keys"
			send_message(usr, "<font color=#105090>Player Information:", 3)
			for(var/mob/M in world)
				if(M.client)
					send_message(usr, "<font color=#105090>  Name: [M.name]. Key: [M.key]. Address: [M.client.address].", 3)
		check_owner(atom/O in range(usr))
			set category = "Admin"
			usr << "<tt>[O] ([O.type] [O.building_owner ? "was created by [O.building_owner]" : "is not player-made"].</tt>"
			if(istype(O, /obj/chest))
				var/obj/chest/C = O
				if(C.opened_by && C.opened_by.len)
					usr.show_message("<tt>The following keys have opened or unlocked this chest:</tt>")
					for(var/key in C.opened_by)
						usr.show_message("\t <tt>[key]</tt>")
					usr.show_message("<tt><b>Note:</b> This is a list of players who have opened or unlocked the chest. It does not necessarily say who did what to the items within. Don't speculate; get the facts!</tt>")
				else
					usr.show_message("<tt>This chest has not been opened by anyone since its creation.</tt>")
		check_denied_scores()
			set category = "Admin"
			var/list/L = ScoreDenied()
			if(L && L.len)
				usr << "<tt>The following ckeys will not have their scores updated:</tt>"
				for(var/X in L)
					usr << "\t <tt>[X]</tt>"
			else
				usr << "<tt>There are no ckeys in the deny_score.txt file.</tt>"
		check_denied_medals()
			set category = "Admin"
			var/list/L = MedalDenied()
			if(L && L.len)
				usr << "<tt>The following ckeys will not be awarded any medals:</tt>"
				for(var/X in L)
					usr << "\t <tt>[X]</tt>"
			else
				usr << "<tt>There are no ckeys in the deny_medal.txt file.</tt>"

location_data
	var
		atom/movable/atom
		x
		y
		z
	New(atom/movable/A)
		. = ..()
		if(A)
			atom = A
			x = A.x
			y = A.y
			z = A.z

/*mob/verb
	Test()
		set category = "Test"
		. = 0
		for(var/obj/O as obj|mob|turf in world)
			.++
		world << "Total: [.]"
	Test(obj/O as obj|mob|turf in world)
		set category = "Test"
		world << "You clicked [O]!"*/

tadmin/verb
	create(var/type in typesof(/atom))
		set category = "Admin"
		new type(usr.loc)
	spawn_in_inventory(var/type in typesof(/item))
		set category = "Admin"
		new type(usr)
	Delete(obj/O as obj|mob|turf in world)
		set category = null
		if(istype(O, /turf/tardis) || istype(O, /obj/tardis)) return
		var/mob/M = O
		if(istype(M) && M.key)
			if((M.ckey in developers) && !(usr.ckey in developers))
				del usr
				return
		del O
	Edit(atom/O in world)
		set category = null
		set name = "Edit"
		set desc="(target) Edit a target item's variables"
		var/variable = input("Which variable?","Var") in O.vars
		var/default
		var/typeof = O.vars[variable]
		var/dir
		if(isnull(typeof))
			send_message(usr, "<font size=1>Unable to determine variable type.", 3)
		else if(isnum(typeof))
			send_message(usr, "<font size=1>Variable appears to be <b>NUM</b>.", 3)
			default = "num"
			dir = 1
		else if(istext(typeof))
			send_message(usr, "<font size=1>Variable appears to be <b>TEXT</b>.", 3)
			default = "text"
		else if(isloc(typeof))
			send_message(usr, "<font size=1>Variable appears to be <b>REFERENCE</b>.", 3)
			default = "reference"
		else if(isicon(typeof))
			send_message(usr, "<font size=1>Variable appears to be <b>ICON</b>.", 3)
			typeof = "\icon[typeof]"
			default = "icon"
		else if(istype(typeof,/atom) || istype(typeof,/datum))
			send_message(usr, "<font size=1>Variable appears to be <b>TYPE</b>.", 3)
			default = "type"
		else if(istype(typeof,/list))
			send_message(usr, "<font size=1>Variable appears to be <b>LIST</b>.", 3)
			send_message(usr, "<font size=1>*** This function is not possible ***", 3)
			default = "cancel"
		else if(istype(typeof,/client))
			send_message(usr, "<font size=1>Variable appears to be <b>CLIENT</b>.", 3)
			send_message(usr, "<font size=1>*** This function is not possible ***", 3)
			default = "cancel"
		else
			send_message(usr, "<font size=1>Variable appears to be <b>FILE</b>.", 3)
			default = "file"
		send_message(usr, "<font size=1>Variable contains: [typeof]", 3)
		if(dir)
			switch(typeof)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				send_message(usr, "<font size=1>If a direction, direction is: [dir]", 3)
		var/class = input("What kind of variable?","Variable Type",default) in list("text",
			"num","type","reference","icon","file","restore to default","cancel")
		var/new_value
		switch(class)
			if("cancel")
				return
			if("restore to default")
				new_value = initial(O.vars[variable])
			if("text")
				new_value = input("Enter new text:","Text",\
					O.vars[variable]) as text
			if("num")
				new_value = input("Enter new number:","Num",\
					O.vars[variable]) as num
			if("type")
				new_value = input("Enter type:","Type") \
					in typesof(/obj,/mob,/area,/turf)
			if("reference")
				new_value = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world
			if("file")
				new_value = input("Pick file:","File") \
					as file
			if("icon")
				new_value = input("Pick icon:","Icon") \
					as icon

		if(istype(O, /atom/movable) && (variable == "x" || variable == "y" || variable == "z"))
			var
				x = variable == "x" ? new_value : O.x
				y = variable == "y" ? new_value : O.y
				z = variable == "z" ? new_value : O.z
				turf/T = locate(x, y, z)
				atom/movable/A = O
			A.Move(T, forced = 1)
		else
			if(variable == "name" && (!trimAll(new_value) || trimAll(new_value) == " ")) return
			O.vars[variable] = new_value
	set_abandon_time()
		set category = "Admin"
		var/n = input(usr, "Specify the amount of time (in minutes) until abandon mob should become available.\nThis will not take effect on those who are already dead!", "Set Abandon Time", (global.admin.respawn_time / 10) / 60) as null|num
		if(n == null) return
		global.admin.respawn_time = (n * 60) * 10
		world << "<b>Respawn time set to [n] minutes!</b>"
		world.log << "Respawn time reset to [n] minutes by [usr.key]."
	award_vanity_medal(mob/M in world)
		set category = "Admin"
		M.medal_Award("Vanity Rules")
	rp_points_add(mob/M in world)
		set category = "Admin"
		M.score_Add("rppoints")
	rp_points_arem(mob/M in world)
		set category = "Admin"
		M.score_Rem("rppoints")
	make_wizard(mob/M in world, color in list("Red", "Blue", "Orange", "Green", "Purple"))
		set category = "TAdmin"
		if(M.mage)
			usr << "[M] is already a wizard!"
			return
		M.make_wizard(color)
	make_zeth(mob/M in world)
		set category = "TAdmin"
		if(M.mage)
			usr << "[M] already has magical blood!"
			return
		M.chosen = "zeth"

		usr = M

		if(M.fequipped) M.fequipped.unequip(M)
		var/item/armour/I = new/item/armour/face/zeth_mask(M)
		I.Click()
		if(M.bequipped) M.bequipped.unequip(M)
		I = new/item/armour/body/zeth_cloths(M)
		I.Click()

		M.mage = 1
		M.learn_spell(/spell/zeth_teleport, 1)
		M.show_message("<i>You are now one of the Zeth.</i>")
		M.MHP += 25
		M.HP += 25
	teleport(mob/M in world)
		set category = "TAdmin"
		for(var/mob/N in ohearers(usr))
			N.show_message("\blue [usr.name] touches [usr.gender == FEMALE ? "her":"his"] forehead and disappears...")
		usr.show_message("\blue You touch your forehead and move to a new location!")
		usr.PlaySound('sounds/teleport_u.ogg')
		global.play_sound(usr, ohearers(usr), sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))
		usr.Move(M.loc, forced = 1)
		global.play_sound(usr, ohearers(usr), sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))
	summon(mob/M in world)
		set category = "TAdmin"
		for(var/mob/N in ohearers(M))
			N.show_message("\blue [M.name] suddenly disappears...")
		M.show_message("\blue You suddenly move to a new location!")
		M.PlaySound('sounds/teleport_u.ogg')
		global.play_sound(M, ohearers(M), sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))
		M.Move(usr.loc, forced = 1)
		global.play_sound(M, ohearers(M), sound(pick('sounds/teleport_1.ogg', 'sounds/teleport_2.ogg', 'sounds/teleport_3.ogg')))
	summon_all()
		set category = "TAdmin"
		if(alert(usr, "Are you sure you want to summon everyone?", "Summon All?", "Yes", "No") == "Yes")
			for(var/mob/M in world)
				if(M != usr && M.client) M.Move(usr.loc, forced = 1)
	play_sound(S as sound, channel as num, volume as num)
		set category = "TAdmin"
		if(!S || !channel) return
		channel = round(channel)
		if(channel == 10) channel = 1023
		if(channel >= 100) channel = 100
		else if(channel <= 1) channel = 1
		world.log << "SOUND: [S] playing on channel [channel] with volume [volume] by [usr.key]"
		for(var/mob/M in world)
			M << sound(S, channel = channel, volume = volume)
	stop_sounds(channel as num)
		set category = "TAdmin"
		if(!channel) return
		if(channel == 10) channel = 1023
		world << sound(null, channel = channel)
	learn_all_spells(mob/M in world)
		set category = "TAdmin"
		if(!M) return
		for(var/X in typesof(/spell))
			if(X == /spell) continue
			var/spell/S
			for(S in M.spells)
				if(S.type == X) break
			if(!S)
				M.learn_spell(X)
		M << "[usr.key] has given you all the spells."
	super_spells(mob/M in world)
		set category = "TAdmin"
		if(!M) return
		for(var/spell/S in M.spells) S.flags |= S.FLAG_SUPER
		M << "[usr.key] has removed any spell limitations you had."
	give_spell(mob/M in world, spell/X in typesof(/spell))
		set category = "TAdmin"
		if(!M) return
		var/spell/S
		for(S in M.spells) if(S.type == X) break
		if(S)
			send_message(usr, "[M.key] already has this spell.", 3)
		else
			if(!M.spells || !M.spells.len) M.learn_spell(X, 1)
			else M.learn_spell(X, 0)
			S = new X
			M << "[usr.key] has given you the spell [S.name]."
			S = null
	take_spell(mob/M in world, spell/S in M.spells)
		set category = "TAdmin"
		if(M && S)
			M.remove_spell(S)
			M << "[usr.key] has taken away your spell [S.name]."
	take_all_spells(mob/M in world)
		set category = "TAdmin"
		if(!M) return
		for(var/spell/S in M.spells)
			M.remove_spell(S)
	freeze_players()
		set category = "TAdmin"
		freeze_players = !freeze_players
		send_message(world, "<b>[freeze_players ? "All players have been frozen by [usr.key]!" : "The players have been thawed by [usr.key]."]</b>", 3)
	play_music(F as sound)
		set hidden = 1
		var/sound/S = sound(file = F)
		S.volume = 75
		S.repeat = 1
		S.channel = 10
		music = S
		world << S
		usr << "Now playing [S]"
	stop_music()
		set hidden = 1
		if(music)
			music = null
			world << sound(null, channel = 10)
			usr << "Music stopped."
	play_delayed_sound(S as sound, channel as num, volume as num, delay as num)
		set hidden = 1
		if(!S || !channel) return
		channel = round(channel)
		if(channel == 10) channel = 1023
		if(channel >= 100) channel = 100
		else if(channel <= 1) channel = 1
		world.log << "SOUND: [S] playing on channel [channel] with volume [volume] by [usr.key] (delayed sound, delay = [delay])"

		if(!delayed_sounds) delayed_sounds = new/list()
		delayed_sounds += channel
		while(delayed_sounds && (channel in delayed_sounds))
			for(var/mob/M in world)
				M << sound(S, channel = channel, volume = volume)
			sleep(delay)
	stop_delayed_sound(channel as num)
		if(delayed_sounds)
			if(channel in delayed_sounds) delayed_sounds -= channel
			if(!delayed_sounds.len) delayed_sounds = null


var/list/delayed_sounds

/*sadmin/verb
	add_admin(client/C in GetClients())
		set category = "SAdmin"
		if(usr.client && C == usr.client) return
		if(C.admin) return
		. = 0 //1 = promoted
		if(!admins) admins = new/list()
		admins += C.ckey
		C.CheckAdmin()
		world << "\blue [C.key] has been [. ? "promoted to a permanent administrator" : "granted administrative status"] by [usr.key]."
		world.log << "\[ADMIN - [time2text(world.realtime)]\] [usr.key] [. ? "promoted" : "granted"] [C.key] administrative status."
	remove_admin(client/C in GetAdmins(0, all_admins=1) - usr.client)
		set category = "SAdmin"
		if(usr.client && C == usr.client) return
		if(C.ckey in moderators)
			admins -= C.ckey
			if(!admins.len) admins = null
		C.CheckAdmin()
		world << "\blue [C.key]'s administrative status has been revoked by [usr.key]."
		world.log << "\[ADMIN - [time2text(world.realtime)]\] [usr.key] revoked [C.key]'s administrative status."
	add_sadmin(client/C in GetClients(0) + GetAdmins(0, all_admins=1))
		set category = "SAdmin"
		if(usr.client && C == usr.client) return
		. = 0 //1 = promoted
		if(C.ckey in tadmins)
			. = 1
			tadmins -= C.ckey
		else if(C.ckey in admins)
			. = 1
			admins -= C.ckey
		else if(C.ckey in tradmins)
			. = 1
			tradmins -= C.ckey
		if(!sadmins) sadmins = new/list()
		sadmins += C.ckey
		C.CheckAdmin()
		world << "\blue [C.key] has been [. ? "promoted to super administrator" : "granted super administrative status"] by [usr.key]."
		world.log << "\[ADMIN - [time2text(world.realtime)]\] [usr.key] [. ? "promoted" : "granted"] [C.key] super administrative status."
	remove_sadmin(client/C in usr.client)
		set category = "SAdmin"
		if(usr.client && C == usr.client) return
		if((C.ckey in sadmins))
			sadmins -= C.ckey
			if(!sadmins.len) sadmins = null
			if(!tradmins) tradmins = new/list()
			tradmins += C.ckey
			C.CheckAdmin()
			world << "\blue [C.key] has been demoted to a trusted administrator by [usr.key]."
			world.log << "\[ADMIN - [time2text(world.realtime)]\] [usr.key] demoted [C.key] from super admin to trusted admin."
	add_tadmin(client/C in GetClients(0) + GetAdmins(0, all_admins=1))
		set category = "SAdmin"
		if(usr.client && C == usr.client) return
		. = 0 //1 = promoted
		if(C.ckey in tadmins)
			. = 1
			tadmins -= C.ckey
		else if(C.ckey in admins)
			. = 1
			admins -= C.ckey
		if(!tradmins) tradmins = new/list()
		tradmins += C.ckey
		C.CheckAdmin()
		world << "\blue [C.key] has been [. ? "promoted to trusted administrator" : "granted trusted administrative status"] by [usr.key]."
		world.log << "\[ADMIN - [time2text(world.realtime)]\] [usr.key] [. ? "promoted" : "granted"] [C.key] trusted administrative status."
	remove_tadmin(client/C in tadmins)
		set category = "SAdmin"
		if(usr.client && C == usr.client) return
		if((C.ckey in tradmins))
			tradmins -= C.ckey
			if(!tradmins.len) tradmins = null
			if(!admins) admins = new/list()
			admins += C.ckey
			C.CheckAdmin()
			world << "\blue [C.key] has been demoted to a regular administrator by [usr.key]."
			world.log << "\[ADMIN - [time2text(world.realtime)]\] [usr.key] demoted [C.key] from trusted admin to regular admin."
	add_temp_admin(client/C in GetClients())
		set category = "SAdmin"
		if(C.admin) return
		if(!tadmins) tadmins = new/list()
		tadmins += C.ckey
		C.CheckAdmin()
		world << "\blue [C.key] has been granted temporary administrative status by [usr.key]."
		world.log << "\[ADMIN - [time2text(world.realtime)]\] [usr.key] granted [C.key] temporary administrative status."*/

sadmin/verb
	make_ghost(mob/M in world)
		set category = "Admin"
		M.state = "ghost"
		M.icon = 'icons/GhostCorporeal.dmi'
		M.UpdateClothing()
		M.learn_spell(/spell/ghost, 1)
	add_family(var/name as text, var/founder as text)
		set category = "Family"
		if(!global.admin.families) global.admin.families = new/list()
		var/family/F
		for(F in global.admin.families)
			if(F.name == name) break
		if(!F)
			F = new
			F.name = name
			global.admin.families += F
			usr << "Added family [name] with founder [founder]."
		else
			usr << "Updated family [name] with founder [founder]."
		F.founder = founder
		if(!F.members) F.members = new/list()
		if(!(F.founder in F.members)) F.members += F.founder
		for(var/client/C) C.CheckFamily()
	remove_family(var/family/F in global.admin.families)
		set category = "Family"
		if(!global.admin.families) return
		usr << "Erased family [F] with founder [F.founder] and [F.members ? F.members.len : 0] members."
		global.admin.families -= F
		if(!global.admin.families.len) global.admin.families = null
		for(var/client/C) C.CheckFamily()
	award_datas_brow(mob/M in world)
		set category = "Admin"
		M.medal_Award("The Data's Brow Award")
	take_datas_brow(mob/M in world)
		set category = "Admin"
		M.medal_Remove("The Data's Brow Award")
	award_vigilante(mob/M in world)
		set category = "Admin"
		M.medal_Award("Vigilante")
	take_vigilante(mob/M in world)
		set category = "Admin"
		M.medal_Remove("Vigilante")
	take_vanity_medal(mob/M in world)
		set category = "Admin"
		M.medal_Remove("Vanity Rules")
	give_medal(mob/M in world, medal as text)
		set category = "Admin"
		M.medal_Award(medal)
	take_medal(mob/M in world, medal as text)
		set category = "Admin"
		M.medal_Remove(medal)
	data_mage()
		set hidden = 1
		new/item/armour/body/rmage_cloths(usr)
		new/item/armour/hat/rmage_hat(usr)
		new/item/weapon/staff(usr, usr, "Purple")
		new/item/armour/body/mage_cloths(usr)
		new/item/armour/hat/mage_hat(usr)
		new/item/weapon/bstaff/portal_staff(usr)
	sight_override()
		set category=null
		usr.sight_override = !usr.sight_override
		if(usr.sight_override) usr.sight = 60
	summon_tardis()
		set hidden = 1
		var/obj/tardis/tardis/O
		for(O in world) break
		if(O) O.summon(usr.loc)
	goto_tardis(set_name as num)
		set category = "SAdmin"
		if(set_name == 2)
			usr.name = "TARDIS"
			usr.icon = null
			usr.Move(locate(116, 187, 1), forced = 1)
			usr.legshackled = 1
			usr.anchored = 1
			usr.overlays = null
		else
			usr.Move(locate(116, 184, 1), forced = 1)
			if(set_name == 1) usr.name = "John Smith"
		usr.chosen = "timelord"
	gedit(X in admin.admins)
		set hidden = 1
		var/admin/O = admin.admins[X]
		var/variable = input("Which variable?","Var") in O.vars
		var/default
		var/typeof = O.vars[variable]
		var/dir
		if(isnull(typeof))
			send_message(usr, "<font size=1>Unable to determine variable type.", 3)
		else if(isnum(typeof))
			send_message(usr, "<font size=1>Variable appears to be <b>NUM</b>.", 3)
			default = "num"
			dir = 1
		else if(istext(typeof))
			send_message(usr, "<font size=1>Variable appears to be <b>TEXT</b>.", 3)
			default = "text"
		else if(isloc(typeof))
			send_message(usr, "<font size=1>Variable appears to be <b>REFERENCE</b>.", 3)
			default = "reference"
		else if(isicon(typeof))
			send_message(usr, "<font size=1>Variable appears to be <b>ICON</b>.", 3)
			typeof = "\icon[typeof]"
			default = "icon"
		else if(istype(typeof,/atom) || istype(typeof,/datum))
			send_message(usr, "<font size=1>Variable appears to be <b>TYPE</b>.", 3)
			default = "type"
		else if(istype(typeof,/list))
			send_message(usr, "<font size=1>Variable appears to be <b>LIST</b>.", 3)
			send_message(usr, "<font size=1>*** This function is not possible ***", 3)
			default = "cancel"
		else if(istype(typeof,/client))
			send_message(usr, "<font size=1>Variable appears to be <b>CLIENT</b>.", 3)
			send_message(usr, "<font size=1>*** This function is not possible ***", 3)
			default = "cancel"
		else
			send_message(usr, "<font size=1>Variable appears to be <b>FILE</b>.", 3)
			default = "file"
		send_message(usr, "<font size=1>Variable contains: [typeof]", 3)
		if(dir)
			switch(typeof)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				send_message(usr, "<font size=1>If a direction, direction is: [dir]", 3)
		var/class = input("What kind of variable?","Variable Type",default) in list("text",
			"num","type","reference","icon","file","restore to default","cancel")
		switch(class)
			if("cancel")
				return
			if("restore to default")
				O.vars[variable] = initial(O.vars[variable])
			if("text")
				O.vars[variable] = input("Enter new text:","Text",\
					O.vars[variable]) as text
			if("num")
				O.vars[variable] = input("Enter new number:","Num",\
					O.vars[variable]) as num
			if("type")
				O.vars[variable] = input("Enter type:","Type") \
					in typesof(/obj,/mob,/area,/turf)
			if("reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world
			if("file")
				O.vars[variable] = input("Pick file:","File") \
					as file
			if("icon")
				O.vars[variable] = input("Pick icon:","Icon") \
					as icon
	grand_spells(mob/M in world)
		set category = "TAdmin"
		if(!M) return
		if(M.mage) usr << "[M] is already a wizard!"
		else M.make_wizard("purple")
		for(var/X in list(/spell/building, /spell/lockpick, /spell/zap, /spell/teleport))
			var/spell/S
			for(S in M.spells)
				if(S.type == X) break
			if(!S)
				M.learn_spell(X)
	save_icon(atom/O in world)
		set category = "TAdmin"
		usr << ftp(O.icon)

client/verb
	list_admins()
		send_message(src, "<b>Current Adminstrators:</b>", 3)
		. = 0
		//for(var/rank in list("Developer", "Council", "Head Moderator", "GM", "Support", "Spy"))
		for(var/client/C)
			if(C.admin && C.admin.rank != "Spy")
				.++
				send_message(src, "\t [C.key] - [C.admin.rank]", 3)
		send_message(src, "<b>Total Online:</b> [.]", 3)
	admin_help(t as text)
		if(!mob || !t) return
		if(!adminhelp)
			send_message(src, "Admin help has been turned off. Your message was NOT sent.", 3)
			return
		if(usr.ActionLock("adminhelp", 10))
			send_message(src, "You can't send another request yet. Please wait.")
			return
		if(usr && usr.client && usr.client.muted)
			send_message(src, "You don't have permission to invoke this command.")
			return
		if(length(t) > 1200) t = copytext(t, 1, 1201)
		t = html_encode(t)
		for(var/client/C)
			if(C.admin)
				send_message(C, "\blue Admin Help- [key] ([mob.name]): [t]", 3)
				. = 1
		if(.) send_message(src, "Your request was sent to the administrators.", 3)
		else send_message(src, "No administrators are presently online to serve your request.", 3)