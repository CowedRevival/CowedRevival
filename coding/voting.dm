var/vote_system/vote_system = new
vote_data
	var
		winner
		tie = 0 //1 if this was a tie
		list/tie_list
		aborted = 0
	New(winner, tie = 0, tie_list)
		if(!winner)
			aborted = 1
		else
			src.winner = winner
			src.tie = tie
			src.tie_list = tie_list
vote_system
	var
		question
		list
			answers
			results
		vote = 0 //if 1, a vote is already in progress
		default_answer = 0 //0 = H
		vote_reboot = TRUE
		reboot_vote = FALSE //if the vote is actually on
		reboot_time
		vote_timeout
		flags = 0
		const
			VOTING = 1
			ABORTING = 2
			REBOOT = 4
	proc
		Abort() flags |= 2
		Query(vote, list/answers, timeout = 300)
			set background = 1
			src.question = vote
			src.answers = answers
			src.results = new/list()
			src.vote = 1
			SendMessage(world)

			vote_timeout = timeout + world.timeofday

			timeout /= 10
			while(--timeout && !(flags & ABORTING))
				sleep(10)

			if(flags & ABORTING)
				flags = 0
				return new/vote_data()

			send_message(world, "<b>Voting has ended!</b>", 3)
			var/list/winners[src.answers.len]
			for(var/i = 1 to src.answers.len) winners[i] = 0

			for(var/ckey in results) winners[results[ckey]]++

			var/highest = 0
			for(var/i = 1 to winners.len) if(winners[i] > highest) highest = winners[i]

			var/winner
			for(var/i = 1 to winners.len)
				if(winners[i] >= highest)
					if(istype(winner, /list)) winner += i
					else if(winner) winner = list(winner, i)
					else winner = i

			src.vote = 0
			if(istype(winner, /list)) return new/vote_data(pick(winner), 1, winner)
			else return new/vote_data(winner)
		SendMessage(recp)
			if(!vote) return
			send_message(recp, "<center><b>A vote has been started! ([question])</b></center>", 3)
			send_message(recp, "<center>Click <a href=\"byond://?src=\ref[src];cmd=view\">here</a> to cast your vote.</center>", 3)
		/*Query(vote, list/Answers)
			if(src.vote) return
			if(Answers)
				src.vote = 3
				src.default_answer = 0
				src.question = vote
				src.answers = Answers
				src.results = new/list()
				SendMessage(world)
				spawn(300)
					src.vote = 0
					for(var/client/C)
						if(C.key) winshow(C, "votewindow", 0)
					var
						choice1 = 0
						choice2 = 0
						choice3 = 0
					for(var/ckey in results)
						if(results[ckey] == 1) choice1++
						else if(results[ckey] == 2) choice2++
						else if(results[ckey] == 3) choice3++

					if(choice1 == choice2 && choice2 == choice3)
						send_message(world, "Result: <b>Tie!</b>", 3)
						RandomizeMode(rand(1, 3), 0)
					else if(choice1 == choice3 && choice3 > choice2)
						send_message(world, "Result: <b>Tie between [lowertext(answers[1])] and [lowertext(answers[3])]!</b>", 3)
						RandomizeMode(pick(1, 3), 0)
					else if(choice2 == choice3 && choice3 > choice1)
						send_message(world, "Result: <b>Tie between [lowertext(answers[2])] and [lowertext(answers[3])]!</b>", 3)
						RandomizeMode(rand(2, 3) , 0)
					else if(choice1 == choice2 && choice2 > choice3)
						send_message(world, "Result: <b>Tie between [lowertext(answers[1])] and [lowertext(answers[2])]!</b>", 3)
						RandomizeMode(rand(1, 2), 0)
					else if(choice1 > choice2 && choice1 > choice3)
						send_message(world, "Result: <b>[answers[1]]</b>", 3)
					else if(choice2 > choice1 && choice2 > choice3)
						send_message(world, "Result: <b>[answers[2]]</b>", 3)
					else if(choice3 > choice1 && choice3 > choice2)
						send_message(world, "Result: <b>[answers[3]]</b>", 3)
					else
						send_message(world, "Result: <b>Unknown!</b>", 3)
						send_message(world, "By golly, the game has suddenly gotten very confused as what to do. I guess we'll just pick a random choice.", 3)
						RandomizeMode(rand(1, 3), 0)

					spawn Loop()
			else
				src.vote = vote
				switch(vote)
					if(1)
						question = "Which mode would you like to play?"
						answers = list("Peasant", "Normal", "Kingdoms")
						src.default_answer = 0
					if(2)
						question = "Would you like to reboot?"
						answers = list("Yes", "No", "Meh")
						default_answer = 3
				src.results = new/list()
				SendMessage(world)
				spawn(vote == 1 ? 200 : 300)
					src.vote = 0
					for(var/client/C)
						if(C.key) winshow(C, "votewindow", 0)
					if(vote == 1)
						var
							peasant = 0
							normal = 0
							kingdoms = 0
						for(var/ckey in results)
							if(results[ckey] == 1) peasant++
							else if(results[ckey] == 2) normal++
							else if(results[ckey] == 3) kingdoms++

						var/result
						if(peasant == normal && normal == kingdoms)
							send_message(world, "Result: <b>Tie!</b>", 3)
							result = RandomizeMode(rand(1, 3))
						else if(peasant == kingdoms && kingdoms > normal)
							send_message(world, "Result: <b>Tie between peasant and kingdoms!</b>", 3)
							result = RandomizeMode(pick(1, 3))
						else if(normal == kingdoms && kingdoms > peasant)
							send_message(world, "Result: <b>Tie between normal and kingdoms!</b>", 3)
							result = RandomizeMode(rand(2, 3))
						else if(peasant == normal && normal > kingdoms)
							send_message(world, "Result: <b>Tie between peasant and normal!</b>", 3)
							result = RandomizeMode(rand(1, 2))
						else if(peasant > normal && peasant > kingdoms)
							send_message(world, "Result: <b>Peasant</b>", 3)
							result = 1
						else if(normal > peasant && normal > kingdoms)
							send_message(world, "Result: <b>Normal</b>", 3)
							result = 2
						else if(kingdoms > peasant && kingdoms > normal)
							send_message(world, "Result: <b>Kingdoms</b>", 3)
							result = 3
						else
							send_message(world, "Result: <b>Unknown!</b>", 3)
							send_message(world, "By golly, the game has suddenly gotten very confused as what to do. I guess we'll pick a random mode.", 3)
							result = RandomizeMode(rand(1, 3))
						spawn(10)
							switch(result)
								if(1) gametype = "peasants"
								if(2) gametype = "normal"
								if(3) gametype = "kingdoms"
							spawn Loop()
					else
						var
							yes = 0
							no = 0
						for(var/ckey in results)
							if(results[ckey] == 1) yes++
							else if(results[ckey] == 2) no++

						if(no > yes)
							send_message(world, "Result: <b>No!</b>", 3)
							send_message(world, "Next reboot vote will be in 30 minutes.", 3)
						else if(yes > no)
							send_message(world, "Result: <b>Yes!</b>", 3)
							. = 1
						else
							send_message(world, "Result: <b>Tie!</b>", 3)
							send_message(world, "Throwing up a quarter...", 3)
							if(prob(50))
								. = 1
								send_message(world, "It's [pick("heads", "tails")]! The game has decided to <b>reboot</b>!", 3)
							else
								send_message(world, "It's [pick("heads", "tails")]! The game has decided <b>not</b> to reboot!", 3)

						if(.)
							send_message(world, "Reboot in 10 seconds.", 3)
							spawn(100)
								send_message(world, "Rebooting!", 3)
								world.Reboot()
						else
							spawn Loop()*/
	Topic(href, href_list[])
		if(!vote)
			usr << browse(null, "window=\ref[src]")
			return
		if(href_list["cmd"] == "vote" || href_list["cmd"] == "view")
			if(href_list["cmd"] == "vote")
				var/choice = text2num(href_list["choice"])
				if((usr.ckey in results) && results[usr.ckey] == choice) results -= usr.ckey
				else results[usr.ckey] = choice
				if(href_list["verbose"])
					/*if(istype(usr, /mob/character_handling))
						var/mob/character_handling/M = usr
						M.Display2()*/
					return
			. = {"
			<html>
				<head>
					<title>Voting Booth</title>
					<style>
						 body {
						 	font-family: Papyrus;
						 	font-size: 10pt;
						 	background-color: rgb(222, 213, 182);
						 	color: rgb(109, 64, 18);
						 }
						 input {
						 	background-color: rgb(222, 213, 182);
						 	color: rgb(109, 64, 18);
						 	margin-right: 8px;
						 	width: 100%;
						 	height: 24px;
						 	cursor: pointer;
						 }
						 input.selected {
						 	border-style: inset;
						 }
					</style>
				</head>
				<body>
					<p>[question]</p>
					<table width="100%">
						<tr><td>"}
			for(var/i = 1 to src.answers.len)
				. += "<input type=\"button\" value=\"[src.answers[i]]\" onclick=\"parent.location='byond://?src=\ref[src];cmd=vote;choice=[i]';\" [(usr.ckey in results) && results[usr.ckey] == i ? "class=\"selected\"" :] /></td>"
				if((i % 3) == 0)
					. += "</tr><tr>"
				. += "<td>"
			. += {"
					</table>
				</body>
			</html>"}
			usr << browse(., "window=\ref[src];size=600x256")