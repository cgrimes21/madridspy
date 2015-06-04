mob/MouseDrop(atom/over)

	//src is dragged to atom/over
	if(!istype(over,/mob))
		return


	if(over!=usr)
		return	//must be you in order to loot someone
	if(over == src)
		return	//no loot yourself


	if(!src.is_Binded())
		return
	if(get_dist(src,over)<=1)

		var/t = FALSE
		for(var/obj/o in src)
			if(istype(o,/obj/small/weapon))
				continue
			if(prob(54))
				t = TRUE
				src.force_drop_item(o)
				var/mob/m = over
				m.do_objective("lootid")
		if(!t)
			over<<"you failed to loot [src.name]"