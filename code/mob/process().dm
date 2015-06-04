mob
	process()

		if(!istype(src.Overlays,/list))
			src.Overlays = list()

		if(src.timesaid > 0)
			src.timesaid -= 10
			if(src.timesaid < 0)

				src.timesaid = 0
				for(var/obj/V in Overlays)
					if(istype(V,/obj/balloon))// == "balloon")
						game_del(V)
				src.refresh_overlays()


		if(src.flags & GRABBING)
			if(src.is_Binded())	//your binded
				if(src.grabbing)	//your holding it in your hand, remove it. process() should reset the other mob being affected
					game_del(src.grabbing)
				src.flags &= ~GRABBING

			if(src.grabbing && src.grabbing.who)
				if(get_dist(src.grabbing.who,src)>=1)//your guy isnt around anymore, gotta be zero spaces away
					game_del(src.grabbing)
					src.flags &= ~GRABBING




			else	//obviously you arent grabbing then, so reset flag
				src.flags &= ~GRABBING
				if(src.grabbing)	//lets say src.grabbing.who logs out, this will be null and now we need to tie up loose ends
					game_del(src.grabbing)

		if(src.flags & GRABBED)
			if(src.grabbed_by)

				if(get_dist(src.grabbed_by,src)>=1)//your guy isnt around anymore
					src.grabbed_by = null
					src.flags &= ~GRABBED

				if(src.grabbed_by && src.grabbed_by.grabbing)
					if(src.grabbed_by.grabbing.who != src)//your grabber has somebody else as their grabee, your not being grabbed anymore
						src.grabbed_by=null
						src.flags &= ~GRABBED
				else
					//hes not grabbing you anymore
					src.grabbed_by = null
					src.flags &= ~GRABBED

			else
				src.flags &= ~GRABBED







				//every 1 second
		..()
		//call mob/process()

		//their life control and status control
		ticks ++
		if(!src.loc)
			src.loc = locate(src.spawnx,src.spawny,src.spawnz)
		//if(!src.x || !src.y || !src.z)
		//	src.loc = locate(src.lx,src.ly,src.lz)
		//prevents them from getting stuck

		//src.refresh_overlays()
		if(!(ticks % 5))	//update your shadow every 5 seconds
		////set your shadow
			var/turf/t = src.loc
			if(t)
				src.shadow = min(max(t.lighted,0),4)
			/*
				var/obj/small/clothing/vest/sneak_suit/c = locate(/obj/small/clothing/vest/sneak_suit) in src
				if( c && c.worn)

					c.blend = src.shadow
					src.icon = src.oicon


					var/n = (25.75*c.blend)
					src.icon += rgb(0,0,0,n)
			*/	//src.refresh_overlays()


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
		//for any reason you aren't capable of holding things, make them drop

		if(locate(/obj/effect/smoke) in view(6,src))

			for(var/obj/effect/smoke/m in view(6,src))
				if(m in src.Imager)
					return

				var/image/sb

				if((m.home == src) || (m.special == src))

					sb = new('effects.dmi',loc=m,icon_state="smoke2blank",layer=layer_smoke)
				else
					sb = new('effects.dmi',loc=m,icon_state="smoke2",layer=layer_smoke)



				if(!(m in src.Imager))
					//src.Imager += sb
					src.Imager += m
					src<<sb
		/*
			src.client.images = list()
			for(var/image/ii in src.Imager)
				src<<ii
*/





		if(src.w_cuff || src.ko>0 || src.health<=0 )	//anything cuffed, if your knocked out, or health below zero,
			src.pulling = null
			if(src.lh)
				src.force_drop_item(src.lh)
			if(src.rh)
				src.force_drop_item(src.rh)

		var/mob/agent/agent
		if(istype(src,/mob/agent))
			agent = src


		if(agent && agent.next_search)		//if its next search, reduce
			agent.next_search -= 1


		src.flags &= ~STUCK
		src.flags &= ~STUNNED
		src.flags &= ~BLINDED
		src.flags &= ~BLACKOUT
		src.flags &= ~DEAD
		src.flags &= ~CANTMOVE

		if(!src.can_move)
			src.flags |= CANTMOVE

		if(src.stuck>0)
			src.flags |= STUCK
			src.stuck -= 1

		if(src.stun>0)
			src.flags |= STUNNED
			src.stun -= 1


		if(src.blood_rating)		//goes down very very slowly
			src.blood_rating -= 0.05


		src.sight = 0
		src.sight &= SEE_PIXELS
		if(src.elevation >=1)
			src.sight |= (SEE_OBJS|SEE_TURFS|SEE_MOBS)



		if(src.blinded > 0 )
			src.flags &= BLINDED
			src.sight |= BLIND
			src.blinded -= 1
			if(src.blinded <= 0)
				src.sight &= ~BLIND
				src.blinded = 0
			//the only way this doesnt interfere with blind = -1 is because it scans if it is above zero first, then counts down
		else
			if(src.w_head)
				if(istype(src.w_head, /obj/small/clothing/mask/swat_thermal))
					src.sight |= SEE_MOBS




		if(src.blinded==-1)
			src.sight |= BLIND





		//DE remove after playtest
		if(src.poison)
			src.poison -= 1
			src.hit(roll(2,2),"poison")

		if(src.slash)
			src.slash -= 1
			step(src,pick(NORTH,SOUTH,EAST,WEST))

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

			if(agent)
				agent.dead_for ++

				if(agent.dead_for > (90))		//if your down for 1 1/2 minutes, your dead unless you have
					agent.health = -(agent.mhealth+10)	//this will kill them
		else
			if(agent)
				agent.dead_for = 0

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
			src.flags |= BLACKOUT

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



		if(src.ko>0)
			if(src.lh)
				src.force_drop_item(src.lh)
			if(src.rh)
				src.force_drop_item(src.rh)
			if(istype(src,/mob/agent))
				src.ko -= 1
				//only allow players to wake up, guards will remain until woken up by ally
			src.flags |= BLACKOUT
			src.icon_state = "dead"

		src.pixel_x = 0
		src.pixel_y = 0

		if(src.grabbed_by)
			var/mob/g = src.grabbed_by

			if(g)
				switch(g.dir)
					if(1) pixel_y=8
					if(2) pixel_y=-8
					if(4) pixel_x=8
					if(8) pixel_y=-8
			//GE	src.dir = turn(g.dir,180)
			//now lets calc. layers
		src.layer = MOB_LAYER		//defaulr

		if(src.elevation >= 1)
			src.layer = layer_mob_on_roof



		if(src.icon_state == "dead")
			src.layer = layer_corpse