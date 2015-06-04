obj/door/tut1_door
	side = "tut1"

	icon_state = "securedoor1"

	deny = ""
	openin = "securedoorc0"
	closin = "securedoorc1"
	o = "securedoor0"
	c = "securedoor1"
	spw = 6
	opensound = 'turretdoor.ogg'
	closesound = 'turretdoor.ogg'
	timeopen = 5
	opacity = 0

turf/tutorial1
	icon = 'tut1icons.dmi'
	New()
		..()
		src.icon_state = copytext(src.icon_state,1,length(src.icon_state))

	tut1_begin
		icon_state = "tut1_beginx"
		kind = turf_type_trigger


	//	New()
	//		..()
	//		src.icon_state = "tut1_begin"

		triggered(mob/m, inside=0)
			.=1
			if(!inside) return	//must be inside the turf to trigger
			if(!m) return
			if(!istype(m,/mob)) return
			if(!m.client)	return
			//only players

			if(!("tut1" in m.completed_missions))	//havent done mission, lets see..
				if(m.mission)						//if on a mission, check to
													//see if its the current mission, if they havent gotten d1 yet show it to them
					var/mission/tutorial1/ty
					if(istype(m.mission,/mission/tutorial1))
						ty = m.mission

					if(ty && (!ty.d1))
						var/mission/tutorial1/t = new()
						m.mission = t
						t.begin(m)
						return

				else
					var/mission/tutorial1/t = new()
					m.mission = t
					t.begin(m)


	tut1_1nopass
		icon_state = "tut1_1nopassx"
		kind = turf_type_barrier


	//	New()
	//		..()
	//		src.icon_state = "tut1_1nopass"
		/////
		//the turf that wont let you pass the first cell door without knocking out the guard
		////

		barrier(mob/m, inside=0)
			.=1

			if(inside) return //dont call it when they entered
			if(!m) return
			if(!istype(m,/mob)) return
			//only check for mobs


			if(m.mission && istype(m.mission,/mission/tutorial1))
				var/mission/tutorial1/t = m.mission
				if(t.ko_guard)//they knocked out the guard, let them through
					return
				else
					return	0	//deny

		tut1_nopass_hideguard
			icon_state = "tut1_nopass_hgx"
			kind = turf_type_barrier | turf_type_trigger
			New()
				..()
				src.icon_state = "tut1_nopass_hg"

			triggered(mob/m, inside=0)
				.=1
				if(!inside) return	//must be inside the turf to trigger
				if(!m) return
				if(!istype(m,/mob)) return
				if(!m.client)	return
				//only players

				//npc will stop you, you will move onto part 5. passing security
				if(m.mission && istype(m.mission,/mission/tutorial1))
					if(istype(m.part,/mission/tutorial1/part4))	//move them on

						var/mission/tutorial1/part5/p = new
						m.part = p
						p.begin(m)

			barrier(mob/m, inside=0)
				.=1
				if(inside) return
				if(!m) return
				if(!istype(m,/mob)) return

				if(m.mission && istype(m.mission,/mission/tutorial1))
					var/mission/tutorial1/t = m.mission
					var/turf/tt = t.guard1.loc
					if(locate(/obj/decals/bed) in tt)	//under a bed
						return
					else
						return 0 //deny




mob/npc/inside_mole

