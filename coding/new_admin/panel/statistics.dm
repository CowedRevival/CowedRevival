admin_panel/UpdateScreen(screen)
	. = ..()
	if(screen != "statistics") return .
	var/list
		MyPlayers = new/list()
		MyPunishedPlayers = new/list()
		PunishedPlayers = new/list()
	for(var/player/P in global.admin.players)
		if(master.client.ckey in P.watchers)
			MyPlayers += P
			continue
		var/player_punishment/W
		for(W in P.punishments)
			if(!W.expired && W.admin == master.client.key) break
		if(W)
			MyPunishedPlayers += P
		else
			for(W in P.punishments)
				if(!W.expired && W.state != "note") break
			if(W)
				PunishedPlayers += P
	. += {"<div class=\"box\">
		<h1>Server Information</h1>
		<table>
			<tr>
				<th>Uptime:</th>
				<td>[world.system_type == UNIX ? shellresult("/usr/bin/uptime") : "N/A (Windows)"]</td>
			</tr><tr>
				<th>CPU Usage:</th>
				<td>[world.cpu]%</td>
			</tr><tr>
				<th>Operating System:</th>
				<td>[world.system_type]</td>
			</tr><tr>
				<th>Address:</th>
				<td><font color=\"#0000FF\">[world.url || "(generating...)"]</font></td>
			</tr>
		</table>
	</div><div class=\"box\">
		<h1>Watched Players</h1>
		[_OutputPlayerTable(MyPlayers)]
	</div><div class=\"box\">
		<h1>Players I Punished</h1>
		[_OutputPlayerTable(MyPunishedPlayers)]
	</div>"}
	if(master.rank == "Head Moderator" || master.rank == "Council" || master.rank == "Developer" || master.rank == "Spy")
		. += {"<div class=\"box\">
			<h1>Other Punished Players</h1>
			[_OutputPlayerTable(PunishedPlayers)]
		</div>"}
	. += {"<div class=\"box\">
		<h1>Recent Activity</h1>
		<table width="571" class="table">
			<tr>
				<th width="30%">By whom?</th>
				<th width="70%">Action</th>
				[_OutputActionLog(limit = 25)]
			</tr>
		</table>
		<a href="byond://?src=\ref[src];log_start=[max(1, log_start - 25)]">Back</a> &middot; <a href="byond://?src=\ref[src];log_start=[min(admin.admin_log.len, log_start + 25)]">Next</a>
	</div>"}
