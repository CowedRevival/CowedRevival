obj/family/farnsworth
	icon = 'icons/families/farnsworth.dmi'
	controller
		name="Controls"
		icon = 'icons/families/farnsworth_controller.dmi'
		density = 1
		anchored = 1
		var
			item/misc/orbs/orb
			obj/family/farnsworth/invention/invention
		New()
			.=..()
			for(var/obj/family/farnsworth/invention/I in view(src))
				invention = I // Link up with something
				break
		MouseDropped(item/misc/orbs/I)
			if(istype(I) && !orb &&  (usr in range(1, src)) && !usr.restrained() && (I in usr.contents))
				I.Move(src, forced = 1)
				I.dropped(usr)
				orb = I
				UpdateIcon()
				return 1
			else return ..()
		attack_hand(mob/M)
			if(ActionLock("toggle", 40)) return
			play_sound(src, hearers(src), sound('sounds/chronojohn/lever.wav'))
			src.icon_state = "on"
			spawn(10) src.icon_state = ""
			if(!orb) return
			if(invention) invention.activate(M)
		verb
			remove_orb()
				set name = "Remove Orb"
				set src in view(usr, 1)
				if(orb)
					orb.Move(src.loc, forced = 1)
					orb = null
					UpdateIcon()


		proc/UpdateIcon()
			if(!orb)
				src.overlays = list()
			else
				src.overlays += icon('icons/families/farnsworth_controller.dmi',"orb-[orb.icon_state]")

	lights

		var
			id=0

		light
			name="electric light"
			icon_state="light1"
			density=0
			anchored=1
			layer = FLY_LAYER
			luminosity=6
			proc/toggle()
				if(luminosity)
					src.sd_SetLuminosity(0)
					src.icon_state="light0"
				else
					src.sd_SetLuminosity(6)
					src.icon_state="light1"
		lightswitch
			name="lightswitch"
			icon_state="lightswitch"
			density=0
			anchored=1
			layer = FLY_LAYER
			attack_hand(mob/M)
				if(ActionLock("toggle", 10)) return
				for(var/obj/family/farnsworth/lights/light/L in world)
					if(L.id == src.id)
						L.toggle()
				M<<"\blue <tt>You flick the lightswitch.</tt>"

	invention
		proc
			activate(mob/M)

		enchantrix
			name="Enchantrix"
			density = 1
			anchored = 1
			icon = 'icons/families/farnsworth_enchantrix.dmi'
			activate(mob/M)
				M<<"\blue <tt>You activate the Enchantrix!</tt>"
				play_sound(src, hearers(src), sound('sounds/chronojohn/electricity.ogg'))
				src.sd_SetLuminosity(6)
				flick("on",src)
				spawn(10) src.sd_SetLuminosity(0)
				Enchant_Firestones()
				Enchant_Waterstones()
				Enchant_Mob()
			MouseDropped(mob/M)
				if(istype(M) && (usr in range(1, src)) && !usr.restrained() && (M in range(1, src)))
					M.Move(src.loc, forced = 1)
					viewers(M)<<"[usr] places [M] on the [src]."
					return 1
				else return ..()
			proc
				Enchant_Firestones()
					var/item/misc/fire_stone
						A
						B
					for(var/item/misc/fire_stone/F in src.loc)
						if(!A)
							A = F
						else if(!B)
							B = F
							break
					if(!A || !B) return
					if(A.flags & A.FLAG_ENCHANTED || B.flags & B.FLAG_ENCHANTED) return
					A.flags |= A.FLAG_ENCHANTED
					B.flags |= B.FLAG_ENCHANTED
					A.id = ++A._id
					B.id = A.id

				Enchant_Waterstones()
					for(var/item/misc/waterstone_box/B in src.loc)
						if(!B.enchanted) B.enchant()
					var/item/misc/waterstone
						A
						B
					for(var/item/misc/waterstone/F in src.loc)
						if(!A && !F.enchanted)
							A = F
						else if(!B && !F.enchanted)
							B = F
							break
					if(!A || !B) return
					A.enchanted = 1
					B.enchanted = 1
					A.secondStone = B
					B.secondStone = A
					var/id = ++A.id
					A.name = "waterstone- '[id]'"
					B.name = "waterstone- '[id]'"

				Enchant_Mob()
					for(var/mob/M in src.loc)
						if(!M.isMonster && M.key && !M.ActionLock("spell_luminosity"))
							var/init = M.icon
							M.icon = 'icons/CowGlow.dmi'
							M.ActionLock("spell_luminosity",600)
							M<<"<tt>You develop a healthy glow...</tt>"
							spawn(600)
								if(M)
									M.icon = init
									M<<"<tt>Your glow fades away...</tt>"

		portal
			name="Portal Grabber"
			density = 1
			anchored = 1
			icon = 'icons/families/farnsworth_portal.dmi'
			layer = FLY_LAYER
			var
				on = 0
				obj/portal/portal
				obj/family/farnsworth/controller/controls
				count = 0
			New()
				.=..()
				controls = locate() in view(src)
				if(controls) controls.invention = src
			activate(mob/M)
				if(!on)
					M.show_message("\blue <tt>You activate the [src].</tt>")
					hearers(src) << sound(null, channel = 668)
					icon_state = "active"
					flick("activate", src)
					spawn Activate()
			proc
				Activate()
					on = 1
					sleep(25)
					if(portal) del portal

					var/list/L = list()
					for(var/obj/portal/P in world)
						if(P.z != 1)
							L += P
					if(L.len)
						//create portal
						var/obj/portal/Target = pick(L)
						portal = new(locate(src.x+1,src.y,src.z))
						portal.target = Target.loc
						portal.icon_state = "portala"
						portal.name = "artificial portal"
						src.icon_state = "found"
						play_sound(src, hearers(src), sound('sounds/sliders_timer.ogg', channel = 668))
						sleep(300)

						//remove the portal
						if(portal) del portal
					src.icon_state = ""
					src.on = 0

sadmin/verb
	goto_farnsworth()
		set category = "SAdmin"
		var/turf/T = locate(/obj/family/farnsworth/controller)
		if(!T) return
		T = T.loc
		usr.loc = T