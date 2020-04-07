family_member
	var
		name //name currently in use (or was last in use) by the member in question
		key //their BYOND key
		rank //which rank they've got
		is_invited = TRUE //false if the invitation was accepted
	New(player/P, family_rank/R)
		if(!P) return
		if(P.client && P.client.mob) name = P.client.mob.name
		else name = P.name
		key = P.name
		rank = R

family_rank
	var
		name
		access
	New(name)
		. = ..()
		if(name) src.name = name

family
	var
		name
		founder //BYOND key
		list
			members
			ranks
		level = 1
		family_rank/default_rank

		list
			contents
		spawn_location
		gold

		version = 1
	verb
		add_family_member(family/F in usr.GetFamilies(1), mob/M in view(usr))
			set category = "Family"
			if(!M.key) return
			if(!F.members) F.members = new/list()
			if(!(M.key in F.members)) F.members += M.key
			M.show_message("<tt>You are now a member of the [F.name] family.</tt>")
			usr.show_message("<tt>[M.key] is now a member of your family.</tt>")
		remove_family_member(family/F in usr.GetFamilies(1), var/key in F.members)
			set category = "Family"
			if(key == F.founder) return
			F.members -= key
			usr.show_message("<tt>[key] is no longer a member of your family.</tt>")
			for(var/client/C)
				if(C.key == key && C.mob)
					C.mob.show_message("<tt>You have been removed from the [name] family.</tt>")
					C.CheckFamily()
		list_family_members(family/F in usr.GetFamilies(0))
			set category = "Family"
			usr.show_message("<tt>The following keys are members of your family:</tt>")
			for(var/key in F.members)
				usr.show_message("\t <tt>[key][F.founder == key ? "*":]</tt>")
		show_family_gold(family/F in usr.GetFamilies(0))
			set category = "Family"
			usr.show_message("<tt>Your families' net worth (family: [F.name]) consists of [F.gold] gold (which equals [round(F.gold * 8)] copper).</tt>")
		set_family_gold(family/F in usr.GetFamilies(1), var/n as num)
			set category = "Family"
			if(alert(usr, "Are you sure that you want to change the value of gold for family [F.name] to [F.gold]?", "Confirm!", "No", "Yes") == "Yes")
				F.gold = n
				usr.show_message("<tt>Family [F.name] now has [F.gold] gold (which equals [round(F.gold * 8)] copper).</tt>")
/*	proc
		ShowPanel(mob/M)
			winshow(M, "family")
			var/list/L = list(
				"family.title" = "[src.name]",
				"family.btnGeneral.command" = "byond://?src=\ref[src];tab=general",
				"family.btnMembers.command" = "byond://?src=\ref[src];tab=members",
				"family.btnRanks.command" = "byond://?src=\ref[src];tab=ranks",
				"family.btnForum.command" = "byond://?src=\ref[src];tab=forum",
				"family.btnBuy.command" = "byond://?src=\ref[src];tab=shop"
			)
			winset(M, null, list2params(L))
			Display(M, "general")
		Display(mob/M, menu)
			. = {"
			<html>
				<head>
					<title></title>
					<link rel="stylesheet" type="text/css" href="cowed_style.css" />
					<style type="text/css">
						.info { width: 256px; border: 1px solid rgb(109, 64, 18); margin-top: 2px; }
						.info h1, .info p {
							text-align: center;
						}
						.info h1 {
							background-color: rgb(122, 113,82);
							margin: 0px;
							padding: 0px;
							border-bottom: 1px solid rgb(109, 64, 18);
							font-size: 12px;
						}
						.info p { margin: 0px; padding: 4px; }
					</style>
				</head>
				<body>"}
			switch(menu)
				if("general")
					var
						rp_points = 0
						online = 1
						total = 1
						inactive = 0
					. += {"<center>
						<div class="info">
							<h1>Family Name</h1>
							<p>[src.name]</p>
						</div><div class="info">
							<h1>Level</h1>
							<p>[src.level]</p>
						</div><div class="info">
							<h1>RP Points</h1>
							<p>[rp_points]</p>
						</div><div class="info">
							<h1>Founder</h1>
							<p>[founder]</p>
						</div><div class="info">
							<h1>Members \[online/total (inactive))\]</h1>
							<p>
								[online]/[total] ([inactive])
							</p>
						</div><div class="info">
							<h1>Location</h1>
							<p>unknown</p>
						</div>
					</center>"}
				if("members")
					if(ranks && ranks.len)
						. += {"
						<center>
							<div class="info style="width: 360px;"">
								<h1>Invite to family</h1>
								<p>
									<form action="byond://" method="post">
										<input type="hidden" name="src" value="\ref[src]" />
										<input type="hidden" name="action" value="invite_member" />
										BYOND Key: <input type="text" name="key" /> <input type="submit" value="Invite" />
									</form>
								</p>
							</div>
						</center>"}
					. += {"<table border="1">
						<tr>
							<th>Member</th>
							<th>Rank</th>
							<th>Activity</th>
							<th>Commands</th>
						</tr><tr>
							<td>[M.key]</td>
							<td>Founder</td>
							<td>online</td>
							<td><a href="#">Kick</a> &middot; <a href="#">Rank</a></td>
						</tr>
					</table>"}
				if("ranks")
					. += {"
					<div style="margin: 16px;">
						<form action="byond://" method="post">
							<input type="hidden" name="src" value="\ref[src]" />
							<input type="hidden" name="action" value="default_rank" />
							Default Rank: <select name="rank" onchange="this.form.submit();">"}
					for(var/family_rank/R in ranks)
						. += "<option value=\"\ref[R]\"[default_rank == R ? " selected":]>[R.name]</option>"
					. += "</select></form></div>"

					. += {"
						<div class="info style="float: right; width: 160px;"">
							<h1>Add Rank</h1>
							<p>
								<form action="byond://" method="post">
									<input type="hidden" name="src" value="\ref[src]" />
									<input type="hidden" name="action" value="add_rank" />
									Name: <input type="text" name="name" /> <input type="submit" value="Add" />
								</form>
							</p>
						</div>"}

					for(var/family_rank/R in ranks)
						. += {"<div>
							[R.name]
						</div>"}
					/*if(ranks && ranks.len)
					. += {"<table border="1">
						<tr>
							<th>Member</th>
							<th>Rank</th>
							<th>Activity</th>
							<th>Commands</th>
						</tr><tr>
							<td>[M.key]</td>
							<td>Founder</td>
							<td>online</td>
							<td><a href="#">Kick</a> &middot; <a href="#">Rank</a></td>
						</tr>
					</table>"}*/
			. += "</body></html>"
			M << browse(., "window=family.browser")
	Topic(href, href_list[])
		if("tab" in href_list)
			Display(usr, href_list["tab"])
			return
		switch(href_list["action"])
			if("invite")
				if(!ranks || !ranks.len) return
				var
					ckey = ckey(href_list["key"])
					player/P
				for(P in global.admin.players) if(ckey(P.name) == ckey) break
				if(P)
					var/family_member/M = new(P, default_rank)
					members += M

					Display(usr, "members")
			if("kick")
				var/family_member/M = locate("member")
				if(M in members)
					members -= M
					var/player/P
					for(P in global.admin.players)
						if(P.name == M.key) break
					if(P)
						if(P.client) send_message(P.client, "<i>You have been removed from the family [name]!</i>")
			if("add_rank")
				var/name = trimAll(href_list["name"])
				if(!name || name == " ") return
				ranks += new/family_rank(name)
				Display(usr, "ranks")*/