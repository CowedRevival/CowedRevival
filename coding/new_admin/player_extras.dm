player_punishment
	var
		admin //administrator who originally made the punishment
		date //date the punishment was created
		state //state of the punishment (warn, moderated, ooc_mute, ic_mute, mute, ban)
		expired = 0
		expiration_date = -1
		expiration_rounds = -1
		reason
		message
		list/posts
		player/master
	proc
		State(state = src.state)
			switch(state)
				if("ooc_mute") return "Mute (OOC)"
				if("ic_mute") return "Mute (IC)"
				else return uppertext(copytext(state, 1, 2)) + copytext(state, 2)
		AutoExpire()
			if(expired || (expiration_date == -1 && expiration_rounds == -1)) return 1
			. = 0
			if(expiration_date != -1 && expiration_date < world.realtime) . = 1
			if(expiration_rounds != -1 && expiration_rounds <= 0) . = 1
			if(.)
				expired = 1
				global.admin.AddLog("DAEMON", "Expired [master.name]'s [state == "note" ? "note" : "punishment"] as per current expiration setting. (state = [State()])", "players", master.name)

player_post
	var
		author
		date
		message
	New(author, message)
		src.author = author
		src.message = message
		src.date = world.realtime