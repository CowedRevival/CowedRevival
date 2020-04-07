item
	parent_type = /obj
	icon = 'icons/items.dmi'
	var
		armour = 1
		attackpow=1

		inv_type = 0 //0 = default, 1 = armour, 2 = weapons/tools, 3 = misc
		stacked = -1 //-1 = not stackable, >0 = amount of stacked items
		s_istate
	attack_hand(mob/M)
		if(istype(M, /mob/weregoat) || M.restrained()) return
		if(src in M.contents)
			CheckStacked(M)
			return
		if(src in range(1, M))
			getting()
			if(stacked >= 0) //stackable, so don't move unless this is the first item
				var/item/O = locate(src.type) in M.contents
				if(O) //we found an item, so add to it
					O.stacked += src.stacked
					O.suffix = "x[O.stacked]"
					src.Move(null, forced = 1)
					return
			src.Move(M)
			if(stacked > 1) name = initial(name)
	MouseDrop(over_object,src_location,over_location)
		suffix = "x[stacked]"
		if(usr.CheckGhost() || usr.corpse || usr.HP <= 0) return
		if(isturf(over_location) && get_dist(usr, over_location) <= 1)
			if(usr.isEquipped(src))
				usr.show_message("<tt>You can't drop the item while it's equipped!</tt>")
				return

			if(stacked >= 1)
				if(stacked > 1)
					var/amnt = input(usr, "How much would you like to drop? (Max: [stacked])", "Drop [name]") as null|num
					if(amnt == null) return
					amnt = round(amnt)
					if(amnt <= 0) amnt = 1
					if(amnt >= stacked) amnt = stacked
					if(amnt < stacked)
						var/item/I = new src.type(over_location)
						I.stacked = amnt
						I.name = "[initial(I.name)][I.stacked > 1 ? " (x[I.stacked])":]"
						I.dropped(usr)
						stacked -= amnt
						suffix = "x[stacked]"
						return
				if(stacked > 1) name = "[initial(name)] (x[stacked])"
				else name = initial(name)
			if(get_dist(src,over_location)<=1&&get_dist(usr,src)<=1&&get_dist(usr,over_location)<=1)
				Move(over_location)
				src.dropped(usr)
		else if(istype(over_object, /item) && get_dist(usr, over_object) <= 1)
			usr.CheckCraft(src, over_object)
		suffix = "x[stacked]"
	proc
		getting()
		dropped(mob/M)
		CheckStacked(mob/M)
			if(stacked >= 0) //just collect all the items
				for(var/item/I in M.contents)
					if(I != src && I.type == src.type && I.stacked >= 0)
						src.stacked += I.stacked
						I.Move(null, forced = 1)
				suffix = "x[stacked]"
		unequip()