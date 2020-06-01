atom
	var
		building_owner //key of the person that built it; null (obviously) for non-owned objects
		cause //key of the usr at the time of creation; null for world boots of course.
	proc
		attack_hand(mob/M)
		hear(atom/A, data)
		MouseDropped(src_object, src_location, over_location, src_control, over_control, params)
		objExit(atom/movable/A) return 1
	
	//Actions for when the current atom is an argument for another atom's Bump call.
	//Arg: A - atom that bumps this atom
	proc/Bumped(atom/A)
		return

	New()
		. = ..()
		if (usr) cause = usr.key
	Click()
		if(usr.HP <= 0 || usr.restrained() || (usr.stunned + usr.weakened > 0) || usr.issleeping || usr.CheckGhost()) return
		if(usr.selectedSpellComponent)
			var/spell_component/S = usr.selectedSpellComponent
			usr.selectedSpellComponent = null
			if(S.canInvoke(usr)) S._invoke(usr, src)
		else
			if(!usr.restrained() && get_dist(usr, src) <= 1 && isturf(usr.loc)) attack_hand(usr)
			else
				var/turf/T = get_turf(src)
				if(!T) return ..()
				if((istype(usr.lhand, /item/weapon/bow) && !usr.rhand) || (istype(usr.rhand, /item/weapon/bow) && !usr.lhand))
					var/item/misc/quiver/quiver = locate() in usr.contents
					if(!quiver)
						usr.show_message("<tt>You need to have a quiver in your inventory to store arrows in!</tt>")
						return
					if(!quiver.contents || !quiver.contents.len)
						usr.show_message("<tt>You don't have any arrows in your quiver! Drag and drop the arrows to your quiver.</tt>")
						return
					var/item/misc/arrows/arrow = quiver.contents[1]
					if(arrow)
						if(--arrow.stacked <= 0) arrow.Move(null, forced = 1)
						quiver.CountArrows()

						if(usr.ActionLock("fire_arrow", 5)) return
						new/projectile/arrow(usr, T)
				else if(usr.inHand(/item/weapon/revolver))
					if(usr.ActionLock("fire_revolver", 5)) return
					var/item/weapon/revolver/I = usr.lhand
					if(!istype(I)) I = usr.rhand
					if(I.bullets <= 0)
						play_sound(usr, hearers(16, usr), sound(file='sounds/revolvere.wav'))
						usr.show_message("\red *click* *click*", 2)
						return
					var/mob/M
					for(M in src.contents) break

					play_sound(usr, hearers(16, usr), sound(file='sounds/revolver.ogg'))
					for(var/mob/N in hearers(usr))
						N.show_message("\red <b>[usr.name]</b> fires a revolver[!isturf(src) ? (isobj(src) ? "at the [lowertext(name)]" : " at [src.name]"):]!")
					I.bullets--
					new/projectile/bullet(usr, T)
		return ..()
	movable
		var
			anchored = 0 //if set, object can't be pushed/pulled
		MouseDrop(over_object,src_location,over_location)
			// from the Inventory panel to the map
			if(usr && usr.client && usr.client.admin && usr.client.admin.mouse_movement && isturf(src_location) && isturf(over_location))
				src.Move(over_location, forced = 1)
		Move(turf/newloc, newdir, forced = 0)
			var/turf/oldloc = loc	// remember for range calculations
			var/area/area1 = oldloc
			var/area/area2 = newloc
			while(area1 && !isarea(area1)) area1 = area1.loc
			while(area2 && !isarea(area2)) area2 = area2.loc

			// list turfs in view and luminosity range of old loc
			var/list/oldview
			if(isturf(loc))
				oldview = view(luminosity,loc)
			else
				oldview = list()

			if(forced)
				//if(area1 && area2 != area1) area1.Exited(src)
				//if(area2 && area1 != area2) area2.Entered(src)

				loc = newloc
				. = 1
			else
				if(newdir) dir = newdir

				// Move() ignores null destinations so bumping into edge of map has no effect
				if(!newloc) return 0

				if(loc && newloc && !newdir) dir = get_dir(loc, newloc)
				if(oldloc && !oldloc.Exit(src)) return 0

				var/atom/movable/A
				for(A in oldloc)
					if(A == src) continue
					if(!A.objExit(src)) return 0

				if(area1 && area1 != area2 && isturf(oldloc) && !area1.Exit(src)) return 0

				if(newloc && !newloc.Enter(src))
					if(newloc)
						A = newloc.GetObstructed()
						if(A) Bump(A)
					return 0
				if(area2 && area1 != area2 && isturf(newloc) && !area2.Enter(src))
					if(newloc)
						A = newloc.GetObstructed()
						if(A) Bump(A)
					return 0

				// if something else moved us already, abort
				if(loc != oldloc) return 0
				loc = newloc

				if(oldloc) oldloc.Exited(src)
				if(area1 && area1 != area2 && !isarea(oldloc))
					area1.Exited(src)

				. = 1

			if(.)
				if(luminosity > 0 && oldloc != loc) // if the atom moved and is luminous
					if(istype(oldloc))
						sd_StripLum(oldview,oldloc)
						oldloc.sd_lumcount++	// correct "off by 1" error in oldloc
					sd_ApplyLum()

				if(!forced)
					if(loc) loc.Entered(src, oldloc)
					if(area2 && area1 != area2 && !isarea(loc))
						area2.Entered(src, oldloc)

		Bump(atom/A)
			A.Bumped(src)
			..()
