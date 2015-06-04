//the access definition
var
	//inside agencies

	access_security = 1
obj/var/list/req_access
obj/proc
	allowed()

	check_access(var/obj/small/id_card/id)
		if(!id)
			return 0

		if(!(istype(id)))
			return 0

		if(!(istype(id.req_access,/list)))
			id.req_access = list()

		if(!(id.req_access) || !(id.req_access.len))
			return 1






mob/verb/reset_visuals()
	set hidden = 1
	src.Overlays = list()
	src.icon = 'agent.dmi'
	src.icon_state = ""
	src.Overlays += image('agent.dmi',"shadow")






var/list/logg = list(

/turf/grass = 0,
/turf/grass = 1,
/turf/wall = 2,
/turf/steel_wall = 3,
/turf/floor2 = 4,
/turf/water/corners = 5,
/turf/water = 6,
/turf/tile = 7,
/turf/tutorial1/tut1_1nopass/tut1_nopass_hideguard = 8,
/turf/floor = 9,
/turf/tutorial1/tut1_1nopass = 10,
/turf/tutorial1/tut1_begin = 11,
/turf/wooden_floor = 12,
/turf/wood/r = 13,
/turf/wood = 14,
/turf/tree = 15,
/turf/gates = 16,
/turf/tower = 17,
/turf/tile/tile2 = 18,
/turf/brickwall = 19,
/turf/grass/bright = 20,
/turf/road = 21,
/turf/road2 = 22,
/turf/addedd/tile = 23,
/turf/fence = 24,
/turf/black = 25,
/turf/vents/tile = 26,
/turf/vents/exit = 27
)
mob/verb/exportworld()
	set hidden = 1
	var/end = 0
	while(!end)
		sleep()
		var/f = file("world.txt")
		var/f2 = file("types.txt")

		//var/list/logg = list()
		var/i = 0
		var/ty

		for(var/turf/T in world)
			if(T.z != usr.z)
				continue

			if(logg[T.type])		//it has a type, get its number
				ty = logg[T.type]
			else
						//if not, lets set it
				logg[T.type] = i
				f2 << "[T.type] = [i]"
				ty = i
				i++



			f << "[T.x] [150-T.y] [ty]"
		end = 1
