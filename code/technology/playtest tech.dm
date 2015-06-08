obj/small


	hacker
		icon = 'objects.dmi'
		icon_state = "hacker"
		value = 150
		initial_value = 150
		sale_value = 100
		desc = "A device which pulses a series of wires to allow for a short power-down on certian devices. If anything is to be hacked, \
		it will show up with a right click. Right click an object you think you can hack and if there is 'hack' in the dropdown menu, select it. \
		\n\nHacking devices have limited use, and are more effective with more durability."



	screwdriver
		icon = 'objects.dmi'
		icon_state = "screwdriver"

		desc = "A simple screwdriver. This comes in handy in more ways than you know..."

		initial_value = 100
		value = 100
		sale_value = 50
		damt = damage_type_piercing
		force = 1
		delay = 35
		body_loc = BSLOT || SLEEVE || BELT


	playtest
		icon = 'objects.dmi'

		powercell
			icon_state = "power cell"





		prybar
			icon_state = "prybar"
			damt = damage_type_bludgeon
			force=2
			body_loc = BELT

			value = 25
			initial_value = 25
			sale_value = 14

			delay = 25
		wrench
			icon_state = "wrench"
		flash
			icon_state = "flash"

obj/playtest
	icon = 'objects.dmi'
	jump
		density = 1
		icon = 'jump.dmi'

		out
			icon_state = "out"
			bumped(atom/movable/a)
				if(istype(a, /mob))
					var/mob/m = a
					var/obj/spawns/s = m.get_spawn_point()


					s = locate(s) in world
					if(!s)

						m.loc = locate(/obj/spawns/civi)
					else
						m.loc = s.loc


	security_turret
		icon_state = "turret"
		density = 1
		var/disabled = 0
		var/side = 0
		var/idle = 1	//1 = idling, 0 = attacking
		var/found = 0
		var/hostility = 3	//3 = shoot to kill through anything, 2 = stun, 1 = not as lethal (wont shoot through walls/windows/smoke but
							//will still try to kill, 0 = off
		verb/hack()

			set src in oview(1)
			var/obj/small/h = locate(/obj/small/hacker) in usr

			if(h)
				if(h.dura>3)
					h.dura -= 3

					if(!src.disabled)

						usr<<"\red Security was successfully hacked!"
						src.disabled += rand(20,40)
						h.break_r(usr)
					else
						usr<<"\red This is already hacked for [src.disabled] seconds"
		proc/zap(mob/M)

			src.dir = turn(get_dir(M,src),180)
			flick("turretfire",src)


			var/r = rand(1,5)
			switch(r)
				if(1)
					play_sound(src,src.loc,'shot1.ogg',0)
				if(2)
					play_sound(src,src.loc,'shot2.ogg',0)
				if(3)
					play_sound(src,src.loc,'deagle.ogg',0)
				if(4)
					play_sound(src,src.loc,'pistolfire.ogg',0)
				if(5)
					play_sound(src,src.loc,'ric1.ogg',0)
					return	//missed

			M.last_hostile = "security"
			/* dont put this in yet
			DE

			var/obj/small/mission_contract/c = locate(/obj/small/mission_contract) in M
			if(c)
				if(c in M)
					if(c.signature == M.real_name)
						M<<"You have failed your mission."
						game_del(c)
					return
			*/
			if(r!=5)	//didnt miss
				M.hit(rand(1,2), damage_type = "security")

		ris_security
			side = 2
		oss_security
			side = OSS

		process()

			if(src.disabled>=1)
				src.disabled -= 1
				return


			var/found = 0

			if(!locate(/mob) in view(src))
				return

			var/list/attack = list()
			for(var/mob/agent/M in view(src))
				if("[M.agency]" != "[src.side]")
					if(!M.slip)
						found = 1
						attack += M


			if(found)	//they found someone,
				//if they are closed, open them
				if(src.idle)
					src.idle = 0
					flick("turretopening",src)
					play_sound(src,src.loc,'turretdoor.ogg',0)
					sleep(6)
					src.icon_state = "turreto"
				for(var/mob/a in attack)
					if(a)
						src.zap(a)//zap them

			//if not found, if not idle, then set to idle
			if(!found)
				if(!src.idle)
					src.idle = 1
					flick("turretclosing",src)
					play_sound(src,src.loc,'turretdoor.ogg',0)
					sleep(6)
					src.icon_state = "turret"



	cell_charger
		icon_state = "recharger"

	crate
		icon_state = "crate"
		density = 1

		var/open = 0
		layer = OBJ_LAYER - 0.1

		interact(mob/M)
			if(get_dist(M,src)>1)
				return

			open = !open

			if(open)
				src.icon_state = "crate-0"
				src.density = 0
				for(var/atom/movable/o in src)
					o.Move(src.loc)
			else
				src.icon_state = "crate"
				src.density = 1

				for(var/atom/movable/o in src.loc)
					if(istype(o,/mob))
						continue
					//no mobs
					o.Move(src)

					if(istype(o,/obj/small))
						var/obj/small/os = o
						os.owned = TRUE	//so it doesn't poof


