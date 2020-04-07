mob/character_handling
	var
		character_handling/container
			old_kingdom
			old_branch
			branch
		character_handling/class/class
		image
			selector_kingdom
			selector_branch
			selector_class
		run_once = 0
	kingdom = new/character_handling/container/bovinia
	var
		char_gen_gender = "m"
		body_color = "white"
		body_pattern = "plain"
		hair_type = "none"
		beard_type = "none"
		hair_color = "black"

		body_color_index = 0
		body_pattern_index = 0
		hair_type_index = 0
		beard_type_index = 0
		hair_color_index = 0
		beard_icon_state
		hair_icon_state

	var/mob
		char_1
		char_2
		char_3
		char_4
	New()
		. = ..()
		selector_kingdom = image(icon = 'icons/Classes.dmi', loc = null, icon_state = "selector")
		selector_branch = image(icon = 'icons/Classes.dmi', loc = null, icon_state = "selector")
		selector_class = image(icon = 'icons/Classes.dmi', loc = null, icon_state = "selector")
		char_1 = new()
		char_1.dir = 2
		char_2 = new()
		char_2.dir = 1
		char_3 = new()
		char_3.dir = 4
		char_4 = new()
		char_4.dir = 8
		verbs -= /mob/verb/loot

	proc
		Display()
			selector_kingdom.loc = kingdom
			selector_branch.loc = branch
			selector_class.loc = class
			if(run_once) name = winget(src, "character_handling.txtName", "text")
			else run_once = 1
			var
				player/P = client.player
				list/L = list(
				"character_handling.txtName.text" = src.name,
				"character_handling.grdBranches.is-visible" = (kingdom ? "true" : "false"),
				"character_handling.lblBranch.is-visible" = (kingdom ? "true" : "false"),
				"character_handling.lblBranch1.is-visible" = (kingdom ? "true" : "false"),
				"character_handling.grdClasses.is-visible" = (branch ? "true" : "false"),
				"character_handling.lblClass.is-visible" = (branch ? "true" : "false"),
				"character_handling.lblClass1.is-visible" = (branch ? "true" : "false"),
				"character_handling.btnCreate.is-disabled" = (!kingdom || !branch || !class ? "true" : "false"),
				"character_handling.btnSpectate.is-disabled" = (!kingdom ? "true" : "false"),
				"character_handling.grdNames.cells" = "[P && P.recentNames ? "1x[P.recentNames.len]" : "0x0"]",
				"character_handling.btnCreate.command" = "byond://?src=\ref[src];cmd=create",
				"character_handling.btnSpectate.command" = "byond://?src=\ref[src];cmd=spectate",
				"character_creation.btn_male.command" = "Gender \"m\"",
				"character_creation.btn_female.command" = "Gender \"f\"",
				"character_creation.btn_color_left.command" = "ColorShift \"left\"",
				"character_creation.btn_color_right.command" = "ColorShift \"right\"",
				"character_creation.btn_pattern_left.command" = "PatternShift \"left\"",
				"character_creation.btn_pattern_right.command" = "PatternShift \"right\"",
				"character_creation.btn_hair_left.command" = "HairShift \"left\"",
				"character_creation.btn_hair_right.command" = "HairShift \"right\"",
				"character_creation.btn_hair_color_left.command" = "HairColorShift \"left\"",
				"character_creation.btn_hair_color_right.command" = "HairColorShift \"right\"",
				"character_creation.btn_beard_left.command" = "BeardShift \"left\"",
				"character_creation.btn_beard_right.command" = "BeardShift \"right\""
			)

			if(src.kingdom != src.old_kingdom)
				L["character_handling.grdBranches.cells"] = "[kingdom ? kingdom.children.len : 0]"
				L["character_handling.grdClasses.cells"] = "0"
				branch = null
				class = null
				selector_branch.loc = null
				selector_class.loc = null
			if(src.branch != src.old_branch)
				L["character_handling.grdClasses.cells"] = "[branch ? branch.children.len : 0]"
				class = null
				selector_class.loc = null
			winset(src, null, list2params(L))

			if(!kingdom && game.kingdoms.len)
				var/i = 0
				for(var/character_handling/container/kingdom in game.kingdoms)
					client.images -= kingdom.bluex
					if(!kingdom.CanSelect(src)) client.images += kingdom.bluex
					src << output(kingdom, "character_handling.grdKingdoms:[++i]")

			if(src.kingdom != src.old_kingdom)
				if(kingdom)
					var/i = 0
					for(var/character_handling/container/branch in src.kingdom.children)
						client.images -= branch.bluex
						if(!branch.CanSelect(src)) client.images += branch.bluex
						src << output(branch, "character_handling.grdBranches:[++i]")

			if(src.branch != src.old_branch)
				if(branch)
					var/i = 0
					for(var/character_handling/class/C in src.branch.children)
						if(C.img_amount)
							client.images -= C.img_amount
							client.images += C.img_amount

						client.images -= C.redx
						if(!C.amount) client.images += C.redx

						client.images -= kingdom.bluex
						if(!C.CanSelect(src)) client.images += C.bluex
						src << output(C, "character_handling.grdClasses:[++i]")

			src.old_kingdom = src.kingdom
			src.old_branch = src.branch

			if(P && P.recentNames && P.recentNames.len)
				var/i = 0
				for(var/name in P.recentNames)
					src << output("<a href=\"byond://?src=\ref[src];cmd=name;name=[++i]\">[name]</a>", "character_handling.grdNames:1,[i]")

			src << output(char_1, "character_creation.char_grid:1,1]")
			src << output(char_2, "character_creation.char_grid:1,2]")
			src << output(char_3, "character_creation.char_grid:1,3]")
			src << output(char_4, "character_creation.char_grid:1,4]")
		/*Kingdom2Text(kingdom)
			switch(kingdom)
				if("bovinia")
					return "The Bovinia Kingdom is to the left of the map and has a strict hierachy and levels of control.\
					You are not free to do what you please and everyone is expected to respect their church duty.\
					The King is in charge and his or her word is final.\
					However because the law is so strictly upheld executions are a dime a dozen in this kingdom."
				if("cowmalot")
					return "The Cowmalot Kingdom is a partially democratic kingdom after an uprising changed the law.\
					Although the king/queen sits on the throne they act on behalf of the public and often hold votes on \
					critical decisions. You are free to persue your own religion here however the law is not set in stone \
					and you may be sued for pretty much any reason."
				if("peasants")
					return "As a peasant you are free to do whatever you please; build your own house, start mining for rocks \
					or join a cult! You make your own story and set your own destiny. Just be sure to listen to the GM's though!"
				if("family")
					return "As a member of a family you have a special spawn location and some unique items. Don't get too \
					excited though... this luxury will change."
				else
					return "Uh-oh! I was supposed to show a little description in this tooltip here, but nobody told me what to put here!"*/
	Login()
		if(!client) return
		winset(src, "default/game.child", "left=character_handling")

		/*gender = PLURAL
		Display()*/

		var/player/P = client.player
		if(P)
			src.gender = P.gender || MALE
			src.name = P.character_name || src.key
			//if(!(name in names)) names += name

			client.images += selector_kingdom
			client.images += selector_branch
			client.images += selector_class
			Display()
	Logout()
		del src

	verb/ColorShift(var/I as text)
		set hidden = 1
		if(I == "left")
			body_color_index -= 1
			if(body_color_index < 0)
				body_color_index = 1
		else
			body_color_index += 1
			if(body_color_index > 1)
				body_color_index = 0
		switch(body_color_index)
			if(0)
				body_color = "white"
				winset(src, "character_creation.lbl_color", "text = 'White'")
			if(1)
				body_color = "brown"
				winset(src, "character_creation.lbl_color", "text = 'Brown'")
		UpdateCharGen()

	verb/PatternShift(var/I as text)
		set hidden = 1
		if(I == "left")
			body_pattern_index -= 1
			if(body_pattern_index < 0)
				body_pattern_index = 1
		else
			body_pattern_index += 1
			if(body_pattern_index > 1)
				body_pattern_index = 0
		switch(body_pattern_index)
			if(0)
				body_pattern = "plain"
				winset(src, "character_creation.lbl_pattern", "text = 'Plain'")
			if(1)
				body_pattern = "spots"
				winset(src, "character_creation.lbl_pattern", "text = 'Spots'")
		UpdateCharGen()

	verb/HairShift(var/I as text)
		set hidden = 1
		if(I == "left")
			hair_type_index -= 1
			if(hair_type_index < 0)
				hair_type_index = 3
		else
			hair_type_index += 1
			if(hair_type_index > 3)
				hair_type_index = 0
		switch(hair_type_index)
			if(0)
				hair_type = "none"
				winset(src, "character_creation.lbl_hair", "text = 'None'")
			if(1)
				hair_type = "short"
				winset(src, "character_creation.lbl_hair", "text = 'Short'")
			if(2)
				hair_type = "mid"
				winset(src, "character_creation.lbl_hair", "text = 'Medium'")
			if(3)
				hair_type = "long"
				winset(src, "character_creation.lbl_hair", "text = 'Long'")
		UpdateCharGen()

	verb/BeardShift(var/I as text)
		set hidden = 1
		if(I == "left")
			beard_type_index -= 1
			if(beard_type_index < 0)
				beard_type_index = 2
		else
			beard_type_index += 1
			if(beard_type_index > 2)
				beard_type_index = 0
		switch(beard_type_index)
			if(0)
				beard_type = "none"
				winset(src, "character_creation.lbl_beard", "text = 'None'")
			if(1)
				beard_type = "mustache"
				winset(src, "character_creation.lbl_beard", "text = 'Mustache'")
			if(2)
				beard_type = "full_beard"
				winset(src, "character_creation.lbl_beard", "text = 'Full Beard'")
		UpdateCharGen()

	verb/HairColorShift(var/I as text)
		set hidden = 1
		if(I == "left")
			hair_color_index -= 1
			if(hair_color_index < 0)
				hair_color_index = 3
		else
			hair_color_index += 1
			if(hair_color_index > 3)
				hair_color_index = 0
		switch(hair_color_index)
			if(0)
				hair_color = "black"
				winset(src, "character_creation.lbl_hair_color", "text = 'Black'")
			if(1)
				hair_color = "brown"
				winset(src, "character_creation.lbl_hair_color", "text = 'Brown'")
			if(2)
				hair_color = "blonde"
				winset(src, "character_creation.lbl_hair_color", "text = 'Blonde'")
			if(3)
				hair_color = "grey"
				winset(src, "character_creation.lbl_hair_color", "text = 'Grey'")
		UpdateCharGen()

	verb/Gender(var/I as text)
		set hidden = 1
		char_gen_gender = I
		UpdateCharGen()

//Important
	proc/UpdateCharGen()
		if(char_gen_gender == "f")
			if(body_color == "white")
				if(body_pattern == "plain")
					char_1.icon = 'CowF.dmi'
				else
					char_1.icon = 'CowF_Spots.dmi'
			else
				if(body_pattern == "plain")
					char_1.icon = 'CowF_Brown.dmi'
				else
					char_1.icon = 'CowF_Brown_Spots.dmi'
		else
			if(body_color == "white")
				if(body_pattern == "plain")
					char_1.icon = 'Cow.dmi'
				else
					char_1.icon = 'Cow_Spots.dmi'
			else
				if(body_pattern == "plain")
					char_1.icon = 'Cow_Brown.dmi'
				else
					char_1.icon = 'Cow_Brown_Spots.dmi'
		if(char_gen_gender == "f")
			gender = FEMALE
		else
			gender = MALE

		char_1.overlays = null
		char_2.overlays = null
		char_3.overlays = null
		char_4.overlays = null

		if(hair_type == "short")
			if(hair_color == "brown")
				hair_icon_state = "brown_short_hair"
			else if( hair_color == "blonde")
				hair_icon_state = "blonde_short_hair"
			else if( hair_color == "grey")
				hair_icon_state = "grey_short_hair"
			else
				hair_icon_state = "black_short_hair"
		else if(hair_type == "mid")
			if(hair_color == "brown")
				hair_icon_state = "brown_mid_hair"
			else if( hair_color == "blonde")
				hair_icon_state = "blonde_mid_hair"
			else if( hair_color == "grey")
				hair_icon_state = "grey_mid_hair"
			else
				hair_icon_state = "black_mid_hair"
		else if(hair_type == "long")
			if(hair_color == "brown")
				hair_icon_state = "brown_long_hair"
			else if( hair_color == "blonde")
				hair_icon_state = "blonde_long_hair"
			else if( hair_color == "grey")
				hair_icon_state = "grey_long_hair"
			else
				hair_icon_state = "black_long_hair"
		else
			hair_icon_state = "ignore"

		if(hair_icon_state != "ignore")
			var/image/I	= image(icon = 'icons/hair.dmi', icon_state = hair_icon_state)
			char_1.overlays += I
			I.dir = 1
			char_2.overlays += I
			I.dir = 4
			char_3.overlays += I
			I.dir = 8
			char_4.overlays += I
		if(beard_type == "mustache")
			if(hair_color == "brown")
				beard_icon_state = "brown_mustache"
			else if( hair_color == "blonde")
				beard_icon_state = "blonde_mustache"
			else if( hair_color == "grey")
				beard_icon_state = "grey_mustache"
			else
				beard_icon_state = "black_mustache"
		else if(beard_type == "full_beard")
			if(hair_color == "brown")
				beard_icon_state = "brown_full_beard"
			else if( hair_color == "blonde")
				beard_icon_state = "blonde_full_beard"
			else if( hair_color == "grey")
				beard_icon_state = "grey_full_beard"
			else
				beard_icon_state = "black_full_beard"
		else
			beard_icon_state = "ignore"

		if(beard_icon_state != "ignore")
			var/image/I	= image(icon = 'icons/Beard.dmi', icon_state = beard_icon_state)
			char_1.overlays += I
			I.dir = 1
			char_2.overlays += I
			I.dir = 4
			char_3.overlays += I
			I.dir = 8
			char_4.overlays += I

		char_2.icon = char_1.icon
		char_3.icon = char_1.icon
		char_4.icon = char_1.icon

		src << output(char_1, "character_creation.char_grid:1,1]")
		src << output(char_2, "character_creation.char_grid:1,2]")
		src << output(char_3, "character_creation.char_grid:1,3]")
		src << output(char_4, "character_creation.char_grid:1,4]")

	Topic(href, href_list[])
		if(href_list["cmd"] == "spectate" && kingdom)
			. = CheckName()
			if(. == 1)
				alert(src, "Please specify a name for your character!")
				return
			if(. == 2)
				alert(src, "Sorry; this name has already been taken!")
				return
			if(!.)
				var/mob/observer/N = new(locate(locate("peasant spawn").x, locate("peasant spawn").y, locate("peasant spawn").z))
				N.name = src.name
				N.gender = src.gender

				RemoveImages()
				src.client.mob = N
		else if(href_list["cmd"] == "create" && kingdom && branch && class)
			. = CheckName()
			name = winget(src, "character_handling.txtName", "text")
			if(. == 1)
				alert(src, "Please specify a name for your character!")
				return
			if(. == 2)
				alert(src, "Sorry; this name has already been taken!")
				return
			if(!.)
				RemoveImages()
				if(class) class.Invoke(src)
		else if(href_list["cmd"] == "name")
			var
				name = text2num(href_list["name"])
				player/P = client.player
			if(name > 0 && P && P.recentNames && P.recentNames.len >= name)
				winset(src, null, list2params(list("character_handling.txtName.text" = P.recentNames[name])))
				src.name = P.recentNames[name]
		else if(href_list["cmd"] == "genderF")
			src.gender = FEMALE
		else if(href_list["cmd"] == "genderM")
			src.gender = MALE
	proc
		CheckName()
			var
				name = winget(src, "character_handling.txtName", "text")
				t_name = trimAll(name)
			if(!t_name || t_name == " ") return 1
			if((name in names)) return 2

			src.name = name

			var/player/P = client.player
			if(P)
				P.character_name = name
				P.gender = src.gender

				if(!P.recentNames) P.recentNames = new/list()
				if(!(name in P.recentNames))
					P.recentNames += name
					P.recentNames = BubbleSort(P.recentNames)

					if(P.recentNames.len > 32) P.recentNames -= P.recentNames[1]
			return 0
		RemoveImages()
			client.images -= selector_kingdom
			client.images -= selector_branch
			client.images -= selector_class
			RemoveClassImages()
	/*Topic(href, href_list[])
		if(!chosen)
			if("name" in href_list)
				var
					name = href_list["name"] || "Ben Dover"
					old_name = src.name

				if(!trimAll(name) || trimAll(name) == " ")
					alert(usr, "No name entered! Please specify a valid name!")
					return
				if((name in names) && name != old_name)
					alert(usr, "Sorry; this name has already been taken! Please specify a valid name!")
					return

				src.name = name
				names -= old_name
				names += name
				chosen = 1
				if(href_list["gender"] == "female") gender = FEMALE
				else gender = MALE
				client.Save()
				Display2()
		else
			if(vote_system.vote && href_list["cmd"] == "vote")
				src << link("byond://?src=\ref[vote_system];cmd=vote;choice=[href_list["choice"]];verbose=1")
			else if(href_list["kingdom"])
				kingdom = href_list["kingdom"]
				Display2()
			else if(href_list["class"])
				var/class/C = locate(href_list["class"])
				if(!(C in game.classes)) return
				if(C.amount <= 0 && C.amount != -2)
					alert(src, "This class has already been taken!")
					return
				C.Invoke(src)*/
	Life() return