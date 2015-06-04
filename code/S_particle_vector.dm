vector
	var/
		sx = 1
		sy = 1
		//originals


		posx = 1
		posy = 1

		x = 1
		y = 1

		dir = NORTH	//direction its traveling in
		speed = 0.1	//speed it moves

		last_move = 0

		obj/particle/part

	proc/update_vector()
		if(!src.part) return
		sleep(1)

		if(last_move > world.time)
			return
		last_move = world.time + speed

		switch(dir)
			if(NORTHEAST)
				posy ++
				posx ++
			if(NORTHWEST)
				posy ++
				posx --
			if(SOUTHEAST)
				posy --
				posx ++
			if(SOUTHWEST)
				posy --
				posx--

			if(NORTH)
				posy ++
				posx = sx+rand(-2,2)
			if(SOUTH)
				posy --
				posx = sx+rand(-2,2)
			if(EAST)
				posx ++
				posy = sy+rand(-2,2)
			if(WEST)
				posx--
				posy = sy+rand(-2,2)

		if(posy > 32)
			posy = 1

			y += 1
			dir = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)//-turn(dir,180)	//cant go backwards
			//pick a new direction
		if(posx > 32)
			posx = 1
			x += 1
			dir = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)//-turn(dir,180)

		//now update the image
		if(src.part)
			src.part.x = x

			src.part.y = y

			src.part.pixel_x = posx
			src.part.pixel_y = posy

		//dir = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)

		update_vector()

	New(var/obj/particle/P)
		..()
		part = P

		spawn(100*world.tick_lag)
			part = null



		spawn(1)

			update_vector()

mob/var/tmp/just_set = 0

mob/verb/set_fire()
	set hidden = 1
	if(just_set > world.time)
		return
	just_set = world.time + 600

	for(var/tt = 500, tt>=1, tt--)
		sleep(1)
		var/obj/particle/P = new (src.loc)
		P.invisibility = src.invisibility
		P.layer = src.layer+2

		var/vector/v = new (P)

		v.dir = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)

		v.x = src.x
		v.y = src.y
		v.posx = rand(7,17)
		v.posy = rand(7,17)
		v.sx = v.posx
		v.sy = v.posy





obj/particle
	icon = 'particle.dmi'
	icon_state = "blank"
	layer = MOB_LAYER + 1.1


	New()
		..()
		spawn(2)
			flick("smoke",src)
			spawn(100*world.tick_lag)
				del src
