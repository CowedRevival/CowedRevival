player
	var
		name
		ckey
		list
			punishments
			associates
			alt_records
			watchers //list of ckeys of admins who are watching this player
		activity = null
		tmp
			client/client

		list
			paintings
			medals
			_medals //medals that still need to be awarded (but were given while the hub was down)
			recentNames
			class_id_ban
		score_deaths = 0
		score_royalblood = 0
		score_taxes = 0
		score_rppoints = 0

		tmp
			medal_apprentice = 0 //amount of spell books learnt from
			list/medal_king
		medal_woodcutter = 0 //amount of trees cut
		medal_chef = 0 //amount of food made
		medal_painter = 0 //amount of paintings produced
		music = 100 //play background music where applicable (volume)
		sounds = 100 //play sounds where applicable (volume)
		character_name
		gender
		family/family
	New(client/C)
		. = ..()
		if(C)
			name = C.key
			ckey = C.ckey
	proc
		Login(client/C)
			activity = 0
			client = C

			Reassociate()

			spawn
				for(var/medal in _medals)
					if(medal in medals)
						if(!isnull(world.SetMedal(medal, name))) _medals -= medal
					else
						if(!isnull(world.ClearMedal(medal, name))) _medals -= medal
				if(!_medals || !_medals.len) _medals = null

				if((ckey in developers) || (ckey in ScoreDenied()))
					world.SetScores(name, "")
		Logout()
			activity = world.realtime
			client = null

		CheckPunishments()
			if(!client || client.admin) return //administrators are immune to these effects
			var/player_punishment/P = GetWarn() //get most important punishment
			if(P)
				client.muted = 0
				switch(P.state)
					if("ban")
						send_message(client, "\red <b>You have been banned from Cowed.</b>", 3)
						if(P.message) send_message(client, "\red Message: [P.message]", 3)
						send_message(client, "\red Administrator in charge of your ban: [P.admin]", 3)
						if(client)
							client.verbose_logout = 0
							del client
					if("mute", "ic_mute", "ooc_mute")
						send_message(client, "\red <b>You have been[P.state != "mute" ? " partially":] muted.</b>", 3)
						if(P.message) send_message(client, "\red Message: [P.message]", 3)
						send_message(client, "\red Administrator in charge of your mute: [P.admin]", 3)
						switch(P.state)
							if("ic_mute") client.muted = 1
							if("ooc_mute") client.muted = 2
							if("mute") client.muted = 3
					if("moderated","warn")
						send_message(client, "\red <b>You have an official warning.</b>", 3)
						if(P.message) send_message(client, "\red Message: [P.message]", 3)
						if(P.state == "moderated") client.muted = -1
		Reassociate()
			set background = 1
			alt_records = new/list()
			if(!associates) associates = new/list()
			if(client)
				if(client.address && !(client.address in associates)) associates += client.address
				if(client.computer_id && !(client.computer_id in associates)) associates += client.computer_id
				if(client.ckey && !(client.ckey in associates)) associates += client.ckey

			for(var/player/P in global.admin.players)
				if(P == src) continue
				var/assoc
				for(assoc in src.associates)
					if(assoc in P.associates) break
				if(!assoc)
					for(assoc in P.associates)
						if(assoc in src.associates) break

				if(assoc)
					for(assoc in src.associates)
						if(!(assoc in P.associates)) P.associates += assoc
					for(assoc in P.associates)
						if(!(assoc in src.associates)) src.associates += assoc

					alt_records += P

			for(var/player/P in alt_records)
				P.alt_records = src.alt_records
		GetAssociates()
			if((ckey in developers) || (ckey in global.admin.admins))
				return list(src)
			if(!alt_records) Reassociate()
			var/list/L = list(src)
			if(alt_records) L += alt_records
			return L
			/*. = new/list()
			for(var/player/P in global.admin.players)
				if(P == src) . += P
				else
					if((P.ckey in developers) || (P.ckey in global.admin.admins)) continue
					for(var/assoc in src.associates)
						if(assoc in P.associates)
							. += P
							break*/
		GetPunishments()
			. = new/list()
			var/list/players = GetAssociates()
			for(var/player/P in players)
				for(var/player_punishment/N in P.punishments)
					if(!N.master) N.master = P
					.[N] = P

		Status()
			var/player_punishment/P = GetWarn()
			if(!P) return "Clean"
			return P.State()
		GetWarn(type)
			if(!type) //get the highest standing
				var/player_punishment/winner
				for(var/player_punishment/P in GetPunishments())
					if(!P.expired)
						if(!winner) winner = P
						else
							switch(P.state)
								if("ban")
									if(winner.state != "ban") winner = P
								if("mute")
									if(winner.state != "ban" && winner.state != "mute") winner = P
								if("ic_mute")
									if(winner.state != "ban" && winner.state != "mute" &&\
									   winner.state != "ic_mute" && winner.state != "ooc_mute") winner = P
								if("ooc_mute")
									if(winner.state != "ban" && winner.state != "mute" &&\
									   winner.state != "ic_mute" && winner.state != "ooc_mute") winner = P
								if("moderated")
									if(winner.state != "ban" && winner.state != "mute" &&\
									   winner.state != "ic_mute" && winner.state != "ooc_mute") winner = P
								if("warn")
									if(winner.state != "ban" && winner.state != "mute" &&\
									   winner.state != "ic_mute" && winner.state != "ooc_mute" && \
									   winner.state != "warn") winner = P
				return winner
			else
				//type = type2text(type)
				for(var/player_punishment/P in GetPunishments())
					if(P.state == type && !P.expired) return P
		type2text(type)
			switch(type)
				if(0) return "Clean"
				if(1) return "Warned"
				if(2) return "Moderated"
				if(3) return "Muted (IC)"
				if(4) return "Muted (OOC)"
				if(5) return "Muted"
				if(6) return "Banned"

		UpdateScore()
			//update scores
			//don't update if the world is shutting down, we're a developer or on the data/deny_score.txt list
			if(dta_shutdown) return
			if(score_deaths > 999999999999999) score_deaths = 999999999999999
			if(score_royalblood > 999999999999999) score_royalblood = 999999999999999
			if(score_taxes > 999999999999999) score_taxes = 999999999999999
			else if(score_taxes < 0) score_taxes = 0
			if(score_rppoints > 999999999999999) score_rppoints = 999999999999999

			if(!(ckey in developers) && !(ckey in ScoreDenied()))
				var/list/L = list(
					"Deaths" = score_deaths,
					"Royal Blood" = score_royalblood,
					"Taxes" = score_taxes,
					"RP Points" = score_rppoints
				)
				world.SetScores(name, list2params(L))

			if(client)
				var/mob/M = client.mob
				if(M) hud_main.UpdateHUD(M)
		AwardMedal(medal)
			if((ckey in MedalDenied()) || (medal in medals)) return 0 //already awarded
			//award it locally
			if(!medals) medals = new/list()
			medals += medal
			world << "\icon[icon('icons/icons.dmi', "medal")] <tt><font color=\"#4545CC\">Achievement unlocked! [name] has been awarded the <strong>[medal2text(medal)]</strong> medal.</font></tt>"

			if(isnull(world.SetMedal(medal, name)))
				if(!_medals) _medals = new/list()
				_medals += medal
		RemoveMedal(medal)
			if(!medals || !(medal in medals)) return 0 //not awarded
			medals -= medal
			if(!medals.len) medals = null
			world << "\icon[icon('icons/icons.dmi', "medal")] <tt><font color=\"#4545CC\">Achievement lost! [name]'s <strong>[medal2text(medal)]</strong> medal has been recinded!</font></tt>"

			if(isnull(world.ClearMedal(medal, name)))
				if(!_medals) _medals = new/list()
				_medals += medal
		ReportMedal(medal, additional) //called by game procs to report different actions happening
			switch(medal)
				if("apprentice")
					if(++medal_apprentice >= 5)
						AwardMedal("Apprentice")
				if("woodcutter")
					if(++medal_woodcutter >= 50000)
						AwardMedal("Woodcutter")
				if("chef")
					if(++medal_chef >= 20000)
						AwardMedal("Chef de cuisine")
				if("paint")
					if(++medal_painter >= 200)
						AwardMedal("Painter")
				if("king")
					if("Overthrown" in medals) return
					var
						item/I = additional
						list/types = list(
							/item/armour/hat/Royal_crown, /item/armour/hat/noble_crown,
							/item/armour/body/royal_armour, /item/armour/body/noble_armour,
							/item/armour/face/royal_mask, /item/armour/face/noble_mask
						)
					if(I && (I.type in types))
						if(!medal_king) medal_king = new/list()
						if(!(I.type in medal_king)) medal_king += I.type

					if(medal_king && medal_king.len >= 3)
						AwardMedal("Overthrown")