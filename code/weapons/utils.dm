proc
	balance_gun()
		return
		//the strongest gun will be able to shoot you down in approx. 7 seconds
//maybe put a 2-3 second delay on equipping equipment

/obj/small/weapon/proc/uequip(mob/a)

	if(usr.is_Binded(1))
		return
	if(src.suffix == "equipped")
		switch(src.body_loc)
			if(RIGHT_HAND)
				a.hand = null
			if(SLEEVE)
				a.sleeve = null
			if(BOOT)
				a.boot = null
		src.suffix = ""
		a<<"You unequip [src.name]."
		a.recalc_stats()
	return

/obj/small/weapon/proc/equip(mob/a)

	if(!src) return
	if(!(src in a)) return
	if(!a) return

	if(!(istype(a, /mob))) return

	if(a.is_Binded(1))	//your binded, you cant be messing with your weapons
		a<<"\blue You can't seem to equip [src.name]."
		return			//the 1 means you can equip weapons if your only STUCK in place
						//and not dead/binded
	if(src.suffix == "equipped")
		src.uequip(a)
		return
	for(var/obj/small/weapon/w in a)
		if(w == src)
			continue

		if(src.body_loc == w.body_loc)		//only one per location
			if(w.suffix == "equipped")		//its equipped, unequip to equip src
				w.uequip(a)		//unequip it, only one weapon at a time

	switch(src.body_loc)
		if(RIGHT_HAND)
			a.hand = src
		if(SLEEVE)
			a.sleeve = src
		if(BOOT)
			a.boot = src
	src.suffix = "equipped"

	a.recalc_stats()
	return

/obj/small/weapon/set_stats()

	var/v = src.dura
	var/vv = src.mdura
	if(!v || !vv)
		return
	var/p = v/vv

	damage *= p
	range *= p
	return
	//both damage and range get halved the more durability is away from max
/*
/obj/small/weapon/drop()

	if(usr.is_Binded(1))
		return

	if(src.suffix == "equipped")
		src.uequip(usr)

	var/mob/agent/a
	if(istype(usr, /mob/agent))
		a = usr
	if(a)
		a.recalc_stats()
	..()
	return

	*/