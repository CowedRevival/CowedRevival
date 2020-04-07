global_admin
	var
		list
			players
			admins
			admin_log
			families
		respawn_time = 3000
		const
			FLAG_REBOOTING = 1
			FLAG_SHUTDOWN = 2
			FLAG_VOTE_REBOOT = 4 //allows a vote-to-reboot by non-admins
		tmp
			flags = FLAG_VOTE_REBOOT
			list
				reboot_votes
	New()
		. = ..()
		var/savefile/F = new("data/admin.sav")
		F >> admins
		F = new("data/admin_log.sav")
		F >> admin_log
		F = new("data/players.sav")
		F >> players
		F = new("data/families.sav")
		F >> families

		for(var/family/family in families)
			if(family.version == 1)
				family.version = 2
				family.contents = null

		if(!admins) admins = new/list()
		for(var/X in developers)
			admins[X] = new/admin(dta_ckey2key(X), "Developer")

		if(!admin_log) admin_log = new/list()

		spawn(10)
			/*if(global.dta_admin)
				if(!players) players = new/list()
				file("admin_convert.log") << "*** Begin conversion cycle. ([time2text(world.realtime)]) ***"
				for(var/dta_admin/player/P in global.dta_admin.players)
					var/player/D
					for(D in players)
						if(D.name == P.name) break
					if(!D)
						D = new
						D.name = P.name
						D.ckey = ckey(P.name)
						D.activity = P.activity
						D.paintings = P.paintings
						D.medals = P.medals
						D._medals = P._medals
						D.score_deaths = P.score_deaths
						D.score_royalblood = P.score_royalblood
						D.score_taxes = P.score_taxes
						D.score_rppoints = P.score_rppoints
						D.medal_woodcutter = P.medal_woodcutter
						D.medal_chef = P.medal_chef
						D.medal_painter = P.medal_painter

						file("admin_convert.log") << "Converted [P.name] (\ref[P]) -> [D.name] (\ref[D])"
						players += D
					else
						file("admin_convert.log") << "Skipped [P.name] (\ref[P]) -> [D.name] (\ref[D])"
				file("admin_convert.log") << "*** End conversion cycle. ***"*/

			if(players)
				file("admin_deleted.log") << "*** Begin deletion cycle. ([time2text(world.realtime)]) ***"
				for(var/player/P in players)
					if(!P.name)
						file("admin_deleted.log") << "Removing [P.name]."
						players -= P
				file("admin_deleted.log") << "*** End deletion cycle. ***"
			if(players)
				for(var/player/P in players)
					for(var/player_punishment/N in P.punishments)
						if(!N.master) N.master = P
	Del()
		var/savefile/F = new("data/admin.sav")
		F << admins
		F = new("data/admin_log.sav")
		F << admin_log
		F = new("data/players.sav")
		F << players
		F = new("data/families.sav")
		F << families
		return ..()

	proc
		Loop()
			while(1)
				for(var/player/P in global.admin.players)
					for(var/player_punishment/W in P.punishments)
						if(!W.expired && W.expiration_date != -1) W.AutoExpire()
				sleep(3000)
		AddLog(admin, text, type, target, dupe = 0)
			if(!admin_log) admin_log = new/list()
			if(!dupe)
				var/admin_log/L
				for(L in admin_log)
					if(L.admin == admin && L.text == text && L.type == type && L.target == target && L.date + 6000 > world.realtime) break
				if(L) return 0
			admin_log.Insert(1, new/admin_log(admin, text, world.realtime, type, target))
			if(admin_log.len > 2000)
				admin_log.len = 2000
			return 1
		reboot(cause)
			if(flags & FLAG_REBOOTING)
				ActionLock("reboot", 100)
				flags &= ~FLAG_REBOOTING
				send_message(world, "<b>Reboot aborted[cause ? " by [cause]" :].</b>", 3)
			else
				if(ActionLock("reboot")) return
				flags |= FLAG_REBOOTING
				send_message(world, "<b>Rebooting server in 10 seconds![cause ? " Initiated by [cause].":]</b>", 3)
				spawn(70)
					if(!(flags & FLAG_REBOOTING)) return
					send_message(world, "<b>Rebooting server in 3...", 3)
					sleep(10)
					if(!(flags & FLAG_REBOOTING)) return
					send_message(world, "<b>Rebooting server in 2...", 3)
					sleep(10)
					if(!(flags & FLAG_REBOOTING)) return
					send_message(world, "<b>Rebooting server in 1...", 3)
					sleep(10)
					if(!(flags & FLAG_REBOOTING)) return
					send_message(world, "<b>Rebooting server!", 3)
					world.Reboot()
		shutdown2(cause)
			if(flags & FLAG_SHUTDOWN)
				ActionLock("shutdown", 100)
				flags &= ~FLAG_SHUTDOWN
				send_message(world, "<b>Server shutdown aborted[cause ? " by [cause]" :].</b>", 3)
			else
				if(ActionLock("shutdown")) return
				flags |= FLAG_SHUTDOWN
				send_message(world, "<b>Closing server in 10 seconds![cause ? " Initiated by [cause].":]</b>", 3)
				spawn(70)
					if(!(flags & FLAG_SHUTDOWN)) return
					send_message(world, "<b>Closing server in 3...", 3)
					sleep(10)
					if(!(flags & FLAG_SHUTDOWN)) return
					send_message(world, "<b>Closing server in 2...", 3)
					sleep(10)
					if(!(flags & FLAG_SHUTDOWN)) return
					send_message(world, "<b>Closing server in 1...", 3)
					sleep(10)
					if(!(flags & FLAG_SHUTDOWN)) return
					send_message(world, "<b>Closing server!", 3)
					del world
		refreshAdminSettings(client/C)
			if("admin/settings" in C.windows)
				var/list/L = list(
					"admin/settings.on-close" = "byond://?src=\ref[src];module=admin_settings;cmd=close"
				)
				winset(C, null, list2params(L))

				. = {"
				<html>
					<head>
						<title>Admin :: Global Settings</title>
						<link rel="stylesheet" type="text/css" href="cowed_style.css" />
					</head>
					<body>
						<form action="byond://" method="post">
						<input type="hidden" name="src" value="\ref[src]" />
						<input type="hidden" name="module" value="admin_settings" />
						<table>
							<tr>
								<td>Server Port:</td>
								<td><input type="text" name="port" value="[world.port]"[C.admin.rank < 3 ? " disabled":] /></td>
							</tr><tr>
								<td>Server Host:</td>
								<td><input type="text" name="host" value="[world.host || hostkey]"[world.host || C.admin.rank < 3 ? " disabled":] /></td>
							</tr><tr>
								<td>Status Message:</td>
								<td><input type="text" name="status" value="[status_message]" /></td>
							</tr><tr>
								<td>Player Cap:</td>
								<td><input type="text" name="playercap" value="[max_players == -1 ? "unlimited" : max_players]" /></td>
							</tr><tr>
								<td>Commands:</td>
								<td>
									<input type="submit" value="Commit Changes" />
									<input type="button" value="[(flags & FLAG_REBOOTING) ? "Abort ":]Reboot" onclick="if(confirm('Are you sure that you want to reboot?')){parent.location='byond://?src=\ref[src];module=admin_settings;cmd=reboot';}" />
									<input type="button" value="[(flags & FLAG_SHUTDOWN) ? "Abort ":]Shutdown" onclick="if(confirm('Are you sure that you want to shutdown? The server can only be started up by someone with access to the host machine!')){parent.location='byond://?src=\ref[src];module=admin_settings;cmd=shutdown';}"[C.admin.rank < 3 ? " disabled":] />
								</td>
							</tr>
						</table></form>
					</body>
				</html>"}
				C << browse(., "window=admin/settings.browser")