mob

	var
		issleeping=0
		HP = 100 //health
		MHP = 100 //max health
		SLEEP = 100  //mana
		MSLEEP = 100 // max mana
		HUNGER = 100  //mana
		MHUNGER = 100 // max mana
		THIRST = 100
		MTHIRST = 100

/*
obj/meters
	var/num = 0 // current unrounded icon_state number
	var/width // number of frames in your meter, if you have frames 0 = 30 then this is set to 30
	          // even though theres 31 frames.
	layer = MOB_LAYER+701
	meter1 // hud health meter, more frames, larger, and much better detail
		name = "HP"
		icon = 'icons/HPscreen.dmi'
		icon_state = "0"
		screen_loc = "2,17"
		width = 100
		Click()
			usr << "Health: [usr.HP]"

	hmeter1 // hud mana meter
		name = "hunger"
		icon = 'icons/screenhunger.dmi'
		icon_state = "0"
		screen_loc = "11,17"
		width = 100

	smeter1 // hud mana meter
		name = "Sleep"
		icon = 'icons/stuff_bar2.dmi'
		icon_state = "sleeping"
		screen_loc = "14,17"
		width = 100
		Click()
			if(usr.icon_state == "ghost") return
			if(usr.issleeping==1 && usr.rolling==0)
				usr.issleeping=0
				usr.icon_state="alive"
				for(var/obj/A in usr.my_overlays)
					if(usr.secondhand=="[A]")
						if(usr.icon_state=="dead")
							A.icon_state="alive"
						if(usr.icon_state=="alive")
							A.icon_state="dead"
						A.icon=A.L_ICON
						usr.overlays-=A
						A.icon_state="[usr.icon_state]"
						usr.overlays+=A
						A.icon=A.R_ICON
					else
						if(usr.icon_state=="dead")
							A.icon_state="alive"
						if(usr.icon_state=="alive")
							A.icon_state="dead"
						usr.overlays-=A
						A.icon_state="[usr.icon_state]"
						usr.overlays+=A
				return
			if(usr.issleeping==0 && usr.rolling==0)
				usr.issleeping=1
				usr.icon_state="dead"
				for(var/obj/A in usr.my_overlays)
					if(usr.secondhand=="[A]")
						if(usr.icon_state=="dead")
							A.icon_state="alive"
						if(usr.icon_state=="alive")
							A.icon_state="dead"
						A.icon=A.L_ICON
						usr.overlays-=A
						A.icon_state="[usr.icon_state]"
						usr.overlays+=A
						A.icon=A.R_ICON
						if(usr.icon_state=="dead")
							A.icon_state="alive"
						if(usr.icon_state=="alive")
							A.icon_state="dead"
					else
						if(usr.icon_state=="dead")
							A.icon_state="alive"
						if(usr.icon_state=="alive")
							A.icon_state="dead"
						usr.overlays-=A
						A.icon_state="[usr.icon_state]"
						usr.overlays+=A
						if(usr.icon_state=="dead")
							A.icon_state="alive"
						if(usr.icon_state=="alive")
							A.icon_state="dead"
				spawn for()
					sleep(10)
					usr.SLEEP+=1
					if(usr.SLEEP>=100)
						usr.SLEEP=100
					hud_main.UpdateHUD(usr)
					if(usr.issleeping==0)
						break



	proc/Update()// NOTE: this is the only part of the code made by Spuzzum, I would change it but I see no point in doing this.
				 // NOTE: it also has the original commenting from Spuzzum.
		if(num < 0) //if the meter is negative
			num = 0 //set it to zero
		else if(num > width) //if the meter is over 100%
			num = width //set it to 100%
		src.icon_state = "[round(src.num)]" // this sets the icon state of the meter to its rounded off number

mob

	proc/Update(mob/M as mob)
		if(client)
			for(var/obj/meters/meter1/N in client.screen)
				N.num = (src.HP/src.MHP)*N.width
				N.Update()
			for(var/obj/meters/hmeter1/MM in client.screen)
				MM.num = (src.HUNGER/src.MHUNGER)*MM.width
				MM.Update()
		//	for(var/obj/meters/smeter1/MM in client.screen)
		//		MM.num = (src.SLEEP/src.MSLEEP)*MM.width
			//	MM.Update()
*/