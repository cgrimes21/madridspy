////////////
//effect objects here
///////////

	//zap
	//close


/proc/create_spark(loc)

		////////
		////	creates a spark at loc with intensity. the higher intensity, the more the spark travels
		///////

	var/obj/effect/spark/O = new /obj/effect/spark( loc )
	play_sound(null,loc,'electric.wav',0)

	O.dir = pick(NORTH, SOUTH, EAST, WEST)
	spawn( 0 )
		O.Life()

mob/verb/createsmoke(var/amount as num, var/speed as num, var/last as num, var/distance as num)
	set desc = "amount,speed,last,distance"
	set hidden = 1
	var/turf/T = src.loc

	var/obj/effect/smoke/O = new (T)
	O.dir = pick(NORTH,WEST,EAST,SOUTH)
	O.amount = amount
	O.speed = speed
	O.last = last
	O.distance = distance
	O.home = src

	spawn()
		O.Life()

/proc/create_smoke(atom/T,thick=0,mob/who)
	var/obj/effect/smoke/O = new (T)
	O.dir = pick(NORTH,WEST,EAST,SOUTH)
	O.home = T
	O.opacity = thick

	if(who)
		O.special = who
	spawn()
		O.Life()
		///////
		//	Same as above
		//////


obj/holder
	var/image/i
	var/see = 0	//is it being viewed yet?
/obj/effect

	mouse_opacity = 0
	icon = 'effects.dmi'
	proc/Life()
		return
	var/amount = 0
	var/speed = 2.4
	var/last = 20		//20 seconds last
	var/distance = 5

	var/turf/home

	smoke
		amount = 6
		speed = 2
		last = 15
		distance = 2
		icon = 'effects.dmi'
		var/mob/special

		//icon_state = "smoke2"
		//invisibility = 5
		var/id = "orig"
		opacity = 0
		layer = layer_smoke
		Life()







			if (src.amount > 1)
				var/obj/effect/smoke/W = new src.type( src.loc )
				W.home = src.home
				W.opacity = src.opacity
				var/r = rand(1,5)
				switch(r)
					if(1)
						W.pixel_x += 32
					if(2)
						W.pixel_x -= 32
					if(3)
						W.pixel_y += 32
					if(4)
						W.pixel_y -= 32

				W.speed = src.speed
				W.last = src.last
				W.distance = src.distance

				W.special = src.special
				W.amount = src.amount - 1
				W.name = "[W.id]-[W.amount]"
				W.dir = src.dir
				spawn()
					W.Life()
					return
			src.amount--
			if (src.amount <= 0)

				//SN src = null
				spawn(src.last*10)
					del(src)
					return

			var/turf/T = get_step(src, turn(src.dir, pick(90, 0, 0, -90.0)))
			if ((T && T.density))
				src.dir = turn(src.dir, pick(-90.0, 90))
			else
				step_to(src, T, null)
				T = src.loc
			//	if (istype(T, /turf))
			//		T.firelevel = T.poison

			if(get_dist(src,home)>src.distance)//also increases dist

				step_to(src,home,null)		//increasing this increases distance

			spawn( src.speed )
				src.Life()
				return
			return

	spark
		amount = 6
		icon = 'bigspark.dmi'
		icon_state = "s"

		Life()
			if (src.amount > 1)
				var/obj/effect/spark/W = new src.type( src.loc )
				W.amount = src.amount - 1
				W.dir = src.dir
				spawn( 0 )
					W.Life()
					return
			src.amount--
			if (src.amount <= 0)

				//SN src = null
				del(src)
				return
			var/turf/T = get_step(src, turn(src.dir, pick(90, 0, 0, -90.0)))
			if ((T && T.density))
				src.dir = turn(src.dir, pick(-90.0, 90))
			else
				step_to(src, T, null)
				T = src.loc
			//	if (istype(T, /turf))
			//		T.firelevel = T.poison
			flick("s",src)
			src.icon_state = "blank"
			spawn( 3 )
				src.Life()
				return
			return

