paint_window
	var
		width
		height
		min_width
		min_height

		list/contents
		mob/mob
		obj/obj
		dir
		tool = "line"
		color = "black"

		black_berries = 0
		red_berries = 0
		blue_berries = 0
		white_berries = 0
		yellow_berries = 0
		using = 0
	New(mob/M, obj/O)
		if(dd_testing) return null
		. = ..()
		mob = M
		mob.paint_window = src
		obj = O
		dir = O.dir
		var/icon/I = new(icon = (O.paint_icon||O.icon), icon_state = (O.paint_icon_state||O.icon_state))
		width = I.Width()
		height = I.Height()
		var/maximum = max(width, height)
		contents = new/list()

		min_height = height == maximum ? 1 : height / 4
		min_width = width == maximum ? 1 : width / 4

		for(var/w = 1 to maximum)
			for(var/h = 1 to maximum)
				if(w < min_width || h < min_height)
					contents["[w],[h]"] = new/paint_object("transparent", w, h, src)
				else
					var/pixel = I.GetPixel(w - min_width + 1, h - min_height + 1, dir = O.dir)
					if(!pixel)
						contents["[w],[h]"] = new/paint_object("transparent", w, h, src)
					else
						if(obj.paint_list && ("[w],[h]" in obj.paint_list))
							contents["[w],[h]"] = new/paint_object("[obj.paint_list["[w],[h]"]]t", w, h, src)
						else
							contents["[w],[h]"] = new/paint_object("transparent2", w, h, src)
					//w - min_width + 1 = w
				sleep(-1)
			sleep(-1)
		Display(M)
	proc
		CalcBerries()
			var/item/misc/new_berries
				black/black = locate() in mob.contents
				red/red = locate() in mob.contents
				blue/blue = locate() in mob.contents
				white/white = locate() in mob.contents
				yellow/yellow = locate() in mob.contents
			black_berries = black ? black.stacked : 0
			red_berries = red ? red.stacked : 0
			blue_berries = blue ? blue.stacked : 0
			white_berries = white ? white.stacked : 0
			yellow_berries = yellow ? yellow.stacked : 0
			for(var/c in contents)
				var/paint_object/O = contents[c]
				if(O.ricon_state != O.icon_state)
					switch(O.icon_state)
						if("black") black_berries -= 0.25
						if("red") red_berries -= 0.25
						if("blue") blue_berries -= 0.25
						if("white") white_berries -= 0.25
						if("yellow") yellow_berries -= 0.25
			if(black_berries) black_berries = round(black_berries)
			if(red_berries) red_berries = round(red_berries)
			if(blue_berries) blue_berries = round(blue_berries)
			if(white_berries) white_berries = round(white_berries)
			if(yellow_berries) yellow_berries = round(yellow_berries)

			//update labels
			var/list/L = list(
				"paint_window.lblBlackBerries.text" = "[black_berries]",
				"paint_window.lblRedBerries.text" = "[red_berries]",
				"paint_window.lblBlueBerries.text" = "[blue_berries]",
				"paint_window.lblWhiteBerries.text" = "[white_berries]",
				"paint_window.lblYellowBerries.text" = "[yellow_berries]",

				"paint_window.lblBlackBerries.font-style" = "[black_berries < 0 ? "bold" : ""]",
				"paint_window.lblRedBerries.font-style" = "[red_berries < 0 ? "bold" : ""]",
				"paint_window.lblBlueBerries.font-style" = "[blue_berries < 0 ? "bold" : ""]",
				"paint_window.lblWhiteBerries.font-style" = "[white_berries < 0 ? "bold" : ""]",
				"paint_window.lblYellowBerries.font-style" = "[yellow_berries < 0 ? "bold" : ""]"
			)
			winset(mob, null, list2params(L))
		Clear()
			for(var/c in contents)
				var/paint_object/O = contents[c]
				if(O)
					O.icon_state = O.ricon_state
					O.oicon_state = O.icon_state
			CalcBerries()
		Save()
			CalcBerries() //make sure we have the latest calculation
			if(black_berries < 0 || red_berries < 0 || blue_berries < 0 || white_berries < 0 || yellow_berries < 0)
				mob << "<tt>You do not have enough berries to create this painting!</tt>"
				return
			var/item/misc/new_berries
				black/black = locate() in mob.contents
				red/red = locate() in mob.contents
				blue/blue = locate() in mob.contents
				white/white = locate() in mob.contents
				yellow/yellow = locate() in mob.contents
			if(black && black_berries)
				var/amount = black.stacked - black_berries
				black.stacked = black_berries
				if(black.stacked <= 0) black.Move(null, forced = 1)
				var/item/misc/seeds/I = locate(black.SeedType) in mob.contents
				if(!I)
					I = new black.SeedType(mob)
					I.stacked--
				I.stacked += amount
			if(red && red_berries)
				var/amount = red.stacked - red_berries
				red.stacked = red_berries
				if(red.stacked <= 0) red.Move(null, forced = 1)
				var/item/misc/seeds/I = locate(red.SeedType) in mob.contents
				if(!I)
					I = new red.SeedType(mob)
					I.stacked--
				I.stacked += amount
			if(blue && blue_berries)
				var/amount = blue.stacked - blue_berries
				blue.stacked = blue_berries
				if(blue.stacked <= 0) blue.Move(null, forced = 1)
				var/item/misc/seeds/I = locate(blue.SeedType) in mob.contents
				if(!I)
					I = new blue.SeedType(mob)
					I.stacked--
				I.stacked += amount
			if(white && white_berries)
				var/amount = white.stacked - white_berries
				white.stacked = white_berries
				if(white.stacked <= 0) white.Move(null, forced = 1)
				var/item/misc/seeds/I = locate(white.SeedType) in mob.contents
				if(!I)
					I = new white.SeedType(mob)
					I.stacked--
				I.stacked += amount
			if(yellow && yellow_berries)
				var/amount = yellow.stacked - yellow_berries
				yellow.stacked = yellow_berries
				if(yellow.stacked <= 0) yellow.Move(null, forced = 1)
				var/item/misc/seeds/I = locate(yellow.SeedType) in mob.contents
				if(!I)
					I = new yellow.SeedType(mob)
					I.stacked--
				I.stacked += amount

			var/icon/I = new/icon(icon = 'icons/blank.dmi')
			I.Scale(width, height)

			obj.paint_list = new/list()
			obj.paint_icon = obj.icon
			obj.paint_icon_state = obj.icon_state
			for(var/c in contents)
				var/paint_object/O = contents[c]
				if(!O || O.icon_state == "transparent" || O.icon_state == "transparent2") continue
				if(O.icon_state == O.ricon_state && dd_hassuffix("[O.icon_state]", "t"))
					obj.paint_list[c] = copytext("[O.icon_state]", 1, length("[O.icon_state]"))
				else
					obj.paint_list[c] = O.icon_state

				var/RGB
				switch(O.icon_state)
					if("black") RGB = rgb(0, 0, 0, 128)
					if("red") RGB = rgb(255, 0, 0, 128)
					if("blue") RGB = rgb(0, 0, 255, 128)
					if("white") RGB = rgb(255, 255, 255, 128)
					if("yellow") RGB = rgb(255, 255, 0, 128)
				//if(O.ricon_state == "[O.icon_state]t") RGB += rgb(0, 0, 0, 128)
				//else
				switch(O.ricon_state)
					if("blackt") RGB = rgb(0, 0, 0, 192)
					if("redt") RGB = rgb(255, 0, 0, 192)
					if("bluet") RGB = rgb(0, 0, 255, 192)
					if("whitet") RGB = rgb(255, 255, 255, 192)
					if("yellowt") RGB = rgb(255, 255, 0, 192)

				if(RGB)
					I.DrawBox(RGB, O._x, O._y, O._x, O._y)


			var/icon/B = new/icon(obj.icon, obj.icon_state, obj.dir)
			B.Blend(I, ICON_OVERLAY)

			var/icon/C = new/icon(obj.icon)
			C.Insert(B, obj.icon_state, obj.dir)
			obj.icon = C
			obj.painted(src, mob)
			mob << "<tt>You are done drawing!</tt>"
			mob.paint_window = null
			winshow(mob, "paint_window", 0)

			mob.medal_Report("paint")
		Display(mob/M = src.mob)
			if(!M || !M.client) return
			for(var/paint_object/O in M.client.screen) M.client.screen -= O
			for(var/c in contents)
				var/paint_object/O = contents[c]
				if(O) M.client.screen += O

			winshow(mob, "paint_window")
			//update buttons
			var/list/L = list(
				"paint_window.on-close" = "byond://?src=\ref[src];cmd=close",
				"paint_window.btnPen.command" = "byond://?src=\ref[src];tool=pen",
				"paint_window.btnLine.command" = "byond://?src=\ref[src];tool=line",
				"paint_window.btnRect.command" = "byond://?src=\ref[src];tool=rect",
				"paint_window.btnFRect.command" = "byond://?src=\ref[src];tool=frect",
				"paint_window.btnClear.command" = "byond://?src=\ref[src];cmd=clear",
				"paint_window.btnSave.command" = "byond://?src=\ref[src];cmd=save",
				"paint_window.btnSaveF.command" = "byond://?src=\ref[src];cmd=savef",
				"paint_window.btnLoad.command" = "byond://?src=\ref[src];cmd=load",
				"paint_window.btnLine.is-checked" = "true",

				"paint_window.btnColorBlack.command" = "byond://?src=\ref[src];color=black",
				"paint_window.btnColorRed.command" = "byond://?src=\ref[src];color=red",
				"paint_window.btnColorBlue.command" = "byond://?src=\ref[src];color=blue",
				"paint_window.btnColorWhite.command" = "byond://?src=\ref[src];color=white",
				"paint_window.btnColorYellow.command" = "byond://?src=\ref[src];color=yellow",
				"paint_window.btnColorBlack.is-checked" = "true",
			)
			winset(mob, null, list2params(L))
			CalcBerries()
	Topic(href, href_list[])
		if(usr.paint_window != src) return //no cheating!
		switch(href_list["tool"])
			if("pen")
				winset(usr, "paint_window.btnPen", "is-checked=true")
				tool = "pen"
			if("line")
				winset(usr, "paint_window.btnLine", "is-checked=true")
				tool = "line"
			if("rect")
				winset(usr, "paint_window.btnRect", "is-checked=true")
				tool = "rect"
			if("frect")
				winset(usr, "paint_window.btnFRect", "is-checked=true")
				tool = "frect"
		switch(href_list["color"])
			if("black")
				winset(usr, "paint_window.btnColorBlack", "is-checked=true")
				color = "black"
			if("red")
				winset(usr, "paint_window.btnColorRed", "is-checked=true")
				color = "red"
			if("blue")
				winset(usr, "paint_window.btnColorBlue", "is-checked=true")
				color = "blue"
			if("white")
				winset(usr, "paint_window.btnColorWhite", "is-checked=true")
				color = "white"
			if("yellow")
				winset(usr, "paint_window.btnColorYellow", "is-checked=true")
				color = "yellow"
		switch(href_list["cmd"])
			if("clear")
				if(using) return
				Clear()
			if("save")
				if(using) return
				Save()
			if("close")
				usr.paint_window = null
				winshow(usr, "paint_window", 0)
			if("savef")
				if(!usr || !usr.client || !usr.client.player) return
				using = 1
				var
					name = input(usr, "Specify a name to save this painting under.", "Save Painting") as null|text
					player/P = usr.client.player
					list/L = new/list()
				if(!name)
					using = 0
					return

				for(var/c in contents)
					var/paint_object/O = contents[c]
					if(!O || O.icon_state == "transparent" || O.icon_state == "transparent2") continue
					L[c] = O.icon_state
				if(!P.paintings) P.paintings = new/list()
				P.paintings[name] = L
				using = 0
			if("load")
				if(!usr || !usr.client || !usr.client.player) return
				using = 1
				var
					player/P = usr.client.player
					list/L
				if(!P.paintings || !P.paintings.len)
					alert(usr, "You do not have any paintings to load!", "Load Painting")
					using = 0
					return
				var/entry = input(usr, "Select the painting to load.", "Load Painting") as null|anything in P.paintings
				if(!entry)
					using = 0
					return
				L = P.paintings[entry]
				if(L && L.len)
					for(var/c in contents)
						var/paint_object/O = contents[c]
						if(!O || O.icon_state == "transparent") continue
						if(c in L)
							O.icon_state = L[c]
							O.oicon_state = O.icon_state
					CalcBerries()
				using = 0

paint_object
	parent_type = /obj
	icon = 'icons/paint.dmi'
	var
		_x
		_y
		paint_window/master
		oicon_state
		ricon_state
	New(color = "transparent", _x, _y, master)
		. = ..()
		icon_state = color
		oicon_state = color
		ricon_state = color
		screen_loc = "paintmap:[_x],[_y]"
		src._x = _x
		src._y = _y
		src.master = master
	MouseDown(location, control, params)
		if(icon_state == "transparent" || master.using) return
		params = params2list(params)
		if(params["right"])
			icon_state = ricon_state
		else
			icon_state = master.color
		oicon_state = icon_state
		master.CalcBerries()
	MouseDrag(paint_object/over_object, src_location, over_location, src_control, over_control, params)
		if(!istype(over_object) || over_control != "paint_window.paintmap" || master.using) return
		params = params2list(params)

		var
			min_x = min(over_object._x, _x)
			min_y = min(over_object._y, _y)
			max_x = max(over_object._x, _x)
			max_y = max(over_object._y, _y)

		var/list/include_list
		if(master.tool == "line")
			include_list = new/list()
			include_list += "[_x],[_y]"
			include_list += "[over_object._x],[over_object._y]"
			var
				x1 = _x
				x2 = over_object._x
				y1 = _y
				y2 = over_object._y
				steep = abs(y2 - y1) > abs(x2 - x1)
			if(steep)
				var/temp = x1
				x1 = y1
				y1 = temp

				temp = x2
				x2 = y2
				y2 = temp
			if(x1 > x2)
				var/temp = x1
				x1 = x2
				x2 = temp

				temp = y1
				y1 = y2
				y2 = temp

			var
				deltax = x2 - x1
				deltay = abs(y2 - y1)
				error = 0
				y = y1
				ystep = y1 < y2 ? 1 : -1
			for(var/x = x1, x < x2, x++)
				if(steep) include_list += "[y],[x]"
				else include_list += "[x],[y]"
				error += deltay
				if((2 * error) >= deltax)
					y += ystep
					error -= deltax

		for(var/c in master.contents)
			var/paint_object/O = master.contents[c]
			if(O && O.icon_state != "transparent")
				if(master.tool != "pen") O.icon_state = O.oicon_state

				. = (O == src || O == over_object)
				if(master.tool == "frect" && ((O._x >= min_x && O._x <= max_x) && (O._y >= min_y && O._y <= max_y)))
					. = 1
				else if(master.tool == "rect" && ((O._x >= min_x && O._x <= max_x && (O._y == min_y || O._y == max_y)) || (O._y >= min_y && O._y <= max_y && (O._x == min_x || O._x == max_x))))
					. = 1
				else if(master.tool == "line")
					. = 0
					if(c in include_list) . = 1

				if(.)
					if(params["right"]) O.icon_state = O.ricon_state
					else O.icon_state = master.color
	MouseDrop(paint_object/over_object, src_location, over_location, src_control, over_control, params)
		if(master.using) return
		for(var/c in master.contents)
			var/paint_object/O = master.contents[c]
			if(O && O.icon_state != "transparent")
				O.oicon_state = O.icon_state
		master.CalcBerries()