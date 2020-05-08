item/misc
	ingot
		tin_ingot
			name = "Tin Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Tin Ingot"
			stacked = 1

		copper_ingot
			name = "Copper Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Copper Ingot"
			stacked = 1

		tungsten_ingot
			name = "Tungsten Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Tungsten Ingot"
			stacked = 1

		iron_ingot
			name = "Iron Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Iron Ingot"
			stacked = 1

		silver_ingot
			name = "Silver Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Silver Ingot"
			stacked = 1

		gold_ingot
			name = "Gold Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Gold Ingot"
			stacked = 1

		palladium_ingot
			name = "Palladium Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Palladium Ingot"
			stacked = 1

		mithril_ingot
			name = "Mithril Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Mithril Ingot"
			stacked = 1

		magicite_ingot
			name = "Magicite Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Magicite Ingot"
			stacked = 1

		adamantite_ingot
			name = "Adamantite Ingot"
			icon='icons/ores_and_veins.dmi'
			icon_state="Adamantite Ingot"
			stacked = 1

	molten
		molten_tin
			name = "Molten Tin"
			icon='icons/ores_and_veins.dmi'
			icon_state="molten tin"
			stacked = 1

			MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/tin_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/tin_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_copper
			icon_state = "molten copper"
			icon='icons/ores_and_veins.dmi'
			name = "Molten Copper"
			stacked = 1
			MouseDrop(obj/over_object,src_location,turf/over_turf,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_object,/item/misc/key_mold) && (over_object in usr.contents))
					var/item/misc/key_mold/mold = over_object
					new/item/misc/key{icon_state="key_copper"}(usr, mold.keyid)
					if(--stacked <= 0) Move(null, forced = 1)
				else if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/copper_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/copper_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_tungsten
			name = "Molten Tungsten"
			icon='icons/ores_and_veins.dmi'
			icon_state="molten tungsten"
			stacked = 1
			MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/tungsten_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/tungsten_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_iron
			icon='icons/ores_and_veins.dmi'
			icon_state="molten iron"
			stacked = 1
			verb
				build_cannon()
					if(stacked >= 10)
						new/obj/Cannon(locate(usr.x,usr.y,usr.z))
						stacked -= 10
			MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/iron_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/iron_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_silver
			name = "Molten Silver"
			icon='icons/ores_and_veins.dmi'
			icon_state="molten silver"
			stacked = 1
			MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/silver_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/silver_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_gold
			icon='icons/ores_and_veins.dmi'
			icon_state="molten gold"
			name = "Molten Gold"
			stacked = 1
			MouseDrop(obj/over_object,src_location,over_turf,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_object,/item/misc/key_mold) && (over_object in usr.contents))
					var/item/misc/key_mold/mold = over_object
					new/item/misc/key(usr, mold.keyid)
					if(--stacked <= 0) Move(null, forced = 1)
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/gold_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/gold_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_palladium
			name = "Molten Palladium"
			icon='icons/ores_and_veins.dmi'
			icon_state="molten palladium"
			stacked = 1
			MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/palladium_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/palladium_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_mithril
			name = "Molten Mithril"
			icon='icons/ores_and_veins.dmi'
			icon_state="molten mithril"
			stacked = 1
			MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/mithril_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/mithril_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_magicite
			name = "Molten Magicite"
			icon='icons/ores_and_veins.dmi'
			icon_state="molten magicite"
			stacked = 1
			MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/magicite_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/magicite_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_adamantite
			name = "Molten Adamantite"
			icon='icons/ores_and_veins.dmi'
			icon_state="molten adamantite"
			stacked = 1
			MouseDrop(turf/over_turf, src_location,over_location,src_control,over_control,params)
				if(!(src in usr.contents)) return ..()
				if(istype(over_turf, /turf/water))
					if(get_dist(src,over_turf)>1) return ..()
					var/item/misc/ingot/adamantite_ingot/I = locate() in usr
					if(I)
						I.stacked += 1
						I.suffix = "x[I.stacked]"
					else usr.contents += new/item/misc/ingot/adamantite_ingot
					if(--stacked <= 0) Move(null, forced = 1)
					else suffix = "x[stacked]"
				else return ..()

		molten_glass
			name = "Molten Glass"
			icon='icons/ores_and_veins.dmi'
			icon_state="molten glass"
			stacked = 1