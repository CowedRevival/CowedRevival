mob/proc/revive()
	var/mob
		observer/C = src
		M
	if(!istype(C) && C.corpse) C = C.corpse
	if(!istype(C)) return

	M = C.corpse
	if(!M) return

	M.key = C.key
	C.loc = null

	M.name = C.name
	M.icon_state = "alive"
	M.HP = M.MHP
	M.HUNGER = M.MHUNGER
	M.THIRST = M.MTHIRST
	M.SLEEP = M.MSLEEP
	M.corpse = null
	C.corpse = null
	M.UpdateClothing()
	hud_main.UpdateHUD(M)

	del C // to not bug summon.