mob
	Move(var/alo, var/b)
		if(istype(src, /mob/agent))
			var/mob/agent/a = src
			if(a.buy_contents)
				a.buy_contents = null

		if(src.client)
			if(src.client.eye != src)
				src.client.eye = src

		if(src.stuck>0)
			return

		var/turf/older = src.loc
		if(src.slash)


			if(prob(70+src.slash))	//more your hurt, the more random you walk
				b = pick(NORTH,SOUTH,EAST,WEST,NORTHWEST,SOUTHWEST,SOUTHEAST,NORTHEAST)-b
				alo = get_step(src.loc,b)

		..(alo,b)
		if(src.client)
			for(var/image/l in src.client.images)
				if(l.icon == 'light.dmi')
					del l
		for(var/obj/other/light/ll in range(2,src))
			if(ll.flags & INV_LIGHT)
				continue	//dont do anything with these

			if((ll.flags) & LIGHT)//invisibility == 1)
				src<<image(ll.icon,ll,ll.icon_state,dir=ll.dir)

		//update shadows as you move into them
		var/turf/T = src.loc
		if(T)
			src.shadow = min(max(T.lighted,0),4)
		//pull anyone in your pulling

		if(src.pulling)
			if(!(istype(src.pulling, /obj)))	//not an object
				var/mob/s = src.pulling
				if(!(s.is_Binded()))	//the have to be binded (dead/unconscious/roped)
					src.pulling = null			//you lose them if they arent binded
		//if you didnt lose your pulling due to binding restrictions
		//check if they are 1 or less tiles away from your last turf you were on

		src.do_grab()


		if( (src.pulling) && (get_dist(older, src.pulling) <= 1 || src.pulling.loc == src.loc))
			var/diag = get_dir(src, src.pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, src.pulling) > 1 || diag))
				for(var/mob/M in range(1,src.pulling))
					if(M!=src)	//another guy
						if(M.pulling == src.pulling)	//pulling same guy
							view(src.pulling)<<"[src.name] has been pulled from [M.name]'s grip."
							M.pulling = null
				step(src.pulling, get_dir(src.pulling.loc, older))

		else
			src.pulling = null