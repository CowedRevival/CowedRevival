map_object
	parent_type = /obj
	icon = 'icons/map_objects.dmi'
	icon_state = "map_object"
	invisibility = 100
	var
		character_handling/container/kingdom
		map_layer //ground
		map_object
			NextLayer
			PrevLayer
	New()
		. = ..()
		icon = null
	Del() return //can't delete this type of object
	proc
		NextLayer()
			if(NextLayer) return NextLayer
			var
				map_object/O
				layer = src.map_layer + 1
			for(O in world) if(O.kingdom == src.kingdom && O.map_layer == layer) break
			NextLayer = O
			return O
		PrevLayer()
			if(PrevLayer) return PrevLayer
			var
				map_object/O
				layer = src.map_layer - 1
			for(O in world) if(O.kingdom == src.kingdom && O.map_layer == layer) break
			PrevLayer = O
			return O