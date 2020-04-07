obj/tardis/main_console //main console; maintains all functions
	name = "TARDIS console"
	icon = null
	mouse_opacity = 0
	density = 1
	var
		const
			LOCK_DOOR = 1
			LOCK_VIEWER = 2
			LOCK_KNOWLEDGE = 4
			LOCK_COORDINATES = 8
			LOCK_DEMAT = 16
			LOCK_DOORL = 32
			LOCK_CLOAK = 64
			LOCK_CHAMELEON = 128
			LOCK_INTERCOM = 256
			LOCK_EXTVIEWER = 512
		lock_state = LOCK_VIEWER | LOCK_CHAMELEON | LOCK_CLOAK | LOCK_COORDINATES | LOCK_DEMAT
		mob/eavesdropper/eavesdropper
	proc
		moveRelay(mob/M, newloc, newdir)
			var/turf/T = get_step(master.destination, newdir)
			if(T)
				if(eavesdropper && eavesdropper.loc == master.destination) eavesdropper.loc = T
				master.destination = T
				update_popup(M)
				update()
		update()
			var/status = "defenses up; door [master.door == 1 ? "open" : (master.door == 0 ? "unlocked" : "locked")]"
			if(master.fused_coordinates) status += "; coordinates fused"
			if(master.intercom == 1) status += ";intercom (receive only)"
			else if(master.intercom == 2) status += ";intercom (duplex)"
			if(master.cloaked) status += "; cloak engaged"
			if(master.dematerialized == 2) status += "; dematerialization circuits active"
			else if(master.dematerialized) status += "; dimension stabilizers active"
			else status += "; dimensional bridge connected"

			var/list/L = list(
				"tardis.on-close" = "byond://?src=\ref[src];cmd=close",
				"tardis.lblSource.text" = (!master.loc || (master.x == master.VOID_X && master.y == master.VOID_Y && master.z == master.VOID_Z) ? "the void" : "[master.loc] ([master.loc.x],[master.loc.y],[master.loc.z])"),
				"tardis.lblDestination.text" = (master.destination ? "[master.destination] ([master.destination.x],[master.destination.y],[master.destination.z])" : "unspecified"),
				"tardis.lblLastDest.text" = (master.last_departed ? "[master.last_departed] ([master.last_departed.x],[master.last_departed.y],[master.last_departed.z])" : "unspecified"),
				"tardis.btnCoordinates.command" = "byond://?src=\ref[src];cmd=coordinates",
				"tardis.btnDematerialize.command" = "byond://?src=\ref[src];cmd=dematerialize",
				"tardis.btnFuse.command" = "byond://?src=\ref[src];cmd=fuse",
				"tardis.btnHADS.command" = "byond://?src=\ref[src];cmd=hads",
				"tardis.lblStatus.text" = status,
				"tardis.btnDoor.command" = "byond://?src=\ref[src];cmd=door",
				"tardis.btnDoorDeadlock.command" = "byond://?src=\ref[src];cmd=doord",
				"tardis.btnIntercom.command" = "byond://?src=\ref[src];cmd=intercom",
				"tardis.btnCloak.command" = "byond://?src=\ref[src];cmd=cloak",
				"tardis.btnKey.command" = "byond://?src=\ref[src];cmd=key",
				"tardis.btnViewCancel.command" = "byond://?src=\ref[src];cmd=viewc",
				"tardis.btnViewTarget.command" = "byond://?src=\ref[src];cmd=viewt",
				"tardis.btnViewExterior.command" = "byond://?src=\ref[src];cmd=viewe",
				"tardis.btnChameleon.command" = "byond://?src=\ref[src];cmd=chameleon",
				"tardis.btnChameleon.text" = "[master.chameleon]",
				"tardis.btnLock1.is-checked" = "[(lock_state & 1) ? "true":"false"]",
				"tardis.btnLock2.is-checked" = "[(lock_state & 2) ? "true":"false"]",
				"tardis.btnLock4.is-checked" = "[(lock_state & 4) ? "true":"false"]",
				"tardis.btnLock8.is-checked" = "[(lock_state & 8) ? "true":"false"]",
				"tardis.btnLock16.is-checked" = "[(lock_state & 16) ? "true":"false"]",
				"tardis.btnLock32.is-checked" = "[(lock_state & 32) ? "true":"false"]",
				"tardis.btnLock64.is-checked" = "[(lock_state & 64) ? "true":"false"]",
				"tardis.btnLock128.is-checked" = "[(lock_state & 128) ? "true":"false"]",
				"tardis.btnLock256.is-checked" = "[(lock_state & 256) ? "true":"false"]",
				"tardis.btnLock512.is-checked" = "[(lock_state & 512) ? "true":"false"]",
				"tardis.btnLock1.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=1",
				"tardis.btnLock2.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=2",
				"tardis.btnLock4.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=4",
				"tardis.btnLock8.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=8",
				"tardis.btnLock16.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=16",
				"tardis.btnLock32.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=32",
				"tardis.btnLock64.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=64",
				"tardis.btnLock128.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=128",
				"tardis.btnLock256.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=256",
				"tardis.btnLock512.command" = "byond://?src=\ref[src];cmd=toggle_lock;lock=512",
			)
			var/params = list2params(L)
			for(var/mob/M in range(1, src)) if(M.client && M.using == src) winset(M, null, params)
		update_popup(mob/M, refresh_mobs = 0)
			if(!M || !M.client) return
			M.moveRelay = src
			var/list/L = list(
				"tardis/popup.on-close" = "byond://?src=\ref[src];cmd=close_popup",
				"tardis/popup.txtCoordinates.text" = "",
				"tardis/popup.lblZ.text" = istype(M.client.eye, /atom) ? M.client.eye:z : "N/A",
				"tardis/popup.btnZL.command" = "byond://?src=\ref[src];cmd=zl",
				"tardis/popup.btnZR.command" = "byond://?src=\ref[src];cmd=zr",
				"tardis/popup.btnRefresh.command" = "byond://?src=\ref[src];cmd=refresh_popup",
				"tardis/popup.lblLoc.text" = istype(M.client.eye, /atom) && !ismob(M.client.eye) ? "[M.client.eye:x],[M.client.eye:y],[M.client.eye:z]" : "N/A"
			)
			if(refresh_mobs)
				L["tardis/popup.lstPlayers.cells"] = 0
				L["tardis/popup.lstLandmarks.cells"] = 0
			winset(M, null, list2params(L))

			if(refresh_mobs)
				var/i = 0
				for(var/mob/N in world)
					if(!N.key) continue
					M << output(N, "tardis/popup.lstPlayers:[++i]")

				i = 0
				for(var/obj/landmark/O in world)
					//if(O.z != worldz && O.z != undergroundz && O.z != skyz && O.z < start_z) continue
					M << O.image
					M << output(O, "tardis/popup.lstLandmarks:[++i]")
		Select(atom/O, mob/M)
			master.destination = get_turf(O)
			if(eavesdropper) eavesdropper.Move(master.destination, forced = 1)
			update_popup(M)
			update()
	attack_hand(mob/M)
		if(M.chosen != "timelord" && (lock_state & LOCK_KNOWLEDGE))
			M.show_message("<tt>The controls are too confusing for you, and you instinctively back away...</tt>")
			return
		M.using = src
		winshow(M, "tardis")
		update()
	Topic(href, href_list[])
		if(!(usr in range(1, src)) || usr.restrained() || usr.issleeping)
			if(usr.using == src) usr.using = null
			if(usr.moveRelay == src) usr.moveRelay = null
			winshow(usr, "tardis", 0)
			winshow(usr, "tardis/popup", 0)
			if(usr && usr.client)
				usr.client.eye = usr
				usr.client.perspective = MOB_PERSPECTIVE
				usr.client.images -= master.redX
				for(var/obj/landmark/L in world) usr.client.images -= L.image
			return
		switch(href_list["cmd"])
			if("coordinates")
				if(usr.chosen != "timelord" && (lock_state & LOCK_COORDINATES))
					alert(usr, "The controls do not seem to respond.")
					return
				if(master.fused_coordinates)
					master.destination = master.last_departed
					master.redX.loc = master.destination
				else
					winshow(usr, "tardis/popup", 1)
					update_popup(usr, 1)
					usr << master.redX
			if("refresh_popup") update_popup(usr, 1)
			if("dematerialize")
				if(usr.chosen != "timelord" && (lock_state & LOCK_DEMAT))
					alert(usr, "The controls do not seem to respond.")
					return
				if(master.dematerialized == 1) master.materialize()
				else if(master.dematerialized == 0) master.dematerialize()
				else
					alert(usr, "The controls do not seem to respond.")
					return
			if("fuse")
				if(usr.chosen != "timelord" && (lock_state & LOCK_COORDINATES))
					alert(usr, "The controls do not seem to respond.")
					return
				if(usr.chosen != "timelord")
					alert(usr, "The controls do not seem to respond.")
					return
				if(!master.last_departed)
					spawn alert(usr, "ERROR: Coordinates could not be fused.", "TARDIS Controls :: Error 71B")
					return
				master.fused_coordinates = TRUE
			if("hads")
				if(usr.chosen != "timelord" && (lock_state & LOCK_DEMAT))
					alert(usr, "The controls do not seem to respond.")
					return
				. = master.hads()
				if(!.)
					alert(usr, "Invalid coordinates supplied!")
					return
				if(. == -1)
					alert(usr, "Still recharging power from the last use. Please try later!")
					return
			if("door")
				if(usr.chosen != "timelord" && (lock_state & LOCK_DOOR))
					alert(usr, "The controls do not seem to respond.")
					return
				if(master.door == 1) master.close_door()
				else master.open_door()
			if("doord")
				if(usr.chosen != "timelord" && (lock_state & LOCK_DOORL))
					alert(usr, "The controls do not seem to respond.")
					return
				if(master.door == 1) master.close_door()
				master.door = -2
			if("intercom")
				if(usr.chosen != "timelord" && (lock_state & LOCK_INTERCOM))
					alert(usr, "The controls do not seem to respond.")
					return
				if(++master.intercom > 2) master.intercom = 0
			if("cloak")
				if(usr.chosen != "timelord" && (lock_state & LOCK_CLOAK))
					alert(usr, "The controls do not seem to respond.")
					return
				if(ActionLock("cloak", 20)) return
				master.cloaked = !master.cloaked
				master.updateicon()
				range(master) << sound('sounds/tardis/outsync.ogg', volume=50)
			if("key")
				if(usr.chosen != "timelord")
					alert(usr, "The controls do not seem to respond.")
					return
				new/item/misc/tardis_key(usr, master)
			if("close_popup")
				if(usr.moveRelay == src) usr.moveRelay = null
				if(usr && usr.client)
					usr.client.images -= master.redX
					for(var/obj/landmark/L in world) usr.client.images -= L.image
			if("close")
				if(usr.using == src) usr.using = null
				if(usr.moveRelay == src) usr.moveRelay = null
				winshow(usr, "tardis", 0)
				winshow(usr, "tardis/popup", 0)
				if(usr && usr.client)
					usr.client.eye = usr
					usr.client.perspective = MOB_PERSPECTIVE
					usr.client.images -= master.redX
					for(var/obj/landmark/L in world) usr.client.images -= L.image
			if("viewc")
				if(usr && usr.client)
					usr.client.eye = usr
					usr.client.perspective = MOB_PERSPECTIVE
			if("viewt")
				if(usr.chosen != "timelord" && (lock_state & LOCK_VIEWER))
					usr.client.eye = usr
					usr.client.perspective = MOB_PERSPECTIVE
					alert(usr, "The controls do not seem to respond.")
					return
				if(usr && usr.client && master.destination)
					usr.client.perspective = EYE_PERSPECTIVE
					if(!eavesdropper)
						eavesdropper = new(master.destination)
						master.redX.loc = eavesdropper
					eavesdropper.Move(master.destination, forced = 1)
					usr.client.eye = eavesdropper
			if("viewe")
				if(usr.chosen != "timelord" && (lock_state & LOCK_EXTVIEWER))
					usr.client.eye = usr
					usr.client.perspective = MOB_PERSPECTIVE
					alert(usr, "The controls do not seem to respond.")
					return
				if(usr && usr.client)
					usr.client.perspective = EYE_PERSPECTIVE
					usr.client.eye = master
			if("chameleon")
				if(usr.chosen != "timelord" && (lock_state & LOCK_CHAMELEON))
					alert(usr, "The controls do not seem to respond.")
					return
				if(++master.chameleon > 3) master.chameleon = 0
				switch(master.chameleon)
					if(1) master.name = "bookcase"
					if(2) master.name = "stone door"
					if(3) master.name = "wood door"
					else master.name = initial(master.name)
				master.updateicon()
			if("zl", "zr")
				if(usr.chosen != "timelord" && (lock_state & LOCK_COORDINATES))
					alert(usr, "The controls do not seem to respond.")
					return
				var/atom/A = master.destination
				if(!A) return
				A = locate(A.x, A.y, A.z - (href_list["cmd"] == "zl" ? 1 : -1))
				if(A)
					master.destination = A
					eavesdropper.Move(A, forced = 1)
				update_popup(usr)
			if("toggle_lock")
				if(usr.chosen != "timelord")
					alert(usr, "The controls do not seem to respond.")
					return
				var/i = text2num(href_list["lock"])
				lock_state ^= i
		src.update()
	verb
		tardis_input_coordinates(coords as text)
			set hidden = 1
			set src = range(1, usr)
			if(usr && usr.client) for(var/obj/landmark/L in world) usr.client.images -= L.image
			winshow(usr, "tardis/popup", 0)
			var
				pos = findtext(coords, ",")
				x
				y = loc.y
				z = (master.loc.z == 1 ? worldz : loc.z)
			if(pos)
				x = text2num(copytext(coords, 1, pos))
				coords = copytext(coords, pos + 1)
				pos = findtext(coords, ",")
				if(pos)
					y = text2num(copytext(coords, 1, pos))
					coords = copytext(coords, pos + 1)
					if(coords) z = text2num(copytext(coords, 1))
			if(!x || !y || !z)
				alert(usr, "Invalid coordinates supplied! (Must be in form of x,y,z)")
				return
			var/turf/T = locate(x, y, z)
			if(!T)
				alert(usr, "Invalid coordinates supplied! (Must be in form of x,y,z)")
				return
			master.destination = T
			src.update()