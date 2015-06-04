mob
	interact(mob/M,loc,ctrl,params)		//M clicks src
		var/list/L = params2list(params)
		var/xx = L["icon-x"]
		var/yy = L["icon-y"]
		var/l = L["left"]
		var/hand = 0		//default is left

		if(!l)	//if right handed click, set hand to 1, otherwise assume left click
			hand = 1

		xx = text2num(xx)
		yy = text2num(yy)

		if(!M)
			return
		if(!src)
			return
		if(M.health <= 0)	//unconscious
			return

		if(M.is_Binded(1))
			return

		if(M.attack_delay > world.time)
			return
			//cant attack yet

		var/obj/small/w = M.get_hand(hand)
		if(!w)
			var/obj/small/weapon/hands/h = new()
			M.hand = h
			w = h

		if(!w.force)
			return

		var/range = 1
		if(istype(w,/obj/small/weapon))
			var/obj/small/weapon/ww = w
			range = ww.range

		if((get_dist(M,src)>range))
			M<<"\blue target is out of reach."
			return

		//////////////////
		//.....do some calculations
		/////////////////



		if(src.invisibility == 101) return
		if(M.invisibility == 101) return

		src.last_hostile = M.real_name


		M.unhide()
		M.unmask()

		src.unhide()	//come out of hiding

		var/turf/t = src.loc
		if(t)
			var/obj/roof/r = locate(/obj/roof) in t
			if(t.no_fight)
				if(r)
					if(r.no_fight)
						M<<"You don't feel like fighting."
						return//they are safe from hits
				else
					M<<"You don't feel like fighting."
					return//they are safe from hits


		///////////////
		//...........end calculations
		//////////////




		//if(istype(w, /obj/small/weapon))	//only if its a weapon

			//src.get_hit(M,w)	//src is getting hit by M with w
			//for now we use attack to specialize each effect of each weapon

		w.attack(M,src)		//w is attacking src, being used by M
		if(!w)
			return
		if(!M)
			return
		M.attack_delay = world.time + w.delay



	Click(loc,ctrl,params)
		src.interact(usr,loc,ctrl,params)

	DblClick()
		winset(usr,"infowindow.itemdesc","max-lines=1")
		usr<<output("~","infowindow.itemdesc")
		winset(usr,"infowindow.itemdesc","max-lines=1000")
		usr<<output("\icon[src] [src.name]\nBelonging to [FetchAgencyName(src.agency)]\nHas health of [src.health]/[src.mhealth]","infowindow.itemdesc")

mob
	explode(mob/M)
		..()
		if(M)
			src.last_hostile = M
		src.hit(rand(18,23),"burn")




/mob/proc/hit(damage = 1, damage_type = "")
	///////
	//		Just hit src for damage for natural causes (things like traps poisons)
	//////

	if(src.invisibility == 101)
		return	//do nothing, your nonexistant within the shadows

	src.health -= damage
	src<<"\red <b>You take [damage] point\s [damage_type] damage!"
	orange(src)<<"\red [src.name] takes [damage] point\s [damage_type] damage!"

	for(var/obj/small/s in src)
		s.hit(src)



mob/get_hit(mob/who, obj/small/what, damage = 0)
	//////
	//		Mob gets hit by who with weapon what
	/////

	if(!who) return
	if(!what) return

	if(src.invisibility == 101) return
	if(who.invisibility == 101) return

	src.last_hostile = who.real_name

	if(!damage)	//no damage was defined
		damage = 1
	damage = max(damage, 0)



	who.unhide()
	who.unmask()

	src.unhide()	//come out of hiding


	if(prob(damage*10))
		src.bleed()
	var/damage_type

	if(damage)
		src<<"\red <b>You take [damage] point\s [damage_type] damage!"
		orange(src)<<"\red [src.name] takes [damage] point\s [damage_type] damage!"
	else
		src<<"[who.name] attempts to hit you but misses!"
		orange(src)<<"[who.name] attempts to hit [src.name] but misses!"

	src.health -= damage
	who.blood_rating += rand(1,5)
	for(var/obj/small/s in src)
		s.hit(src)
	//process checks for dead






mob/proc/dead(var/mob/killer)
	if(src.invisibility == 101) return	//already in the dying process
	if(src.health <= (-src.mhealth))	//your considered dead only call this when agent is at negative max hp,


		if(killer)
			//DE
			//debuggers<<"[killer.name] killed [src.name]!"
			src<<"You have died! ([killer.name])"
			killer<<"You kill [src.name]."

			world<<"<b>[killer.name] killed [src.name]!</b>"
			if(src.client)
				wlog<<"[get_time()] agent [killer.real_name] ([killer.name]) (([killer.ckey])) ((([src.client.address ? "[src.client.address]" : ""]))) killed [src.real_name] ([src.name]) (([src.ckey])) ((([src.client.address ? "[src.client.address]" : ""])))"

			if(src.ragency == killer.ragency)
				var/loss = 0

				if(killer.money>0)
					loss = killer.money * 0.4
				killer<<"<b>[src.name] was on your side!</b>\nYou lose $[loss]."
				killer.money -= loss

				wlog<<"[get_time()] [killer.real_name] was on same side as [src.real_name], so they lose $[loss] leaving them with [killer.money]$"
		else
			src<<"You have died!"

		play_music(src,'death.ogg',1,0)

		src.bleed()

		src.poison = 0
	//	src.lose_item()
		src.drop_id()

		 //make a new corpse, if your on a mission then save the body, if not garbage collect it
		 //this is called in obj/corpse's new

		if(istype(src, /mob/npc))	//an npc
			//match npc mission id with yours and if it matches dont spawn him back

			game_del(src)

		else	//its a player
			if(!src.spawnx || !src.spawny || !src.spawnz)
				if(istype(src, /mob/agent))
					var/mob/agent/a = src
					a.set_spawn_point()

			new /obj/corpse (src.loc,src.name)

			src.invisibility = 101
			//src.health = 1//so the blind will be removed and you can see whats going on
			src.sight  &= ~BLIND

			src.stuck += 4	//stuck for 3 seconds
			var/obj/small/mission_contract/c = locate(/obj/small/mission_contract) in src
			if(c)
				if(c in src)
					if(c.signature == src.real_name)
						src<<"You have failed your mission."
						game_del(c)
					return

			spawn(40)
				if(src)
					src.health = src.mhealth/2
					src.invisibility = 0
					src.see_invisible = 0
					src.elevation = 0
					src.issue_card()

					var/obj/o = src.get_spawn_point()

					o = locate(o) in world//locate(src.spawnx, src.spawny, src.spawnz)

					if(o)
						src.loc = o.loc
					else
						src.loc = locate(/obj/spawns/civi)

					src.last_hostile = null
					src.sight = 0
					src.current_sound = null
					src.recalc_stats()
				return


mob/proc/drop_id()	//drops their id card
	for(var/obj/small/id_card/c in src)
		if(ckey(c.written_name) == ckey(src.real_name))
			c.dropable = 1	//you can now drop this
			src.force_drop_item(c)

			src<<"You lost your ID card!"
			//issue a new card later when they revive

mob/proc/lose_item()	// calls item checks
	for(var/obj/small/s in src)
		s.death(src)
		if(prob(8))
			if(s && (s in src))
				if(s.suffix == "worn")
					continue
				if(s.suffix == "equipped")
					continue
				//dont drop items that are equipped, can change later

				if(!s.protected)	//can be dropped
					src<<"You lost your [s.name]."
					s.Move(src.loc)
					s.owned = FALSE
					s.dropped(src)
					src.recalc_stats()

					if(prob(6))
						game_del(s)	//chance of never seeing item again
					if(s)	//didnt get deleted
						spawn( 2700 )
							if(s)
								s.poof_check()
							return



obj
	blood
		icon = 'blood.dmi'
		New()
			..()

			src.icon_state = "[rand(1,18)]"
			spawn( 200 )
				game_del(src)

obj/corpse
	icon = 'dead.dmi'
	layer = MOB_LAYER + 1
	density = 1

	New(loc,namer)
		..(loc)
		src.name = namer
		spawn( 2700 )
			if(src)
				game_del(src)



mob/verb/drugged()
	set hidden = 1
	usr << "<font face=courier>------------------------------</font>"
	usr << "<font face=courier>------ InfoScan Mark II ------</font>"
	usr << "<font face=courier>------------------------------</font>"
	usr << "\n<font face=courier> Running Locate...\n</font>"
	sleep(20)
	usr << "<font face=courier> Last known locations:</font>"
	for(var/mob/I in world)
		var/disp_name = I.name
		var/padding = 20 - length(disp_name)
		var/i = 0
		while(i < padding)
			disp_name += " "
			i++
		usr << text("<font face=courier> [][]</font>", disp_name, pick("area51","fire in the sky","smoke on teh water"))
		//Foreach goto(203)
	usr << "\n<font face=courier>------------------------------</font>\n"



obj/small/weapon
	//w activates with M

	activate_item(mob/M,mob/attacker,xx,yy)



		var/obj/small/weapon/w




		if(istype(src, /obj/small/weapon))
			w = src
		if(!w)
			return
		//above are checks
		if(!attacker)	//its called elsewhere from interacting with another mob,
			return		//do nothing

		//var/bd = turn(get_dir(src, M),180)

		if(w.range<=1)	//its a hand item, dont attack down below
			if(attacker.elevation != M.elevation)
				attacker<<"\blue Target is out of range."
				return

		attacker.dir = turn(get_dir(M,src),180)
		//attacker.dir = bd
		if(!(get_dist(attacker, M) <= w.range))
			attacker<<"\blue Target is out of range."
			return
		var/turf/t = M.loc
		if(t)
			var/obj/roof/r = locate(/obj/roof) in t

			if(t.no_fight)
				if(r)
					if(r.no_fight)
						attacker<<"You don't feel like fighting."
						return//they are safe from hits
				else
					attacker<<"You don't feel like fighting."
					return//they are safe from hits

		if(istype(w, /obj/small/weapon/gun))
			spawn(1)
				flick("fire",attacker)

				attacker.shoot_sound(w.noise)
			//still need to check if its a sniper/pistol/machine





		/*DE
		var/damage = rand(w.damage-2, w.damage+2)
*/
		var/p = 25 //25 chance of infliction

		if((xx >= 14) && (yy >=  21))
			if(M.icon_state == "dead")
				return	//no headshots when your dead

			if(istype(attacker, /mob/agent))
				if((istype(w, /obj/small/weapon)&&(!istype(w, /obj/small/weapon/hands))))
					//no headshot with hands
					var/mob/agent/u = attacker
					u.headshots ++
					u.total_headshots ++

			if(istype(M,/mob/npc))	//only npcs can die from headshots
				var/mob/npc/npc = M
				if(npc.can_die)
					M.health = 0


					M.dead(attacker)
			else
				//double the damage
				p *= 2
			//DE
			//	damage *= 2

		//hit them
		attacker.attack_delay = world.time + w.delay
		//DE
		//M.get_hit(attacker, attacker.hand, damage)

		//added on, remove after
		if(istype(w, /obj/small/weapon/gun/poison_gun))
			if(get_dist(M,attacker) <=6)
				attacker<<"\red You are too close to the target!"
				attacker.attack_delay = world.time
				return

			M.last_hostile = attacker.real_name
			attacker.blood_rating += 5
			if(attacker.blood_rating > 5)
				var/obj/small/mission_contract/c = locate(/obj/small/mission_contract) in attacker
				if(c)
					if(c in attacker)
						if(c.signature == attacker.real_name)
							attacker<<"You have failed your mission."
							game_del(c)
						return
			if(prob(p))
				attacker<<"Success! [M.name] has been injected with lethal poison."
				M<<"You have been injected with poison."

				M.poison += rand(20,24)	//has chance of not killing target with max life
			else
				attacker<<"You failed to inject poison. Reloading..."
				spawn(250)
					attacker<<"Poison gun reloaded."