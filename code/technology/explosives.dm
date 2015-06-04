obj/small
	electronics


		transmitter
			icon = 'objects.dmi'
			icon_state = "transmitter"
			desc = "A device to be used for explosives. Any signals sent to this device will trigger a shock of 1000+ degrees of electricity. This is ideal for attaching this device to explosives and detonating remotely. This also can be used to stun enemies.\nDoes not work yet."
			value = 25
			initial_value = 25
			sale_value = 5
			explode()
				..()
				game_del(src)

			activate_item(mob/M)


		emitter
			icon = 'objects.dmi'
			icon_state = "emitter"
			desc = "This device creates a laser-tripwire when placed. Disrupting the signal will trigger the emitter.\n\nIf an explosive is attached, the explosive will detonate. After, the device emitts a signal to the specified frequency, which can be used in combination with a transmitter to detonate explosives remotely.\nDoes not work yet."
			value = 25
			initial_value = 25
			sale_value = 5

			explode()
				..()
				game_del(src)







	explosive
		icon = 'objects.dmi'
		icon_state = "explosive"
		desc = "A highly explosive combination of chemicals and material. Detonation point exists above 1000 degrees C."

		value = 25
		initial_value = 25
		sale_value = 5

		proc/detonate(obj/o,mob/M)	//M is who set the bomb off
			play_sound(o,o.loc,'explode1.wav',0)
			for(var/atom/a in range(1,o))
				//if(a && (a in range(2,src)))
				if(istype(a,/area))
					continue
				a.explode(M)

		activate_item(mob/M)

			if(M.hand)
				if(istype(M.hand, /obj/small/timer) || istype(M.hand, /obj/small/motion_sensor) ||	istype(M.hand, /obj/small/electronics/transmitter) ||istype(M.hand, /obj/small/electronics/emitter))	//its a timer
					src.Move(M.hand)
					M<<"explosive combined with [src.name]."
					M.hand.underlays += src


	timer
		icon = 'objects.dmi'
		icon_state = "timer"
		value = 25
		initial_value = 25
		sale_value = 5
		desc = "A small timer."

		explode()
			..()
			game_del(src)

		var/tmp/time = 0
		proc/timerup(mob/M)
			src.icon = initial(src.icon)
			range(4,src)<<"*beep *beep"
			for(var/obj/small/explosive/e in src)
				e.detonate(src,M)



		proc/timerbegin(mob/M)//mob who set

			if(src.time>0)
				src.icon += rgb(0,0,0,75)

				while(src.time>0)
					sleep(10)
					src.time -= 1
					src.suffix = "[src.time] seconds"
					if(src.time <= 0)
						src.timerup(M)
						break

		activate_item(mob/M)

			if(src.time <= 0)
				var/t = input("Enter the amount of seconds before this timer detonates. \n60 seconds = 1 minute\n300 seconds = 5 minutes") as null|num

				if(!t) return
				if(!M) return
				if(!M.client) return

				if(src.time<=0)
					src.time = t
					M<<"\blue timer set to [t] seconds."
					spawn()
						src.timerbegin(M)


	motion_sensor
		icon = 'objects.dmi'
		icon_state = "motion sensor"
		desc = "Senses motion up to 3 spaces away.\nDoes not work yet."

		value = 25
		initial_value = 25
		sale_value = 5