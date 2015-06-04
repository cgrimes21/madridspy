
/proc/spawn_object(type,loc,side=0,mdura=0,dura=0)
	var/obj/small/s = new type (loc)
	s.version = side
	s.mdura = mdura
	s.dura = dura
	s.set_stats()
	s.set_desc()
	s.owned = FALSE
	spawn( 2700 )
		if(s)
			s.poof_check()
		return
	return

/obj/small/proc/set_stats()	//update/create obj based on durabilities.

	return


/obj/small/proc/set_desc()	//resets description based on variables

	return

/obj/small/proc/throwing(t_dir,steps,mob/who)

	if(!src) return
	if(!steps)
		steps = 1
	src.throwing = 1
	src.density = 1

	while((steps>=0))
		if(!src.throwing)
			src.density = 0
			src.throwhit(who)
			return
		steps --
		step(src,t_dir)
		sleep(1)
	//didnt hit anything, let it know its done
	src.throwing = 0
	src.density = 0
	src.throwend(who)

obj/small/Bump(atom/a)	//src bumps a
	if(src.throwing)
		src.throwing = 0

		return
	..()

/*
mob/verb/throwrighthand()
	if(src.rh)
		src.throw_item(src.rh)
*/
/obj/small/proc/throwhit(atom/who)	//src hits who

/obj/small/proc/throwend(atom/who)	//throw is ended, if your a smoke bomb we should go off right now

/obj/small/proc/break_r(mob/M)	//called when durability reaches zero
	if(!M)
		if(istype(src.loc,/mob))
			M = src.loc
			//who it belongs to so we can tell them the message

	if(!src.mdura)
		return		//can't break

	if(src.dura<=0)


		if(M)
			M<<"[src.name] has fallen apart!"
			M.recalc_stats()
			M.refresh_overlays()
			M.refresh_clothings()
		game_del(src)
	return

/obj/small/proc/poof_check()	//garbage collection

	if(!src.owned)
		var/found = FALSE
		for(var/mob/m in oview(1,src))
			found = TRUE
		if(!found)
			game_del(src)
		else
			spawn( 30 )
				if(src)
					src.poof_check()
				return
	return
	/*	Honestly think i wont need this. dropping items changes owned to zero. Selling does too.
		However its always good to code robustly, so check this out when you host. How many stray objects are there
		whos owner remains 1.


	else	//its owned, lets double check
		var/found = FALSE
		for(var/mob/m in range(1,src))
			//If inside, will locate mob holding
			//if on turf, will locate mob next to item
			found = TRUE
		if(istype(/obj,src.loc)	//inside an object (vendor,

		if(!found)		//nothing is found, its not owned.
*/


/obj/small/proc/dropped(mob/M)	//called when item is dropped
	oviewers(M)<<"[M.name] drops the [src.name]."
	src.add_fingerprint(M)
	src.owned = 0
	src.remove_durability(1)
	if(!src)//it was deleted
		return

	M.recalc_stats()
	M.refresh_overlays()
	M.refresh_clothings()

	if(M.elevation>0)
		src.elevation = M.elevation
		src.invisibility = M.elevation
		src.layer = M.layer - 0.5



	spawn( 2700 )
		if(src)
			src.poof_check()		//collect garbage so things dont accumulate
		return
	play_sound(M,M.loc,'sounds/three/rustle5.ogg',0)
	return

/obj/small/proc/hit()		//called when mob is hit

	if(!src.mdura)
		return

	remove_durability(roll(2,4))
	return

/obj/small/proc/pickup(mob/M)	//called when mob picks it up

	src.add_fingerprint(M)
	oviewers(M)<<"[M.name] gets the [src.name]."

	if(!src.last_owned)
		src.last_owned = M.name
	else
		if(src.last_owned != M.name)
			src.last_owned = M.name
	src.owned = 1

	src.elevation = 0
	src.invisibility = 0
	src.layer = OBJ_LAYER
	src.set_stats()
	M.recalc_stats()
	M.refresh_overlays()
	play_sound(M,M.loc,'sounds/three/rustle5.ogg',0)
	return

/obj/small/proc/death()	//called when mob dies

	if(!src.mdura)
		return

	src.remove_durability(roll(2,4))
	return



//No add durability because the only time you do that is if your repairing something, which will
//be called in repairs utility


/obj/small/proc/remove_durability(newvalue=0)

	if(!src.mdura)
		return
	src.dura -= newvalue
	if(src.dura <= 0)
		src.break_r()
	src.set_stats()			//resets stats based on durability

	src.set_desc()			//reset desc based on stats

	return



/obj/small/explode()
	..()
	src.remove_durability(roll(2,4))
	return