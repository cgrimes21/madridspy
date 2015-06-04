


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





mob
	var/mission/mission
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
			var/c = alert(usr,"Assassination Contract","~","Agreements","Breifing","Terms")
			if(c == "Terms")
				alert(usr,src.ob,"Assassination Contract")
			if(c == "Breifing")
				alert(usr,src.content,"Assassination Contract")
			if(c=="Agreements")
				alert(usr,src.terms,"Assassination Contract")
		sign()
			set src in usr
			if(src.signature)
				src<<"This document has been signed!"
				return
			if(alert(usr, "By signing this document, you fully agree to the terms and conditions presented within the document and will accept all punishments to the full extent of the law listed within the document.","sign","no,","sign,")=="sign,")
				src.signature = ckey(usr.real_name)
				src.icon_state = "papersigned"
				usr<<"\blue you scribble your name on the bottom line."
				usr<<"Bring the document to your agency clerk, say 'start mission' to begin the mission."
			src.set_desc()
mob/verb/ada()
	for(var/mob/agent/a in world)
		if(a != src)
			niu += ckey(a.real_name)
proc
	assign_mission(mob/who)
		var/assassinate_name = null

		if(niu.len <= 1)
			alert(who, "There are no assassination missions available.")
			return

		for(var/m in niu)
			if(ckey(m) != ckey(who.real_name))

				//DE
				var/F = FALSE
				for(var/mob/agent/n in world)
					if(ckey(n.real_name) == m)
						if(n.ragency == who.ragency)
							F = TRUE

				if(F == TRUE)
					continue
				if(rand(1,5) == 3)
					assassinate_name = m

		if(!assassinate_name)
			assign_mission(who)
			return
		var/obj/small/mission_contract/c = new(who)
		c.reward = 250
		c.name = "mission contract"
		c.suffix = "assassinate [assassinate_name]"
		c.ass = assassinate_name
		c.ob = {"

->Terms~
        You cannot exceed a blood rating of 5.
        Triggering any alarms results in automatic failure of mission.
        Death will result in failure.
        "}

		c.terms = {"
->Agreements~
        By signing this document, you fully understand that if captured, the agency will deny all \
        affiliation and will deny your existance. Should this document be captured by enemy territory, the document becomes void. \
        This is a high priority mission, should you fail any of the terms, the agency will lose significant trust with you \
        and shall deduct funds from your bank account(s).
        "}

		c.content = {"
->Breifing~
        The mission you are to carry out requires assassination of enemy personell. Agent [assassinate_name] has been traced and is accused \
        of tampering with agency classified documents. Your job is to assassinate agent [assassinate_name] and collect his/her ID card upon death. \
        Should you fail, you are subject to the agreements and punishment(s) of the document.

Reward for this mission: $250.00 Will be automatically transferred to the account of your specification.

((The reward is so low because of alpha test version. In more stable releases, this is very rewarding.))

Goodluck, ~Anonymous "}

mob
	npc
		clerk
			icon = 'agent.dmi'

			name = "clerk"
			NoticeSound(atom/A, soundname, range, volume)
				var/mob/M

				if(get_dist(src,A)<=range)
					if(istype(A,/mob))
						M = A
					if(!M.is_alone())	//your not alone
						if(M.agency != src.agency)	//you are the outcast, only glare at you
							oview(M)<<"[src.name] glares at [M.name]"
							M<<"[src.name] glares at you."
						return
					if(lowertext(soundname) == "finish mission")
						for(var/obj/small/mission_contract/c in M)
							if(c.signature)
								if(M.current_mission == c)
									for(var/obj/small/id_card/ic in M)
										if(ckey(ic.written_name) == ckey(c.ass))
											M<<"<b>You have completed your mission!</b>"
											M.money += c.reward
											M<<"<b>$[c.reward] is being transferred into your bank account."
											M.current_mission = null
											game_del(ic)
											game_del(c)


					if(lowertext(soundname) == "terminate mission")
						//Below lets you terminate a contract even if you dont have it with you
						//if you do have it however, delete it
						var/obj/small/mission_contract/c
						for(var/obj/small/mission_contract/b in M)
							if(M.current_mission == b)
								c = b


						if(alert(M, "You sure you want to terminate? In the future you will lose money.","~","no,","yes,")=="yes,")
							if(c)
								game_del(c)
							M.current_mission = null
							M<<"Mission terminated."
							return

					if(lowertext(soundname) == lowertext("get mission"))
						if(istype(A,/mob))
							M = A
						if(!M.client)
							return
						if(!src)
							return
						if(locate(/obj/small/mission_contract) in M)
							M<<"You can only hold one mission at your trust level."
							//DE
							return

						if(M.ragency == src.agency)
							assign_mission(M)
						else
							M<<"You are not of this agency! SCRAM"
							return
						return
					if(lowertext(soundname) == "start mission")
						if(istype(A,/mob))
							M = A
						if(!M.client)
							return
						if(!src)
							return
						if(M.current_mission)
							M<<"Finish or terminate your current mission first before requesting to start another!\nTerminate missions by saying 'terminate mission'."
							return
						var/obj/small/mission_contract/mc
						var/list/docs = list()
						for(var/obj/small/mission_contract/c in M)
							if(c.signature)
								docs["[c.suffix]"] = c
								mc = c


						if(!docs.len)

							alert(M,"You do not have any contracts signed.")
							return
						if(docs.len == 1)

							alert(M,{"
A copy of the contract has been stored in your records. When you complete the mission, your contract will replace the old with stats on how well the mission was performed.

To complete the mission, complete your objective(s) and come back here. Say 'finish mission' to complete the mission.

Do not lose your copy of the mission, without it your mission will end!
							"})
							M.current_mission = mc
						else

							var/t = input(M,"You have more than one mission to choose from. Select:") as null|anything in docs
							var/obj/small/mission_contract/tt = docs["[t]"]
							if(!t)
								return
							if(!M)
								return
							if(!M.client)
								return
							if(!(tt in M))
								return
							M.current_mission = tt

							alert(M,{"
A copy of the contract has been stored in your records. When you complete the mission, your contract will replace the old with stats on how well the mission was performed.

To complete the mission, complete your objective(s) and come back here. Say 'finish mission' to complete the mission.

Do not lose your copy of the mission, without it your mission will end!
							"})


			ris
				icon_state = "MercenaryExample"
				agency = RIS
			oss
				icon_state = "uniform2"
				agency = OSS


var/list/playtest_tech = list(
///obj/small/electronics/emitter,
/obj/small/electronics/radio,
/obj/small/electronics/transmitter,
/obj/small/explosive,
/obj/small/hacker,
/obj/small/lock_pick,
/obj/small/motion_sensor,
/obj/small/note,
/obj/small/screwdriver,
/obj/small/timer,
/obj/small/weapon/gun/poison_gun,
/obj/small/poison_antidote
)

obj/vendors
	icon = 'computers.dmi'
	density = 1
	process()
		..()


		if(prob(28))

			var/s = pick(playtest_tech)


			spawn_object(s,src,0,100,100)

			//these guns are sorted when interacted by their min_rank

	verb
		purchase()
			set src in oview(1)
			var/mob/agent/a = usr


			a.buy_contents = src.contents