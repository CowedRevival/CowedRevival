obj
	crop
		icon='icons/crops.dmi'
		var/length = 1000
		var/player_planted = 0
		corn
			icon_state="crop_growth_1"
			anchored = 1
			length = 800
			name = "corn plant"
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr)<=1)
					if(usr.inHand(/item/weapon/shovel))
						if(usr.movable==0)
							usr.movable=1
							hearers()<<"<small>[usr] starts to dig up the soil."
							sleep(20)
							hearers()<<"<small>[usr] digs up the soil."
							new/turf/path(locate(src.x,src.y,src.z))
							usr.movable=0
							del src
					else if(icon_state == "corn_growth_3")
						if(usr.CheckGhost() || usr.corpse) return
						icon_state = "corn_growth_2"
						var/farmer_yield = 0
						var/farmer_range = 3
						if(usr.skills.farming == 100)
							farmer_yield += 1
							farmer_range += 1
						if(usr.skills.farming >= 75)
							farmer_range += 1
						if(usr.skills.farming >= 50)
							farmer_yield += 1
						if(usr.skills.farming >= 25)
							farmer_range += 1
						var/item/misc/food/Corn/I = locate() in usr
						if(I)
							I.stacked += rand(1,farmer_range) + farmer_yield
							I.suffix = "x[I.stacked]"
						else
							usr.contents += new/item/misc/food/Corn
							var/item/misc/food/Corn/J = locate() in usr
							J.stacked += rand(0,(farmer_range - 1)) + farmer_yield
							J.suffix = "x[J.stacked]"
						spawn(length)
							if(!src) return
							icon_state = "corn_growth_3"
					..()
		watermelon
			icon_state="crop_growth_1"
			anchored = 1
			length = 1200
			name = "watermelon plant"
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr)<=1)
					if(usr.inHand(/item/weapon/shovel))
						if(usr.movable==0)
							usr.movable=1
							hearers()<<"<small>[usr] starts to dig up the soil."
							sleep(20)
							hearers()<<"<small>[usr] digs up the soil."
							new/turf/path(locate(src.x,src.y,src.z))
							usr.movable=0
							del src
					else if(icon_state == "wm_growth_3")
						if(usr.CheckGhost() || usr.corpse) return
						icon_state = "wm_growth_2"
						var/farmer_yield = 0
						var/farmer_range = 3
						if(usr.skills.farming == 100)
							farmer_yield += 1
							farmer_range += 1
						if(usr.skills.farming >= 75)
							farmer_range += 1
						if(usr.skills.farming >= 50)
							farmer_yield += 1
						if(usr.skills.farming >= 25)
							farmer_range += 1
						var/item/misc/food/Watermelon/I = locate() in usr
						if(I)
							I.stacked += rand(1,farmer_range) + farmer_yield
							I.suffix = "x[I.stacked]"
						else
							usr.contents += new/item/misc/food/Watermelon
							var/item/misc/food/Watermelon/J = locate() in usr
							J.stacked += rand(0,(farmer_range - 1)) + farmer_yield
							J.suffix = "x[J.stacked]"
						spawn(length)
							if(!src) return
							icon_state = "wm_growth_3"
					..()
		carrot
			icon_state="crop_growth_1"
			anchored = 1
			length = 900
			name = "carrot plant"
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr)<=1)
					if(usr.inHand(/item/weapon/shovel))
						if(usr.movable==0)
							usr.movable=1
							hearers()<<"<small>[usr] starts to dig up the soil."
							sleep(20)
							hearers()<<"<small>[usr] digs up the soil."
							new/turf/path(locate(src.x,src.y,src.z))
							usr.movable=0
							del src
					else if(icon_state == "carrot_growth_3")
						if(usr.CheckGhost() || usr.corpse) return
						var/farmer_yield = 0
						var/farmer_range = 3
						if(usr.skills.farming == 100)
							farmer_yield += 1
							farmer_range += 1
						if(usr.skills.farming >= 75)
							farmer_range += 1
						if(usr.skills.farming >= 50)
							farmer_yield += 1
						if(usr.skills.farming >= 25)
							farmer_range += 1
						var/item/misc/food/Carrot/I = locate() in usr
						if(I)
							I.stacked += rand(1,farmer_range) + farmer_yield
							I.suffix = "x[I.stacked]"
						else
							usr.contents += new/item/misc/food/Carrot
							var/item/misc/food/Carrot/J = locate() in usr
							J.stacked += rand(0,(farmer_range - 1)) + farmer_yield
							J.suffix = "x[J.stacked]"
						del src
					..()
		hemp
			icon_state="crop_growth_1"
			anchored = 1
			length = 10
			name = "hemp plant"
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr)<=1)
					if(usr.inHand(/item/weapon/shovel))
						if(usr.movable==0)
							usr.movable=1
							hearers()<<"<small>[usr] starts to dig up the soil."
							sleep(20)
							hearers()<<"<small>[usr] digs up the soil."
							new/turf/path(locate(src.x,src.y,src.z))
							usr.movable=0
							del src
					else if(icon_state == "hemp_growth_3")
						if(usr.CheckGhost() || usr.corpse) return
						var/item/misc/Hemp/I = locate() in usr
						if(I)
							I.stacked += rand(1,2)
							I.suffix = "x[I.stacked]"
						else
							usr.contents += new/item/misc/Hemp
							var/item/misc/Hemp/J = locate() in usr
							J.stacked += rand(0,1)
							J.suffix = "x[J.stacked]"
						del src
					..()
		potato
			icon_state="crop_growth_1"
			anchored = 1
			length = 600
			name = "potato plant"
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr)<=1)
					if(usr.inHand(/item/weapon/shovel))
						if(usr.movable==0)
							usr.movable=1
							hearers()<<"<small>[usr] starts to dig up the soil."
							sleep(20)
							hearers()<<"<small>[usr] digs up the soil."
							new/turf/path(locate(src.x,src.y,src.z))
							usr.movable=0
							del src
					else if(icon_state == "potato_growth_3")
						if(usr.CheckGhost() || usr.corpse) return
						var/farmer_yield = 0
						var/farmer_range = 3
						if(usr.skills.farming == 100)
							farmer_yield += 1
							farmer_range += 1
						if(usr.skills.farming >= 75)
							farmer_range += 1
						if(usr.skills.farming >= 50)
							farmer_yield += 1
						if(usr.skills.farming >= 25)
							farmer_range += 1
						var/item/misc/food/Potato/I = locate() in usr
						if(I)
							I.stacked += rand(1,farmer_range) + farmer_yield
							I.suffix = "x[I.stacked]"
						else
							usr.contents += new/item/misc/food/Potato
							var/item/misc/food/Potato/J = locate() in usr
							J.stacked += rand(0,(farmer_range - 1)) + farmer_yield
							J.suffix = "x[J.stacked]"
						del src
					..()
		tomato
			icon_state="crop_growth_1"
			anchored = 1
			length = 1200
			name = "tomato plant"
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr)<=1)
					if(usr.inHand(/item/weapon/shovel))
						if(usr.movable==0)
							usr.movable=1
							hearers()<<"<small>[usr] starts to dig up the soil."
							sleep(20)
							hearers()<<"<small>[usr] digs up the soil."
							new/turf/path(locate(src.x,src.y,src.z))
							usr.movable=0
							del src
					else if(icon_state == "tomato_growth_3")
						if(usr.CheckGhost() || usr.corpse) return
						icon_state = "tomato_growth_2"
						var/farmer_yield = 0
						var/farmer_range = 3
						if(usr.skills.farming == 100)
							farmer_yield += 1
							farmer_range += 1
						if(usr.skills.farming >= 75)
							farmer_range += 1
						if(usr.skills.farming >= 50)
							farmer_yield += 1
						if(usr.skills.farming >= 25)
							farmer_range += 1
						var/item/misc/food/Tomato/I = locate() in usr
						if(I)
							I.stacked += rand(1,farmer_range) + farmer_yield
							I.suffix = "x[I.stacked]"
						else
							usr.contents += new/item/misc/food/Tomato
							var/item/misc/food/Tomato/J = locate() in usr
							J.stacked += rand(0,(farmer_range - 1)) + farmer_yield
							J.suffix = "x[J.stacked]"
						spawn(length)
							if(!src) return
							icon_state = "tomato_growth_3"
					..()
		wheat
			icon_state="crop_growth_1"
			anchored = 1
			length = 1000
			name = "wheat plant"
			DblClick()
				if(usr.shackled==1) return
				if(get_dist(src,usr)<=1)
					if(usr.inHand(/item/weapon/shovel))
						if(usr.movable==0)
							usr.movable=1
							hearers()<<"<small>[usr] starts to dig up the soil."
							sleep(20)
							hearers()<<"<small>[usr] digs up the soil."
							new/turf/path(locate(src.x,src.y,src.z))
							usr.movable=0
							del src
					else if(icon_state == "wheat_growth_3")
						if(usr.CheckGhost() || usr.corpse) return
						icon_state = "wheat_growth_2"
						var/farmer_yield = 0
						var/farmer_range = 3
						if(usr.skills.farming == 100)
							farmer_yield += 1
							farmer_range += 1
						if(usr.skills.farming >= 75)
							farmer_range += 1
						if(usr.skills.farming >= 50)
							farmer_yield += 1
						if(usr.skills.farming >= 25)
							farmer_range += 1
						var/item/misc/food/Wheat/I = locate() in usr
						if(I)
							I.stacked += rand(1,farmer_range) + farmer_yield
							I.suffix = "x[I.stacked]"
						else
							usr.contents += new/item/misc/food/Wheat
							var/item/misc/food/Wheat/J = locate() in usr
							J.stacked += rand(0,(farmer_range)) + farmer_yield
							J.suffix = "x[J.stacked]"
						spawn(length)
							if(!src) return
							icon_state = "wheat_growth_3"
					..()