/obj/machinery/floorlayer

	name = "automatic floor layer"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "pipe_d"
	density = 1
	var/turf/old_turf
	var/on = 0
	var/obj/item/stack/tile/T
	var/list/mode = list("dismantle"=0,"laying"=0,"collect"=0)

/obj/machinery/floorlayer/Initialize()
	. = ..()
	T = new/obj/item/stack/tile/floor(src)

/obj/machinery/floorlayer/Move(new_turf,M_Dir)
	..()

	if(on)
		if(mode["dismantle"])
			dismantleFloor(old_turf)

		if(mode["laying"])
			layFloor(old_turf)

		if(mode["collect"])
			CollectTiles(old_turf)


	old_turf = new_turf

/obj/machinery/floorlayer/attack_hand(mob/user as mob)
	on=!on
	user.visible_message("<span class='notice'>[user] has [!on?"de":""]activated \the [src].</span>", "<span class='notice'>You [!on?"de":""]activate \the [src].</span>")
	return

/obj/machinery/floorlayer/attackby(var/obj/item/W as obj, var/mob/user as mob)

	if (W.iswrench())
		var/m = input("Choose work mode", "Mode") as null|anything in mode
		mode[m] = !mode[m]
		var/O = mode[m]
		user.visible_message("<span class='notice'>[usr] has set \the [src] [m] mode [!O?"off":"on"].</span>", "<span class='notice'>You set \the [src] [m] mode [!O?"off":"on"].</span>")
		return

	if(istype(W, /obj/item/stack/tile))
		user << "<span class='notice'>\The [W] successfully loaded.</span>"
		user.drop_item(T)
		TakeTile(T)
		return

	if(W.iscrowbar())
		if(!length(contents))
			user << "<span class='notice'>\The [src] is empty.</span>"
		else
			var/obj/item/stack/tile/E = input("Choose remove tile type.", "Tiles") as null|anything in contents
			if(E)
				user <<  "<span class='notice'>You remove the [E] from /the [src].</span>"
				E.forceMove(src.loc)
				T = null
		return

	if(W.isscrewdriver())
		T = input("Choose tile type.", "Tiles") as null|anything in contents
		return
	..()

/obj/machinery/floorlayer/examine(mob/user)
	..()
	var/dismantle = mode["dismantle"]
	var/laying = mode["laying"]
	var/collect = mode["collect"]
	var/number = 0
	if (T)
		number = T.get_amount()
	user << "<span class='notice'>\The [src] has [number] tile\s, dismantle is [dismantle?"on":"off"], laying is [laying?"on":"off"], collect is [collect?"on":"off"].</span>"

/obj/machinery/floorlayer/proc/reset()
	on=0
	return

/obj/machinery/floorlayer/proc/dismantleFloor(var/turf/new_turf)
	if(istype(new_turf, /turf/simulated/floor))
		var/turf/simulated/floor/T = new_turf
		if(!T.is_plating())
			if(!T.broken && !T.burnt)
				new T.flooring.build_type()
			T.make_plating()
		return T.is_plating()
	return 0

/obj/machinery/floorlayer/proc/TakeNewStack()
	for(var/obj/item/stack/tile/tile in contents)
		T = tile
		return 1
	return 0

/obj/machinery/floorlayer/proc/SortStacks()
	for(var/obj/item/stack/tile/tile1 in contents)
		if (tile1 && tile1.get_amount() > 0)
			if (!T || T.type == tile1.type)
				T = tile1
			if (tile1.get_amount() < tile1.max_amount)
				for(var/obj/item/stack/tile/tile2 in contents)
					if (tile2 != tile1 && tile2.type == tile1.type)
						tile2.transfer_to(tile1)

/obj/machinery/floorlayer/proc/layFloor(var/turf/w_turf)
	if(!T)
		if(!TakeNewStack())
			return 0
	w_turf.attackby(T , src)
	return 1

/obj/machinery/floorlayer/proc/TakeTile(var/obj/item/stack/tile/tile)
	if(!T)	T = tile
	tile.forceMove(src)

	SortStacks()

/obj/machinery/floorlayer/proc/CollectTiles(var/turf/w_turf)
	for(var/obj/item/stack/tile/tile in w_turf)
		TakeTile(tile)
