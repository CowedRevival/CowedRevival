proc
	dir2text(direction)
		switch(direction)
			if(1) return "north"
			if(2) return "south"
			if(4) return "east"
			if(8) return "west"
			if(5) return "northeast"
			if(6) return "southeast"
			if(9) return "northwest"
			if(10) return "southwest"
	send_message(targets, msg, flag = 1|2)
		if(!msg) return
		var/mob/I = targets
		if(I && I.client && I.client.font_size) msg = "<font size=[I.client.font_size]>[msg]</font>"
		msg = censorText(msg)
		targets << msg
		if(flag & 1)
			targets << output(msg, "outputwindow/ic.output")
		if(flag & 2)
			targets << output(msg, "outputwindow/ooc.output")
	get_area(area/A)
		while(!istype(A, /area) && A) A = A.loc
		return A
	get_turf(turf/T)
		while(!istype(T, /turf) && T) T = T.loc
		return T
	MapLayer(z)
		var/map_object/O

		if(!MapObjectsByZ) MapObjectsByZ = new/list()
		if("[z]" in MapObjectsByZ) O = MapObjectsByZ["[z]"]
		else
			for(O in world) if(O.z == z) break
			if(O) MapObjectsByZ["[z]"] = O
		if(O) return O.map_layer
	MapObject(z)
		if(!MapObjectsByZ) MapObjectsByZ = new/list()
		if("[z]" in MapObjectsByZ) return MapObjectsByZ["[z]"]

		var/map_object/O
		for(O in world) if(O.z == z) break
		if(O)
			MapObjectsByZ["[z]"] = O
			return O
	MaxLayer(character_handling/container/kingdom)
		. = 0
		var/map_object/O
		for(O in world) if(O.kingdom == kingdom && O.map_layer > .) . = O.map_layer
	MinLayer(character_handling/container/kingdom)
		. = 0
		var/map_object/O
		for(O in world) if(O.kingdom == kingdom && O.map_layer < .) . = O.map_layer
	activity2text(activity, inactivity)
		if(activity == null) return "never"
		else if(activity == 0)
			return "online[!isnull(inactivity) ? (inactivity <= 100 ? " (active)" : " (inactive for [estimate_time(inactivity)])") : ""]"
		else return estimate_time(activity - world.realtime)
	solar_eclipse(timeout = rand(600, 1200))
		var/hour = Hour
		world << "<b>A solar eclipse suddenly appears.</b>"
		Hour = -1
		game.TimeLight()
		spawn(timeout)
			Hour = hour
			world << "<b>The solar eclipse has passed.</b>"
			game.TimeLight()
	play_sound(atom/source, list/recp, sound/S, volume = 100, falloff = 0)
		for(var/mob/M in recp)
			//if(!M.client || !M.client.player || !M.client.player.prefs || !(M.client.player.prefs.flags & M.client.player.prefs.FLAG_SOUND))
			//	continue
			_play_sound(source, M, S, volume, falloff)
	_play_sound(atom/source, mob/dest, sound/S, volume = 100, falloff = 0)
		if(source)
			var/in_falloff = (source in range(falloff, dest))
			S.x = in_falloff ? 0 : (source.x - dest.x)
			var
				y = in_falloff ? 0 : (source.y - dest.y)
				z = in_falloff ? 0 : (source.z - dest.z)
			S.y = (y + z) * 0.707106781187 //0.707106781187 = sqrt(2)
			S.z = (y - z) * 0.707106781187
			var
				occlusion = 0
				room_ratio = 1.5
				direct_level = 1
				obstruction = 0
				exclusion = 0
				turf/T = get_turf(source)
				door_test = 0
				area/A = get_area(dest)
				recursion = 100
			if(T && T != get_turf(dest))
				while(T && --recursion > 0)
					if(T.density)
						occlusion -= 2000
					var/obj/O
					for(O in T) if(O.density) break
					if(O)
						obstruction -= 2000
					for(O in T) if(O.density && !O.opacity) break
					if(O)
						room_ratio *= 0.5
						door_test = 1
					for(O in T) if(O.density && O.opacity) break
					if(O)
						exclusion -= 2000
					if(door_test && get_area(T) == A)
						room_ratio *= 0.5
						direct_level *= 0.75
					door_test = 0
					T = get_step(T, get_dir(T, dest))
					if(T == get_turf(dest)) break
			S.echo = list(0, 0, 0, 0, obstruction, 0, occlusion, 0, room_ratio, direct_level, exclusion ,0 , 0, 0, 0, 0, 0, 7)
		//if(istype(dest) && dest.client && dest.client.player && dest.client.player.prefs) S.volume = dest.client.player.prefs.sound_volume
		//else
		//S.volume = initial(S.volume)
		if(S.volume > volume) S.volume = volume
		if(istype(dest)) dest.PlaySound(S)
		else dest << S
	shellresult(cmd)
		var/tmpfile = "/tmp/test" + num2text(rand(100000)) + ".txt"
		shell("[cmd] > [tmpfile]")
		var/result = file2text(tmpfile)
		fdel(tmpfile)
		return result
	censorText(t)
		. = t
		if(!censorText) //stave it off... 1, 2, 3
			censorText = new/list()
			var/list/L = list(
				/*"asslicker" = "suck-up", "asskisser" = "suck-up", "anus" = "butt", "arse" = "butt", "arsehole" = "butt",
				"assfuck", "asshole", "bastard", "beaner", "bitchass", "bitch", "blowjob", "blow job",
				"boner", "bullshit", "cockass", "cockface", "cockhead", "cock", "cuntface", "cuntlicker", "cunthole",
				"motherfucker", "mothafucka", "motherfucking", "sandnigger", "sand nigger",
				"cunt", "faggot", " fag", " fag", "fatass", "fuckass", "fuckbag", "fuckboy", "fuckbrain", "fuckbutt", "fucker",
				"fucking", "fuck", "gaytard", "gaywad", "gaylord", "gay", "handjob", "homo", "jerk off", "jizz", "niggers",
				"nigger", "penis", "pussylicking", "queer", "shitass", "shitbag", "shitcunt", "shitdick", "shithead", "shit",
				"slutbag", "slut", "unclefucker", "vagina", "whorebag", "whoreface", "whore"*/
			) //"unclefucker" is more of an easter egg as I expect no-one to ever say that
			for(var/word in L)
				var/censored = ""
				if(L[word]) censored = L[word]
				else
					for(var/i = 1 to length(word))
						if(text2ascii(word, i) == 32) censored += " "
						else censored += "*"
				censorText[word] = censored

		for(var/word in censorText) . = replacetext(., word, censorText[word])

var/list/censorText