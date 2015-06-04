/*priorities
.010	attack location
.020	everything else for now
*/



proc
	MoveToLocation(location, run=0)

	//move src to location, run=1 will make them run


	MoveToObject(obj, run=0, range=1)


	MoveAwayFromObject(obj/flee, run=0, range=1)

	GetItemPosessor(obj)

	GetItemPosessedBy(src,obj)

	GetLastAttacker(src)

	GetNearestPlayer()





atom
	var
		AI_event






obj/patrol_route
	icon = 'patrol.dmi'
	var/stres = 0
	north
		dir = NORTH
	south
		dir = SOUTH
	east
		dir = EAST
	west
		dir = WEST

	NE
		dir = NORTHEAST
	NW
		dir = NORTHWEST
	SE
		dir = SOUTHEAST
	SW
		dir = SOUTHWEST

	stress
		stres = 1
		icon_state = "stress"
		NE
			dir = NORTHEAST
		NW
			dir = NORTHWEST
		SE
			dir = SOUTHEAST
		SW
			dir = SOUTHWEST
		north
			dir = NORTH
		south
			dir = SOUTH
		east
			dir = EAST
		west
			dir = WEST
	New()
		..()
		src.icon = null
mob
	var/tmp/current_sound

	var/tmp/noav = 0	//if this reaches 30 that means in 30 steps they didnt reach opatrol, so they must be stuck
						//help them out
	npc
		rank = 20


		var/list/route = list()//a list of locations
		var/list/stress_route = list()
		var/patrol = 0		//1 if your patrolling

		var/turf/opatrol
		var/turf/npatrol
		var/stress = 0
		var/goal = null
		var/atom/goal_target
		var/wait = 0			//time in seconds to wait
		var/mob/enemy
		var/current_priority = 0	//the priority of the current goal
		var/hostile_scan = 0		//once this hits 1 minute its back to patrol if not found anything
		var/hostile_attack_time		//when this hits about 30, call hostile scan, if ai hits something this is reset

		var/scan_dir
		var/scan_walk 		//max is 5 tiles walked in scan_dir direction
		var/knocked_out = 0	//the time they are knocked out

		proc
			Bark()		//yells something

			GetEnemy()	//gets closest enemy
				src.enemy = null

				for(var/mob/agent/A in view(src))

					if(A.shadow < 4)
						if(get_dist(A,src) <= A.shadow)
						//they see you
							//lets add a probability
							if(prob( A.shadow * 25 ))		//the lower the shadow, the less chance of being seen
								src.enemy = A
						//they have to be x amount of range away to see you
					else	///it is 4, your light up
						if(prob(90))
							src.enemy = A

					break

			RevealWeapon()
			ConcealWeapon()

			LoadGuns()
				var/obj/small/weapon/gun/Magnum/M = new (src)
				M.Move(src)
				M.equip(src)

			Patrol()
				src.FindRoute()

			OpenDoor()
			CloseDoor()

			FindRoute()

				var/obj/patrol_route/TT = locate(/obj/patrol_route) in src.loc


				if(TT)


					src.dir = TT.dir


					if(TT.dir == NORTHWEST)
						src.dir = pick(NORTH,WEST)
					if(TT.dir == NORTHEAST)
						src.dir = pick(NORTH,EAST)
					if(TT.dir == SOUTHEAST)
						src.dir = pick(SOUTH,EAST)
					if(TT.dir == SOUTHWEST)
						src.dir = pick(SOUTH,WEST)



					step(src,src.dir)
				else
					//no patrol route, attempt to walk to it
					world<<"step to opatrol"
				//	var/turf/Ta
				//	for(var/turf/T in world)
				//		if(T == src.opatrol)
				//			Ta = T


					if(noav > 30)	//they must be stuck
						src.Move(src.opatrol)
						src.noav = 0
					else
						step_towards(src,src.opatrol)
						src.noav += 1








			FindStressRoute()



			Next_Scan_Dir()
				switch(src.scan_dir)
					if(NORTH)
						src.scan_dir = WEST
					if(SOUTH)
						src.scan_dir = EAST
					if(WEST)
						src.scan_dir = SOUTH
					if(EAST)
						src.scan_dir = null	//you should be done


		NoticeSight(A,movement)		//this is only called when an object interacts within range of src.
										//only time this is called basically is when you do something suspicious
										//in front of src.
		guard
			icon='agent.dmi'
			process()
				..()
				src.icon_state = initial(src.icon_state)

				if(src.knocked_out>1)
					src.knocked_out -= 1
					src.icon_state = "dead"
					return

				if(src.wait>0)
					src.wait -= 1

				if(src.patrol)
					if(src.wait<1)
						src.Patrol()


				src.Scout()		//scouts area for anything suspicious

				if(src.wait<1)	//no wait, lets do the goal
					if(src.goal)
						src.Goal()



/*
mob/verb/explode()
	for(var/turf/T in range(1,src))
		T.density = 0
		T.opacity = 0
		T.icon_state = "floor2"
		spawn(160)
			T.density = initial(T.density)
			T.opacity = initial(T.opacity)
			T.icon_state = initial(T.icon_state)


*/
