var/king_amount = 1
var/duke_amount = 1
var/rguard_amount = 2
var/rarcher_amount = 2
var/key_smith_amount = 1
var/librarian_amount = 1
var/jailer_amount = 1
var/jester_amount = 1
var/chef_amount = 1
var/guard_amount = 5
var/bishop_amount = 1
var/priest_amount = 1
var/zeth_amount = 1
var/mage_amount = 1
var/necro_amount = 1
var/healer_amount = 1
var/smith_amount = 1
var/peasant_amount = -1

character_handling
	icon = 'icons/Classes.dmi'
	icon_state = "redx"
	parent_type = /obj
	var
		_x
		_y
		_z = 0
		class_id
		character_handling/container/parent
		image
			redx
			bluex
	New()
		. = ..()
		redx = image(icon = 'icons/Classes.dmi', loc = src, icon_state = "redx")
		bluex = image(icon = 'icons/Classes.dmi', loc = src, icon_state = "bluex")
	proc
		CanSelect(mob/character_handling/M)
			var/player/P = M.client.player
			if(P && P.class_id_ban && (src.class_id in P.class_id_ban)) return 0
			return 1
	container
		var
			list
				children //branches or classes
		New()
			. = ..()
			if(!children)
				children = new/list()
				var/list/base_types = typesof(src.type) - src.type
				for(var/type in base_types)
					base_types -= typesof(type)
					base_types += type
				for(var/type in base_types)
					children += new type

			for(var/character_handling/O in children) O.parent = src

			if(parent_type == /character_handling/container) //kingdom
				for(var/map_object/O in world)
					if(O.kingdom == src.type) O.kingdom = src
		Click(location, control, params)
			if(control == "admin/classban.grdKingdoms" || control == "admin/classban.grdBranches")
				var/admin/A = usr.client.admin
				if(!istype(A)) return //grr...

				params = params2list(params)
				if(params["right"])
					var/player/P = A.panel.players_record
					if(P)
						if(!P.class_id_ban) P.class_id_ban = new/list()
						if(src.class_id in P.class_id_ban)
							P.class_id_ban -= src.class_id
							if(!P.class_id_ban.len) P.class_id_ban = null
						else
							P.class_id_ban += src.class_id
				else
					if(parent_type == /character_handling/container)
						A.panel.classban_kingdom = src
					else
						A.panel.classban_branch = src
				A.panel.UpdateClassBanList()
				return
			var/mob/character_handling/M = usr
			if(!istype(M)) return
			var/player/P = M && M.client ? M.client.player : null
			if(!istype(P)) return
			if(src.class_id && P.class_id_ban && (src.class_id in P.class_id_ban))
				alert(M, "You have been banned from choosing this [parent_type == /character_handling/container ? "kingdom" : "branch"].")
				return
			if(parent_type == /character_handling/container) //kingdom
				M.kingdom = src
			else
				M.branch = src
			M.Display()
		bovinia
			name = "Bovinia"
			icon_state = "bovinia_king"
			desc = {"The Bovinia Kingdom has a strict hierachy whereby the King is in charge and his word is final.
The Belius is the religion of this kingdom, and all peasants must uphold it or become outcasts."}
			class_id = "bovinia"
			_x = 98
			_y = 107
			royalty
				name = "Royalty"
				desc = {"The Royals are in charge of the kingdom and are at the highest positions in the castle."}
				children = newlist(
					/character_handling/class/bovinia/king
				)
				class_id = "bovinia_royalty"
			royal_guard
				name = "The Royal Guard"
				desc = {"Royalty needs to be protected and this is the job of the guards. Their duties range from protecting
the village all the way to protecting the King."}
				icon_state = "bovinia_rguard"
				children = newlist(
					/character_handling/class/bovinia/royal_guard, /character_handling/class/bovinia/guard, /character_handling/class/bovinia/jailer,
				)
				class_id = "bovinia_rguard"
			royal_staff
				name = "The Royal Staff"
				desc = {"The castle doesn't maintain itself. The staff of the castle makes sure that everything is in tip-top
	shape and performs duties for the royals."}
				icon_state = "librarian"
				children = newlist(
					/character_handling/class/bovinia/cook, /character_handling/class/bovinia/treasurer
				)
				class_id = "bovinia_rstaff"
			/*religion
				name = "The Belius Church"
				desc = {"The Belius Church consists of a bishop in charge of the place and several priests."}
				icon_state = "priest"
				children = newlist(
					/character_handling/class/religion/priest
				)
				_x = 73
				_y = 120
				class_id = "bovinia_religion"*/
			peasants
				name = "Peasants"
				desc = {"Peasants are the people who grow up and live outside the castle. They have to fend for themselves,
	enjoying protection from the King while in his town."}
				icon_state = "peasant_labourer"
				children = newlist(
					/character_handling/class/peasants/labourer, /character_handling/class/peasants/craftsman,
					/character_handling/class/peasants/hunter, /character_handling/class/peasants/farmer,
					/character_handling/class/peasants/fisherman, /character_handling/class/peasants/tailor
				)
				class_id = "bovinia_peasant"
			special_class
				name = "Special Classes"
				desc = {"A couple of classics are listed here for your enjoyment."}
				icon_state = "zeth"
				children = newlist(
					/character_handling/class/special/priest, /character_handling/class/special/zeth,
					/character_handling/class/special/mage, /character_handling/class/special/alchemist,
					/character_handling/class/special/blacksmith, /character_handling/class/special/necromancer
				)
				class_id = "bovinia_special"
		peasants
			name = "Peasant"
			icon_state = "peasant_labourer"
			desc = {"Peasant"}
			class_id = "bovinia"
			peasants
				name = "Peasants"
				desc = {"Peasants are the people who grow up and live outside the castle. They have to fend for themselves,
			enjoying protection from the King while in his town."}
				icon_state = "peasant_labourer"
				children = newlist(
					/character_handling/class/peasants/labourer, /character_handling/class/peasants/craftsman,
					/character_handling/class/peasants/hunter, /character_handling/class/peasants/farmer,
					/character_handling/class/peasants/fisherman, /character_handling/class/peasants/tailor
				)
				class_id = "bovinia_peasant"

		null
			invisibility = 101
			icon_state = "blank"
		/*cowmalot
			name = "Cowmalot"
			icon_state = "cowmalot_king"
			desc = {"The Cowmalot Kingdom is a partially democratic kingdom after an uprising changed the local laws.
Although the King sits on the throne they act on behalf of the public and you'll often see votes held on all kinds of
decisions.
There is no set religion in Cowmalot allowing for freedom of religion.
Because the law is not set in stone and depends on public opinion, you'll want to avoid being an outcast in this small town."}*/
	class
		var
			amount
			kingdom //null = peasant
			list/modes //list of modes this class is in; null = all modes
			rp_points = null //minimum amount of RP points required to get this job; null to skip
			spawn_tag = "peasant spawn"
			image
				img_amount
		New()
			. = ..()
			AmountGet()
			if(amount != -1)
				img_amount = image(loc = src)
				UpdateAmount()
		proc
			UpdateAmount()
				img_amount.overlays = list()
				for(var/i = 1 to 15)
					overlays += image(icon = 'icons/screen_numbers.dmi', icon_state = "[copytext(num2text(round(amount),100),i,i+1)]", pixel_y = -16)
		Click(location, control, params)
			AmountGet()
			if(control == "admin/classban.grdClasses")
				var/admin/A = usr.client.admin
				if(!istype(A)) return //grr...

				params = params2list(params)
				if(params["right"])
					var/player/P = A.panel.players_record
					if(P)
						if(!P.class_id_ban) P.class_id_ban = new/list()
						if(src.class_id in P.class_id_ban)
							P.class_id_ban -= src.class_id
							if(!P.class_id_ban.len) P.class_id_ban = null
						else
							P.class_id_ban += src.class_id
				else
					alert(usr, "[isnull(rp_points) ? "No" : rp_points] points are required for this class.")
				A.panel.UpdateClassBanList()
				return

			var/mob/character_handling/M = usr
			if(!istype(M)) return
			var/player/P = M && M.client ? M.client.player : null
			if(!istype(P)) return
			if(src.class_id && P.class_id_ban && (src.class_id in P.class_id_ban))
				alert(M, "You have been banned from choosing this class.")
				spawn M.Display()
				return
			if(!isnull(rp_points) && rp_points > P.score_rppoints)
				alert(M, "You are not allowed to pick this class. You need at least [rp_points] RP Points.")
				spawn M.Display()
				return
			if(amount == 0)
				alert(M, "This class has already been taken.", "Class Selection")
				spawn M.Display()
				return
			M.class = src
			spawn M.Display()
		CanSelect(mob/character_handling/M)
			var/player/P = M.client.player
			if(P && P.class_id_ban && (src.class_id in P.class_id_ban)) return 0
			if(!isnull(rp_points) && rp_points > P.score_rppoints) return 0
			return 1
		proc
			Invoke(mob/character_handling/M)
				AmountGet()
				if(!istype(M, /mob/character_handling) || !M.client || !M.client.player) return
				var/player/P = M.client.player
				if(src.class_id && P.class_id_ban && (src.class_id in P.class_id_ban))
					alert(M, "You have been banned from choosing this class.")
					M.class = null
					M.Display()
					return
				if(!isnull(rp_points) && rp_points > P.score_rppoints)
					alert(M, "You are not allowed to pick this class. You need at least [rp_points] RP Points.")
					M.class = null
					M.Display()
					return
				if(!amount)
					alert(M, "This class has already been taken.", "Class Selection")
					M.class = null
					M.Display()
					return

				/*if(alert(M, src.desc, "Select Class?", "Yes", "No") == "Yes")
					if(!M.client || !istype(M, /mob/character_handling) || amount <= 0)
						alert(M, "Somebody chose this class before you got a chance to respond; or you're already in the game!")
						return*/

				var
					mob/N = new
					list
						startingtools = newlist(/item/weapon/axe, /item/weapon/shovel, /item/weapon/pickaxe,
						/item/weapon/sledgehammer, /item/weapon/hoe, /item/weapon/shears, /item/weapon/knife)
				N.name = M.name
				N.gender = M.gender
				N.kingdom = M.kingdom
				N.hair = M.hair_icon_state
				N.beard = M.beard_icon_state
				N.icon = M.char_1.icon
				N.sight = SEE_PIXELS
				. = Selected(N, M)
				if(.)

					N.shackled = 0
					N.movable = 0
					if(. == 2) N.contents += startingtools

					N.initial_net_worth = 0
					for(var/item/misc/gold/I in N) N.initial_net_worth += (I.stacked * 8)
					for(var/item/misc/copper_coin/I in N) N.initial_net_worth += I.stacked

					N.contents += new/item/misc/food/Corn
					N.contents += new/item/misc/food/Potato{stacked=3}
					N.contents += new/item/misc/food/Tomato{stacked=2}
					N.contents += new/item/misc/food/Meat

					N.see_invisible = 0
					N.UpdateClothing()

					if(!(M.name in names)) names += M.name
					if(gamemode == "Peasant" && spawn_tag == "peasant spawn") spawn_tag = "peasant mode spawn"
					var/turf/spawn_point = locate(spawn_tag)
					N.Move(locate(spawn_point.x, spawn_point.y, spawn_point.z), forced = 1)
					N.client = M.client
					AmountUpdate(-1)
					AmountGet()
					if(amount != -1)
						img_amount = image(loc = src)
						UpdateAmount()

			Selected(mob/M) return null

			AmountGet() return
			AmountUpdate(var/x as num)

		bovinia
			kingdom = "bovinia"
			modes = list("normal", "kingdoms")
			king
				icon_state = "bovinia_king"
				desc = "The King/Queen rules the land and is considered the one with the highest status. However, you must not seem too weak or you may be impeached. Would you like to become the King?"
				amount = 1
				class_id = "bovinia_royalty_king"
				spawn_tag = "king spawn"
				_x = 92
				_y = 180
				Selected(mob/M)
					M.chosen = "king"

					M.contents += new/item/armour/hat/Royal_crown(M)
					M.contents += new/item/armour/face/royal_mask(M)
					M.contents += new/item/armour/body/royal_armour(M)
					M.contents += new/item/misc/key/Guard_Key(M)
					M.contents += new/item/misc/key/Royal_Guard_Key(M)
					M.contents += new/item/misc/key/Cell_Door_Key(M)
					M.contents += new/item/misc/key/Royal_Room_Key(M)
					M.contents += new/item/misc/key/Treasurer_Key(M)
					M.contents += new/item/misc/key/Jailhouse_Key(M)
					M.contents += new/item/misc/key/Jailer_Key(M)
					M.contents += new/item/misc/key/BCM_Key(M)
					M.contents += new/item/weapon/excowlibur(M)

					M.contents += new/item/misc/gold{stacked=50}(M)
					M.score_Add("royalblood")
					return 1
				New()
					..()
					amount = king_amount
				AmountGet()
					amount = king_amount
				AmountUpdate(var/x as num)
					if(king_amount != -1)
						king_amount--
			treasurer
				icon_state = "librarian"
				desc = "The Archduke is the personal advisor of the king and directly below in the king in authority. They are wise people who tend to value knowledge, though some vow to use that knowledge to try to steal the throne..."
				amount = 1
				rp_points = -6
				class_id = "bovinia_royalty_archduke"
				spawn_tag = "librarian spawn"
				_x = 82
				_y = 172
				Selected(mob/M)
					M.chosen = "treasurer"

					M.contents += new/item/misc/key/BCM_Key(M)
					M.contents += new/item/misc/key/Treasurer_Key(M)
					M.contents += new/item/armour/face/librarian_glasses(M)
					M.contents += new/item/armour/body/librarian_clothes(M)
					M.contents += new/item/misc/book(M)
					M.contents += new/item/misc/paper(M)
					M.contents += new/item/misc/paper(M)
					M.contents += new/item/misc/paper(M)
					return 2

				New()
					..()
					amount = duke_amount
				AmountGet()
					amount = duke_amount
				AmountUpdate(var/x as num)
					if(duke_amount != -1)
						duke_amount--
			royal_guard
				icon_state = "bovinia_rguard"
				desc = "Royal Guards are the personal escorts of the King/Queen and orders come directly from that person. They have the authority to boss any of the royal staff around in the name of the King/Queen but must give their lives if the (s)he were in danger. Would you like to become a Royal Guard?"
				amount = 2
				rp_points = -7
				spawn_tag = "rguard spawn"
				class_id = "bovinia_rguard_rguard"
				_x = 92
				_y = 168
				Selected(mob/M)
					M.chosen = "royalguard"

					M.contents += new/item/misc/key/Guard_Key(M)
					M.contents += new/item/misc/key/Royal_Guard_Key(M)
					M.contents += new/item/misc/key/Cell_Door_Key(M)
					M.contents += new/item/misc/key/Royal_Room_Key(M)
					M.contents += new/item/misc/key/Jailhouse_Key(M)
					M.contents += new/item/misc/key/Jailer_Key(M)
					M.contents += new/item/misc/key/Royal_Archer_Key(M)

					M.contents += new/item/misc/gold{stacked=20}(M)
					return 1
				New()
					..()
					amount = rguard_amount
				AmountGet()
					amount = rguard_amount
				AmountUpdate(var/x as num)
					if(rguard_amount != -1)
						rguard_amount--
			royal_archer
				icon_state = "bovinia_rarcher"
				desc = "The Royal Archer is an extension to the Royal Guard but does not protect the King. Instead, the Royal Archer and Guards are on an equal basis in terms of power. Archers get a bow which makes them quite deadly especially from far away. Would you like to become a Royal Archer?"
				amount = 2
				rp_points = -7
				spawn_tag = "rarcher spawn"
				class_id = "bovinia_rguard_rarcher"
				_x = 96
				_y = 168
				Selected(mob/M)
					M.chosen = "archer"

					M.contents += new/item/misc/key/Guard_Key(M)
					M.contents += new/item/misc/key/Royal_Archer_Key(M)
					M.contents += new/item/misc/key/Royal_Room_Key(M)
					M.contents += new/item/misc/key/Jailhouse_Key(M)
					M.contents += new/item/misc/key/Jailer_Key(M)
					M.contents += new/item/misc/key/Cell_Door_Key(M)

					M.contents += new/item/misc/gold{stacked=20}(M)
					return 2
				New()
					..()
					amount = rarcher_amount
				AmountGet()
					amount = rarcher_amount
				AmountUpdate(var/x as num)
					if(rarcher_amount != -1)
						rarcher_amount--
			guard
				icon_state = "bovinia_guard"
				desc = "Guards patrol the kingdom and make sure that the village is safe. They are often seen guarding the bridge between the village and the castle. Would you like to become a guard?"
				amount = 5
				rp_points = -8
				spawn_tag = "guard spawn"
				class_id = "bovinia_rguard_guard"
				_x = 92
				_y = 135
				Selected(mob/M)
					M.chosen = "guard"
					M.contents += new/item/misc/key/Guard_Key(M)
					M.contents += new/item/misc/key/Cell_Door_Key(M)
					M.contents += new/item/misc/key/Jailer_Key(M)
					M.contents += new/item/misc/key/Jailhouse_Key(M)

					M.contents += new/item/misc/gold{stacked=5}(M)
					return 2
				New()
					..()
					amount = guard_amount
				AmountGet()
					amount = guard_amount
				AmountUpdate(var/x as num)
					if(guard_amount != -1)
						guard_amount--
			jailer
				icon_state = "bovinia_jailer"
				desc = "It is the job of the Jailer to make sure that prisoners remain in their cells. The Jailer also sees to torturing and (public) executions. In addition they have minor guard duties. Would you like to be the Jailer?"
				amount = 1
				rp_points = -8
				spawn_tag = "jailer spawn"
				class_id = "bovinia_rguard_jailer"
				_x = 103
				_y = 147
				Selected(mob/M)
					M.chosen = "jailer"

					M.contents += new/item/misc/key/Jailer_Key(M)
					M.contents += new/item/misc/key/Cell_Door_Key(M)
					M.contents += new/item/misc/key/Royal_Room_Key(M)
					M.contents += new/item/misc/key/Jailhouse_Key(M)

					M.contents += new/item/misc/gold{stacked=20}(M)
					return 1
				New()
					..()
					amount = jailer_amount
				AmountGet()
					amount = jailer_amount
				AmountUpdate(var/x as num)
					if(jailer_amount != -1)
						jailer_amount--
			/*librarian
				icon_state = "librarian"
				desc = "The librarian keeps the books and makes sure that history is properly recorded. They have an uncanny ability for determing the exact time that has passed on the sand clocks used to keep time. Would you like to become the librarian?"
				amount = 1
				rp_points = -12
				spawn_tag = "librarian spawn"
				class_id = "bovinia_rstaff_librarian"
				_x = 101
				_y = 173
				Selected(mob/M)
					M.chosen = "librarian"

					M.contents += new/item/armour/face/librarian_glasses(M)
					M.contents += new/item/armour/body/librarian_clothes(M)
					M.contents += new/item/misc/book(M)
					M.contents += new/item/misc/paper(M)
					M.contents += new/item/misc/paper(M)
					M.contents += new/item/misc/paper(M)
					return 2
				New()
					..()
					amount = librarian_amount
				AmountGet()
					amount = librarian_amount
				AmountUpdate(var/x as num)
					if(librarian_amount != -1)
						librarian_amount--*/
			keysmith
				icon_state = "keysmith"
				desc = "The Keysmith is the officially sanctioned locksmith of a kingdom. They start off with enough molten gold to produce several keys and have access to the castle key molds. Would you like to become the Keysmith?"
				amount = 1
				rp_points = -12
				spawn_tag = "keysmith spawn"
				class_id = "bovinia_rstaff_keysmith"
				_x = 109
				_y = 164
				Selected(mob/M)
					M.chosen = "keysmith"

					//M.contents += new/item/armour/face/librarian_glasses(M)
					M.contents += new/item/armour/body/blacksmith_cloths(M)
					M.contents += new/item/misc/key/Keysmith_Key(M)
					return 2
				New()
					..()
					amount = key_smith_amount
				AmountGet()
					amount = key_smith_amount
				AmountUpdate(var/x as num)
					if(key_smith_amount != -1)
						key_smith_amount--
			jester
				icon_state = "bovinia_jester"
				desc = "The court jester has only one job: entertain the king. However he or she sees fit to doing that job is their own business, but the one thing to keep in mind is that you don't want to make the king mad at you. Would you like to become the jester?"
				amount = 1
				rp_points = -12
				spawn_tag = "jester spawn"
				class_id = "bovinia_rstaff_jester"
				_x = 97
				_y = 172
				Selected(mob/M)
					M.chosen = "jester"

					M.contents += new/item/armour/hat/jester_hat(M)
					M.contents += new/item/armour/body/jester_cloths(M)

					return 2
				New()
					..()
					amount = jester_amount
				AmountGet()
					amount = jester_amount
				AmountUpdate(var/x as num)
					if(jester_amount != -1)
						jester_amount--
			cook
				icon_state = "cook"
				desc = "The cook is among the castle staff and has a very important job: to keep the staff and especially the king well-fed. The cook starts off with some food and their job is to get more so they can stuff the king. The cook is one of the kings' most trusted as food is easily poisoned... Would you like to become the Cook?"
				amount = 1
				rp_points = -12
				spawn_tag = "cook spawn"
				class_id = "bovinia_rstaff_cook"
				_x = 116
				_y = 165
				Selected(mob/M)
					M.chosen = "cook"

					M.contents += new/item/armour/hat/chef_hat(M)
					M.contents += new/item/armour/body/cloak(M)
					M.contents += new/item/misc/key/Cook(M)

					return 2
				New()
					..()
					amount = chef_amount
				AmountGet()
					amount = chef_amount
				AmountUpdate(var/x as num)
					if(chef_amount != -1)
						chef_amount--
		peasants
			craftsman
				icon_state = "peasant_woodworker"
				desc = "Craftsman have basic knowledge in smithing! Do you want to be a laborer?"
				amount = -1
				class_id = "peasant_craftsman"
				Selected(mob/M)
					M.chosen = "woodworker"
					M.contents += new/item/armour/body/woodcrafter_cloak(M)

					M.skills.smithing = 25
					M.skills.recycling = 35

					return 2
			labourer
				icon_state = "peasant_labourer"
				desc = "A laborer is well rounded in all areas of trade! Do you want to be a laborer?"
				amount = -1
				class_id = "peasant_labourer"
				Selected(mob/M)
					M.chosen = "labourer"
					M.skills.smithing = 10
					M.skills.mining = 20
					M.skills.recycling = 35
					M.contents += new/item/armour/hat/pez_hat(M)
					M.contents += new/item/armour/body/pez_cloths(M)
					return 2
			hunter
				icon_state = "peasant_hunter"
				desc = "Hunters can use their spear to kill animals in one strike, or use their traps to capture them!  Can also hide and wait for animals with their camouflage! Do you want to be a hunter?"
				amount = -1
				class_id = "peasant_hunter"
				Selected(mob/M)
					M.chosen = "hunter"
					M.contents += new/item/armour/hat/hunter_headband(M)
					M.contents += new/item/armour/body/hunter_cloths(M)
					M.contents += new/item/weapon/spear(M)
					M.skills.hunting = 55
					return 2
			farmer
				icon_state = "peasant_farmer"
				desc = "Whatever a farmer plants grows twice as fast and farmers till earth twice as fast too!  Starts out with 2 pigs! Do you want to be a farmer?"
				amount = -1
				class_id = "peasant_farmer"
				Selected(mob/M)
					M.chosen = "farmer"
					M.contents += new/item/armour/hat/farmer_hat(M)
					M.contents += new/item/armour/body/farmer_cloths(M)
					M.contents += new/item/armour/body/gatherer_garb(M)
					M.skills.farming = 55
					spawn(10) //wait for teleport
						for(var/i = 1 to 2)
							var/animal/pig/A = new(M.loc)
							A.master = M
							A.friends = new/list()
							A.friends += M
							A.order = A.ORDER_FOLLOW
					return 2
			fisherman
				icon_state = "peasant_fisherman"
				desc = "Fisherman have a dramatically easier time catching fish! Do you want to be a fisherman?"
				amount = -1
				class_id = "peasant_fisherman"
				Selected(mob/M)
					M.chosen = "fisherman"
					M.skills.fishing = 60
					M.contents += new/item/armour/hat/fisherman_hat(M)
					M.contents += new/item/armour/body/pez_cloths(M)
					M.contents += new/item/weapon/fishing_rod(M)
					return 2
			tailor
				icon_state = "peasant_tailor"
				desc = "Tailors are the only ones on the land capable of making clothes from wool or hide! Do you want to be a tailor?"
				amount = -1
				class_id = "peasant_tailor"
				Selected(mob/M)
					M.chosen = "tailor"
					M.contents += new/item/armour/body/tailor(M)
					M.contents += new/item/misc/wool{stacked=8}
					M.skills.tailoring = 50
					return 2
		special
			zeth
				icon_state = "zeth"
				desc = "Play your part as a travelling member of the near-extinct Zeth race. Would you like to pick this class?"
				amount = 1
				rp_points = -15
				class_id = "special_zeth"
				//spawn_tag = "zeth spawn"
				_x = 82
				_y = 86
				Selected(mob/M)
					M.chosen = "zeth"

					M.contents += new/item/armour/face/zeth_mask(M)
					M.contents += new/item/armour/body/zeth_cloths(M)
					M.contents += new/item/armour/hat/pez_hat(M)
					M.contents += new/item/armour/body/pez_cloths(M)

					M.learn_spell(/spell/zeth_teleport, 1)
					M.learn_spell(/spell/heal, 0)
					M.MHP += 25
					M.HP += 25
					return 2
				New()
					..()
					amount = zeth_amount
				AmountGet()
					amount = zeth_amount
				AmountUpdate(var/x as num)
					if(zeth_amount != -1)
						zeth_amount--
			blacksmith
				icon_state = "blacksmith"
				desc = "Play your part as the town blacksmith. Would you like to pick this class?"
				amount = 1
				class_id = "special_blacksmith"
				_x = 133
				_y = 152
				spawn_tag = "blacksmith spawn"
				Selected(mob/M)
					M.chosen = "blacksmith"

					M.contents += new/item/armour/face/blacksmith_mask(M)
					M.contents += new/item/armour/body/blacksmith_cloths(M)

					M.contents += new/item/misc/gold{stacked=30}(M)
					M.skills.recycling = 55
					M.skills.smithing = 75
					return 2
				New()
					..()
					amount = smith_amount
				AmountGet()
					amount = smith_amount
				AmountUpdate(var/x as num)
					if(smith_amount != -1)
						smith_amount--

			priest
				icon_state = "priest"
				desc = "The Priest makes sure that all villages understand one thing clearly: although there may be a king to rule over them, religion is also very important. The Priest is often seen doing ceremonies of all sorts. As the Priest, you wield the ability to be able to resurrect the recently deceased. Would you like to become the Priest?"
				amount = 1
				class_id = "special_priest"
				spawn_tag = "priest spawn"
				Selected(mob/M)
					M.chosen = "priest"

					M.contents += new/item/armour/hat/priest_hat(M)
					M.contents += new/item/armour/body/priest_cloths(M)
					M.contents += new/item/misc/books/Holy(M)
					//HOLDER

					return 2
				New()
					..()
					amount = priest_amount
				AmountGet()
					amount = priest_amount
				AmountUpdate(var/x as num)
					if(priest_amount != -1)
						priest_amount--

			necromancer
				icon_state = "necro"
				desc = "The Necromancer is fond of corpses, especially if the strings binding their souls have not yet been severed. As the Necromancer, you can create an army of the undead by reanimating dead tissue, but be careful of whose side you're on. Would you like to become the Necromancer?"
				amount = 1
				rp_points = -15
				class_id = "special_necro"
				//spawn_tag = "necro spawn"
				_x = 82
				_y = 135
				_z = -1
				Selected(mob/M)
					M.chosen = "necromancer"

					M.contents += new/item/armour/hood/necro_hood(M)
					M.contents += new/item/armour/cloak/necro_cloths(M)
					M.contents += new/item/misc/books/Necro(M)
					M.contents += new/item/misc/key/Necromancer(M)
					M.contents += new/item/armour/hat/pez_hat(M)
					M.contents += new/item/armour/body/pez_cloths(M)
					M.learn_spell(/spell/necromancer, 1)

					return 2
				New()
					..()
					amount = necro_amount
				AmountGet()
					amount = necro_amount
				AmountUpdate(var/x as num)
					if(necro_amount != -1)
						necro_amount--
			alchemist
				icon_state = "healer"
				desc = "Play your part as a healer that has recently set up a home in the peasant village of Bovinia. Would you like to pick this class?"
				amount = 1
				class_id = "special_healer"
				_x = 137
				_y = 83
				spawn_tag = "healer spawn"
				Selected(mob/M)
					M.chosen = "healer"

					M.contents += new/item/armour/hood/healer_hood(M)
					M.contents += new/item/armour/cloak/healer_cloths(M)
					M.contents += new/item/armour/body/doctor(M)
					M.contents += new/item/armour/hat/doctor_hat(M)
					//M.contents += new/item/misc/books/Healer(M)
					M.contents += new/item/armour/hat/pez_hat(M)
					M.contents += new/item/armour/body/pez_cloths(M)
					M.contents += new/item/misc/new_berries/glass_vial

					M.skills.medicine = 100
					M.skills.farming = 50

					return 2
				New()
					..()
					amount = healer_amount
				AmountGet()
					amount = healer_amount
				AmountUpdate(var/x as num)
					if(healer_amount != -1)
						healer_amount--
			mage
				icon_state = "bluemage"
				desc = "Play your part as a rare powerful wizard. Would you like to pick this class?"
				amount = 1
				rp_points = -15
				class_id = "special_mage"
				_x = 137
				_y = 113
				spawn_tag = "mage spawn"
				Selected(mob/M)
					M.chosen = "mage"
					M.contents += new/item/misc/spellbook/Empty_Spellbook
					M.make_wizard("Blue")
					M.contents += new/item/armour/hat/pez_hat(M)
					M.contents += new/item/armour/body/pez_cloths(M)
					M.contents += new/item/misc/excavation_tool/hand_pick/magicite_hand_pick
					M.contents += new/item/misc/excavation_tool/chisel/magicite_chisel
					M.contents += new/item/misc/excavation_tool/brush/magicite_brush
					M.skills.research = 100
					return 2
				New()
					..()
					amount = mage_amount
				AmountGet()
					amount = mage_amount
				AmountUpdate(var/x as num)
					if(mage_amount != -1)
						mage_amount--
		religion
			/*bishop
				icon_state = "bishop"
				desc = "The Bishop is in charge of the church of Bovinia. He works with his priests to spread the word of Belius to others."
				amount = 1
				class_id = "special_bishop"
				spawn_tag = "bishop spawn"
				Selected(mob/M)
					M.chosen = "priest"

					M.contents += new/item/armour/hat/bishop_hat(M)
					M.contents += new/item/armour/body/bishop_cloths(M)
					M.contents += new/item/misc/books/Holy(M)
					M.learn_spell(/spell/heal_extended, 1)

					return 1
				New()
					..()
					amount = bishop_amount
				AmountGet()
					amount = bishop_amount
				AmountUpdate(var/x as num)
					if(bishop_amount != -1)
						bishop_amount--*/
			/*priest
				icon_state = "priest"
				desc = "The Priest makes sure that all villages understand one thing clearly: although there may be a king to rule over them, religion is also very important. The Priest is often seen doing ceremonies of all sorts. As the Priest, you wield the ability to be able to resurrect the recently deceased. Would you like to become the Priest?"
				amount = 2
				class_id = "special_priest"
				spawn_tag = "priest spawn"
				Selected(mob/M)
					M.chosen = "priest"

					M.contents += new/item/armour/hat/priest_hat(M)
					M.contents += new/item/armour/body/priest_cloths(M)
					M.contents += new/item/misc/books/Holy(M)
					//HOLDER

					return 2
				New()
					..()
					amount = priest_amount
				AmountGet()
					amount = priest_amount
				AmountUpdate(var/x as num)
					if(priest_amount != -1)
						priest_amount--*/


		/*family
			icon_state = "peasant"
			Click(location, control, params)
				if(!(src in range(usr))) return
				if(usr.chosen)
					usr.loc = locate(98, 107, worldz) //peasant village (Bovinia)
					return

				var/list/L = new/list()
				for(var/family/F in usr.GetFamilies(0)) L += F
				if(!L || !L.len)
					usr.show_message("You are not a member of any families.")
					return

				var/family/F
				if(L && L.len > 1)
					F = input(usr, "Which family would you like to join as?", "Multiple families") as null|anything in L
					if(!F || usr.chosen || !(src in range(usr))) return
				else F = L[1]

				usr.family = F
				usr.show_message("Joining the [F.name] family.")
				usr.loc = locate(64, 9, 1)
				usr.show_message("Choose a class.")*/