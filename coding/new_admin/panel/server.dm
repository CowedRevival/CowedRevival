admin_panel/UpdateScreen(screen)
	. = ..()
	if(screen != "server") return .
	. += {"<div class="box">
		<h1>Settings & Commands</h1>
		<table>
			<tr>
				<th>Game Time:</th>
				<td>
					<a href=\"byond://?src=\ref[src];cmd=month\">[Month]</a> &middot;
					<a href=\"byond://?src=\ref[src];cmd=day\">[Day]</a> &middot;
					<a href=\"byond://?src=\ref[src];cmd=hour\">[Hour]</a><br />
					(Month->Day->Hour; does NOT automatically update)
				</td>
			</tr><tr>
				<td>
					<input type="checkbox" onclick="parent.location='byond://?src=\ref[src];cmd=toggle_am';" [abandon_mob ? "checked ":][master.rank == "Spy" ? "disabled ":]/> Abandon Mob
				</td><td>
					<input type="checkbox" onclick="parent.location='byond://?src=\ref[src];cmd=toggle_infect';" [infection_mode ? "checked ":][master.rank == "Spy" ? "disabled ":]/> Infection Mode
				</td>
			</tr><tr>
				<td>
					<input type="checkbox" onclick="parent.location='byond://?src=\ref[src];cmd=toggle_ooc';" [oocon ? "checked ":][master.rank == "Spy" ? "disabled ":]/> OOC Channel
				</td><td>
					<input type="checkbox" onclick="parent.location='byond://?src=\ref[src];cmd=toggle_vote';" [vote_system.vote_reboot ? "checked ":][master.rank == "Spy" ? "disabled ":]/> Reboot Vote
			</tr><tr>
				<td>
					<input type="checkbox" onclick="parent.location='byond://?src=\ref[src];cmd=toggle_help';" [adminhelp ? "checked ":][master.rank == "Spy" ? "disabled ":]/> Admin Help
				</td>
			</tr>
		</table>
		<input type="button" [!(global.admin.flags & global.admin.FLAG_REBOOTING) ? "onclick=\"if(confirm('Are you sure that you want to reboot the server?')){parent.location='byond://?src=\ref[src];cmd=reboot';}\"":"onclick=\"parent.location='byond://?src=\ref[src];cmd=reboot';\""] value="[global.admin.flags & global.admin.FLAG_REBOOTING ? "Abort Server ":]Reboot" [master.rank == "Spy" ? "disabled":] />
		<input type="button" [!(global.admin.flags & global.admin.FLAG_SHUTDOWN) ? "onclick=\"if(confirm('Are you sure that you want to shut the server down? This action can only be reversed if you have access to the machine this server resides on!')){parent.location='byond://?src=\ref[src];cmd=shutdown';}\"":"onclick=\"parent.location='byond://?src=\ref[src];cmd=shutdown';\""] value="[global.admin.flags & global.admin.FLAG_SHUTDOWN ? "Abort Shutdown":"Close Server"]" [master.rank != "Developer" ? "disabled":] />
	</div><div class="box">
		<h1>Player MOTD</h1>
		<form action="byond://" method="post">
			<input type="hidden" name="src" value="\ref[src]" />
			<input type="hidden" name="cmd" value="change_motd" />
			<textarea name="message">[file2text("motd.txt")]</textarea><br />
			<input type="submit" value="Change Player MOTD" [master.rank == "Spy" ? "disabled":] />
		</form>
	</div><div class="box">
		<h1>Admin MOTD</h1>
		<form action="byond://" method="post">
			<input type="hidden" name="src" value="\ref[src]" />
			<input type="hidden" name="cmd" value="change_amotd" />
			<textarea name="message">[file2text("motd_admin.txt")]</textarea><br />
			<input type="submit" value="Change Admin MOTD" [master.rank != "Developer" ? "disabled":] />
		</form>
	</div><div class="box">
		<h1>"Rules" Page</h1>
		<form action="byond://" method="post">
			<input type="hidden" name="src" value="\ref[src]" />
			<input type="hidden" name="cmd" value="change_rules" />
			<textarea name="message">[file2text("rules.htm")]</textarea><br />
			<input type="submit" value="Change Rules Page" [master.rank != "Developer" && master.rank != "Council" && master.rank != "Head Moderator" ? "disabled":] />
		</form>
	</div>"}
