admin_panel/UpdateScreen(screen)
	. = ..()
	if(screen != "players") return .
	if(players_record)
		var/player/P = players_record
		if(players_punishment && players_punishment.state && !(players_punishment in P.punishments)) players_punishment = null

		if(players_punishment)
			var
				player_punishment/W = players_punishment
			. += {"
			<form action="byond://" method="post">
				<input type="hidden" name="src" value="\ref[src]" />
				<input type="hidden" name="cmd" value="update_punishment" />
			<div class=\"box\">
				<h1>[P.name] - \ref[W]</h1>
				<table>
					<tr>"}
			if(W.state != "note")
				. += {"
						<th>Expiration:</th>
						<td>
							<a href="byond://?src=\ref[src];cmd=toggle_expired">[W.expired ? "expired" : "active"]</a>
						</td>
					</tr><tr>"}
			. += {"
						<th>State:</th>
						<td>
							<select name="state">"}
			if(W.state == "note")
				. += "<option>Note</option>"
			else
				if(!W.state) . += "<option value=\"note\">[W.State("note")]</option>"
				. += {"
					<option value="warn"[W.state == "warn" ? " selected":]>[W.State("warn")]</option>
					<option value="moderated"[W.state == "moderated" ? " selected":]>[W.State("moderated")]</option>
					<option value="ooc_mute"[W.state == "ooc_mute" ? " selected":]>[W.State("ooc_mute")]</option>
					<option value="ic_mute"[W.state == "ic_mute" ? " selected":]>[W.State("ic_mute")]</option>
					<option value="mute"[W.state == "mute" ? " selected":]>[W.State("mute")]</option>
					<option value="ban"[W.state == "ban" ? " selected":]>[W.State("ban")]</option>
				"}
			. += {"			</select>
						</td>
					</tr><tr>
						<th>Admin:</th>
						<td><input type="text" name="admin" value="[W.admin]" [master.rank != "Developer" && master.rank != "Council" && master.rank != "Head Moderator" ? "disabled":] /></td>
					</tr>"}
			if(W.state != "note")
				. += {"
					</tr><tr>
						<th>Expiration Date:</th>
						<td><input type="text" name="expire_date" /><br />(Current setting: [W.expiration_date ? time2text(W.expiration_date) : "forever"]; -1 = forever; in hours)</td>
					</tr><tr>
						<th>Expiration Rounds:</th>
						<td><input type="text" name="expire_rounds" /><br />(Current setting: [W.expiration_rounds ? W.expiration_rounds : "forever"]; -1 = forever)</td>"}
			. += {"</table>
			</div><div class="box">
				<h1>[W.state == "note" ? "Note" : "Reason"]</h1>
				<textarea name="reason">[W.reason]</textarea>
			</div>"}
			if(W.state != "note")
				. += {"<div class="box">
					<h1>Message (displayed to player)</h1>
					<textarea name="message">[W.message]</textarea>
				</div>"}
			. += {"
			<div class="box">
				<h1>Commands</h1>
				<input type="submit" value="[!W.state ? "Add" : "Modify"] [W.state == "note" ? "Note":"Punishment"]" [W.admin != usr.key && master.rank != "Developer" && master.rank != "Council" && master.rank != "Head Moderator" ? "disabled":] />
				<input type="reset" value="Reset Values" />
				<input type="button" value="Cancel" onclick="parent.location='byond://?src=\ref[src];cmd=cancel';" />
				<input type="button" value="Delete" onclick="if(confirm('Are you sure?')){parent.location='byond://?src=\ref[src];cmd=delete_punishment';}" [master.rank != "Developer" && master.rank != "Council" && master.rank != "Head Moderator" ? "disabled":] />
			</div></form>"}

			if(W.state)
				. += {"
				<div class="box">
					<h1>Comments</h1>"}
				for(var/player_post/post in W.posts)
					. += {"<div class=\"box\"><h1>[post.author]</h1>
					<p>[post.message]</p></div>"}
				. += {"
				<h1>Add Comment</h1>
				<form action="byond://" method="post">
					<input type="hidden" name="src" value="\ref[src]" />
					<input type="hidden" name="cmd" value="add_comment" />
					<textarea name="comment"></textarea>
					<input type="submit" value="Add Comment" />
				</form>
				</div>"}
		else if(show_all_punishments)
			. += {"<div class=\"box\">
				<h1>All Notes and Punishments</h1>
				<table class="table" width="571">
					<tr>
						<th>#ID</th>
						<th>Assigned to</th>
						<th>State</th>
						<th>Admin</th>
						<th>Posted on</th>
					</tr>"}
			var
				skipped = 0
				list/L = P.GetPunishments()
			for(var/player_punishment/N in L)
				if(!N.expired && N.date <= world.realtime + (7 DAYS))
					skipped = 1
					continue
				. += "<tr><td><a href=\"byond://?src=\ref[src];cmd=open_punishment;punishment=\ref[N]\">\ref[N]</a></td>\
				<td>[L[N]]</td><td>[N.State()]</td><td>[N.admin]</td><td>[time2text(N.date)]</td></tr>"
			. += "</table>[skipped ? "<a href=\"byond://?src=\ref[src];cmd=view_punishments\">View recent list...</a><br />":]"
			if(master.rank != "Support" && master.rank != "Spy") . += "<a href=\"byond://?src=\ref[src];cmd=add_punishment\">Add Punishment</a>"
		else
			. += {"<div class=\"box\">
				<h1>[P.name]</h1>
				<table>
					<tr>
						<th>Activity:</th>
						<td>[activity2text(P.activity)]</td>
					</tr><tr>
						<th>Medals:</th>
						<td>[P.medals ? "[P.medals.len] medal\s" : "No medals earned"].</td>
					</tr><tr>
						<th>Score:</th>
						<td>
							<table>
								<tr>
									<th>Deaths:</th>
									<td>[P.score_deaths]</td>
									<th>Taxes:</th>
									<td>[P.score_taxes]</td>
								</tr><tr>
									<th>Royal Blood:</th>
									<td>[P.score_royalblood]</td>
									<th>RP Points:</th>
									<td>[P.score_rppoints]</td>
								</tr>
							</table>
						</td>
					</tr><tr>
						<th>Associates:</th>
						<td>"}
			var/list/associates = P.GetAssociates()
			if(associates && associates.len > 1)
				for(var/player/X in associates)
					if(X == P) continue
					. += "<a href=\"byond://?src=\ref[src];cmd=open_record;record=\ref[X]\">[X.name]</a>; "
				. = copytext(., 1, length(.) - 1)
				if(master.rank == "Developer" || master.rank == "Council" || master.rank == "Head Moderator")
					. += "<br /><a href=\"byond://?src=\ref[src];cmd=disassociate\" onclick=\"return confirm('Are you sure?! This will remove all associations with other records from this record!');\">Disassociate this record</a>"
			else . += "<em>(none!)</em>"

			. += {"
					</tr><tr>
						<th>Class Ban:</th>
						<td>
							<a href="byond://?src=\ref[src];cmd=classban\">Manage list</a> ([P.class_id_ban ? P.class_id_ban.len : 0] entries)
						</td>
					</tr>
				</table>
				<br />"}
			if(P.watchers && (master.client.ckey in P.watchers))
				. += "You are watching this player. <a href=\"byond://?src=\ref[src];cmd=toggle_watch\">Stop watching.</a><br />"
			else
				. += "<a href=\"byond://?src=\ref[src];cmd=toggle_watch\">Start watching this player.</a><br />"
			. += {"<a href=\"byond://?src=\ref[src];cmd=cancel\">Close</a> this record.
			</div><div class=\"box\">
				<h1>Recent Notes and Punishments</h1>
				<table class="table" width="571">
					<tr>
						<th>#ID</th>
						<th>Assigned to</th>
						<th>State</th>
						<th>Admin</th>
						<th>Posted on</th>
					</tr>"}
			var
				skipped = 0
				list/L = P.GetPunishments()
			for(var/player_punishment/N in L)
				if(N.expired || N.date > world.realtime + (7 DAYS))
					skipped = 1
					continue
				. += "<tr><td><a href=\"byond://?src=\ref[src];cmd=open_punishment;punishment=\ref[N]\">\ref[N]</a></td>\
				<td>[L[N]]</td><td>[N.State()]</td><td>[N.admin]</td><td>[time2text(N.date)]</td></tr>"
			. += "</table>[skipped ? "<a href=\"byond://?src=\ref[src];cmd=view_punishments\">View full list...</a><br />":]"
			if(master.rank != "Support" && master.rank != "Spy") . += "<a href=\"byond://?src=\ref[src];cmd=add_punishment\">Add Punishment</a>"
			. += {"</div><div class=\"box\">
				<h1>Recent Activity</h1>
				<table width="571" class="table">
					<tr>
						<th width="30%">By whom?</th>
						<th width="70%">Action</th>
						[_OutputActionLog(limit = 15, type = "players", target = P.name)]
					</tr>
				</table>
				<a href="byond://?src=\ref[src];log_start=[max(1, log_start - 25)]">Back</a> &middot; <a href="byond://?src=\ref[src];log_start=[min(admin.admin_log.len, log_start + 25)]">Next</a>
			</div>"}
	else
		. += {"<div class=\"box\">
			<h1>[players_search == 2 ? "Listing Active Players" : (players_search == 1 ? "Listing All Players" : "Search[players_search ? " Results":]")]</h1>"}

		if(players_search == 1 || istext(players_search)) //list all
			var/done = 0
			for(var/player/P in global.admin.players)
				if(players_search == "warn" && !P.GetWarn("warn") && !P.GetWarn("moderated"))
					continue
				if(players_search == "mute" && !P.GetWarn("mute") && !P.GetWarn("ic_mute") && !P.GetWarn("ooc_mute"))
					continue
				if(players_search == "ban" && !P.GetWarn("ban"))
					continue
				. += "<a href=\"byond://?src=\ref[src];cmd=open_record;record=\ref[P]\">[P.name]</a>; "
				done = 1
			if(done) . = copytext(., 1, length(.) - 1)
			else . += "No records were found with the specified filter."
			. += "<br /><a href=\"byond://?src=\ref[src];cmd=search\">Back to search form</a>"
		else if(players_search == 2) //list online
			var/list/players = new/list()
			for(var/client/C) if(C.player) players += C.player
			. += _OutputPlayerTable(players)
			. += "<br /><a href=\"byond://?src=\ref[src];cmd=search\">Back to search form</a>"
		else if(players_search)
			var
				list/L = new/list()
				name = players_search[1]
				ip = players_search[2]
				status = players_search[3]
			for(var/player/P in global.admin.players)
				var/match = FALSE
				if(name && dd_hasprefix(P.name, name)) match = TRUE
				else if(ip && (ip in P.associates)) match = TRUE
				else if(status)
					if((status & 1) && P.GetWarn("note")) match = TRUE
					else if((status & 2) && P.GetWarn("warn")) match = TRUE
					else if((status & 4) && P.GetWarn("moderated")) match = TRUE
					else if((status & 8) && P.GetWarn("ic_mute")) match = TRUE
					else if((status & 16) && P.GetWarn("ooc_mute")) match = TRUE
					else if((status & 32) && P.GetWarn("mute")) match = TRUE
					else if((status & 64) && P.GetWarn("ban")) match = TRUE
				if(!match) continue
				L += P
			. += _OutputPlayerTable(L)
			. += "<a href=\"byond://?src=\ref[src];cmd=search\">Cancel Search</a>"
		else
			. += {"
			<form action="byond://" method="post">
				<input type="hidden" name="src" value="\ref[src]" />
				<input type="hidden" name="cmd" value="search" />
				<table>
					<tr>
						<th>Name:</th>
						<td><input type="text" name="name" maxlength="30" /></td>
					</tr><tr>
						<th>IP/ID:</th>
						<td><input type="text" name="ip" /></td>
					</tr><tr>
						<th>Status:</th>
						<td>
							<table>
								<tr>
									<td><input type="checkbox" name="status" value="1" /> Note</td>
									<td><input type="checkbox" name="status" value="2" /> Warned</td>
									<td><input type="checkbox" name="status" value="4" /> Moderated</td>
									<td><input type="checkbox" name="status" value="64" /> Banned</td>
								</tr><tr>
									<td><input type="checkbox" name="status" value="8" /> Muted (IC)</td>
									<td><input type="checkbox" name="status" value="16" /> Muted (OOC)</td>
									<td><input type="checkbox" name="status" value="32" /> Muted (Full)</td>
								</tr><tr>
								</tr><tr>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<input type="submit" value="Search" />
				<br /><a href="byond://?src=\ref[src];cmd=search;list_online=1">List online players</a>
			</form>"}
		. += "<br />[global.admin.players.len] player\s in the database."
		var
			int_players = 0
			admins = 0
		for(var/client/C)
			if(C.key)
				int_players++
				if(C.admin) admins++
		. += "<br />[int_players - admins] player\s</a> online; [admins] admin\s online for a total of [int_players] connected users."
		. += {"</div><div class=\"box\">
			<h1>Recent Activity</h1>
			<table width="571" class="table">
				<tr>
					<th width="30%">By whom?</th>
					<th width="70%">Action</th>
				</tr>[_OutputActionLog(limit = 25, type = "players")]
			</table>
			<a href="byond://?src=\ref[src];log_start=[max(1, log_start - 25)]">Back</a> &middot; <a href="byond://?src=\ref[src];log_start=[min(admin.admin_log.len, log_start + 25)]">Next</a>
		</div>"}