mob/var
	tmp/scope_x = 0
	tmp/scope_y = 0
	tmp/scope_z = 0
	tmp/mouse_in = 0
client
	proc/move_eye(turf/t, direction)
		if(src.mob.mouse_in)
			var/turf/tt = get_step(src.eye, direction)
			if(tt.density)
				return
			src.eye = t

			sleep(1)
			src.move_eye(tt, direction)

obj/scope_arrow
	icon = 'scope.dmi'
	layer = 9999
	mouse_opacity = 2






	MouseEntered()
	/*
		if(!usr.scope_x && !usr.scope_y && !usr.scope_z)
			usr.scope_x = usr.x
			usr.scope_y = usr.y
			usr.scope_z = usr.z
			*/
		if(usr.mouse_in)
			return

		usr.mouse_in  = 1
		if(usr.client)
			var/turf/t = get_step(usr.client.eye, src.dir)
			usr.client.move_eye(t, src.dir)
		..()
	MouseExited()
		usr.mouse_in = 0
		..()


	proc/check_turf(x,y,z)
		.=0

		var/turf/t = locate(x,y,z)

		if(t.density)
			return 1
		else
			return 0


	down
		screen_loc = "8,1"
		dir = SOUTH

	up
		screen_loc = "8,15"
		dir = NORTH

	left
		screen_loc = "1,8"
		dir = WEST

	right
		screen_loc = "15,8"
		dir = EAST
mob/var/tmp/scoping = 0

obj
	small
		weapon
			icon = 'spy2.dmi'
			icon_state = "8"
			weight = 3
			range = 7
			var
				model = 0		//what type of weapon it is
				resist = "AC"	//what type of protection resists it
				action = ""
				sound = ""
				damage = 2

				clip			//how big the clip is
				reload			//reload time
				noise = 10
				silencer
				extra_clip
				precision
				reloading = 0
				in_chamber		//bullets in chamber



			body_loc = RIGHT_HAND


			hands
				range = 1
				damage = 1
				action = "hit"
				delay = 3
				force = 1
			gun
				verb/equip_()
					set src in usr
					set category = null
					src.equip(usr)

				action = "shoot"
				blowgun
					weight = 1
					name = "blow-gun"

				icon = 'shit.dmi'
				icon_state = "357"

				poison_gun
					icon = 'sniper.dmi'
					icon_state = "2"
					model = m40a3
					initial_value = 275
					value = 275
					sale_value = 150
					delay = 250
					weight = 1
					force = 2
					range = 24
					body_loc = BACK
					desc = "A gun that inflicts approx. 22 seconds of deadly poison into target *almost assuring death. \
					Nice and clean, perfect for quiet elimination."


					verb
						warp()
							set src in usr
							set hidden = 1
							usr.loc = usr.client.eye
						scope()
							set src in usr
							if(usr.scoping)
								usr.scoping = 0

								if(usr.client)
									usr.client.eye = usr
									for(var/obj/scope_arrow/a in usr.client.screen)
										game_del(a)
							else
								usr.scoping = 1
								if(usr.client)
									usr.client.screen += new /obj/scope_arrow/up
									usr.client.screen += new /obj/scope_arrow/down
									usr.client.screen += new /obj/scope_arrow/left
									usr.client.screen += new /obj/scope_arrow/right

					attack(mob/who,mob/target)
						if(!who)
							return
						if(!target)
							return

						play_sound(null,who.loc,'sounds/three/dart.ogg',0)
						play_sound(null,target.loc,'sounds/three/dart.ogg',0)
						var/obj/o = new(who.loc)

						o.icon = 'shit.dmi'
						o.icon_state = "tranq dart"
						if(get_dist(o, target)<=8)
							walk_to(o,target,0,1)
							while(o.loc != target.loc)
								sleep(1)
							game_del(o)


						if(prob(70))
							target.last_hostile = who.real_name
							if(!target.poison)
								target<<"\green You have been poisoned!"
								who<<"\green You have successfully injected [target.name] with poison!"
								orange(5,target)<<"\green [target.name] has been poisoned!"
							target.poison += rand(20,24)


				Magnum

					icon_state = "45"
					model = magnum
					initial_value = 836.95
					name = ".45 Magnum"

					damage = 2
					range = 7
					delay = 7
					reload = 14
					clip = 6
					noise = 4

					min_rank = 0//1




				Revolver
					model = revolver
					initial_value = 500
					value = 500
					sale_value = 400

					name = ".357 Revolver"

					damage = 3
					range = 6
					delay = 11
					reload = 4
					clip = 6
					noise = 8

					min_rank = 0//6

				Colt
					model = coltapc
					initial_value = 995
					name = ".45 Colt APC"

					damage = 2
					range = 5
					delay = 5
					reload = 20
					clip = 20
					noise = 9

					min_rank = 0//15

				Desert
					model = deserteagle
					initial_value = 1469
					value = 1000
					sale_value = 1234
					name = "Desert Eagle"

					damage = 5
					range = 4
					delay = 1
					reload = 14
					clip = 6
					noise = 10

					min_rank = 0//22


				R700
					icon = 'sniper.dmi'
					icon_state = "1"

					model = r700
					initial_value = 4500


				M40A3
					icon = 'sniper.dmi'
					icon_state = "2"
					model = m40a3
					initial_value = 500
					value = 250
					sale_value = 250

				Barrett
					icon = 'sniper.dmi'
					icon_state = "3"
					model = barrett
					initial_value = 8000

				M21
					icon = 'sniper.dmi'
					icon_state = "4"
					model = m21
					initial_value = 5000

				Mac
					model = mac
					initial_value = 3695

				Mp5
					model = mp5
					initial_value = 24000

				P90
					model = p90
					initial_value = 3995
			tranq_dart
				action = "hit"
				icon = 'shit.dmi'
				icon_state = "tranq dart"
				range = 12
				value = 80
				initial_value = 80
				sale_value = 45
				force=2
				body_loc = BSLOT || BELT || SLEEVE

				var/dose = 5

				name = "tranquilizer"
				set_desc()
					desc = {"[src.dose] uses. Will stop target in their tracks for 10 seconds. Use at your own risk."}
				desc = "5 uses. Will stop target in their tracks for 15 seconds. Use at your own risk."

				weight = 1

				attack(mob/who,mob/target)
					if(!who)
						return
					if(!target)
						return
					src.dose -= 1
					if(src.dose < 0)
						who<<"tranquilizer used up!"
						game_del(src)
						return

					play_sound(null,who.loc,'sounds/three/dart.ogg',0)
					play_sound(null,target.loc, 'sounds/three/dart.ogg',0)
					var/obj/o = new(who.loc)
					o.icon = src.icon
					o.icon_state = src.icon_state
					walk_to(o,target,0,1)
					while(o.loc != target.loc)
						sleep(1)
					game_del(o)

					target.last_hostile = who.real_name
					src.set_desc()
					target.stun = 10
					who<<"[target.name] hit with tranquilizer."


					//target.stun = 15


			knife
				action = "stab"
				icon = 'shit.dmi'
				icon_state = "knife"
				range = 1
				weight = 2
				force=1
				value = 60
				initial_value = 60
				sale_value = 30

				body_loc = BSLOT || SLEEVE || BELT

				var/poison = 0	//level of poison
				var/tranq = 0	//level of tranquilizer

				name = "Marbles 05CS Crown Stag Bowie"
				initial_value = 72.34
				desc = {"9" polished stainless clip blade, 15 1/4" overall, crown stag handle, brass guard, leather sheath."}

				attack(mob/who,mob/target)
					play_sound(null,target,'sounds/three/knife.ogg',0)
					if(!target.slash)
						target<<"\red [who.name] stabs you! You feel disoriented.<br>"
					target.slash+=5


					if(prob(90))
						target.get_hit(who,src,rand(1,2+src.force))

				//	world<<"[target.name] gets hit with a [src.name] by [who.name]"