var
	ris_score = 0
	oss_score = 0
obj
	control_panel
		icon = 'control_panel.dmi'
		oss
			NoticeSound(mob/agent/M,word,range,vol)
				if(get_dist(M,src) > range) return

				if("[word]" == "kill")

					for(var/obj/small/id_card/c in M)
						if(c.written_name != M.real_name)
							if(c.agency != M.ragency)
								play_sound(M,M.loc,'success.wav',1)
								M.kills += 1
								var/rew = rand(150,250)
								M.money += rew
								M<<"You find $[rew] in your pocket."
								M.u_equip(c)
								game_del(c)


					var/flag = 0

					for(var/obj/small/document/d in M)

						if((M.ragency == OSS) && (d.flag_side == 1))


							flag = 1


							M.u_equip(d)
							game_del(d)

					if(flag)
						play_sound(M,M.loc,'success.wav',1)
						oss_score += 1
						var/rew = rand(150,250)
						M.money += rew
						M<<"You find $[rew] in your pocket."



		speak
			var/code// = ris_code
			NoticeSound(mob/agent/M, word, range, vol)
				code = ris_code
				//DE

				if(get_dist(M,src) > range) return

				if("[word]" == "kill")

					var/flag = 0

					for(var/obj/small/document/d in M)

						if((M.ragency == RIS)&&(d.flag_side == 2))
							flag = 1
							M.u_equip(d)
							game_del(d)

					if(flag)
						play_sound(M,M.loc,'success.wav',1)
						ris_score += 1
						var/rew = rand(150,250)
						M.money += rew
						M<<"You find $[rew] in your pocket."



					for(var/obj/small/id_card/c in M)
						if(c.written_name != M.real_name)
							if(c.agency != M.ragency)

								play_sound(M,M.loc,'success.wav',1)
								M.kills += 1
								var/rew = rand(150,250)
								M.money += rew
								M<<"You find $[rew] in your pocket."
								M.u_equip(c)
								game_del(c)

				if("[word]" == "[code]")
					for(var/obj/door/d in range(5,src))
						if(d.id == "hidden_door")
							d.locked = 0
							d.force_open()
							d.locked = 1
					for(var/obj/vent/fan/f in range(5,src))
						if(f.id == "hidden")

							f.icon_state = "fan0"
							f.density = 0
							spawn(rand(40,50))
								f.density = 1
								f.icon_state = "fan"

		interact(mob/M)
			if(get_dist(src,M)>1) return

			src.add_fingerprint(M)

			for(var/obj/door/d in range(5))
				if(d.id=="hidden_door")
					//d.locked = 0
					d.open()
					//d.locked = 1
	door
		doorr
			icon = 'doorglass.dmi'
			opacity = 0
			icon_state = "door_closed"

		icon = 'doorwood.dmi'
		icon_state = "door1"
		opacity = 1
		density = 1
		name = "door"

		var/side = null
		var/id 		//for remote operation
		var/locked = 0
		var/open = 0
		var/opening = 0
		var/closing = 0
		var/blocked = null

		var/deny = "door_deny"
		var/openin = "doorc0"
		var/closin = "doorc1"
		var/o = "door0"
		var/c = "door1"
		var/spw = 7
		var/opensound = 'door_open.wav'
		var/closesound = 'door_close.wav'
		var/denysound = 'door_locked.ogg'
		var/timeopen = 50

		var/no_enter

		OSS_door
			side = "1"


		RIS_door
			side = "2"

			secure_door
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
		wall_door
			icon = 'doorwall.dmi'
			icon_state = "door1"
			locked = 0
			name = "wall"
			id = "hidden_door"
			no_enter = SOUTHEAST

			updown
				no_enter = WEST || EAST
			leftright
				no_enter = NORTH || SOUTH
		discreet_wall_door
			icon = 'ddoorwall.dmi'
			icon_state = "door1"
			locked = 0
			//no_enter = EAST || WEST || NORTH || SOUTH
			name = "wall"
			id = "hidden_doors"
			denysound = null
			opensound = 'turretdoor.ogg'
			closesound = 'turretdoor.ogg'

		//	interact()
		//		return	//do nothing, no interactions
		proc
			force_open()
				if(src.blocked) return
				if(src.opening) return
				if(src.closing) return
				if(src.open) return
				src.opening = 1

				play_sound(src,src.loc,opensound,0)

				flick(openin,src)
				spawn(spw)
					src.icon_state = o
					src.opening = 0
					src.open = 1
					src.opacity = 0
					src.density = 0
					spawn(timeopen)
						src.close()
			open(mob/a)
				if(!a) return

				if(src.locked)

					flick(deny,src)
					play_sound(src,src.loc,denysound,0)
					return

				if(src.blocked) return
				if(src.opening) return
				if(src.closing) return
				if(src.open) return

				var/obj/small/id_card/c
				if(a.w_id)
					c = a.w_id

				if(src.side && a)
					if(!c)	//no card, no access

						flick(deny,src)
						play_sound(src,src.loc,denysound,0)
						return


					if("[src.side]" != "[c.agency]")
						flick(deny,src)
						play_sound(src,src.loc,denysound,0)
						return

				if(a)
					src.add_fingerprint(a)

				src.opening = 1

				play_sound(src,src.loc,opensound,0)

				flick(openin,src)
				spawn(spw)
					src.icon_state = o
					src.opening = 0
					src.open = 1
					src.opacity = 0
					src.density = 0
					spawn(timeopen)
						src.close(a)
			close()
				if(src.opening) return
				if(src.closing) return
				if(!src.open) return

				for(var/atom/v in src.loc)
					if(v.density)
						spawn(timeopen)
							src.close()
						return
				//if(a)
				//	src.add_fingerprint(a)

				src.closing = 1
				src.density = 1
				flick(closin,src)
				play_sound(src,src.loc,closesound,0)
				spawn(spw)
					src.closing = 0
					src.open = 0
					src.icon_state = c
					src.opacity = initial(src.opacity)


			pick_lock(mob/M)
				M<<"You begin to pick the lock."
				sleep(30)
				if(get_dist(M,src)<=1)
					src.force_open(M)

		get_hit_hand(mob/M)
			if(M.is_Binded())
				return

			if(get_dist(M,src)>1)
				return
			if(src.opening || src.open)
				return

			src.add_fingerprint(M)


			M<<"you look through the keyhole"// knock on the door"
			if(M.client)
				var/d = get_dir(M,src)
				M.client.eye = locate(src.x,src.y,src.z)
				M.client.eye = (get_step(src,d))
			return


		get_hit(mob/M,obj/small/what)
			if(M.is_Binded())
				return

			if(get_dist(M,src)>1)
				return

			src.add_fingerprint(M)




			if(istype(what, /obj/small/lock_pick))

				if(what.dura>3)

					src.pick_lock(M)
					what.dura -= rand(10,17)
					what.break_r(M)
				return
			if(istype(M.hand, /obj/small/optic_cam))
				M<<"view under door"
				return


		bumped(atom/a)

			if(istype(a, /mob))
				var/mob/M = a
				if(M.is_Binded())
					return

				if(src.open)
					src.close(a)
				else
					//if(a.dir & src.no_enter)
					//	return
					src.open(a)
			..()
