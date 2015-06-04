obj
	overlays
		layer = layer_weapon
		var/olayer = layer_weapon

		pistol_overlay
			icon = 'pistol_overlay.dmi'
			layer = layer_weapon
			name = "pistol_overlay"
		sniper_overlay
			icon = 'sniper_overlay.dmi'
			layer = layer_weapon
			name = "sniper_overlay"


		machinegun_overlay


var
	obj/overlays/pistol_overlay/PISTOL_OVERLAY		 = new()//'pistol_overlay.dmi',layer=MOB_LAYER+1)
	obj/overlays/sniper_overlay/SNIPER_OVERLAY		 = new()//'sniper_overlay.dmi',layer=MOB_LAYER+1)
	obj/overlays/machinegun_overlay/MACHINEGUN_OVERLAY	 = new()

	image/explosion				 = new('explode.dmi',icon_state = "bright",layer=999)
	image/smokeblank			 = new('effects.dmi',icon_state="smoke2blank",layer=layer_smoke)
	image/smoke					 = new('effects.dmi',icon_state="smoke2",layer=layer_smoke)


	version = 0.76

	used_names = file("used_names.txt")
	list/niu = list()	//Names In Use

	ris_code = "no"
	rev = 0
	revstart = 3431.42//3924.42

	log_on = 0	//is it recording logs?
	logs = file("logs/")

	closed = 2		//closed testing, 2 is open, 1 is restricted (list), 0 is closed
	list/authorized = list("suicideshifter","demon27933","smokeyjoe","lordian","zinned","receptionist")
	list/guides = list()
	list/cardinal = list( NORTH, SOUTH, EAST, WEST)
	list/banned = list()//"nadrew")	//nadrew is a fucker
	list/alphabet = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o",
						"p","q","r","s","t","u","v","w","x","y","z")
	list/debuggers = list()
	list/gen_names = list()


	list/guns = list(

	magnum = ".45 Magnum",
	revolver = ".357 Revolver",
	coltapc = ".45 Colt APC",
	deserteagle = "Desert Eagle",
	r700 = "R700 Bolt Action",
	m40a3 = "M40A3 Bolt Action",
	barrett = "Barrett Semi Automatic",
	m21 = "M21 Semi Automatic",
	mac = "Mac 11",
	mp5 = "Mp5",
	p90 = "P90")


	/**************
	Important Lists
	***************/
	records = list(
1 = list(name = "rat", agency=3, current_mission="", fingerprint="",last_seen="",version=1,ckey=""),
				  )



	passport = "14c9ddf46e1d77a7"

	ticker = 0
	night = 0		//0 for day, 1 for night







proc
	garbage_collect()
		for(var/obj/small/o in world)
			if(isturf(o.loc))
				if(!o.owned)
					if(!o.indestructable)
						if(istype(o, /obj/small/id_card))
							game_del(o)

		debuggers<<"garbage collected"

	play_ambience(mob/a)
		if(!istype(a, /mob))
			return

		if(!a.music)
			a<<sound(null,0,1,1)
			a.amb = 0
			return
		a.amb = 1
		//if(rand(1,3) == 2)
		a<<sound('Background Music.ogg',0,1,1,75)
		//a<<sound('ambigen5.ogg',0,1,1)
		//a<<sound('ambigen6.ogg',0,1,1)
		//a<<sound('ambigen7.ogg',0,1,1)
		//if(rand(1,3) == 2)

		a<<sound('Background Music 2.ogg',0,1,1,75)
	//	a<<sound('ambigen8.ogg',0,1,1)
	//	a<<sound('ambigen9.ogg',0,1,1)
	//	a<<sound('ambigen10.ogg',0,1,1)
	//	a<<sound('ambigen11.ogg',0,1,1)
	//	a<<sound('ambigen12.ogg',0,1,1)

		spawn(1200)//spawn(1950)
			if(a)
				play_ambience(a)


	play_music(mob/a,sound,self = 1,repeat = 1)
		if(!istype(a, /mob))
			return

		if(!a.music)
			return

		if(self)
			a<<sound(sound,repeat,0,1)
		else
			for(var/mob/M in view(a))
				if(M.sound == "false")
					continue

				if(M.current_sound != sound)	// i did this to prevent playing same assult music
												//every time they got stressed
					M<<sound(sound,repeat,0,1)
					M.current_sound = sound
					spawn(2400)	//if after 4 minutes the song still playing, get rid of it
						if(M)
							if(M.current_sound == sound)
								M<<sound(null,0,0,1)



	play_sound(mob/a,turf/where, sound,self = 1)
		if(!a && self==1)
			return
		if(!istype(a, /mob) && (self == 1))
			return
			//only play to a mob	if self is 1



		if(self)
			if(!a.sound)
				return
			a<<sound(sound,0,0,5)
		else
			var/atom/wha
			if(a)
				wha = a
			else if(where)
				wha = where
			if(!wha)
				return
			//play from a mob by default, if no mob play from location
			for(var/mob/M in viewers(wha))
				if(!M.sound)
					continue
				var/sound/s = sound(sound,0,0,5)
				if(where)
					s.x = (where.x-M.x)
					s.y = (where.y-M.y)
					s.z = (where.z-M.z)
				M<<s


	create_names()
		var/co = file2text('names.txt')

		for(var/v = 20, v>1, v--)

			var/a = copytext(co,1,findtext(co,"\n"))
			gen_names += a


			co = copytext(co, findtext(co, a)+length(a)+1)
			if(!co) break

	game_del(atom/a)
		if(!a)
			return

		var/list/built_in = list("type","parent_type","gender","verbs","vars","group")
		for(var/v in a.vars)
			if(!(v in built_in))
				a.vars[v] = null
		del a

/*
mob/verb/testlisterman()
	var/list/L = list("hap","kip","red","blue","yellow")
	var/one
	var/i = L.Find("yellow")
	if(i)
		world<<i
		world<<i % L.len + 1
		world<<10 % 10

		one = L[i % L.len + 1]	recycles through list if reaches end
	world<<one

*/