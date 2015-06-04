obj/missions
		//we have waypoints and spawns for events
	waypoints
		tutorial1
			tut1	//triggers tutorial1 if havent been through already
				bumped(mob/M)
					if(istype(M))
						if(!M.client)
							M.loc = src.loc
							return	//dont give npcs missions
						//do checks blah blah
						if(!("tut1" in M.completed_missions))	//do this tutorial
							if(M.mission)
								var/mission/tutorial1/ty
								if(istype(M.mission,/mission/tutorial1))
									ty = M.mission
								if(!ty.d1)				//completed part 1 yet?
									var/mission/tutorial1/t = new()
									M.mission = t
									t.begin(M)
							else
								var/mission/tutorial1/t = new()
								M.mission = t
								t.begin(M)

						M.loc = src.loc
						..()
				density = 1