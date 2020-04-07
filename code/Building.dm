proc/build(mob/M, in_front = 0, T, TL = null, not_on_floor = 1) // T is the default built type, TL the one for boats
	if(M.z == 1) return
	if(!TL)
		if(ispath(T,/turf))
			TL = null
		else
			TL = T

	var/turf/build_loc

	build_loc = M.loc

	if(!build_loc) return

	for(var/atom/A in build_loc)
		if(istype(A,/turf)||istype(A,/obj))
			if(A.density)
				return

	if(istype(build_loc, /turf/underground/dirtwall) || istype(build_loc, /turf/holowall) ||\
	   istype(build_loc, /turf/trekfloor) || istype(build_loc, /turf/holofloor)) return
	if(not_on_floor && (istype(build_loc, /turf/water/bridgewater) || istype(build_loc, /turf/wooden/rope_bridge))) return
	if(not_on_floor == 1 && (((istype(build_loc, /turf/stone) || \
	 istype(build_loc, /turf/wooden)) && build_loc.density) || istype(build_loc, /turf/stone/stone_floor) || \
	 istype(build_loc, /turf/wooden/wood_floor)) || istype(build_loc, /turf/table)) return

	var/obj/falsewall/O = locate() in build_loc
	if(O && !(istype(T, /turf/wooden/wood_floor) || istype(T, /turf/stone/stone_floor))) return

	if(istype(build_loc, /turf/sky))
		var/turf/sky/S = build_loc
		if(!S.can_build)
			return

	if(istype(build_loc, /turf/water/))
		if(locate(/obj/boat) in build_loc)
			if(!TL) return
			var/atom/B = new TL(build_loc)
			B.building_owner = M.key
			return B
		else
			return
	else if(istype(build_loc, /turf/wooden/rope_bridge))
		if(!TL) return
		var/atom/B = new TL(build_loc)
		B.building_owner = M.key
		return B
	else
		var/atom/B = new T(build_loc)
		B.building_owner = M.key
		return B