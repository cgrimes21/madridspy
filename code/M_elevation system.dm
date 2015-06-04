//a quick elevation system

atom
	var/elevation = 0
	var/oe = 0	//used to save elevation
	var/oer = 0	//used for telling if your jumping off roof
obj
	roof
		var/no_fight = 0
		invisibility = 1

		elevation = 1
	//	icon = 'turfs.dmi'
		icon_state = "roof"

		layer = layer_roof

		New()
			..()

			src.icon = 'turfs.dmi'
			src.invisibility = 1

		edge
			icon_state = "edge"
//var/sound/S = sound('IntrotoOptions.ogg')

turf
	var/busy = 0

	Enter(atom/A)

		///////////////////
		//triggers
		//////////////////
		if(src.kind & turf_type_barrier)
			if(!src.barrier(A))
				return
				//if it returns zero, return

		if(src.kind &  turf_type_trigger)
			if(!src.triggered(A))
				return

		if(src.kind & turf_type_trap)
			if(!src.trapped(A))
				return

		if(src.kind & turf_type_waypoint)
			if(!src.waypoint(A))
				return

		if(istype(A, /mob))
			A.oer = A.elevation

			if(!src.density || (src.elevation < A.elevation))
				var/mob_find = 0
				var/obj_find = 0
				for(var/mob/m in src)
					if(m.density)
						if(m.elevation == A.elevation)
							mob_find = 1
				for(var/obj/of in src)
					if(of.density)
						if(of.elevation == A.elevation)
							obj_find = 1


				if(mob_find)
					return 0
				if(obj_find)
					return 0

				return 1

			else
				return 0
		if(istype(A,/obj))
			A.oer = A.elevation
			if(!A.density)
				return 1	//let em go

			if(!src.density || (src.elevation < A.elevation))
				var/mob_find = 0
				var/obj_find = 0
				for(var/mob/m in src)
					if(m.density)
						if(m.elevation == A.elevation)
							mob_find = 1
				for(var/obj/of in src)
					if(of.density)
						if(of.elevation == A.elevation)
							obj_find = 1


				if(mob_find)
					return 0
				if(obj_find)
					return 0

				return 1

			else
				return 0

			//return 1	//its something other than a mob (obj) let it go

	Entered(mob/M)

		/////////////
		//triggers//
		////////////

		if(src.kind & turf_type_barrier)
			src.barrier(M,1)
		if(src.kind & turf_type_trigger)
			src.triggered(M,1)
		if(src.kind & turf_type_trap)
			src.trapped(M,1)
		if(src.kind & turf_type_waypoint)
			src.waypoint(M,1)


		src.busy += 1


		if(istype(M, /mob/agent))
			//var/mob/agent/P = M

			if(M.scoping)
				M.scoping = 0

				if(M.client)
					M.client.eye = M
					for(var/obj/scope_arrow/a in M.client.screen)
						game_del(a)

			var/obj/roof/R = locate(/obj/roof) in src
			if(R && (M.elevation >= R.elevation))
				M.elevation = R.elevation
				M.see_invisible = R.elevation
				M.invisibility = R.elevation
				M.layer = layer_mob_on_roof
				if(M.elevation >=1)
					M.sight |= (SEE_OBJS|SEE_TURFS|SEE_MOBS)
			//	else
				//	M.sight &= ~(SEE_OBJS|SEE_TURFS|SEE_MOBS)
				//	if(M.
			else	//no R
				//M.hit(rand(15,22))
			//	if(M.elevation>src.elevation)
					//falling
					//M.last_hostile = "" disputeable (pushing people off roofs)



				M.elevation = src.elevation
				M.see_invisible = src.elevation
				M.invisibility = src.elevation
				M.layer = MOB_LAYER
				if(M.elevation >=1)
					M.sight |= (SEE_OBJS|SEE_TURFS|SEE_MOBS)
				//else
				//	M.sight &= ~(SEE_OBJS|SEE_TURFS|SEE_MOBS)
				if(locate(/obj/other/ladder) in M.loc)
					return	//deal no damage

				if(M.oer > M.elevation)

					var/hit_guy=0
					M.oer = M.elevation
					for(var/mob/ab in M.loc)
						if(ab == M)
							continue
						//deal damage
						ab.get_hit(M, new /obj/small/weapon/hands, damage=27)

						hit_guy = 1
						if(istype(ab,/mob/npc))

							var/mob/npc/nn = ab
							nn.knocked_out += 20


					//M.last_hostile = null
					//I commented the above out because this would make pushing off the roof and killing
					//possible. you would get the credit if you hit him and he jumped off the roof and died
					//PLAY around with this
					if(!hit_guy)

						M.hit(rand(6,8))
						M.sight &= ~(SEE_OBJS|SEE_TURFS|SEE_MOBS)
						M.stuck += 5

						M.fell += 5
					//if you didnt hit anybody, you fell. your stunned



mob/proc/grapple()
	if(src.is_Binded())
		return

	var/obj/roof/check = locate(/obj/roof) in src.loc
	if(check)
		if(check.elevation > src.elevation)
			return //cant jump inside/below a roof
	var/turf/t = get_step(src,src.dir)
	if(istype(t, /turf/wall))
		src.elevation = 1
		step(src,src.dir)
	/*
	src.elevation += 1
	src.layer = 50
	src.see_invisible = src.elevation
	src.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)

*/