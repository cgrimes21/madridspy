///******Utilities (procedures) for strictly ALL mobs*****////
/mob/proc/drop_item(obj/small/s,hander=0)	//0 is left hand, 1 is right hand
	if(!s) return
	if(!(s in src)) return

	if(src.is_Binded(1))
		return
	if((!s.dropable))
		src<<"You can't drop this item."
		return
	if(istype(s,/obj/small/id_card))
		var/obj/small/id_card/c = s
		if(c.written_name == src.real_name)	//its theirs

			var/f = 0
			for(var/obj/small/id_card/cc in src)
				if((cc != c) && (cc.written_name == src.real_name))//you have two of the same?
					f = 1

			if(!f)
				src<<"You can't drop your ID card."
				return

	src.u_equip(s)

	//src.refresh_clothings()
	if(s)

		s.loc = src.loc
		s.dropped(src)
		src<<"You drop the [s.name]."


/mob/proc/throw_item(obj/small/s,dire = src.dir,space=5)

	if(!(s in src))
		return
	if((src.lh != s) && (src.rh != s))
		return
//	if(src.isBinded())
//		return


	src.u_equip(s)
	//drop
	src.drop_item(s)


	s.throwing(dire,space,src)


/mob/proc/knock_out()
	if(!src) return

	//called after it calculates a k.o in process()



/mob/proc/force_drop_item(obj/small/s)
	if(!s) return
	if(!(s in src)) return

	src.u_equip(s)

	if(s)
//	src.refresh_clothings()
		s.loc = src.loc
		s.dropped(src)


/mob/proc/u_equip(obj/s)

	if(src.lh == s)
		src.lh = null
	if(src.rh == s)
		src.rh = null
	if(src.w_mask == s)
		src.w_mask = null
	if(src.w_head == s)
		src.w_head = null
	if(src.w_id == s)
		src.w_id = null
	if(src.w_armor == s)
		src.w_armor = null
	if(src.w_suit == s)
		src.w_suit = null
	if(src.w_sleeve == s)
		src.w_sleeve = null
	if(src.w_bootslot == s)
		src.w_bootslot = null
	if(src.w_p1 == s)
		src.w_p1 = null
	if(src.w_p2 == s)
		src.w_p2 = null
	if(src.w_belt == s)
		src.w_belt = null
	if(src.w_back == s)
		src.w_back = null

	if(src.client)
		if(s in src.client.screen)
			src.client.screen -= s
	return
mob

	proc
		toggle_light()
			if(!src.luminosity)
				src.luminosity = 3
				var/turf/t = src.loc
				if(t)
					t.lighted ++  //dont know what the fuck but it fixes it
				src.update_light()
			else
				var/turf/t = src.loc
				if(t)
					t.lighted--
				src.strip_light()
				src.luminosity = 0

	proc/is_alone()
		.=1
		//default is your alone
		for(var/mob/m in oview(src,7))
			if("[m.agency]" == "[src.agency]")
				continue
			else	//someone of other agency, is an enemy, you are not alone
				.=0
		return .

	proc/shoot_sound(var/range = 10)
		for(var/mob/m in range(10,src))
			if(m.sound == "false")
				continue

			var/r = rand(1,4)
			switch(r)
				if(1)
					m<<sound('shot1.ogg',0,0,5)
				if(2)
					m<<sound('shot2.ogg',0,0,5)
				if(3)
					m<<sound('deagle.ogg',0,0,5)
				if(4)
					m<<sound('pistolfire.ogg',0,0,5)




	proc/check_weight()
		.=0
		for(var/obj/small/I in src)
			if(istype(I,/obj/small))
				if(I && (!I.invisibility))
					. += I.weight
		return .

	//being binded will disallow access to inventory and a lot of verbs, since you are binded
	//unless the parameter is 1
//	is_Binded(var/p = 0)	//cant move if binded, includes rope, stuck (like stunned),
//		return 0		//not binded

	proc/get_spawn_point()
		switch(src.agency)
			if(OSS)
				return /obj/spawns/oss
			if(RIS)
				return /obj/spawns/ris
			if(FL)
				return /obj/spawns/freelancer
			if(CV)
				return /obj/spawns/civi




	proc/issue_card()	//issue an id card based on their stats
		var/obj/small/id_card/i = new(src)
		i.written_name = src.real_name
		i.agency = src.ragency
		i.suffix = "[i.written_name]"
		//i.desc = "Name: [i.written_name]\nAgency: [FetchAgencyName(i.agency)]"

		i.set_desc()// = "Name: [i.written_name]\nAgency: [i.agency]\nAuthorization Access: 0\nTitle: none"
		src.refresh_clothings()



	proc/hide()
		if(src.slip)
			return
		src.icon = initial(src.icon)
		src.icon = 'hiddenspy.png'
				//src.icon += rgb(0,0,0,56)
		src<<"you slip into the shadows"
		src.slip = 1
		src.overlays = null

	proc/unhide(atom/a)		//reveal them from hiding
		if(src.slip)
			if(a)
				view(src)<<"[a.name] reveals [src.name] from the shadows!"
			src.icon = initial(src.icon)
			src.slip = 0
			oviewers(src)<<"[src.name] emerges."
			src<<"you emerge from the shadows."
			src.refresh_overlays()


	proc/unmask()		//reveal identity

	proc/bleed()
		var/list/l = list()
		for(var/turf/T in range(src,rand(1,2)))
			if(T)
				l += T
		if(l.len)
			for(var/v = 3, v>0, v--)
				var/turf/A = pick(l)
				l -= A
				new /obj/blood (A)


	proc/return_enemy_in_view()

		var/list/attack = list()
		if(locate(/mob) in view(src))
			for(var/mob/M in view(src))
				if("[M.agency]" != "[src.agency]")
					if(!M.slip)
						attack += M
		return attack
