spell_component
	parent_type = /obj
	icon = 'icons/screen_spells.dmi'
	icon_state = "message"
	layer = 19
	mouse_opacity = 2
	var
		spell/master
		cooldown = 50 //cooldown period
		mana_cost = 20 //the amount of mana required for this spell
		primary = 0
	proc
		onSleep(mob/M) //triggered when the wizard goes to sleep
		_invoke(mob/M, obj/O)
			if(!invoke(M, O))
				if(!(master.flags & master.FLAG_SUPER))
					M.SLEEP -= mana_cost
					if(M.SLEEP <= 0) M.SLEEP = 0
					hud_main.UpdateHUD(M)

					if(master.flags & master.FLAG_LOCAL_COOLDOWN)
						master.ActionLock("spell_invoked", cooldown)
					else
						M.ActionLock("spell_invoked", cooldown)
		invoke(mob/M, obj/O)
		activate(mob/M) return _invoke(M)
			//if(!_invoke(M))
				/*if(!(master.flags & master.FLAG_SUPER))
					M.SLEEP -= mana_cost
					if(M.SLEEP <= 0) M.SLEEP = 0
					hud_main.UpdateHUD(M)

					//now actually set the cooldown time
					(master.flags & master.FLAG_LOCAL_COOLDOWN) ? master.ActionLock("spell_invoked", cooldown) : M.ActionLock("spell_invoked", cooldown)*/
		_activate(mob/M)
			. = canInvoke(M)
			if(. == 1)
				return activate(M)
			else if(. == 0)
				if(master.flags & master.FLAG_DISABLED)
					M << "<tt>Your powers have been suppressed!</tt>"
				else
					var/time = (master.flags & master.FLAG_LOCAL_COOLDOWN) ? master.actionlock["spell_invoked"] : M.actionlock["spell_invoked"]
					M << "<tt>You must wait [estimate_time(time)] before you can invoke this spell.</tt>"
			else if(. == -1)
				M << "<tt>You are too tired to cast this spell.</tt>"
			else if(. == -2)
				M << "<tt>You do not meet the requirements to cast this spell.</tt>"
				M << "<tt>Requirements: [Requirements()]</tt>"
		canInvoke(mob/M)
			if(master.flags & master.FLAG_DISABLED) return 0
			if(master.flags & master.FLAG_SUPER) return 1
			if(M.restrained()) return -3
			if(M.SLEEP - 5 < mana_cost)
				return -1
			//simply check if the cooldown time is in effect
			. = (master.flags & master.FLAG_LOCAL_COOLDOWN) ? !master.ActionLock("spell_invoked") : !M.ActionLock("spell_invoked")
		Requirements() return "N/A"
	Click()
		if(!usr.CheckAlive()) return
		return _activate(usr)
	sleep_spell
		name = "Sleep Spell"
		icon_state = "sleep_spell"
		mana_cost = 30
		activate(mob/M)
			M.selectedSpellComponent = src
			M << "<tt>Click on a person to target.</tt>"
		invoke(mob/M, mob/T)
			if(!istype(T))
				M << "<tt>You did not select a person. Spell aborted.</tt>"
				return 1
			T.SLEEP = 0
			T.toggle_sleep(1)
	/*shapeshift
		name = "Shapeshift"
		icon_state = "glow"
		mana_cost = 90
		var
			orig_name
			orig_icon
		activate(mob/M)
			M.selectedSpellComponent = src
			M << "<tt>Click on a person to target.</tt>"
		invoke(mob/M, mob/T)
			if(!istype(T))
				M << "<tt>You did not select a person. Spell aborted.</tt>"
				return 1

			orig_name = M.name
			orig_icon = M.icon

			M.anim_fadeout()
			M.icon = T.icon
			M.icon_state = "alive"
			for(var/I in T.overlays)
				M.overlays += image(icon = I:icon, icon_state = I:icon_state)
			M.anim_fadein()*/

spell
	var
		name
		const
			FLAG_SPELLBOOK = 1 //this spell can be written down in a spell book
			FLAG_MAGE = 2 //this spell can only be learnt by a Mage
			FLAG_SUPER = 4 //this spell is "super": no cooldown time, fast use time. (admin only)
			FLAG_LOCAL_COOLDOWN = 16 //this spell uses a local (spell-specific) cooldown in favor of a global cooldown time
			FLAG_DISABLED = 32 //the spell is disabled
		flags = FLAG_SPELLBOOK
		list/components //list of spell_component objects
		learning_time = 200 //amount of ticks required to incribe the spell or learn it
	New(is_primary = 0)
		. = ..()
		for(var/spell_component/S in components) S.master = src
		if(is_primary)
			var/spell_component/S = components[components.len]
			S.primary = 1
			S.overlays += image(icon = 'icons/screen_spells.dmi', icon_state = "primaryline")
	proc
		onSleep(mob/M)
			for(var/spell_component/S in components) S.onSleep(M)