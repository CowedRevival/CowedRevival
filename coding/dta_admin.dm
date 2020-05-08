#define L2P(X) list2params(X)

dta_admin/dta_admin
	var
		respawn_time = 3000
	New()
		. = ..()
		if(!admins || !admins.len)
			admins = new/list()

dta_admin/module
	gm
		name = "GM"
		access = list("superadmin", "gm", "gm.gameTime")
		game_time
			name = "Game Time"
			access = list("superadmin", "gm.gameTime")
			create_tab(mob/M)
				var
					size = master.GetWindowSize()
					pos = findtext(size, "x")
					width
					list/L
				if(pos) width = round(text2num(copytext(size, 1, pos)) / 2) - 32
				//labels
				L = list(
					"parent" = skinid,
					"type" = "label",
					"size" = "64x24",
					"pos" = "[width - 72],8",
					"text" = "Hour",
					"anchor1" = "50,0"
				)
				winset(M, "[skinid].lblHour", L2P(L))

				L["pos"] = "[width],8"
				L["text"] = "Day"
				winset(M, "[skinid].lblDay", L2P(L))

				L["pos"] = "[width + 72],8"
				L["text"] = "Month"
				winset(M, "[skinid].lblMonth", L2P(L))

				//buttons
				L = list(
					"parent" = skinid,
					"type" = "button",
					"size" = "64x24",
					"pos" = "[width - 72],32",
					"command" = "byond://?src=\ref[src];cmd=hour",
					"anchor1" = "50,0"
				)
				winset(M, "[skinid].btnHour", L2P(L))

				L["pos"] = "[width],32"
				L["command"] = "byond://?src=\ref[src];cmd=day"
				winset(M, "[skinid].btnDay", L2P(L))

				L["pos"] = "[width + 72],32"
				L["command"] = "byond://?src=\ref[src];cmd=month"
				winset(M, "[skinid].btnMonth", L2P(L))
			refreshWindow(mob/M)
				var/L = list2params(list(
					"[skinid].btnHour.text" = "[Hour]",
					"[skinid].btnDay.text" = "[Day]",
					"[skinid].btnMonth.text" = "[Month]"
				))
				winset(M, null, L)
			Command(href, href_list[])
				switch(href_list["cmd"])
					if("hour") Hour++
					if("day") Day++
					if("month") Month++
				TimeCheck()
		book
			name = "Books"
			access = list("superadmin", "gm.BookManager")
			var/item/misc/book/edit
			create_tab(mob/M)
				var/L = list2params(list(
					"parent" = skinid,
					"type" = "browser",
					"size" = "0x0",
					"pos" = "0,0",
					"anchor1" = "0,0",
					"anchor2" = "100,100"
				))
				winset(M, "[skinid].browser", L)
			refreshWindow(mob/M)
				. = {"
				<html>
					<head>
						<style type="text/css">
							body {
								font-family: verdana;
								font-size: 12px;
							}
							a { color: #0000FF; font-size: 12px; text-decoration: none; }
							a:hover { text-decoration: underline; }
							th { text-align: left; border-bottom: 1px solid #000000; }
							th,td { padding: 0px 8px; }
							td, td a { font-size: 10px; }
							textarea {
								margin: 2px;
								width: 100%;
								height: 160px;
							}
						</style>
					</head>
					<body>"}
				if (edit)
					var/label = copytext(edit.name, 8)
					label = copytext(label, 1, length(label))
					. += {"
						<a href="byond://?src=\ref[src];cmd=save;cancel=cancel">\[Back to books list]</a><hr />
						<form action="byond://" method="post">
							<input type="hidden" name="src" value="\ref[src]" />
							<input type="hidden" name="cmd" value="save" />
							Book label: <input name="label" value="[label]" /><br />"}
					for (var/i = 1; i <= edit.contents.len; i++)
						var/item/misc/paper/P = edit.contents[i]
						. += {"
							<div style="text-align: right"><a href="byond://?src=\ref[src];cmd=addpage;i=[i]">(insert page)</a></div><br />
							<a href="byond://?src=\ref[src];cmd=delpage;page=[i]">(del)</a> Page [i]: <input name="label[i]" value="[P.label]" /><br />
							<textarea name="page[i]">[P.content]</textarea><br />"}
					. += {"
							<div style="text-align: right"><a href="byond://?src=\ref[src];cmd=addpage;i=[edit.contents.len+1]">(insert page)</a></div><br />
							<button onclick="this.form.submit()">Save changes</button>&nbsp;<button onclick="this.form.reset()">Reset changes</button>
						</form>"}
				else
					. += {"
						<small><em>Click on a title to edit it, click on (del) to <strong>delete</strong> it. This action cannot be undone.</em></small>
						<table cellspacing="0">
							<thead>
								<th>Book Title</th>
								<th>Pages</th>
								<th width="156">Last Update</th>
								<th>Delete</th>
							</thead>
							<tbody>"}
					for(var/x in books)
						var/item/misc/book/I = books[x]
						. += {"
						<tr>
							<td><a href="byond://?src=\ref[src];cmd=edit;book=[x]">[x]</a></td>
							<td>[I.contents.len] pages</td>
							<td>[I.updated ? time2text(I.updated) : "updating..."]</td>
							<td><a href="byond://?src=\ref[src];cmd=delete;book=[x]" onclick="return confirm('Are you sure that you want to delete this book?');">(del)</a></td>
						</tr>"}
						if(!I.updated) I.updated = world.realtime
					. += "</tbody></table>"
				. += "</body></html>"
				M << browse(., "window=[skinid].browser")
			Command(href, href_list[])
				switch(href_list["cmd"])
					if ("delete")
						books -= href_list["book"]
						globalRefresh()
					if ("edit")
						edit = books[href_list["book"]]
						refreshWindow(usr)
					if ("save")
						if (href_list["cancel"])
							edit = null
							refreshWindow(usr)
							return
						var/prevname = edit.name
						edit.label(href_list["label"])
						for (var/i = 1; i <= edit.contents.len; i++)
							var/item/misc/paper/P = edit.contents[i]
							P.label(href_list["label[i]"])
							P.content = href_list["page[i]"]
						edit.updated = world.realtime
						if (edit.name != prevname)
							books.Remove(prevname)
							books[edit.name] = edit
						edit = null
						globalRefresh()
					if ("addpage")
						edit.contents.Insert(href_list["i"], new/item/misc/paper)
						refreshWindow(usr)
					if ("delpage")
						edit.contents -= edit.contents[text2num(href_list["page"])]
						refreshWindow(usr)

	server
		name = "Server"
		access = list("superadmin", "servermanager", "servermanager.Reboot", "servermanager.Shutdown", "servermanager.Settings", "motd", "admin_motd", "serverRules")
		settings
			name = "Server Settings"
			access = list("superadmin", "servermanager", "servermanager.Reboot", "servermanager.Shutdown", "servermanager.Settings")
			create_tab(mob/M)
				var/L = list2params(list(
					"parent" = skinid,
					"type" = "browser",
					"size" = "0x0",
					"pos" = "0,0",
					"anchor1" = "0,0",
					"anchor2" = "100,100"
				))
				winset(M, "[skinid].browser", L)
			refreshWindow(mob/M)
				. = {"
				<html>
					<head>
						<style type="text/css">
							body {
								font-family: verdana;
								font-size: 12px;
							}
							a { color: #0000FF; font-size: 12px; text-decoration: none; }
							a:hover { text-decoration: underline; }
							th { text-align: left; border-bottom: 1px solid #000000; }
							th,td { padding: 0px 8px; }
							td, td a { font-size: 10px; }
						</style>
					</head>
					<body>
						<form action="byond://" method="post">
							<input type="hidden" name="src" value="\ref[src]" />
							<input type="hidden" name="cmd" value="change" />
							<table>
								<tr>
									<td>Server Port:</td>
									<td>
										<input type="text" name="port" value="[world.port]" />
									</td>
								</tr><tr>
									<td>Server Host:</td>
									<td>
										<input type="text" name="host" value="[world.host ? world.host : hostkey]"[world.host ? " disabled":]" />
									</td>
								</tr><tr>
									<td>Status Message:</td>
									<td>
										<input type="text" name="status" value="[status_message]" size="64" />
									</td>
								</tr><tr>
									<td>Player Limit:</td>
									<td>
										<input type="text" name="playerlimit" value="[max_players == -1 ? "unlimited" : max_players]" />
									</td>
								</tr><tr>
									<td>Commands:</td>
									<td>
										<input type="submit" value="Commit Changes"[!master.hasAccess(list("superadmin", "servermanager.Settings")) ? " disabled":] />
										<input type="button" value="[(admin.flags & admin.FLAG_REBOOTING) ? "Abort ":]Reboot" onclick="if(confirm('Are you sure that you want to reboot?')){parent.location='byond://?src=\ref[src];cmd=reboot';}"[!master.hasAccess(list("superadmin", "servermanager.Reboot")) ? " disabled":] />
										<input type="button" value="[(admin.flags & admin.FLAG_SHUTDOWN) ? "Abort ":]Shutdown" onclick="if(confirm('Are you sure that you want to shutdown? The server can only be started up by someone with access to the host machine!')){parent.location='byond://?src=\ref[src];cmd=shutdown';}"[!master.hasAccess(list("superadmin", "servermanager.Shutdown")) ? " disabled":] />
									</td>
								</tr>
							</table>
					</body>
				</html>"}
				M << output(., "[skinid].browser")
			Command(href, href_list[])
				if(href_list["cmd"] == "change")
					var
						port = text2num(href_list["port"])
						host = href_list["host"]
						status = href_list["status"]
						playerlimit = href_list["playerlimit"] == "unlimited" ? -1 : text2num(href_list["playerlimit"])
					if(port > 0) world.OpenPort(port)
					if(host && !world.host) hostkey = host
					if(status != null) status_message = status
					if(max_players != null) max_players = playerlimit
					if(max_players == 0) //kick all the players off if we're going in maintenance mode
						for(var/client/C) if(!C.dta_admin) del C
					world.update_status()
				else if(master.hasAccess(list("superadmin", "servermanager.Reboot")) && href_list["cmd"] == "reboot") admin.reboot(usr.key)
				else if(master.hasAccess(list("superadmin", "servermanager.Shutdown")) && href_list["cmd"] == "shutdown") admin.shutdown2(usr.key)
				globalRefresh()
		motd
			name = "Server MOTD"
			access = list("superadmin", "motd")
			create_tab(mob/M)
				var/L = list2params(list(
					"parent" = skinid,
					"type" = "browser",
					"size" = "0x0",
					"pos" = "0,0",
					"anchor1" = "0,0",
					"anchor2" = "100,100"
				))
				winset(M, "[skinid].browser", L)
			refreshWindow(mob/M)
				. = {"
				<html>
					<head>
						<style type="text/css">
							html, body {
								margin: 0;
								width: 100%;
								height: 100%;
							}
							body {
								font-family: verdana;
								font-size: 12px;
								overflow: hidden;
							}
							textarea {
								position: absolute;
								left: 0px;
								top: 0px;
								width: 100%; height: 100%;
							}
						</style>
					</head>
					<body scroll="no">
						<form action="byond://" method="post">
							<input type="hidden" name="src" value="\ref[src]" />
							<textarea name="motd" onblur="this.form.submit();">[file2text("motd.txt")]</textarea>
						</form>
					</body>
				</html>"}
				M << output(., "[skinid].browser")
			Command(href, href_list[])
				if(href_list["motd"])
					if(fexists("motd.txt")) fdel("motd.txt")
					text2file(href_list["motd"], "motd.txt")
					globalRefresh()
		admin_motd
			name = "Admin MOTD"
			access = list("superadmin", "admin_motd")
			create_tab(mob/M)
				var/L = list2params(list(
					"parent" = skinid,
					"type" = "browser",
					"size" = "0x0",
					"pos" = "0,0",
					"anchor1" = "0,0",
					"anchor2" = "100,100"
				))
				winset(M, "[skinid].browser", L)
			refreshWindow(mob/M)
				. = {"
				<html>
					<head>
						<style type="text/css">
							html, body {
								margin: 0;
								width: 100%;
								height: 100%;
							}
							body {
								font-family: verdana;
								font-size: 12px;
								overflow: hidden;
							}
							textarea {
								position: absolute;
								left: 0px;
								top: 0px;
								width: 100%; height: 100%;
							}
						</style>
					</head>
					<body scroll="no">
						<form action="byond://" method="post">
							<input type="hidden" name="src" value="\ref[src]" />
							<textarea name="motd" onblur="this.form.submit();">[file2text("motd_admin.txt")]</textarea>
						</form>
					</body>
				</html>"}
				M << output(., "[skinid].browser")
			Command(href, href_list[])
				if(href_list["motd"])
					if(fexists("motd_admin.txt")) fdel("motd_admin.txt")
					text2file(href_list["motd"], "motd_admin.txt")
					globalRefresh()
		server_rules
			name = "Server Rules"
			access = list("superadmin", "serverRules")
			create_tab(mob/M)
				var/L = list2params(list(
					"parent" = skinid,
					"type" = "browser",
					"size" = "0x0",
					"pos" = "0,0",
					"anchor1" = "0,0",
					"anchor2" = "100,100"
				))
				winset(M, "[skinid].browser", L)
			refreshWindow(mob/M)
				. = {"
				<html>
					<head>
						<style type="text/css">
							html, body {
								margin: 0;
								width: 100%;
								height: 100%;
							}
							body {
								font-family: verdana;
								font-size: 12px;
								overflow: hidden;
							}
							textarea {
								position: absolute;
								left: 0px;
								top: 0px;
								width: 100%; height: 100%;
							}
						</style>
					</head>
					<body scroll="no">
						<form action="byond://" method="post">
							<input type="hidden" name="src" value="\ref[src]" />
							<textarea name="motd" onblur="this.form.submit();">[file2text("rules.htm")]</textarea>
						</form>
					</body>
				</html>"}
				M << output(., "[skinid].browser")
			Command(href, href_list[])
				if(href_list["motd"])
					if(fexists("rules.htm")) fdel("rules.htm")
					text2file(href_list["motd"], "rules.htm")
					globalRefresh()