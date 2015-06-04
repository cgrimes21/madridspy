obj/small/grab	//grabbing takes up hand
	icon_state = "grab"
	icon = 'screen.dmi'
	var/tmp/mob/who	//who is being grabbed
	get_hit_self(mob/M)



		if(src.who && (get_dist(src.who,M)<=1))

			//knock them out
			if(src.who.flags & (DEAD | BLACKOUT))
				return
			if(M.flags & (DEAD | BLACKOUT | HANDCUFFED | STUNNED))
				return
			src.who.ko += 5
			M<<"You knock out [src.who.name]."

			//missions
			if(M.mission)
				if(src.who.mission_id == M.mission.id)
					if(src.who.name == "guard1")
						M.do_objective("koguard1")

			orange(M)<<"[M.name] knocks [src.who.name] out!"
			src.who.flags |= BLACKOUT
			if(istype(src.who,/mob/agent))
				src.who.last_hostile = M.real_name
				src.who.health = -(src.who.mhealth+5)
			game_del(src)

mob
	var

		tmp/mob/grabbed_by				= null
		tmp/obj/small/grab/grabbing 	= null

	proc/do_grab()	//calculate grabbing, called when mob moves

		if((src.flags & GRABBED))	//your being grabbed
			if(src.grabbed_by)
				view(src)<<"[src.name] escapes grab."
				src.flags &= ~GRABBED
				src.grabbed_by.flags &= ~GRABBING
				game_del(src.grabbed_by.grabbing)//DE this might or might not remove grab obj from their screen
				src.grabbed_by = null
			else
				//your flag never got set, your not really being grabbed
				src.flags &= ~GRABBED

		/*
			for(var/mob/M in range(1,src))
				if(M.lh && istype(M.lh,/obj/small/grab))
					var/obj/small/grab/gra = M.lh
					if(M.lh.who == src)
		*/


		var/mob/gr
		var/obj/small/grab/g = src.grabbing
		if(g)	//if you have a grab object, make gr your reference (must be next to you)
			for(var/mob/m in range(1,src))
				if((g.who == m))
					gr = m

			if(gr)	//if the mob your grab belongs to is next to you, move them correspondingly
				gr.loc = src.loc	//keep them close


				if(!(gr.flags & GRABBED))
					gr.flags |= GRABBED
				if(!(src.flags & GRABBING))
					src.flags |= GRABBING

			else//nobody around you, but your grabbing still exists

				debuggers<<"found grab item in [src.name]'s hands but asailant isnt next to them to be grabbed. resetting"
				//no grab anymore
				if(g.who)
					debuggers<<"[g.who] g.who still exists. fixing them"
					g.who.grabbed_by = null
					g.who.flags &= ~GRABBED

				game_del(src.grabbing)
			//	src.grabbing = null
				src.flags &= ~GRABBING




	agent
		var/tmp/grab_cool_down = 0 //1 second
		verb
			grab()
				if(src.grab_cool_down > world.time)
					src<<"cooldown"
					return
				if(prob(40))
				//	src<<"you failed to grab"
					src.grab_cool_down = world.time + 20
					return
				else
					src.grab_cool_down = world.time + 10

				if(src.lh&&src.rh)	//one must be free
					src<<"Your hands are full"
					return
				if((src.flags & GRABBING) && src.grabbing)	//your already grabbing
					return
				if(src.flags & (DEAD | STUNNED | BLACKOUT | STUCK | HANDCUFFED | PULLED | CANTMOVE))//cant grab while doing this
					return
				if((src.flags & GRABBED) && src.grabbed_by)	//if both are on, your being grabbed. deny
					return


				var/obj/small/grab/g
				var/mob/M

				for(var/mob/m in get_step(src,src.dir))

					if(m.flags & (GRABBING |DEAD | BLACKOUT ) )//the person your grabbing cant already be grabbing someone else and
						continue
																//cant be dead, they cant be currently grabbed,
					if((m.flags & GRABBED) && M.grabbed_by)					//they are grabbed? lets look further
						continue

					if(m.dir != src.dir)
						continue
					M = m

			//	var/mob/M = locate(/mob) in get_step(src,src.dir)

				if(M)
					if(M.flags & (GRABBING |DEAD | BLACKOUT ) )//the person your grabbing cant already be grabbing someone else and
						return
																//cant be dead, they cant be currently grabbed,

					if((M.flags & GRABBED) && M.grabbed_by)					//they are grabbed? lets look further
						return


					if(M.dir == src.dir)//turn(src.dir,90))
						//facing their back
						g = new
						g.who = M
						M.pulling = null	//no pulling when your grabbed
						src.pulling = null	//you lose it too
						g.desc = "In this hand, you are grabbing [g.who.name]. Click to knockout [g.who.name]."
						if(!src.lh)
							src.lh = g

							g.screen_loc = gui_LH
						else
							src.rh = g

							g.screen_loc = gui_RH

						src.grabbing = g
						src<<"You grab [M.name]."
						orange(src)<<"[src.name] grabs [M.name]!"

						M.grabbed_by = src
						M.stuck += 3	//when this runs out, you can walk again, and when you do you will release their hold
						if(src.client)
							src.client.screen += g

						src.flags |= GRABBING
						M.flags |= GRABBED
						M.loc = src.loc