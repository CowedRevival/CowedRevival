item/armour
	icon = 'icons/mob.dmi'
	var
		overlay_pixel_x = 0
		overlay_pixel_y = 0
		hide_hair
	body
		icon_state = "peasant"
		suffix = ""
		Click()
			. = ..()
			if((src in usr.contents) && !usr.rolling && !usr.shackled && !usr.selectedSpellComponent)
				if(!usr.bequipped)
					usr.bequipped = src
					for(var/obj/O in usr.contents) O.checked = 0
				else if(usr.bequipped == src)
					usr.bequipped = null
					for(var/obj/O in usr.contents) O.checked = 0

				suffix = usr.bequipped == src ? "Equipped" : ""
				usr.UpdateClothing()
		unequip()
			var/mob/M = loc
			if(!istype(M) || M.bequipped != src) return
			if(M.bequipped == src) M.bequipped = null
			suffix = ""
			M.UpdateClothing()
		custom
			New()
				name = input("Choose a name") as text|null
				if (!name) del src
				icon = input("Select icon") as icon|null
				if (!icon) del src
				icon_state = input("Icon state") as text|null
				armour = (input("Armour") as num|null) || armour
		treksuit
			name = "Administrator's Uniform"
			icon_state = "trekcadet"
			armour = 20
			var/min_rank = 0
			Click()
				update()
				if((src in usr.contents) && !usr.rolling && !usr.shackled && !usr.selectedSpellComponent)
					if(!usr || !usr.client || !usr.client.admin)
						usr.show_message("<tt>You can't wear this! It's so out of fashion for you! And those colours, they don't really fit, now do they?</tt>")
						return
				. = ..()
			proc
				update()
					var/mob/M = loc
					if(!istype(M) || !M.client || !M.client.admin) return
					var/rank = M.client.admin.rank
					if(rank == "Developer") //admiral
						icon_state = "trekadmiral"
						min_rank = 8
					else if(rank == "Council") //captain
						icon_state = "trekcaptain"
						min_rank = 7
					else if(rank == "Head Moderator")
						icon_state = "trekcmdr"
						min_rank = 6
					else if(rank == "GM")
						icon_state = "trekltcmdr"
						min_rank = 5
					else if(rank == "Support")
						icon_state = "trekyellow"
						min_rank = 3
					else if(rank == "Spy")
						icon_state = "trekblue"
						min_rank = 2
					else
						icon_state = "trekcadet"
						min_rank = 0
					M.UpdateClothing()
		heavysuit
			name = "The Heavy's Suit"
			icon_state = "heavysuit"
		dwho
			name = "The Doctor's Suit"
			icon_state = "dwho"
		toga
			icon_state = "toga1"
			name = "Toga"
		tailor
			icon_state = "tailor"
			name = "Tailor cloths"
		pez_cloths
			icon_state = "peasant"
			name = "Peasant garments"
		woodcrafter_cloak
			icon_state = "woodcrafter"
			name = "Craftsman cloak"
			suffix = ""
		wood_torso
			armour = 5
			icon_state = "wood_plate"
			name = "Wood torso"
			suffix = ""
		hunter_cloths
			icon_state = "hunter_cloak"
			name = "Hunter cloths"
			suffix = ""
		gatherer_garb
			icon_state = "gatherer_garb"
			name = "Gatherer garb"
			suffix = ""
		farmer_cloths
			icon_state = "farmer"
			name = "Farmer cloths"
			suffix = ""
		cloak
			icon_state = "chef_cloak"
			suffix = ""
		tin_plate
			armour = 9
			icon_state = "tin_plate"
			name = "Tin plate"
			suffix = ""
		copper_plate
			armour = 10
			icon_state = "copper_plate"
			name = "Copper plate"
			suffix = ""
		tungsten_plate
			armour = 12
			icon_state = "tungsten_plate"
			suffix = ""
			name = "Tungsten plate"
		iron_plate
			armour = 11
			icon_state = "guard_plate"
			suffix = ""
			name = "Iron plate"
		silver_plate
			armour = 13
			icon_state = "silver_plate"
			suffix = ""
			name = "Silver plate"
		palladium_plate
			armour = 17
			icon_state = "palladium_plate"
			suffix = ""
			name = "Palladium plate"
		watchman_plate
			armour = 2
			icon_state = "watchman_plate"
			suffix = ""
			name = "Watchman plate"
		noble_guard_plate
			armour = 2
			icon_state = "nguard_plate"
			suffix = ""
			name = "Noble Guard plate"
		gold_guard_plate
			armour = 15
			icon_state = "rguard_plate"
			suffix = ""
			name = "Gold plate"
		mithril_plate
			armour = 16
			icon_state = "mithril_plate"
			suffix = ""
			name = "Mithril plate"
		magicite_plate
			armour = 18
			icon_state = "magicite_plate"
			suffix = ""
			name = "Magicite plate"
		adamantite_plate
			armour = 23
			icon_state = "adamantite_plate"
			suffix = ""
			name = "Adamantite plate"
		royal_armour
			armour = 23
			icon_state = "king_plate"
			suffix = ""
			name = "Royal Armour"
		noble_armour
			armour = 3
			icon_state = "nking_plate"
			suffix = ""
			name = "noble Armour"
		jester_cloths
			icon_state = "jester"
			suffix = ""
			name = "Jester cloth"
		njester_cloths
			icon_state = "njester"
			suffix = ""
			name = "Jester cloth"
		mage_cloths
			icon_state = "mage"
			suffix = ""
			name = "Wizard Robe"
		rmage_cloths
			icon_state = "rmage"
			suffix = ""
			name = "Red mage cloth"
		archer_cloths
			icon_state = "archer"
			suffix = ""
			name = "Archer suit"
		narcher_cloths
			icon_state = "narcher"
			suffix = ""
			name = "Archer suit"
		priest_cloths
			icon_state = "priest_cloak"
			suffix = ""
			name = "Priest robes"
		bishop_cloths
			icon_state = "bishop_cloak"
			suffix = ""
			name = "Bishop robes"
		mushroom_suit
			icon_state = "mushroom_suit"
			suffix = ""
			name = "Mushroom suit"
		mushroom_cloak
			icon_state = "mushroom_cloak"
			suffix = ""
			name = "Mushroom cape"
		zeth_cloths
			icon_state = "zeth"
			name = "Zeth cloths"
			suffix = ""
		tux
			icon_state = "tuxedo"
			name = "tuxedo"
			suffix = ""
		blacksmith_cloths
			icon_state = "blacksmith"
			name = "Blacksmith cloths"
			suffix = ""
		satanist_cloths
			icon_state = "satanist_suit"
			name = "Satanist Cloths"
			suffix = ""
		theif_suit
			icon_state = "theif_suit"
			name = "Theifs Cloths"
			suffix = ""
		iron_chainmail
			armour = 11
			icon_state = "guard_chainmail"
			name = "Guard Chainmail"
			suffix = ""
		watchman_chainmail
			armour = 2
			icon_state = "watchman_chainmail"
			name = "Watchman Chainmail"
			suffix = ""
		librarian_clothes
			icon_state = "librarian"
			name = "Librarian Clothes"
			suffix = ""
		pirate_garb
			icon_state = "pirate_garb"
			name = "Pirate Garb"
			suffix = ""
		miner_clothes
			icon_state = "miner"
			name = "Miner clothes"
			suffix = ""
		herald
			icon_state = "herald"
			name = "Herald clothes"
		ninja
			icon_state = "ninja"
			name = "Ninja clothes"
			armour = 1
		robot
			icon_state = "robot"
			armour = 3
			name = "Robot suit"
		shirts
			icon_state = "shirt-green"
			green
				icon_state = "shirt-green"
				name = "Green shirt"
			blue
				icon_state = "shirt-blue"
				name = "Blue shirt"
			red
				icon_state = "shirt-red"
				name = "Red shirt"
		leprechaun
			name = "Leprechaun costume"
			icon_state = "leprechaun"
		santa
			name = "Santa costume"
			icon_state = "santa"
		weddinggown
			name = "Wedding gown"
			icon_state = "weddinggown"
		doctor
			name = "Doctor's suit"
			icon_state = "doctor"
		greenisle_robe
			name = "Green Isle Robe"
			icon_state = "greenisle_robe"
		greenisle_toga
			name = "Green Isle Toga"
			icon_state = "greenisle_toga"
		grandmage_robe
			name = "Grandmage Robe"
			icon_state = "grandmage_robe"
		archduke_robe
			name = "Archduke Robe"
			icon_state = "archduke"
		narchduke_robe
			name = "Archduke Robe"
			icon_state = "narchduke"
		margrave
			name = "Margrave Armour"
			icon_state = "margrave"
			armour = 3
		baron
			name = "Baron cloths"
			icon_state = "baron"
		count
			name = "Count cloths"
			icon_state = "count"
		towncrier
			name = "Town Crier cloths"
			icon_state = "towncrier"
	face
		icon_state = "peasant_hat"
		Click()
			. = ..()
			if((src in usr.contents) && !usr.rolling && !usr.shackled && !usr.selectedSpellComponent)
				if(!usr.fequipped)
					usr.fequipped = src
					for(var/obj/O in usr.contents) O.checked = 0
				else if(usr.fequipped == src)
					usr.fequipped = null
					for(var/obj/O in usr.contents) O.checked = 0

				suffix = usr.fequipped == src ? "Equipped" : ""
				usr.UpdateClothing()
		unequip()
			var/mob/M = loc
			if(!istype(M) || M.fequipped != src) return
			if(M.fequipped == src) M.fequipped = null
			suffix = ""
			M.UpdateClothing()
		custom
			New()
				name = input("Choose a name") as text|null
				if (!name) del src
				icon = input("Select icon") as icon|null
				if (!icon) del src
				icon_state = input("Icon state") as text|null
				armour = (input("Armour") as num|null) || armour
		iron_helm
			armour = 6
			icon_state = "guard_helm"
			suffix = ""
			name = "Iron Helm"
			hide_hair = 1
		tungsten_helm
			armour = 8
			icon_state = "tungsten_helm"
			suffix = ""
			name = "Tungsten Helm"
			hide_hair = 1
		tin_helm
			armour = 4
			icon_state = "tin_helm"
			suffix = ""
			name = "Tin Helm"
		copper_helm
			armour = 5
			icon_state = "copper_helm"
			suffix = ""
			name = "Copper Helm"
		silver_helm
			armour = 10
			icon_state = "silver_helm"
			suffix = ""
			name = "Silver Helm"
			hide_hair = 1
		palladium_helm
			armour = 13
			icon_state = "palladium_helm"
			suffix = ""
			name = "Palladium Helm"
			hide_hair = 1
		mithril_helm
			armour = 12
			icon_state = "mithril_helm"
			suffix = ""
			name = "Mithril Helm"
			hide_hair = 1
		magicite_helm
			armour = 15
			icon_state = "magicite_helm"
			suffix = ""
			name = "Magicite Helm"
		adamantite_helm
			armour = 19
			icon_state = "adamantite_mask"
			suffix = ""
			name = "Adamantite Helm"
			hide_hair = 1
		watchman_helm
			armour = 1
			icon_state = "watchman_helm"
			suffix = ""
			name = "Watchman Helm"
			hide_hair = 1
		noble_guard_helm
			armour = 2
			icon_state = "nguard_helm"
			suffix = ""
			name = "Noble Guard Helm"
			hide_hair = 1
		gold_guard_helm
			armour = 10
			icon_state = "rguard_helm"
			suffix = ""
			name = "Gold Guard Helm"
			hide_hair = 1
		royal_mask
			armour = 19
			icon_state = "king_mask"
			suffix = ""
			name = "Royal Mask"
		noble_mask
			armour = 2
			icon_state = "nking_mask"
			suffix = ""
			name = "noble Mask"
		insane_mask
			icon_state = "insane_mask"
			name = "Insane mask"
			suffix = ""
		zeth_mask
			icon_state = "zeth_mask"
			name = "Zeth mask"
			suffix = ""
		satanist_mask
			icon_state = "satanist_head"
			name = "Satanist Head Mark"
			suffix = ""
		theif_mask
			icon_state = "thief_mask"
			name = "Theifs Mask"
			suffix = ""
		blacksmith_mask
			icon_state = "blacksmith_mask"
			name = "Blacksmith Mask"
			suffix = ""
		Jailer_mask
			icon_state = "jailer_mask"
			name = "Jailer Mask"
			suffix = ""
		nJailer_mask
			icon_state = "njailer_mask"
			name = "Jailer MaskN"
			suffix = ""
		librarian_glasses
			icon_state = "librarian_glasses"
			name = "Librarian Glasses"
			suffix = ""
		eyepatch
			icon_state = "eyepatch"
			name = "Eyepatch"
			suffix = ""
		visor
			icon_state = "visor"
			name = "Visor"
		greenisle
			icon_state = "greenisle_mask"
			name = "Green Isle Mask"
	hat
		icon_state = "peasant_hat"
		Click()
			. = ..()
			if((src in usr.contents) && !usr.rolling && !usr.shackled && !usr.selectedSpellComponent)
				if(!usr.hequipped)
					usr.hequipped = src
					for(var/obj/O in usr.contents) O.checked = 0
				else if(usr.hequipped == src)
					usr.hequipped = null
					for(var/obj/O in usr.contents) O.checked = 0

				suffix = usr.hequipped == src ? "Equipped" : ""
				usr.UpdateClothing()
		unequip()
			var/mob/M = loc
			if(!istype(M) || M.hequipped != src) return
			if(M.hequipped == src) M.hequipped = null
			suffix = ""
			M.UpdateClothing()
		custom
			New()
				name = input("Choose a name") as text|null
				if (!name) del src
				icon = input("Select icon") as icon|null
				if (!icon) del src
				icon_state = input("Icon state") as text|null
				armour = (input("Armour") as num|null) || armour
		pez_hat
			icon_state = "peasant_hat"
			name = "Peasant hat"
			suffix = ""
		farmer_hat
			icon_state = "farmer_hat"
			name = "farmer hat"
			suffix = ""
		hunter_headband
			icon_state = "hunter_headband"
			name = "hunter headband"
			suffix = ""
		fisherman_hat
			icon_state = "fisherman_hat"
			name = "fisherman hat"
			suffix = ""
		chef_hat
			icon_state = "chef_hat"
			suffix = ""
		iron_helm_top
			armour = 7
			icon_state = "guard_helm_top"
			name = "Iron Helm top"
			suffix = ""
		tungsten_helm_top
			armour = 8
			icon_state = "tungsten_helm_top"
			name = "Tungsten Helm top"
			suffix = ""
		tin_helm_top
			armour = 4
			icon_state = "tin_helm_top"
			name = "Tin Helm top"
			suffix = ""
		copper_helm_top
			armour = 5
			icon_state = "copper_helm_top"
			name = "Copper Helm top"
			suffix = ""
		silver_helm_top
			armour = 9
			icon_state = "silver_helm_top"
			name = "Silver Helm top"
			suffix = ""
		palladium_helm_top
			armour = 13
			icon_state = "palladium_helm_top"
			name = "Palladium Helm top"
			suffix = ""
		mithril_helm_top
			armour = 11
			icon_state = "mithril_helm_top"
			name = "Mithril Helm top"
			suffix = ""
		adamantite_helm_top
			armour = 19
			icon_state = "adamantite_crown"
			name = "Adamantite Crown"
			suffix = ""
		watchman_helm_top
			armour = 1
			icon_state = "watchman_helm_top"
			name = "Watchman Helm top"
			suffix = ""
		noble_guard_helm_top
			armour = 1.5
			icon_state = "nguard_helm_top"
			name = "Noble Guard Helm top"
			suffix = ""
		gold_guard_helm_top
			armour = 10
			icon_state = "rguard_helm_top"
			name = "Gold Guard Helm top"
			suffix = ""
		Royal_crown
			armour = 19
			icon_state = "crown"
			name = "Crown"
			suffix = ""
		noble_crown
			armour = 2
			icon_state = "ncrown"
			name = "Crown"
			suffix = ""
		jester_hat
			icon_state = "jester_hat"
			name = "Jester hat"
			suffix = ""
		njester_hat
			icon_state = "njester_hat"
			name = "Jester hat"
			suffix = ""
		mage_hat
			icon_state = "mage_hat"
			name = "Wizard Hat"
			suffix = ""
		rmage_hat
			icon_state = "rmage_hat"
			name = "Red mage hat"
			suffix = ""
		archer_hat
			icon_state = "archer_hat"
			name = "Archer hat"
			suffix = ""
		narcher_hat
			icon_state = "narcher_hat"
			name = "Archer hat"
			suffix = ""
		priest_hat
			icon_state = "priest_cap"
			name = "Priest hat"
			suffix = ""
		bishop_hat
			icon_state = "bishop_cap"
			name = "Bishop hat"
			suffix = ""
			overlay_pixel_y = 4
		mushroom_cap
			icon_state = "mushroom_cap"
			name = "Mushroom cap"
			armour = 12
			suffix = ""
		red_baseball_cap
			icon_state = "rbaseball_cap"
			name = "red baseball cap"
			suffix = ""
		top_hat
			icon_state = "top_hat"
			name = "top hat"
			suffix = ""
		wood_helmet
			armour = 5
			icon_state = "wood_helmet"
			name = "Wood helmet"
			suffix = ""
		pirate_hat
			icon_state = "pirate_hat"
			name = "Pirate Hat"
			suffix = ""
		doctor_hat
			icon_state = "doctor_hat"
			name = "Doctor Hat"
		leprechaun_hat
			icon_state = "leprechaun_hat"
			name = "Leprechaun Hat"
		archduke_hat
			name = "Archduke Hat"
			icon_state = "archduke_hat"
		narchduke_hat
			name = "Archduke Hat"
			icon_state = "narchduke_hat"
		margrave_hat
			name = "Margrave Hat"
			icon_state = "margrave_hat"
		towncrier_hat
			name = "Town Crier Hat"
			icon_state = "towncrier_hat"
	cloak
		Click()
			. = ..()
			if((src in usr.contents) && !usr.rolling && !usr.shackled && !usr.selectedSpellComponent)
				if(!usr.cequipped)
					usr.cequipped = src
					for(var/obj/O in usr.contents) O.checked = 0
				else if(usr.cequipped == src)
					usr.cequipped = null
					for(var/obj/O in usr.contents) O.checked = 0

				suffix = usr.cequipped == src ? "Equipped" : ""
				usr.UpdateClothing()
		unequip()
			var/mob/M = loc
			if(!istype(M) || M.cequipped != src) return
			if(M.cequipped == src) M.cequipped = null
			suffix = ""
			M.UpdateClothing()
		custom
			New()
				name = input("Choose a name") as text|null
				if (!name) del src
				icon = input("Select icon") as icon|null
				if (!icon) del src
				icon_state = input("Icon state") as text|null
				armour = (input("Armour") as num|null) || armour
		necro_cloths
			icon_state = "necromancer_cloak"
			suffix = ""
		healer_cloths
			icon_state = "healer_cloak"
			suffix = ""
			name = "Healer robes"
	hood
		Click()
			. = ..()
			if((src in usr.contents) && !usr.rolling && !usr.shackled)
				if(!usr.mequipped)
					usr.mequipped = src
					for(var/obj/O in usr.contents) O.checked = 0
				else if(usr.mequipped == src)
					usr.mequipped = null
					for(var/obj/O in usr.contents) O.checked = 0

				suffix = usr.mequipped == src ? "Equipped" : ""
				usr.UpdateClothing()
		unequip()
			var/mob/M = loc
			if(!istype(M) || M.mequipped != src) return
			if(M.mequipped == src) M.mequipped = null
			suffix = ""
			M.UpdateClothing()
		custom
			New()
				name = input("Choose a name") as text|null
				if (!name) del src
				icon = input("Select icon") as icon|null
				if (!icon) del src
				icon_state = input("Icon state") as text|null
				armour = (input("Armour") as num|null) || armour
		necro_hood
			icon_state = "necromancer_hood"
			suffix = ""
		healer_hood
			icon_state = "healer_hood"
			name = "Healer hood"
			suffix = ""
		dwho
			name = "The Doctor's Hood"
			icon_state = "dwho_hood"