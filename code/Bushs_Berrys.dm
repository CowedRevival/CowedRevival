mob/var/poisoned=0
obj
	bush
		icon = 'icons/Bushs.dmi'
		icon_state = "empty"
		anchored=1
		var/berrytype
		var/buildinghealth = 3
		var/icon_state_base = "empty"
		DblClick()
			if(usr.CheckGhost() || usr.corpse || usr.shackled) return
			if(get_dist(src,usr) <= 1)
				if(buildinghealth >= 1)
					if(usr.inHand(/item/weapon/axe))
						if(buildinghealth >= 1)
							hearers(usr) <<"[usr] chops the [src]"
							buildinghealth-=1
						if(buildinghealth == 0)
							hearers(usr) <<"[usr] cuts the [src] down"
							del src
					else
						if(get_dist(src,usr)<=1)
							if(icon_state != "[current_season_state]empty")
								usr.show_message("You pick some berries")
								var/item/misc/new_berries/I = locate(berrytype) in usr
								if(I)
									I.stacked += rand(1,3)
									I.suffix = "x[I.stacked]"
								else
									usr.contents+=new src.berrytype
									var/item/misc/new_berries/J = locate(berrytype) in usr
									J.stacked += rand(0,2)
									J.suffix = "x[J.stacked]"
								var/icon_state_holder = icon_state_base
								icon_state_base = "empty"
								icon_state = "[current_season_state][icon_state_base]"
								spawn(1500)
									icon_state = "[current_season_state][icon_state_base]"
									icon_state_base = icon_state_holder
			..()
		New()
			. = ..()
			spawn
				var/berrymush=rand(0,5)
				if(berrymush==0)
					new/obj/bush/redbb(src.loc)
					del src
					return
				if(berrymush==1)
					new/obj/bush/bluebb(src.loc)
					del src
					return
				if(berrymush==2)
					new/obj/bush/yellowbb(src.loc)
					del src
					return
				if(berrymush==3)
					new/obj/bush/whitebb(src.loc)
					del src
					return
				if(berrymush==4)
					new/obj/bush/greenbb(src.loc)
					del src
					return
				if(prob(20))
					new/obj/bush/blackbb(src.loc)
					del src
					return

		var/berrys = 5

		redbb
			berrytype=/item/misc/new_berries/red
			name="Red Berry Bush"
			icon_state = "redbb"
			icon_state_base = "redbb"
			New()
				return
		bluebb
			berrytype=/item/misc/new_berries/blue
			name="Blue Berry Bush"
			icon_state = "bluebb"
			icon_state_base = "bluebb"
			New()
				return
		yellowbb
			berrytype=/item/misc/new_berries/yellow
			name="Yellow Berry Bush"
			icon_state = "yellowbb"
			icon_state_base = "yellowbb"
			New()
				return
		whitebb
			berrytype=/item/misc/new_berries/white
			name="White Berry Bush"
			icon_state = "whitebb"
			icon_state_base = "whitebb"
			New()
				return
		blackbb
			berrytype=/item/misc/new_berries/black
			name="Black Berry Bush"
			icon_state = "blackbb"
			icon_state_base = "blackbb"
			New()
				return
		greenbb
			berrytype=/item/misc/new_berries/green
			name="Green Berry Bush"
			icon_state = "greenbb"
			icon_state_base = "blackbb"
			New()
				return