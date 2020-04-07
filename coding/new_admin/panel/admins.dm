admin_panel/UpdateScreen(screen)
	. = ..()
	if(screen != "admins") return .
	if(admins_record)
		var
			list/allowed_ranks = master.AllowedRanks()
			admin/A = admins_record
		. += {"<form action="byond://" method="post">
		<input type="hidden" name="src" value="\ref[src]" />
		<input type="hidden" name="cmd" value="modify_record" />
		<div class="box">
			<h1>[A.name]</h1>
			<table>
				<tr>
					<th>BYOND Key:</th>
					<td>
						<input type="text" name="key" value="[A.name]" />
					</td>
				</tr><tr>
					<th>Rank:</th>
					<td>
						<select name="rank">
							<option value="Developer" disabled[A.rank == "Developer" ? " selected":]>Developer</option>
							<option value="Council"[!("Council" in allowed_ranks) ? " disabled":][A.rank == "Council" ? " selected":]>Council</option>
							<option value="Head Moderator"[!("Head Moderator" in allowed_ranks) ? " disabled":][A.rank == "Head Moderator" ? " selected":]>Head Moderator</option>
							<option value="Moderator"[!("Moderator" in allowed_ranks) ? " disabled":][A.rank == "Moderator" ? " selected":]>Moderator</option>
							<option value="Administrator"[!("Administrator" in allowed_ranks) ? " disabled":][A.rank == "Administrator" ? " selected":]>Administrator</option>
							<option value="GM"[!("GM" in allowed_ranks) ? " disabled":][A.rank == "GM" ? " selected":]>GM</option>
							<option value="Support"[!("Support" in allowed_ranks) ? " disabled":][A.rank == "Support" ? " selected":]>Support</option>
							<option value="Spy"[!("Spy" in allowed_ranks) ? " disabled":][A.rank == "Spy" ? " selected":]>Spy</option>
						</select>
					</td>
				</tr>
			</table>
			<input type="submit" value="Save Changes" [!(A.rank in allowed_ranks) ? "disabled":] />
			<input type="button" value="Delete" onclick="if(confirm('Are you sure?')){parent.location='byond://?src=\ref[src];cmd=delete_record';}" [!(A.rank in allowed_ranks) ? "disabled":] />
		</div></form>"}
	. += {"<div class="box">
		<h1>Administrators</h1>
		<table class="table" width="571">
			<tr>
				<th>BYOND Key</th>
				<th>Activity</th>
				<th>Rank</th>
			</tr>"}
	for(var/ckey in global.admin.admins)
		var/admin/A = global.admin.admins[ckey]
		if(!A) continue
		. += "<tr><td><a href=\"byond://?src=\ref[src];cmd=open_record;record=\ref[A]\">[A.name]</a></td>\
		<td>[activity2text(A.activity, A.client ? A.client.inactivity : null)]</td><td>[A.rank]</td></tr>"
	. += "</table><br /><a href=\"byond://?src=\ref[src];cmd=new_record\">Create new record</a></div>"
