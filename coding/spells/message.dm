spell_component/message
	name = "Message"
	icon_state = "message"
	mana_cost = 20
	invoke(mob/M)
		if(!M.movable)
			var/nam = input(M, "Specify the name of the person you want to send a message to.", "Message") as text|null
			if(nam == null) return 1
			var/mob/T
			for(var/mob/N in world)
				if(N.name == nam)
					T = N
			if(!T)
				M.show_message("\blue You are unable to sense someone with that name.")
				return 1
			var/msg = input(M, "Specify the message you would like to send.", "Message") as text|null
			if(!msg) return 1
			if(length(msg) > 1200) msg = copytext(msg, 1, 1201)
			msg = html_encode(msg)

			if(!(master.flags & master.FLAG_SUPER))
				send_message(ohearers(M), "\blue [M.name] begins to cast a spell...", 1)
				M.show_message("\blue You begin to cast Message.")
				M.movable = 1
				sleep(100)
				M.movable = 0
			if(M.CheckAlive())
				send_message(ohearers(M), "\blue [M.name] casts <b>Message!</b>", 1)
				M.show_message("\blue You cast <b>Message!</b>. It might take a while until [T] receives it.")

				var/turf/L = locate(T.x,T.y,usr.z)
				var/distance = get_dist(usr, L)
				spawn(distance * 5)
					T.show_message("\blue <b>The Message spell of [M.name] reaches you:</b> [msg]")
					send_message(ohearers(T), "\blue <b>The Message spell of [M.name] has reached [T.name]:</b> [msg]", 1)
					chat_log << "\[[time2text(world.realtime, "DD.MM.YY hh:mm:ss")]\] [M] - [M.key] Magical Message ([T.key]): [msg]<br />"

spell/message
	name = "Message"
	components = newlist(/spell_component/message)
	flags = FLAG_SPELLBOOK | FLAG_MAGE