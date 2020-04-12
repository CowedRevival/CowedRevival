area
	var
		music
		music_volume = 75
		const
			FLAG_REPEAT = 1
			FLAG_STREAM = 2
		music_flags = FLAG_STREAM
	Entered(mob/M)
		if(ismob(M) && M.client && M.client.player)
			var/player/P = M.client.player
			if(!P || !P.music) return

			if(M.music && !src.music) M << sound(null, channel = 4)
			if(M.music != src.music)
				M.music = src.music
				if(src.music)
					var/sound/S = sound(music, volume = music_volume, channel = 4)
					if(music_flags & FLAG_STREAM) S.status |= SOUND_STREAM
					if(music_flags & FLAG_REPEAT) S.repeat = 1
					M.PlaySound(S)
		return ..()
	//sd_lighting = 0
	darkness
		name = " "
		sd_lighting = 1
		sd_outside = 1
		mouse_opacity = 0
		luminosity = 0
		underground
			sd_outside = 0
			sd_light_level = 0
			/*New(sd_lighting=0)
				. = ..()
				sd_LightLevel(0, 1)*/
		darkness2
		darkness3
		darkness4
		sky

		New()
			..()
			world << "FUG U"

	radiation
		name = " "
		sd_lighting = 1
		sd_outside = 1
		mouse_opacity = 0
		luminosity = 0

		var
			level = 3
		New()
			. = ..()
			spawn Loop()
		Entered(mob/M)
			. = ..()
			if(istype(M))
				M.show_message("<tt>You have entered a level [level + 1] radiation area.</tt>")
		Exited(mob/M)
			. = ..()
			if(istype(M))
				M.show_message("<tt>You have left the radiation area.</tt>")
		proc
			Loop()
				/*while(!undergroundz) sleep(5)
				if(undergroundz != src.z) return*/
				while(1)
					for(var/mob/M in contents)
						if(holodeck.safety && M.client && M.client.admin) continue
						if(M.chosen == "zeth" && prob(75)) continue
						switch(level)
							if(5) M.HP -= rand(15, 40)
							if(4) M.HP -= rand(12, 30)
							if(3) M.HP -= rand(7, 20)
							if(2) M.HP -= rand(4, 16)
							if(1) M.HP -= rand(2, 8)
							else M.HP -= rand(1, 3)
						M.checkdead(M)
						hud_main.UpdateHUD(M)
					sleep(50)
		edison
			sd_outside = 0
			sd_light_level = 0
	holodeck
		stuck
			Exit(mob/M)
				if(!istype(M) || (M.client && M.client.admin)) return ..()
				return 0
	school_of_magic
		music = 'sounds/music/magic_school.ogg'
		ghost_area
		ghost_area_2