/*
mission
	var
		list/waypoints
		mission_id
		current_objective
		list/objectives
		target

	proc
		update_waypoint(newaypoint)

		update_objective(newobjective)

		reach_waypoint(waypoint)

		fail_objective(objective)

		fail_mission()

		mission_string(mob/m,t)

			m<<output("[t]","m_objective.output")
			winshow(m,"m_objective",1)

		extract()

		infiltrate()


	//missions
	tutorial
		mission_id = "tutorial"


*/

mission

	/*
Each mission will have an ID, this ID is shared by any items that pertain to that mission.
Under each mission type, there will be variables to be stored in order for waypoints/objectives to function
Each player will currently only be able to hold 1 mission, and is stored in a permanent variable called current_mission
Each mission sub type will have their own procs defined as to what happens when they complete objective or whatever
lets get started*/

///////// * Waypoints * - Are defined under obj/waypoint or similar, when triggered they trigger your current mission's procedure
			//relating to waypoint (reach_waypoint() ) and will then do accordingly based on that mission

	var
		id
		list/objectives		//text strings
		objective 			//text string, current objective
		atom/target			//an actual target reference

		//Some sub-vars
		atom/reward			//physical reference of reward, a new item perhaps?
		money				//how much the mission pays
		who					//the key the mission belongs to


		//future to-add features
		list/team			//a team working on this mission
		time_limit
		max_blood_rating	//pass this will fail
		security_breaches	//before you fail
		dead_bodies			//found before you fail
		death = 0			//1 if your allowed to die and keep mission



	proc
		extract()			//end mission
		begin()				//when you first begin a mission
		//infiltrate()		//places you on special map regarding certain missions
		reach_waypoint()	//what happens when you reach waypoint
		reach_obj()			//reach objective
		fail_mission()		//fails mission
			extract()
		fail_objective()
		end_dialog()		//what happens when you end dialog
	//missions are only complete when you have finished entire mission (not objectives)
	//as to prevent from doing mission over again by running over waypoints


	//actual missions will be stored here, and use as a reference for future missions
	tutorial1

		id = "tut1"
		var
			//These variables track progress through your mission. when you have completed a mission it will SAVE under your completed mission
			//vars. UNTIL then, these trackers track up where your at in your mission temporarily. Meaning if you log out, and log back in
			//you wont be  'stuck' in middle of a mission.
			//they prevent you from getting popups from a mission earlier in time when you have different objectives

			//yet only save a mission completion when it is fully done. logging out will fail a mission

			tmp/d1 = 0	//dialog 1, havent read yet
			tmp/d2 = 0 //part 2 havent completed

			tmp/d3 = 0 //dialog whith cyanide


			tmp/ko_guard = 0 //did you ko the first guard?
			dropped_guard_id = 0
			reached_hideguard_waypoint = 0 	//you hid the guard behind the bed and your entering the barrier for first time.

			//other misc.

			spotted = 0	//spotted by AI/security

				//characters
			mob/npc/mole
			mob/npc/guard1	//the guard carrying the mole



atom/var/mission_id = 0

mob/proc/do_objective(what = "")	//src just did certian objective, now we check it with their part variable, not mission var

	if(src.mission)
		if(src.part)
			src.part.reach_obj(src,what)
		else//they arent on a sub-part
			src.mission.reach_obj(src,what)


mob/var
	tmp/mission/part = null
	tmp/mission/mission = null //current mission
	list/completed_missions		//a list of text strings with unique identifier (mission id) that player has completed












//just here to make game run, weed out problem in M_missions.dm
mob
	var/obj/small/mission_contract/current_mission = null	//not currently on a mission

obj/small/mission_contract
	icon = 'papers.dmi'
	icon_state = "paper"
	var/signature = null
	var/content = null
	var/terms = null
	var/ob = null
	var/reward = 0
	var/ass = null
	var/mission/statement
	desc = "A mission contract.\n\blue this document has not been signed."
	set_desc()
		src.desc = "A mission contract.\n\blue [src.signature ? "~[src.signature]" : "not signed"]"
	dropped()
		..()
		if(src)
			view(src)<<"[src.name] has crumbled to dust."
			game_del(src)

	verb
		read_()
			set src in usr
			set category = null

		sign()
			set src in usr
var/list/playtest_tech = list(
///obj/small/electronics/emitter,
/obj/small/electronics/radio,

///obj/small/hacker,
///obj/small/lock_pick,

/obj/small/screwdriver,
/obj/small/playtest/prybar,
/obj/small/smoke_bomb,
/obj/small/weapon/gun/poison_gun,
/obj/small/poison_antidote,
/obj/small/weapon/tranq_dart,
/obj/small/weapon/knife,
/obj/small/bomb,
/obj/small/clothing/mask/swat,
/obj/small/clothing/mask/swat_thermal,
/obj/small/flash_bomb,
/obj/small/lock_pick
)


var/global
	RIS_flag = 0
	OSS_flag = 0

obj/cabinet
	icon = 'shit.dmi'
	icon_state = "computer"
	var/flag_side = null

	RIS_
		flag_side = 1
	OSS_
		flag_side = 2
	density = 1

	/*
	process()
		..()

		var/flag1 = 0
		var/flag2 = 0
		for(var/obj/small/document/o in world)

			if(o.flag_side == src.flag_side)

				if(o.flag_side == 1)
					flag1 = 1

				if(o.flag_side == 2)
					flag2 = 1
		if(!flag1)
			RIS_flag = 0
		else
			RIS_flag = 1

		if(!flag2)
			OSS_flag = 0
		else
			OSS_flag = 1
	//	world<<"ris: [RIS_flag] oss: [OSS_flag]"
					*/
	get_hit_hand(mob/who,hander)
		if(get_dist(who,src)>1)
			return
		var/obj/small/document/d



		if((src.flag_side == 1) && (who.ragency == RIS))
			who<<"You can't take your own documents."
			return
		if((src.flag_side == 2) && (who.ragency == OSS))
			who<<"You can't take your own documents."
			return



		if(src.flag_side == 1)
			if(!(locate(/obj/small/document) in range(0,who)))

				d = new()
				d.loc = who
				d.flag_side = 1
				d.owned = TRUE
				d.get_hit_hand(who,hander)

		else if(src.flag_side == 2)
			if(!(locate(/obj/small/document) in range(0,who)))

				d = new()
				d.flag_side = 2
				d.loc = who
				d.owned = TRUE
				d.get_hit_hand(who,hander)
			//lineedit


obj/small/document
	var/flag_side = null
	icon = 'shit.dmi'
	icon_state = "mission"



obj/vendors
	icon = 'computers.dmi'
	density = 1
	process()
		..()


		if(prob(28))

			var/s = pick(playtest_tech)


			spawn_object(s,src,0,100,100)

			//these guns are sorted when interacted by their min_rank


	get_hit_hand(mob/agent/who, hander)
		if(get_dist(who,src)>1)
			return

		var/obj/we = who.get_hand(hander)
		if(!we || (istype(we,/obj/small/weapon/hands)))
			who.buy_contents = src.contents
			if(who.client)
				who.client.statpanel = "vendor"
