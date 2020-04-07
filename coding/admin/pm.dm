admin_pm
	var
		name
		client/target
		list/admins
		log
	New(client/C, client/A)
		. = ..()
		if(!C || !A) del src
		src.name = C.key
		admins = new/list()
		addAdmin(A)

		target = C
		C.pm = src
		showWindow(target)
		if(!admin_pms) admin_pms = new/list()
		admin_pms += src
	proc
		showWindow(client/C)
			if(!winexists(C, "pm\ref[src]"))
				winclone(C, "admin/pm", "pm\ref[src]")
			winshow(C, "pm\ref[src]")

			var/list/L = list(
				"pm\ref[src].can-resize" = "[C.admin ? "true" : "false"]",
				"pm\ref[src].can-close" = "[C.admin ? "true" : "false"]",
				"pm\ref[src].title" = "PM :: [src.name]",
				"pm\ref[src].pminput.command" = "pm \"\ref[src]\" \"",
				"pm\ref[src].on-close" = "[C.admin ? "byond://?src=\ref[src];cmd=close":]"
			)
			winset(C, null, list2params(L))
			C << output(null, "pm\ref[src].output")
			C << output(log, "pm\ref[src].output")
		hideWindow(client/C)
			C << output(null, "pm\ref[src].output")
			winshow(C, "pm\ref[src]", 0)
		addAdmin(client/C)
			if(C == target) return
			if(!admins) admins = new/list()
			showWindow(C)
			if(!(C in admins))
				admins += C
				echo("<b>[C.key]</b> has joined the chatroom.")
		removeAdmin(client/C)
			if(C != target)
				admins -= C
				echo("<b>[C.key]</b> has left the chatroom.")
			else
				echo("<b>[C.key]</b> has disbanded the chat.")
				for(var/client/X in admins) removeAdmin(X)
			hideWindow(C)
			if(!admins || !admins.len)
				if(target)
					hideWindow(target)
					admin_pms -= src
					if(!admin_pms || !admin_pms.len) admin_pms = null
					del src
		echo(t)
			. = "\[[time2text(world.timeofday, "hh:mm:ss")]\] [t]"
			if(log) log += "<br>"
			log += "[.]"
			for(var/client/C in admins) C << output(., "pm\ref[src].output")
			if(target) target << output(., "pm\ref[src].output")
	Topic(href, href_list[])
		if(href_list["cmd"] == "close")
			if(!usr.client.admin && usr.client == target)
				showWindow(usr.client)
			else
				removeAdmin(usr.client)