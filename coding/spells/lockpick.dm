spell/lockpick
	name = "Pick Lock"
	components = newlist(/spell_component/lockpick)
	flags = FLAG_SPELLBOOK | FLAG_MAGE

spell_component/lockpick
	name = "Pick Lock"
	icon_state = "lockpick"
	mana_cost = 10
	cooldown = 10
	activate(mob/M)
		M.selectedSpellComponent = src
		M << "<tt>Click on a door to unlock it.</tt>"
	invoke(mob/M, obj/door/wood/T)
		if(!istype(T) && !istype(T, /obj/door/stone) && !istype(T, /obj/door/wood) && !istype(T, /obj/door/stone))
			M << "<tt>You did not select a door. Spell aborted.</tt>"
			return 1
		if(T.enchanted && T.enchanted != M)
			M << "<tt>The lock has been enchanted by another mage! Spell aborted.</tt>"
			return 1
		/*if(!T.locked)
			M << "<tt>The door you selected is not locked. Spell aborted.</tt>"
			return 1*/
		if(!(T in range(1, M)))
			M << "<tt>You are not standing next to the door. Spell aborted.</tt>"
			return 1

		if(!(master.flags & master.FLAG_SUPER))
			send_message(ohearers(M), "\blue [M.name] points his finger at [T.name].", 1)
			M.show_message("\blue You point your finger at [T.name].")

			M.movable = 1
			sleep(30)
			M.movable = 0

		if(M.CheckAlive() && (T in range(M, 1)))
			send_message(ohearers(M), "\blue [M.name] magically [T.locked ? "unlocks" : "locks"] [T.name]!", 1)
			M.show_message("\blue You magically [T.locked ? "unlock" : "lock"] [T.name]!")
			T.locked = !T.locked