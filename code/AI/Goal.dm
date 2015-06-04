mob
	npc

		proc
			Goal()
			//	world<<"CALL MOTHERFUCKER [src.goal]"


				if(src.goal)

					switch(src.goal)

						if(AI_HOSTILE_ATTACK_AREA)

							src.hostile_attack_time += 1
							if(src.hostile_attack_time<15)


								if(src.goal_target)
									src.dir = get_dir(src,src.goal_target)
									//src.goal_target = src.enemy.loc		//keep track of last seen location

									//move to view it
									if(!(locate(src.goal_target) in view(src,6)))
										step(src,get_dir(src,src.goal_target))

									//now attack their location
									var/mob/a = locate(/mob) in src.goal_target	//attacks whoevers in enemy location
									if(a && (!(istype(a, /mob/npc))))

										src.hostile_attack_time = 0	//reset
										var/obj/small/w = src.hand
										if(w)
											w.activate_item(a,src,rand(1,32),rand(1,32))
									else
										//make it look like they are trying
										flick("fire",src)
										src.shoot_sound(10)





								//	if(get_dist(src,src.goal_target)>2)
								//		step(src,get_dir(src,src.goal_target))
								//	else
								//		step(src, pick(NORTH,SOUTH,EAST,WEST))
							else
								src.goal = AI_HOSTILE_SCAN
								src.current_priority = 0.010
								src.scan_walk = 0
								src.scan_dir = NORTH
								src.wait += 2
								src.hostile_attack_time = 0



						if(AI_HOSTILE_SCAN)

							src.wait += 3

							if(get_dist(src,src.goal_target)>0)
								step(src, get_dir(src,src.goal_target))

							else

								step(src,pick(NORTH,SOUTH,EAST,WEST))

							//increment it while AI searches
							src.hostile_scan += 1
							if(src.hostile_scan >= 10)
								//found nothing within a minute, its pretty safe
								src.hostile_scan = 0
								src.wait += 3
								src.goal = AI_CONTINUE_PATROL
								src.current_priority = 0.015	//make them do this before turning lights on
								src.goal_target = null



						if(AI_SCAN_AREA)

							src.wait += 3
							src.Scan_Area()




						if(AI_CHANGED_LIGHT_SWITCHED)
							var/atom/A = src.goal_target

							for(var/atom/l in view(src))
								if(l==A)



									step(src,get_dir(src,l))
									if(get_dist(src,l)<=0)
										if(istype(A,/obj/other/light))
											var/obj/other/light/li = A
											if(!li.on)
												l.interact()

										src.goal = AI_SCAN_AREA
										src.scan_walk = 0
										src.goal_target = null
										//src.dir = pick(NORTH,SOUTH,EAST,WEST)
										src.wait += 5
										src.scan_dir = NORTH
										src.current_priority = 0.020

						if(AI_SEE_ENEMY_ALERT)

							GetEnemy()

							if(src.enemy)

								src.hostile_scan = 0		//reset the count
								src.goal_target = src.enemy.loc		//keep track of last seen location

								//now attack their location
								var/mob/a = locate(/mob) in src.goal_target	//attacks whoevers in enemy location
								if(a && (!(istype(a, /mob/npc))))

									var/obj/small/w = src.hand
									if(w)
										w.activate_item(a,src,rand(1,32),rand(1,32))


									src.hostile_attack_time = 0

								if(get_dist(src,src.goal_target)>4)
									step(src,get_dir(src,src.goal_target))
							//	else
							//		step(src, pick(NORTH,SOUTH,EAST,WEST))
							else
								src.goal = AI_HOSTILE_ATTACK_AREA
							///	src.scan_walk = 0
							//	src.scan_dir = NORTH
							//	src.wait += 4
								src.current_priority = 0.010	//above all else





						if(AI_CONTINUE_PATROL)

							if(src.opatrol)

								for(var/turf/T in world)
									if(src.opatrol == T)

										walk_to(src,T,0,10)

										if(get_dist(src,T)<=0)
											walk_to(src,null)
											src.goal = null
											play_music(src,null,0)
											for(var/mob/M in range(7,src))
												M.current_sound = null

											range(7,src)<<sound(null,0,0,1)

											viewers(src)<<"<b>[src.name]:</b> Must have been my imagination."
											src.goal_target = null
											src.current_priority = 0.020
											src.stress = 0