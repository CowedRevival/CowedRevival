admin_viewpoint
	var
		atom/loc
		list/mobs
	proc
		receive(txt)
			if(ActionLock(txt, 10)) return
			send_message(mobs, txt, 1)

obj/admin/computer
	icon = 'icons/computers.dmi'
	density = 1
	anchored = 1
	holodeck
		icon = 'icons/Turfs.dmi'
		density = 1
		indicator
			icon_state = "holodeck1_1"
		indicator2
			icon_state = "holodeck2_1"
		computer
			icon_state = "holodeck1"
			attack_hand(mob/M)
				icon_state = icon_state == "holodeck0" ? "holodeck1" : "holodeck0"
				for(var/obj/admin/computer/holodeck/computer/O in world)
					O.icon_state = src.icon_state
				for(var/obj/admin/computer/holodeck/indicator/O in world)
					O.icon_state = icon_state == "holodeck0" ? "holodeck1_1" : "holodeck1_0"
				for(var/obj/admin/computer/holodeck/indicator2/O in world)
					O.icon_state = icon_state == "holodeck0" ? "holodeck2_1" : "holodeck2_0"
	viewscreen
		name = "Viewscreen Console"
		icon_state = "viewscreen"
		var
			list
				viewers
				viewports
		attack_hand(mob/M)
			if(!M || !M.client || !M.client.eye) return
			if(!viewers) viewers = new/list()
			M.using = src
			M.moveRelay = src
			viewers[M] = 0
			M.client.perspective = EYE_PERSPECTIVE
			icon_state = "viewscreen1"
			winshow(M, "admin/viewscreen")
			refresh(M, 1)
			//lstPlayers, lblViewPort, lblZ, btnVL, btnVR, btnZL, btnZR

		proc
			AdjustViewPort(id, turf/T)
				if(!viewports) viewports = new/list()
				var/mob/eavesdropper/M = viewports[id]
				if(!M) viewports[id] = new/mob/eavesdropper(T)
				else M.Move(T, forced = 1)
			Select(mob/T, mob/M)
				if(!M || !M.client) return
				M.client.eye = T
				if(viewers[M] > 0) AdjustViewPort(viewers[M], T)
				for(var/mob/N in range(1, src)) if(N.using == src) refresh(N)
			moveRelay(mob/M, newloc, newdir)
				if(!M || !M.client || !istype(M.client.eye, /atom)) return
				if(!newdir)
					if(!newloc) return
					newdir = get_dir(M, newloc)
				if(!newdir) return
				var/atom/A = M.client.eye
				A = get_step(A, newdir)
				if(A)
					M.client.eye = A
					if(viewers[M] > 0) AdjustViewPort(viewers[M], A)

					for(var/mob/N in range(1, src)) if(N.using == src) refresh(N)
			refresh(mob/M, refresh_mobs = 0)
				if(!M || !M.client) return
				var/list/L = list(
					"admin/viewscreen.on-close" = "byond://?src=\ref[src];cmd=close",
					"admin/viewscreen.lblViewPort.text" = viewers[M],
					"admin/viewscreen.lblZ.text" = istype(M.client.eye, /atom) ? M.client.eye:z : "N/A",
					"admin/viewscreen.btnVL.command" = "byond://?src=\ref[src];cmd=vl",
					"admin/viewscreen.btnVR.command" = "byond://?src=\ref[src];cmd=vr",
					"admin/viewscreen.btnZL.command" = "byond://?src=\ref[src];cmd=zl",
					"admin/viewscreen.btnZR.command" = "byond://?src=\ref[src];cmd=zr",
					"admin/viewscreen.btnRefresh.command" = "byond://?src=\ref[src];cmd=refresh",
					"admin/viewscreen.lblLoc.text" = istype(M.client.eye, /atom) && !ismob(M.client.eye) ? "[M.client.eye:x],[M.client.eye:y],[M.client.eye:z]" : "N/A"
				)
				if(refresh_mobs) L["admin/viewscreen.lstPlayers.cells"] = 0
				winset(M, null, list2params(L))

				if(refresh_mobs)
					var/i = 0
					for(var/mob/N in world)
						if(!N.key) continue
						M << output(N, "admin/viewscreen.lstPlayers:[++i]")

				if(viewers[M] > 0 && (viewports && viewports.len >= viewers[M]))
					var/atom/A = viewports[viewers[M]]
					M.client.eye = A
		Topic(href, href_list[])
			if(!usr || !usr.client || !(usr in range(1, src))) return
			switch(href_list["cmd"])
				if("close")
					usr.client.eye = usr
					usr.client.perspective = MOB_PERSPECTIVE
					usr.using = null
					usr.moveRelay = null
					viewers -= usr
					if(viewers.len <= 0)
						viewers = null
						icon_state = "viewscreen"
					winshow(usr, "admin/viewscreen", 0)
					return
				if("vl")
					var/viewport = viewers[usr]
					viewport--
					if(viewport <= 0) viewport = 0
					viewers[usr] = viewport
				if("vr")
					var/viewport = viewers[usr]
					viewport++
					if(viewport > 9) viewport = 9
					if(!viewports) viewports = new/list()
					if(viewports.len < viewport) viewports += new/mob/eavesdropper(usr.client.eye)

					viewers[usr] = viewport
				if("zl", "zr")
					var/atom/A = usr.client.eye
					if(!A) return
					A = locate(A.x, A.y, A.z - (href_list["cmd"] == "zl" ? 1 : -1))
					if(A)
						usr.client.eye = A
						if(viewers[usr] > 0) AdjustViewPort(viewers[usr], A)
				if("refresh")
					for(var/mob/M in range(1, src)) if(M.using == src) refresh(M, 1)
					return
			for(var/mob/M in range(1, src)) if(M.using == src) refresh(M)