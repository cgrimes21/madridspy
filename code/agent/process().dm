mob/agent/process()
	//every 1 second
	..()
	//call mob/process()

	//their life control and status control
	ticks ++

	if(!src.x || !src.y || !src.z)
		src.loc = locate(src.lx,src.ly,src.lz)
	//prevents them from getting stuck

	if(!(ticks % 5))	//update your shadow every 5 seconds
	////set your shadow
		var/turf/t = src.loc
		if(t)
			src.shadow = min(max(t.lighted,0),4)
			var/obj/small/clothing/vest/sneak_suit/c = locate(/obj/small/clothing/vest/sneak_suit) in src
			if( c && c.worn)

				c.blend = src.shadow
				src.icon = src.oicon


				var/n = (25.75*c.blend)
				src.icon += rgb(0,0,0,n)
			//src.refresh_overlays()


	////xray
	//src.client.view = "5x6"
//	src.client.eye = locate(src.x,src.y-2,src.z)
	///////
	/*if(src.timesaid)
		src.timesaid -= 1
		if(src.timesaid < 0)
			src.timesaid = 0
			src.overlays = null
	*/
	if(src.next_search)		//if its next search, reduce
		src.next_search -= 1

	if(src.stuck>0)
		src.flags |= STUCK
		src.stuck -= 1
		if(src.stuck <= 0)
			src.flags &= ~STUCK



	if(src.stun>0)
		src.stun -= 1

	if(src.blood_rating)		//goes down very very slowly
		src.blood_rating -= 0.05

	if(src.blinded > 0 )
		src.sight |= BLIND
		src.blinded -= 1
		if(src.blinded <= 0)
			src.sight &= ~BLIND
			src.blinded = 0
		//the only way this doesnt interfere with blind = -1 is because it scans if it is above zero first, then counts down

	if(src.blinded==-1)
		src.sight |= BLIND





	//DE remove after playtest
	if(src.poison)
		src.poison -= 1
		src.hit(roll(2,2),"poison")

	var/orig = src.icon_state

	//src.sight &= ~BLIND

	src.icon_state = initial(src.icon_state)

	///vendor
	/*
	var/oldvendor = src.buy_contents
	src.buy_contents = null
	if(locate(/obj/vendor) in view(1,src))
		var/obj/vendor/vend = locate(/obj/vendor) in view(1,src)
		src.buy_contents = vend.contents
		if(src.buy_contents != oldvendor)	//changed
			if(src.client)
				src.client.statpanel = "vendor"
	*/
	if(src.health <=  0)
		if(src.lh)
			src.force_drop_item(src.lh)
		if(src.rh)
			src.force_drop_item(src.rh)

		src.dead_for ++
		if(src.dead_for > (90))		//if your down for 1 1/2 minutes, your dead unless you have
			src.health = -(src.mhealth+10)	//this will kill them
	else
		src.dead_for = 0

	if(!(ticks % src.regen_rate))
		if(src.health > src.mhealth)
			var/e =  src.health - src.mhealth
			src.health -= e

		if(src.health < src.mhealth)
			var/temp = 0
			if(src.health <= 0)
				temp = 2

			src.health += (src.mhealth * ((src.regen+src.rejuv+temp)/100))
			if(prob(79))
				src.bleed()
			if(src.health > src.mhealth)
				var/e = src.health - src.mhealth
				src.health -= e

	if(src.health <= 0)
		src.icon_state = "dead"

	//	src.sight |= BLIND

		if((orig != src.icon_state))	//they were healthy now they arent, black out
			src<<"You have blacked out."

	if(src.health <= -(src.mhealth))
		if(src.last_hostile)
			for(var/mob/m in world)
				if(m.real_name == src.last_hostile)
					src.dead(m)
					return
				//blame it on last hostile
				//if not found, just kill them
		src.dead()
	if(src.fell)
		src.fell --
		src.icon_state = "dead"

	//now lets calc. layers
	src.layer = MOB_LAYER		//defaulr
	if(src.icon_state == "dead")
		src.layer = layer_corpse
