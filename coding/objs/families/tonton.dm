obj/family/tonton
	icon = 'icons/families/tonton.dmi'
	coffee_maker
		icon_state = "coffee_maker"
		anchored = 1
		var/amount = 4
		attack_hand(mob/M)
			for(var/item/weapon/coffee/I in M.contents)
				I.amount = src.amount