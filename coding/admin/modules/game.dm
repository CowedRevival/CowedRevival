admin/module/game
	update()
		var/list/L = list(
			"chkReboot.is-checked" = vote_system.vote_reboot ? "true" : "false",
			"chkOOC.is-checked" = oocon ? "true" : "false",
			"chkHelp.is-checked" = adminhelp ? "true" : "false",
			"chkFrozen.is-checked" = freeze_players ? "true" : "false",

			"chkReboot.command" = "byond://?src=\ref[src];cmd=set_flag;flag=reboot",
			"chkOOC.command" = "byond://?src=\ref[src];cmd=set_flag;flag=ooc",
			"chkHelp.command" = "byond://?src=\ref[src];cmd=set_flag;flag=help",
			"chkFrozen.command" = "byond://?src=\ref[src];cmd=set_flag;flag=frozen",

			"btnRebootVote.text" = "[vote_system.vote ? "Abort Current Vote" : "Initialize Reboot Vote"]",

			"btnMOTD.command" = "byond://?src=\ref[src];cmd=motd",
			"btnVote.command" = "byond://?src=\ref[src];cmd=custom_vote",
			"btnRebootVote.command" = "byond://?src=\ref[src];cmd=reboot_vote",
			"btnDownloadLog" = "byond://?src=\ref[src];cmd=log;action=download",
			"btnViewLog" = "byond://?src=\ref[src];cmd=log;action=view"
		)
		winset(master.client, null, list2params(L))
	Command(href, href_list[])
		switch(href_list["cmd"])
			if("set_flag")
				switch(href_list["flag"])
					if("reboot")
						vote_system.vote_reboot = !vote_system.vote_reboot
						world << "<span class=\"admin\">The automatic reboot vote has been turned [vote_system.vote_reboot ? "on" : "off"] by [usr.key].</span>"
						if(vote_system.vote_reboot && !vote_system.vote) spawn vote_system.Loop()
					if("oocon")
						oocon = !oocon
						world << "<span class=\"admin\">The OOC channel has been turned [oocon ? "on" : "off"] by [usr.key].</span>"
					if("adminhelp")
						adminhelp = !adminhelp
						world << "<span class=\"admin\">The \"admin help\" channel has been turned [adminhelp ? "on" : "off"] by [usr.key].</span>"
					if("frozen")
						freeze_players = !freeze_players
						world << "<span class=\"admin\">All players have been [freeze_players ? "frozen" : "thawed"] by [usr.key].</span>"
				update()
			if("motd")
				var/motd = file2text("motd.txt")
				motd = input(usr, "Make your modifications in the field below and click on \"OK\" to save.", "Change Login Message", motd) as null|message
				if(motd == null) return
				fdel("motd.txt")
				text2file(motd, "motd.txt")
				world << "<span class=\"admin\">The login message has been modified by [usr.key].</span>"
			if("custom_vote")
				if(vote_system.vote)
					spawn alert(usr, "There is already a vote in progress!", "Make Custom Vote")
					return
				var/question = input("What will the question be?", "Question :: Make Custom Vote") as text
				var/list/options = list()
				var/option
				var/i = 0
				do
					if(option) options += option
					option = input(usr, "What will option #[++i] be?", "Option [i] :: Make Custom Vote") as null|text
				while(option != null && !vote_system.vote)

				if(vote_system.vote) return
				world << "<span class=\"admin\">A custom vote was started by [usr.key]!</span>"
				spawn
					var/vote_data/result = vote_system.Query(question, options)
					if(result.aborted) return
					if(result.tie)
						var/list/tie_data = new/list()
						for(i in result.tie_list) tie_data += options[i]
						send_message(world, "<b>Tie!</b> between [dd_list2text(tie_data, "; ")]...", 3)
					send_message(world, "Result: <b>[options[result.winner]]</b>", 3)
			if("reboot_vote")
				if(vote_system.vote)
					world << "<span class=\"admin\">The current vote has been aborted by [usr.key]!</span>"
					vote_system.Abort()
					return
				world << "<span class=\"admin\">A vote-to-reboot has been started by [usr.key]!</span>"
				vote_system.Vote_Reboot()
			if("log")
				switch(href_list["action"])
					if("download") usr << ftp(chat_log)
					if("view")
						. = file2text(chat_log)
						if(length(.) > 524288)
							. = copytext(., length(.) - 524288)
						usr << browse(., "window=\ref[src]_log;size=500x300")