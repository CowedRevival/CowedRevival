spell_component/power_mimic
	obtain_primary
		name = "Obtain Primary Power"
		icon_state = "power_mimic"
		mana_cost = 40
		activate(mob/M)
			M.selectedSpellComponent = src
			M.show_message("<tt>Click on a mage to take their primary power.</tt>")
		invoke(mob/M, mob/T)
			var/spell/power_mimic/master = src.master
			if(!istype(T) || !T.spells || !T.spells.len)
				M.show_message("<tt>You did not select a mage. Spell aborted.</tt>")
				return 1
			var/spell/S = T.spells[1]
			if(!S || istype(S, /spell/power_mimic) || !S.components || !S.components.len)
				M.show_message("<tt>You were unable to take the primary power.</tt>")
				return
			var/spell_component/component
			if(S.components.len > 1)
				component = input(M, "Select the spell you would like to mimic.") as null|anything in S.components
				if(!component) return
			else component = S.components[1]

			master.primary = new component.type
			master.primary.master = master
			master.updateInvoke()
	invoke_primary
		name = "Invoke Primary Power"
		icon_state = ""
		invoke(mob/M)
			var/spell/power_mimic/master = src.master
			if(master.primary) return master.primary.invoke(M)
		activate(mob/M)
			var/spell/power_mimic/master = src.master
			if(master.primary) return master.primary.activate(M)
		_invoke(mob/M, obj/O)
			var/spell/power_mimic/master = src.master
			if(master.primary) return master.primary._invoke(M, O)
		canInvoke(mob/M)
			var/spell/power_mimic/master = src.master
			if(!master.primary) return -1
			return master.primary.canInvoke(M)
		onSleep(mob/M)
			var/spell/power_mimic/master = src.master
			if(master.primary) return master.primary.onSleep(M)
		Requirements()
			var/spell/power_mimic/master = src.master
			if(master.primary) return master.primary.Requirements()
			return ..()

spell/power_mimic
	components = newlist(/spell_component/power_mimic/obtain_primary, /spell_component/power_mimic/invoke_primary)
	var/spell_component/primary
	proc
		updateInvoke()
			for(var/spell_component/power_mimic/invoke_primary/S in components)
				S.icon_state = primary.icon_state
				S.mana_cost = primary.mana_cost