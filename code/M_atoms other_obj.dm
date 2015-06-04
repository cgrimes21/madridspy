
//all atoms are defined here

atom



	var/list/trust_values

	var/fingerprints = null
	var/flags = FPRINT
	var/tmp/ticks = 0		//can be used for their process

	proc/bumped(atom/movable/a)
		return

	proc/process()	//called every second
		return

	proc/add_fingerprint(mob/M as mob)	//only mob has fingerprints
		return



	proc/activate_item(mob/M as mob)
		return

	proc/med_tickle()
		return
	proc/slow_tickle()
		return



	proc/MouseDrop_T(atom/what, mob/who)				//like bumped, this is when what is dropped onto what, who is the mob
		return

	MouseDrop(atom/over_object)
		if(istype(over_object))
			over_object.MouseDrop_T(src, usr)
		else
			return ..()
	//interact is different than activate item!!
	//interact proc is called when you click src and other instances
	//activate item is designed soley for the C button, pressing it will call
	//activate item in your hand and possibly call items in front of you activate_item as well
	proc/flasher()
		src.overlays += explosion
		spawn(3)
			if(src)
				src.overlays -= explosion

	proc/explode()	//called when hit from explosives

		src.overlays += explosion
		spawn(3)
			if(src)
				src.overlays -= explosion
		return
	//some AI

	// src causes the event; loop through all viewers, hearers, etc.
	proc/SightEvent(brightness, movement)
		return
	proc/SoundEvent(soundname, range, volume)
		return
	proc/SmellEvent(smellname, range, intensity)
		return

    // src takes notice of the event
	proc/NoticeSight(atom/A, movement)
		return
	proc/NoticeSound(atom/A, soundname, range, volume)
		return
	proc/NoticeSmell(atom/A, smellname, range, intensity)
		return


	proc/strip_light(list/L = view(src.luminosity,src), center = src)



	New()
		..()

		//spawn()	//wait for world night/day to load (mostly needed for starting up world)

		if(!isarea(src)&&(luminosity>0))

			spawn()
				if(istype(src.loc,/turf))
					src.update_light()
	Del()

		if(!isarea(src)&&(luminosity>0))
			if(istype(src.loc,/turf))	//only on a turf to effect light

				src.strip_light()

		..()

atom/movable

	var/weight = 150
	var/anchored = 0
	var/move_speed = 4.615
	var/tmp/running = 0
	var/tmp/moved_recently = 0

	Bump(atom/a)

		a.bumped(src)
		..()

	Move()
		if(!src)
			return
		if(src.anchored) return

		var/turf/oldloc = src.loc
		var/list/oldview


		if(isturf(loc))
			oldview = view(src.luminosity, oldloc)
		.=..()

		if(.&&(src.luminosity>0))

			if(istype(oldloc))
				src.strip_light(oldview,oldloc)
				var/turf/t = src.loc
				t.lighted ++
			//	oldloc.lighted ++
			src.update_light()




obj
	other
		no_see
			opacity = 1
		ladder
			icon = 'shit.dmi'
			icon_state = "ladder"
			density = 1
			bumped(atom/A)
				if(istype(A,/mob/agent))
					var/mob/agent/M = A
					M.loc = src.loc
					M.elevation = 1
					M.sight |= (SEE_OBJS|SEE_TURFS|SEE_MOBS)
					M.see_invisible = 1
				else
					..()
		guides
			name = "guides"
			red_guide
				icon = 'turfs.dmi'
				icon_state = "redguide"
			green_guide
				icon = 'turfs.dmi'
				icon_state = "greenguide"
		window
			icon = 'table.dmi'
			density = 1
			icon_state = "mwindow"
			explode()
				..()

				src.icon_state = "mwindowbroke"
				src.density = 0
				play_sound(src,src.loc,'glassbreak.ogg',0)
				spawn(rand(400,4500))
					src.icon_state = "mwindow"
					src.density = 1
		table
			icon = 'table.dmi'
			icon_state = "reinf_tabledir"
			density = 1
			layer = layer_table

			get_hit(mob/who,obj/small/what)
				if(!who) return
				if(!what) return

				if(get_dist(who,src)<=1)

					who.u_equip(what)
					who.drop_item(what)
					what.loc = src.loc
				//M<<"whatever is in your hand will be moved to the table."
		chair
			icon = 'chair.dmi'
		//all these are scenery/interactable things that you cant pick up
		light
			invisibility = 1
			invis_light
				invisibility = 2
				flags = FPRINT | INV_LIGHT
			luminosity = 4
			icon = 'light.dmi'
			icon_state = "bulb1"
			layer = layer_light
			flags = FPRINT | LIGHT
			var/on = 1
			var/typ = "bulb"
			var/time_off = 0

			slow_tickle()
				if(src.time_off)				//it was turned off, count it down
					src.time_off -= 1
					if(src.time_off<=0)		//if it reaches zero, turn it back on
						if(!src.on)			//has to be off
							src.update_light()
							src.on = 1
							src.icon_state = "[src.typ][src.on]"
			interact()

				if(src.on)
					src.time_off = 10	//120 seconds
					src.strip_light()
					src.AI_event = AI_CHANGED_LIGHT_SWITCHED


				else
					src.update_light()
					src.time_off = 0
				src.on = !src.on
				src.icon_state = "[src.typ][src.on]"




obj/skill		//skills
	var
		next_available
		active = 0
		expires
		show_active = 0		//show if its activated and only have
							//chance to deactivate
		passive = 0
		min_rank = 1		//minimum rank
		owned = 1
		list/modifiers = list()
		list/effect = list()
	proc/activate()
	proc/deactivate()

	process()	//under this you will search where this obj is
		return
				//if in somebody, activate its effects if passive

				//check if its ready to use


//one agency specializes in security gaining one way windows
//other agencies will specialize in weapons/gadgets/equipment




power_grid // a power grid that supplies power

	var/list/cables = list()	//all the cables
	var/list/nodes = list()		//all the machines its powering
	var/load = 0				//the load of all the machines
	var/gen = 0					//the wattage of power being generated



d/missions	//a datum of all the missions

	var
		name = ""
		goal = ""
		d/missions/next_mission	//the mission assigned when this mission finishes
		d/missions/last_mission	//the mission you had before this one

		reward					//the reward for the mission
		trust_reward = 0		//the amount of trust given for this mission
		failed = 0				//a counter of each time you fail,

		proc
			assign_mission()	//assigns a new mission
			next_mission()		//assigns the next sub_mission from the current mission
			finish_mission()	//finishes the current mission. final. even if your on a sub
			fail_mission()		//fails your mission






/*the source*/
//one source that keeps track of everything and updates it depending on whats happening to it
d/source

	var/ticker = 0




	New()
		..()

		while(src)
			sleep(10)

			src.process()

	proc/process()

		ticker += 1

		if(!(ticker % 60))
			minutes ++
			statistic["[minutes]"] = list("gfc"=gfc,"tfc"=tfc)
		//	debuggers<<"[minutes] minute | given: [gfc] | taken: [tfc]"

			gfc = 0
			tfc = 0



		//night/day system every 2 hours
		if(!(ticker % (60*120)))
			if(night)
				day(1)
			else
				day(0)


	//	for(var/turf/t in world)
	//		t.process()
	//not needed right now

		for(var/mob/M in world)
			M.process()
		for(var/obj/playtest/security_turret/t in world)
			t.process()
		for(var/obj/vendor/v in world)
			v.process()
	//	for(var/obj/o in world)
	//		o.process()
		//for(var/network/n in networks)
		//	n.life()

