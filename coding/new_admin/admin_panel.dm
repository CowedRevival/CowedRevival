admin_panel
	var
		screen = "statistics"
		admin/master
		list
			players_search
		player/players_record
		player_punishment/players_punishment
		admin/admins_record
		family/family
		show_all_punishments = 0
		tmp
			log_start
			image
				selector_kingdom
				selector_branch
			character_handling/container
				classban_kingdom
				classban_branch
				classban_old_kingdom
				classban_old_branch
	New(master)
		. = ..()
		src.master = master
	verb
		show_panel()
			set name = ".adminpanel"
			var/admin/A = usr.client.admin
			if(A.panel) A.panel.Update()
		map_editor()
			set name= ".mapeditor"
			if(!usr.client.map_editor) usr.client.map_editor = new(usr.client)
			else del usr.client.map_editor
	proc
		_AddMenuItem(screen, link_title)
			if(src.screen == screen) return "<strong>[link_title]</strong><br />"
			return "<a href=\"byond://?src=\ref[src];screen=[screen]\">[link_title]</a><br />"
		_OutputPlayerTable(list/L)
			. = {"
			<table class="table" width="560">
				<tr>
					<th>Key</th>
					<th>Last seen</th>
					<th>Status</th>
				</tr>"}
			for(var/player/P in L)
				. += "<tr><td><a href=\"byond://?src=\ref[src];screen=players;cmd=open_record;record=\ref[P]\">[P.name]</a>"
				if(P.client && P.client.mob) . += " ([P.client.mob.name])"
				. += "</td><td>[activity2text(P.activity, P.client ? P.client.inactivity : null)]</td><td>[P.Status()]</td></tr>"
			. += "</table>"
		_OutputActionLog(limit, type, target)
			var
				i = 1
				r_limit = log_start ? limit + log_start : limit
			for(var/admin_log/A in global.admin.admin_log)
				if((!type || A.log_type == type) && (!target || A.target == target))
					i++
					if(log_start && i < log_start) continue
					. += "<tr><td>[A.admin]</td><td>\[[time2text(A.date)]\] [A.text]</td></tr>"
				if(i > r_limit) break
		UpdateClassBanList()
			if(!selector_kingdom) selector_kingdom = image(icon = 'icons/Classes.dmi', loc = null, icon_state = "selector")
			if(!selector_branch) selector_branch = image(icon = 'icons/Classes.dmi', loc = null, icon_state = "selector")
			selector_kingdom.loc = classban_kingdom
			selector_branch.loc = classban_branch

			master.client.images += selector_kingdom
			master.client.images += selector_branch

			var
				player/P = players_record
				list/L = list(
				"admin/classban.grdKingdoms.cells" = "[game.kingdoms.len]",
				"admin/classban.grdKingdoms.size" = "[(game.kingdoms.len * 36) + 48]x36",
				"admin/classban.grdBranches.is-visible" = (classban_kingdom ? "true" : "false"),
				"admin/classban.lblBranch.is-visible" = (classban_kingdom ? "true" : "false"),
				"admin/classban.grdClasses.is-visible" = (classban_branch ? "true" : "false"),
				"admin/classban.lblClass.is-visible" = (classban_branch ? "true" : "false"),
				"admin/classban.on-close" = "byond://?src=\ref[src];cmd=close_classban",
			)
			if(src.classban_kingdom != src.classban_old_kingdom)
				L["admin/classban.grdBranches.cells"] = "[classban_kingdom ? classban_kingdom.children.len : 0]"
				L["admin/classban.grdClasses.cells"] = "0"
				classban_branch = null
				selector_branch.loc = null
			if(src.classban_branch != src.classban_old_branch)
				L["admin/classban.grdClasses.cells"] = "[classban_branch ? classban_branch.children.len : 0]"
			winset(master.client, null, list2params(L))

			if(!classban_kingdom && game.kingdoms.len)
				var/i = 0
				for(var/character_handling/container/kingdom in game.kingdoms)
					master.client.images -= kingdom.bluex
					if(P && P.class_id_ban && (kingdom.class_id in P.class_id_ban)) master.client.images += kingdom.bluex
					master.client << output(kingdom, "admin/classban.grdKingdoms:[++i]")

			if(classban_kingdom)
				var/i = 0
				for(var/character_handling/container/branch in src.classban_kingdom.children)
					master.client.images -= branch.bluex
					if(P && P.class_id_ban && (branch.class_id in P.class_id_ban)) master.client.images += branch.bluex
					if(src.classban_kingdom != src.classban_old_kingdom)
						master.client << output(branch, "admin/classban.grdBranches:[++i]")

			if(classban_branch)
				var/i = 0
				for(var/character_handling/class/C in src.classban_branch.children)
					master.client.images -= C.redx
					if(!C.amount) master.client.images += C.redx

					master.client.images -= C.bluex
					if(P && P.class_id_ban && (C.class_id in P.class_id_ban)) master.client.images += C.bluex
					if(src.classban_branch != src.classban_old_branch)
						master.client << output(C, "admin/classban.grdClasses:[++i]")

			src.classban_old_kingdom = src.classban_kingdom
			src.classban_old_branch = src.classban_branch
		Update()
			. = {"
			<html>
				<head>
					<title>Admin Panel</title>
					<style type="text/css">
						html, body, form {
							margin: 0px;
							overflow: hidden;
						}
						*, body {
							font-family: calibri;
							font-size: 12px;
						}
						h1, h2, h3, h4 {
							font-family: cambria;
						}
						#menu {
							float: left;
							border-right: 3px groove #333333;
							width: 84px;
							padding: 8px;
						}
						#menu, #content {
							height: 500px;
						}
						#content {
							width: 613px;
							padding: 4px;
							overflow: auto;
						}

						th { text-align: left; }
						div.table, table.table td, table.table th { border: 2px ridge #999999; }
						.box h1 { font-size: 16px; margin: 2px; }
						.box { border: 3px groove #666666; padding: 4px; }
						textarea {
							width: 550px;
							height: 100px;
						}
					</style>
				</head>
				<body scroll="no">
					<div id="menu">"}

			. += _AddMenuItem("statistics", "Statistics")
			. += _AddMenuItem("players", "Players")
			. += _AddMenuItem("log", "Admin Log")
			. += _AddMenuItem("server", "Server")
			. += _AddMenuItem("admins", "Admins")
			if(master.rank != "Support" && master.rank != "Spy") . += _AddMenuItem("books", "Books")
			//if(master.rank == "Developer") . += _AddMenuItem("families", "Families")
			//. += _AddMenuItem("tickets", "Tickets")

			. += "</div><div id=\"content\">"
			. += UpdateScreen(screen)
			. += "</div></body></html>"
			master.client << browse(., "window=\ref[src];size=700x500")
		UpdateScreen(screen) return ..()
	Topic(href, href_list[])
		if(!usr || !usr.client || usr.client != master.client) return
		if(href_list["screen"])
			screen = href_list["screen"]
			log_start = 0
			show_all_punishments = 0
		if(href_list["log_start"]) log_start = text2num(href_list["log_start"])
		if(href_list["cmd"] == "close_classban")
			classban_kingdom = null
			classban_branch = null
			master.client.images -= selector_kingdom
			master.client.images -= selector_branch
			selector_kingdom = null
			selector_branch = null

			master.client.mob.RemoveClassImages()
		switch(screen)
			if("players")
				switch(href_list["cmd"])
					if("search")
						if(href_list["list_all"])
							players_search = 1
						else if(href_list["list_banned"]) players_search = "ban"
						else if(href_list["list_muted"]) players_search = "mute"
						else if(href_list["list_warned"]) players_search = "warn"
						else if(href_list["list_online"]) players_search = 2
						else
							var
								name = href_list["name"]
								ip = href_list["ip"]
								status_l = href_list["status"]
								status = 0
							if(status_l)
								if(!istype(status_l, /list)) status_l = list(status_l)
								for(var/flag in status_l) status |= text2num(flag)

							players_search = (name || ip || status) ? list(name, ip, status) : null
					if("open_record")
						var/player/P = locate(href_list["record"])
						players_record = P
						show_all_punishments = 0
					if("open_punishment")
						var/player_punishment/W = locate(href_list["punishment"])
						if(players_record && W) players_punishment = W
					if("view_punishments")
						show_all_punishments = !show_all_punishments
					if("cancel")
						if(players_punishment) players_punishment = null
						else players_record = null

					if("add_punishment")
						if(!players_record || master.rank == "Spy") return
						players_punishment = new
						players_punishment.admin = usr.key
					if("update_punishment")
						var
							player/P = players_record
							player_punishment/W = players_punishment
						if(!P || !W) return
						if(W.admin != usr.key && master.rank != "Developer" && master.rank != "Council" && master.rank != "Head Moderator")
							return //access denied!
						if(!W.state) //add
							/*if((master.rank == "GM" || master.rank == "Support") && (length(href_list["reason"]) < 100 || (href_list["state"] != "note" && length(href_list["message"]) < 50)))
								alert(usr, "You cannot add this punishment; either the reason or the message is too short! (Reason must be at least 100 chars, message at least 50)", "Invalid reason/message supplied!")
								return*/

							W.date = world.realtime
							W.state = href_list["state"]

							if(!P.punishments) P.punishments = new/list()
							P.punishments += W
							global.admin.AddLog(usr.key, "Added [W.state == "note" ? "note" : "punishment"] to [P.name]'s record. (state = [W.State()])", "players", P.name)
						else
							global.admin.AddLog(usr.key, "Modified [P.name]'s [W.state == "note" ? "note" : "punishment"]. (state = [W.State()])", "players", P.name)
							if(W.state != "note")
								if(href_list["state"] != "note") W.state = href_list["state"]

						W.reason = href_list["reason"]
						W.message = href_list["message"]
						if(master.rank == "Developer" || master.rank == "Council" || master.rank == "Head Moderator")
							W.admin = href_list["admin"]
						if(W.state != "note")
							var
								hours = text2num(href_list["expire_date"])
								rounds = text2num(href_list["expire_rounds"])
							if(hours == -1) W.expiration_date = -1
							else if(hours > 0)
								W.expiration_date = world.realtime + (hours HOURS)

							if(rounds == -1) W.expiration_rounds = -1
							else if(rounds > 0) W.expiration_rounds = round(rounds)
						players_punishment = null

						if(P) P.CheckPunishments()
					if("delete_punishment")
						var
							player/P = players_record
							player_punishment/W = players_punishment
						if(!P || !W || !(W in P.punishments)) return
						if(master.rank != "Developer" && master.rank != "Council" && master.rank != "Head Moderator")
							return //access denied!
						P.punishments -= W
						global.admin.AddLog(usr.key, "Deleted [P.name]'s [W.state == "note" ? "note" : "punishment"]. (state = [W.State()])", "players", P.name)
						players_punishment = null
						P.CheckPunishments()
					if("add_comment")
						var
							player/P = players_record
							player_punishment/W = players_punishment
						if(!P || !W || !W.state || !href_list["comment"]) return
						var/player_post/post = new(usr.key, href_list["comment"])
						if(!W.posts) W.posts = new/list()
						W.posts += post
						global.admin.AddLog(usr.key, "Posted a comment on [P.name]'s [W.state == "note" ? "note" : "punishment"].", "players", P.name, dupe = 1)
					if("disassociate")
						if(master.rank == "Developer" || master.rank == "Council" || master.rank == "Head Moderator")
							var
								player/P = players_record
							if(!P) return
							P.associates = null
							P.CheckPunishments()
							global.admin.AddLog(usr.key, "Removed all associations from [P.name]'s record.", "players", P.name)
					if("toggle_expired")
						var
							player/P = players_record
							player_punishment/W = players_punishment
						if(!P || !W) return
						if(W.admin != usr.key && master.rank != "Developer" && master.rank != "Council" && master.rank != "Head Moderator")
							alert("You are not permitted to perform this action!")
							return //access denied!
						W.expired = !W.expired
						P.CheckPunishments()
						global.admin.AddLog(usr.key, "Toggled expiration on [P.name]'s punishment (state = [W.state]; expiration = [W.expired ? "expired" : "active"].", "players", P.name)
					if("toggle_watch")
						var
							player/P = players_record
						if(!P) return
						if(!P.watchers) P.watchers = new/list()
						if(usr.ckey in P.watchers)
							P.watchers -= usr.ckey
							if(P.watchers.len <= 0) P.watchers = null
						else
							P.watchers += usr.ckey
					if("classban")
						var/player/P = players_record
						if(!P) return
						winshow(master.client, "admin/classban", 1)
						UpdateClassBanList()
			if("server")
				switch(href_list["cmd"])
					if("toggle_am")
						if(master.rank == "Spy") return
						abandon_mob = !abandon_mob
						send_message(world, "<b>[abandon_mob ? "You may now abandon mob." : "You may no longer abandon mob."]</b>", 3)
						global.admin.AddLog(usr.key, "Toggled abandon mob (now: [abandon_mob ? "on":"off"])", "server")
					if("toggle_infect")
						if(master.rank == "Spy") return
						infection_mode = !infection_mode
						send_message(world, "<b>Infection mode is [infection_mode ? "on" : "off"]!</b>", 3)
						global.admin.AddLog(usr.key, "Toggled infection mode (now: [infection_mode ? "on":"off"])", "server")
					if("toggle_ooc")
						if(master.rank == "Spy") return
						oocon = !oocon
						send_message(world, "<b>The OOC channel has been [oocon ? "enabled" : "disabled"]!</b>", 3)
						global.admin.AddLog(usr.key, "Toggled the OOC channel (now: [oocon ? "on":"off"])", "server")
					if("toggle_vote")
						if(master.rank == "Spy") return
						global.admin.flags ^= global.admin.FLAG_VOTE_REBOOT
						vote_system.vote_reboot = !vote_system.vote_reboot
						send_message(world, "<b>Reboot vote turned [(global.admin.flags & global.admin.FLAG_VOTE_REBOOT) ? "on" : "off"]!</b>", 3)
						global.admin.AddLog(usr.key, "Toggled reboot vote (now: [(global.admin.flags & global.admin.FLAG_VOTE_REBOOT) ? "on":"off"])", "server")

						if(global.admin.reboot_votes)
							global.admin.reboot_votes = null
							send_message(world, "<tt>Vote to reboot cancelled. All previous votes nullified.</tt>")
					if("toggle_help")
						if(master.rank == "Spy") return
						adminhelp = !adminhelp
						for(var/client/C) if(C.admin)
							C << "\blue <b>(admin) Admin help has been turned [adminhelp ? "on" : "off"].</b>"
						global.admin.AddLog(usr.key, "Toggled admin help (now: [adminhelp ? "on":"off"])", "server")
					if("reboot")
						if(master.rank == "Spy") return
						global.admin.AddLog(usr.key, "[(global.admin.flags & global.admin.FLAG_REBOOTING) ? "Aborted":"Initiated"] Server Reboot", "server")
						global.admin.reboot(usr.key)
					if("shutdown")
						if(master.rank != "Developer") return
						global.admin.AddLog(usr.key, "[(global.admin.flags & global.admin.FLAG_SHUTDOWN) ? "Aborted":"Initiated"] Server Shutdown", "server")
						global.admin.shutdown2(usr.key)
					if("change_motd", "change_amotd", "change_rules")
						var/message = href_list["message"]
						switch(href_list["cmd"])
							if("change_motd")
								if(master.rank == "Spy") return
								global.admin.AddLog(usr.key, "Modified Player MOTD", "server")
								if(fexists("motd.txt")) fdel("motd.txt")
								text2file(message, "motd.txt")
							if("change_amotd")
								if(master.rank != "Developer") return
								global.admin.AddLog(usr.key, "Modified Admin MOTD", "server")
								if(fexists("motd_admin.txt")) fdel("motd_admin.txt")
								text2file(message, "motd_admin.txt")
							if("change_rules")
								if(master.rank != "Developer" && master.rank != "Council" && master.rank != "Head Moderator") return
								global.admin.AddLog(usr.key, "Modified Rules Page", "server")
								if(fexists("rules.htm")) fdel("rules.htm")
								text2file(message, "rules.htm")
					if("hour", "day", "month")
						if(master.rank == "Spy") return
						switch(href_list["cmd"])
							if("hour") Hour++
							if("day") Day++
							if("month") Month++
						global.admin.AddLog(usr.key, "Advanced the game time.", "server", dupe = 0)
						game.TimeCheck()
			if("books")
				switch(href_list["cmd"])
					if("delete_book")
						var/id = text2num(href_list["book"])
						if(!id) return
						global.admin.AddLog(usr.key, "Removed book \"[books[id]]\"", "books", dupe = 0)
						books -= books[id]
					if("reject")
						var/id = text2num(href_list["book"])
						if(!id) return
						global.admin.AddLog(usr.key, "Rejected book \"[books[id]]\"", "books", dupe = 0)
						books -= books[id]
					if("approve")
						var/id = text2num(href_list["book"])
						if(!id) return
						var/item/misc/book/I = books[books[id]]
						if(I)
							global.admin.AddLog(usr.key, "Approved book \"[books[id]]\"", "books", dupe = 0)
							I.approved = 1
							var
								ckey = ckey(I.author)
								player/P
							for(P in global.admin.players)
								if(P.ckey == ckey) break
							if(P)
								P.AwardMedal("Member Of The Bovinia Book Club")
			if("admins")
				switch(href_list["cmd"])
					if("open_record")
						var/admin/A = locate(href_list["record"])
						admins_record = A
					if("delete_record")
						var
							list/allowed_ranks = master.AllowedRanks()
							admin/A = admins_record
						if(!A || !(A.rank in allowed_ranks)) return
						if(A.client) A.Logout(A.client)
						global.admin.admins -= A.ckey
						global.admin.AddLog(usr.key, "Removed [A.name]'s admin record.", "admins", dupe = 1)
						admins_record = null
					if("modify_record")
						var
							list/allowed_ranks = master.AllowedRanks()
							admin/A = admins_record
						if(!A || !(A.rank in allowed_ranks) || !(href_list["rank"] in allowed_ranks) || !href_list["key"]) return

						if(!A.name)
							global.admin.AddLog(usr.key, "Created new admin record for [href_list["key"]] (rank = [href_list["rank"]])", "admins", dupe = 1)
						else
							global.admin.AddLog(usr.key, "Modified admin record for [href_list["key"]] (rank = [href_list["rank"]])", "admins", dupe = 1)

						if(href_list["rank"] in allowed_ranks)
							A.rank = href_list["rank"]
							A.RemoveVerbs()
							A.AddVerbs()

						if(href_list["key"] != A.name && !(ckey(href_list["key"]) in global.admin.admins))
							if(A.client) A.Logout(A.client)
							if(A.ckey) global.admin.admins -= A.ckey
							A.name = dta_ckey2key(ckey(href_list["key"]))
							if(!A.name) A.name = href_list["key"]
							A.ckey = ckey(A.name)
							global.admin.admins[A.ckey] = A
							for(var/client/C)
								if(C.ckey == A.ckey)
									C.admin = A
									A.Login(C)
					if("new_record")
						//if(usr.ckey in developers)
						var/admin/A = new
						A.rank = "Spy"
						admins_record = A
						//else
						//	alert(usr, "Not anymore! You must ask a developer to add the administrator you want (at least for now).", "Could not add anyone!")
			if("families")
				switch(href_list["cmd"])
					if("new_family")
						var/name = input(usr, "Specify a name for the new family.", "New Family") as null|text
						if(!name) return
						var/founder = input(usr, "Specify a founder for the family. Leave blank to delete the family.", "Founder") as null|text

						if(!global.admin.families) global.admin.families = new/list()
						var/family/F
						for(F in global.admin.families)
							if(F.name == name) break
						if(!F)
							if(!founder) return
							F = new
							F.name = name
							global.admin.families += F
							spawn alert(usr, "Added family [name] with founder [founder].")
						else
							if(!founder)
								if(!global.admin.families) return
								spawn alert(usr, "Erased family [F] with founder [F.founder] and [F.members ? F.members.len : 0] members.")
								global.admin.families -= F
								if(!global.admin.families.len) global.admin.families = null
								for(var/client/C) C.CheckFamily()

								Update()
								return
							else
								spawn alert(usr, "Updated family [name] with founder [founder].")
						F.founder = founder
						if(!F.members) F.members = new/list()
						if(!(F.founder in F.members)) F.members += F.founder
						for(var/client/C) C.CheckFamily()
					if("show_family") family = locate(href_list["family"])
					if("cancel") family = null
					if("remove_member")
						if(href_list["key"] == family.founder) return
						family.members -= href_list["key"]
					if("spawn_location")
						var/spawnloc = input(usr, "Specify the new spawn location here.", "Set Spawn Location", family.spawn_location) as null|text
						if(spawnloc == null) return
						family.spawn_location = spawnloc
						usr.show_message("<tt>Set \"[spawnloc]\" as the start location for family [family.name].</tt>")
					if("remove_assigned_to")
						family.contents -= href_list["assigned_to"]
						if(!family.contents.len) family.contents = null
					if("remove_type")
						var
							assigned_to = href_list["assigned_to"]
							type = href_list["type"]
						if(assigned_to in family.contents)
							var/list/L = family.contents[assigned_to]
							if(L && L.len)
								L -= text2path(type)
								if(!L.len) family.contents -= assigned_to
					if("add_item")
						var/add_to = input(usr, "Specify target:", "Add type") as null|anything in list("ALL") + family.members
						if(!add_to) return
						if(add_to != "ALL") add_to = ckey(add_to)
						var/type = input(usr, "Specify type to add:", "Add type") as null|anything in typesof(/item)
						if(!type) return

						if(!family.contents) family.contents = new/list()
						if(!(add_to in family.contents)) family.contents[add_to] = new/list()
						if(!(type in family.contents[add_to])) family.contents[add_to] += type
		Update()