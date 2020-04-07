obj/school_of_magic
	wizard_shop
		icon = 'icons/Turfs.dmi'
		icon_state = "wizard_shop"
		density = 1
		anchored = 1
		name = "Wizard Shop"
		var/list
			spells = list(
				"Empty Spellbook" = list(/item/misc/spellbook/Empty_Spellbook, 6),
				"School of Magic Portal Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_School, 24),
				"Lockpick Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Lockpick, 24),
				"Zap Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Zap, 34),
				"Eclipse Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Eclipse, 26),
				"Enchant Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Enchant, 26),
				"Fireball Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Fireball, 48),
				"Iceball Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Iceball, 48),
				"Glow Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Glow, 54),
				"Heal Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Heal, 54),
				"Message Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Message, 34),
				"Portal Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Portal, 72),
				"Teleport Spell" = list(/item/misc/spellbook/Spellbook/Spellbook_Teleport, 142)
			)
		attack_hand(mob/M)
			. = {"
<html>
	<head>
		<title>Wizard Shop</title>
		<link rel="stylesheet" type="text/css" href="cowed_style.css" />
	</head>
	<body>
		<p>You have <strong>[M.magic_points]</strong> magic points.</p>
		<p>
			What would you like to purchase?
		</p>
		<ul>Accessoires:
			<li><a href="byond://?src=\ref[src];object=tunic">Wizards' Robe + Hat</a> (6 MP)</li>
		</ul><ul>Spellbooks:"}
			var/i = 0
			for(var/spell in src.spells)
				var/list/L = src.spells[spell]
				. += "<li><a href=\"byond://?src=\ref[src];spell=[++i]\">[spell]</a> ([L[2]] MP)</a></li>"
			. += {"
		</ul>
	</body>
</html>"}
			M << browse(., "window=\ref[src];size=500x500;can_resize=0")
		Topic(href, href_list[])
			if(!(src in range(1, usr))) return
			if("spell" in href_list)
				var/spell = text2num(href_list["spell"])
				if(spell && spell > 0 && spell <= spells.len)
					var/list/L = spells[spells[spell]]
					if(usr.magic_points < L[2])
						usr.show_message("<tt>You do not have enough magic points to get this spellbook!</tt>")
						return
					var/type = L[1]
					usr.contents += new type(usr)
					usr.magic_points -= L[2]
			else if("object" in href_list) switch(href_list["object"])
				if("tunic")
					if(usr.magic_points < 6)
						usr.show_message("<tt>You do not have enough magic points to get this item!</tt>")
						return
					var/color = input(usr, "Specify the color you would like your wizard robe + hat to have.") as null|color
					if(!usr || !(usr in range(1, src)) || color == null) return
					usr.magic_points -= 6
					var/item/armour
						body/mage_cloths/body = new(usr)
						hat/mage_hat/hat = new(usr)
					body.icon += color
					hat.icon += color
					body.color = color
					hat.color = color