admin
	var
		name
		ckey
		rank
		activity = -1 //-1 = never seen before, 0 = online, >0 = world.realtime at time of logout
		tmp
			client/client
			admin_panel/panel
			mouse_movement = 0
	New(key, rank)
		if(key)
			src.name = key
			src.ckey = ckey(key)
		if(rank) src.rank = rank
	proc
		Login(client/C)
			activity = 0
			client = C
			panel = new(src)
			C.verbs += new/admin_panel/verb/show_panel

			RemoveVerbs()
			winset(client, "adminmenu", list2params(list("parent" = "menu", "name" = "Admin")))
			winset(client, "adminmenu_panel", list2params(list("parent" = "adminmenu", "name" = "Show Panel", "command" = ".adminpanel")))
			AddVerbs()
		Logout(client/C)
			activity = world.realtime
			client = null
			if(!dta_shutdown) spawn
				if(!dta_shutdown)
					RemoveVerbs()
					if(client) winset(client, "adminmenu", "parent=")
					panel = null

		AddVerbs()
			if(!client) return
			if(rank != "Spy") client.verbs += typesof(/admin/verb)
			if(rank != "Spy" && rank != "Support")
				client.verbs += typesof(/tadmin/verb)
				client.verbs += new/admin_panel/verb/map_editor
				winset(client, "adminmenu_maped", list2params(list("parent" = "adminmenu", "name" = "Map Editor", "command" = ".mapeditor")))
		RemoveVerbs()
			if(!client) return
			client.verbs -= typesof(/tadmin/verb)
			client.verbs -= typesof(/admin/verb)

		AllowedRanks() //which ranks is this administrator allowed to maintain?
			var/list/L = list(
				"Council", "Head Moderator", "Moderator", "Administrator", "GM", "Support", "Spy"
			)
			if(rank == "Developer") return L

			if(rank == "Council") L -= "Council"
			else L = list()
			return L