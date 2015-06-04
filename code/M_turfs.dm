turf
	var
		burnt = 0
		trap = 0
		no_fight = 0
		no_gas = 0
		lighted = 0			//a scale from 0-4 corresponding with mobs shadow variable
							//0 is undetectable, 4 is light up
		charge = 0			//if 1, standing on this tile will charge cells
		interference = 0	//if 1, electrical items will experience interference

		kind

	//inside would be 1 if called under entered()
	//0 if they havent entered turf yet (called under enter())

	proc/barrier(atom/m,inside = 0)
		return 1
	proc/trapped(atom/m, inside=0)
		return 1
	proc/triggered(atom/m, inside=0)
		return 1
	proc/waypoint(atom/m,inside=0)
		return 1
	/*
	Entered(atom/m)
		if(src.kind & turf_type_barrier)
			src.barrier(m,1)
		if(src.kind & turf_type_trigger)
			src.triggered(m,1)
		if(src.kind & turf_type_trap)
			src.trapped(m,1)
		if(src.kind & turf_type_waypoint)
			src.waypoint(m,1)
		..()


	Enter(atom/m)
		//if(src.kind & (turf_type_barrier | turf_type_trigger | turf_type_waypoint | turf_type_trap))

		if(src.kind & turf_type_barrier)
			if(!src.barrier(m))
				return
				//if it returns zero, return

		if(src.kind &  turf_type_trigger)
			if(!src.triggered(m))
				return

		if(src.kind & turf_type_trap)
			if(!src.trapped(m))
				return

		if(src.kind & turf_type_waypoint)
			if(!src.waypoint(m))
				return

		..()
*/
	icon = 'turfs.dmi'

	tree
		icon = 'tree.PNG'
		layer = MOB_LAYER + 5
	tower
		icon = 'tower.png'
		//layer = MOB_LAYER + 5
	wooden_floor
		icon = 'wooden floor.png'
		get_hit(mob/who,obj/small/what)
			if(istype(what,/obj/small/smoke_bomb) || istype(what, /obj/small/bomb) || istype(what,/obj/small/flash_bomb))
				var/d = get_dir(src,who)
				d = turn(d,180)
				var/space = get_dist(who,src)
				who.throw_item(what,d,space)
	gates
		icon = 'gates.png'

	wooden_fence
		icon = 'post fence botton.png'
	brickwall
		icon = 'brickwall.png'
		opacity = 1
		density = 1
		layer = TURF_LAYER - 0.5

	wood
		icon_state = "wood2"
		r
			icon_state = "wood3"
	grass
		icon_state = "grass"
		get_hit(mob/who,obj/small/what)
			if(istype(what,/obj/small/smoke_bomb) || istype(what, /obj/small/bomb) || istype(what,/obj/small/flash_bomb))
				var/d = get_dir(src,who)
				d = turn(d,180)

				var/space = get_dist(who,src)
				who.throw_item(what,d,space)
		New()
			..()
			if(prob(50))
				src.icon_state = "grass2"
		bright
			icon = 'grass.dmi'





	tile
		//lineedit
		icon = 'sixtyfour.dmi'
		icon_state = "tile"
		get_hit(mob/who,obj/small/what)
			if(istype(what,/obj/small/smoke_bomb) || istype(what, /obj/small/bomb) || istype(what,/obj/small/flash_bomb))
				var/d = get_dir(src,who)
				d = turn(d,180)
				var/space = get_dist(who,src)
				who.throw_item(what,d,space)
		tile2
			icon_state = "tile2"

	road
		icon_state = "road"
		get_hit(mob/who,obj/small/what)
			if(istype(what,/obj/small/smoke_bomb) || istype(what, /obj/small/bomb) || istype(what,/obj/small/flash_bomb))
				var/d = get_dir(src,who)
				d = turn(d,180)
				var/space = get_dist(who,src)
				who.throw_item(what,d,space)
	road2
		icon_state = "road2"
		get_hit(mob/who,obj/small/what)
			if(istype(what,/obj/small/smoke_bomb) || istype(what, /obj/small/bomb) || istype(what,/obj/small/flash_bomb))
				var/d = get_dir(src,who)
				d = turn(d,180)
				var/space = get_dist(who,src)
				who.throw_item(what,d,space)
	steel_wall
		icon_state = "steel"
		icon = 'vendor_door.dmi'
		opacity = 1
		density = 1
		explode()
			..()	//do nothing
	water
		invisibility = 101	//nobody can see yet
		density = 1
		icon = 'water.dmi'
		corners
			density = 0
	wall
		icon = 'turfs.dmi'
		icon_state = "wall"
		density = 1
		opacity = 1
		//luminosity = 1
		get_hit_hand(mob/who)
			if(who && (get_dist(who,src)<=1))
				if(who.slip)
					if(prob(2))
						who.loc = src.loc
						return
				who<<"you press on the wall, but nothing happens."
				return
		get_hit(mob/who, obj/small/w)
			if(!who)
				return
			if(!w)
				return
			if(who && (get_dist(who,src)<=1))
				viewers(5,who)<<"[who.name] smashes [w.name] on the wall!"
				play_sound(null,src,'sounds/three/smash.ogg',0)
			//if(w.dest)	//destructable
				w.remove_durability(roll(4,6))

		bumped(atom/a)
			if(istype(a, /mob))
				if(prob(1))
					var/mob/m = a
					var/area/bob
					if(src.loc)
						bob = src.loc

					if(bob && bob.agency)		//they have an agency
						if(m.agency != bob.agency)	//does it match yours? if not dont let them through
							return
					m.loc = src					//otherwise, if bob has agency and matches, or he doesnt, let you through

		explode()

			..()
			src.opacity = 0
			src.density = 0
			src.icon_state = "walle"

			spawn(rand(300,500))
				src.density = 1
				src.opacity = 1
				src.icon_state = "wall"

	vents
		icon = 'vents.dmi'
		tile
			icon_state = "tile"
		exit
			icon_state = "exit"
			var/closed = 1


			interact(mob/M)
				if(M.client)
					M.client.eye = locate(src.x,src.y,1)

			Enter(atom/movable/a)
				//if(istype(a, /mob))
				//	var/mob/aa = a
				var/turf/t = locate(src.x,src.y,1)

				var/obj/vent/opening/o = locate() in t

			//	for(var/obj/vent/opening/o in locate(src.x,src.y,1))
				if(o && (o.closed))
					return 1
				//if there was an opening and it wasnt closed, go through
				//if there wasn't even a vent, treat it the same as an exit anyway
				a.loc = src
				a.z = 1
				play_music(a,null,1,0)
				play_ambience(a)
				return 1




	floor
		icon_state = "floor"
		get_hit(mob/who,obj/small/what)
			if(istype(what,/obj/small/smoke_bomb) || istype(what, /obj/small/bomb) || istype(what,/obj/small/flash_bomb))
				var/d = get_dir(src,who)
				d = turn(d,180)
				var/space = get_dist(who,src)
				who.throw_item(what,d,space)
	grid
		icon_state = "grid"
	fence
		icon_state = "fence"
		density = 1
	border
		icon_state = "border"
	floor2
		icon = 'turfs.dmi'
		//icon = 'sixtyfour.dmi'
		icon_state = "floor2"

		get_hit(mob/who,obj/small/what)
			if(istype(what,/obj/small/smoke_bomb) || istype(what, /obj/small/bomb) || istype(what,/obj/small/flash_bomb))
				var/d = get_dir(src,who)
				d = turn(d,180)
				var/space = get_dist(who,src)
				who.throw_item(what,d,space)

		floor3
			icon_state = "floor3"
			New()
				..()
				if(prob(1.5))
					src.icon_state = "floor2c"