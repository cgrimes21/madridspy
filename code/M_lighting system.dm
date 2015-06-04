
area
	light_level(level = src.lighted as num)
		if(!src) return
		overlays -= light_image

		level = min(max(level,0), 4)
		if(level>0)
			src.luminosity = 1
		else
			src.luminosity = 0

		//safe_ss_l4_8_1



		light_image = image('light.dmi',,num2text(level),990)



		//Im going to add a sort of icon-joining to this

		var/di = 0 //the direction it is, now lets figure it out

		var/turf/A = locate(/turf) in src




		var/turf/up = get_step(A,NORTH)
		var/turf/down = get_step(A,SOUTH)
		var/turf/left = get_step(A,WEST)
		var/turf/right = get_step(A,EAST)


		if(up)
			world<<"Level[level] compared to [up.lighted]"
			if(min(max(up.lighted, 0),4) == level)

				di |= NORTH
			else
				di &= ~NORTH
		if(down)
			if(min(max(down.lighted, 0),4) == level)
				di |= SOUTH
			else
				di &= ~SOUTH
		if(left)
			if(min(max(left.lighted, 0),4) == level)
				di |= WEST
			else
				di &= ~WEST
		if(right)
			if(min(max(right.lighted, 0),4) == level)
				di |= EAST
			else
				di &= ~EAST


		/*
		10 = top right corner
		9 = bottom edge

		*/

	//	if(di == 5)//10(topright)


			//A.overlays = null
			//A.overlays += image('agent.dmi')


		overlays += light_image







atom

	strip_light(list/L = view(src.luminosity,src), center = src)

		for(var/turf/T in L)
			var/area/t = T.loc
			if(t)
				if((!istype(t,/area/inside)) && (!night))	//if its outside and not night
					continue

				T.lighted -= (src.luminosity-get_dist(center,T))


				T.lighted = max(0,T.lighted)	//interfering w/ flashlights

			//	T.lighted = min(max(T.lighted, 0),4) //cap
				T.lum_update()
atom
	proc
		update_light(list/L = view(src.luminosity,src), center = src)
			//L is a list of everything you can see within luminosity
			if(src.luminosity > 6)
				src.luminosity = 6
			for(var/turf/T in L)

				//do some runs on T
				var/area/t = T.loc
				if(t)
					if((!istype(t,/area/inside)) && (!night))	//if its outside and not night

						continue

					//if it is inside, it will break
					//if it is outside and it is night, it will break
					//if it is outside and not night, it will not break and return


					T.lighted += (src.luminosity-get_dist(center,T))
					//T.lighted = min(max(T.lighted, 0),4)	//cap it at 4
					T.lum_update(src)
			//when its done, apply effects

turf
	proc/lum_update(var/space)
		var/area/Loc = loc	//the area
		if(!istype(Loc)) return

		var/light = min(max(src.lighted, 0),4)

		var/ltag = copytext(Loc.tag, 1, findtext(Loc.tag, "_ss_l")) + "_ss_l[light]"








		if(Loc.tag != ltag)		//if the current area's light matches this turfs light, then
								//theres nothing to do, so skip. if not, go below
								//in other words, if the areas tag doesnt match the light
								//in turf, update that area to match it

			var/area/A = locate(ltag)
			if(!A)		//the area doesn't exist, create one

				A = new Loc.type()				//new area with same variables
				for(var/V in Loc.vars-"contents")
					if(issaved(Loc.vars[V])) A.vars[V] = Loc.vars[V]
				A.tag = ltag
				A.light_level(light)	//update the light for this area

			A.contents += src	//what this does is allow you to see overlays on the turfs
								//when an overlay is placed over the area. When an overlay
								//is placed over an area that overlay also is placed over
								//turfs in the area, aka turfs in A.contents.
proc
	load_light()
		//initializes the world light system
		wlog<<"[get_time()] loading light"
		night = 0

		for(var/area/A in world)
			for(var/turf/C in A)
				C.lighted = 0
			A.light_level(0)

		for(var/area/B in world)
			if(!(istype(B, /area/inside)))
				for(var/turf/D in B)
					D.lighted = 4

				B.light_level(4)
		wlog<<"[get_time()] end load light"






proc
	day(t = 0)	//automatically 1 for day, 0 for night

		if(!t)


			for(var/area/A in world)

				if(!(istype(A, /area/inside)))
					for(var/turf/B in A)

						B.lighted = 0


					A.tag = "[A.name]"
					A.light_level(0)	//night
					night = 1

			for(var/obj/other/light/l in world)
				if(l.on)
					l.strip_light()
					l.update_light()




		else

			for(var/area/A in world)
				if(!(istype(A, /area/inside)))
					for(var/turf/B in A)
						B.lighted = 4

					A.tag = "[A.name]"
					A.light_level(4)	//day
					night = 0

