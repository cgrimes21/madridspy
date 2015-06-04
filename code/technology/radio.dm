obj/small
	electronics			//anything that has a frequency that can inter-comm. with each other, place in this tree



		proc
			rec_signal(mob/M, msg, freq)	//recieve signal, called when this device recieves a signal from parameters

				if(freq != src.freq)
					return	//must be same frequency

		var
			freq = 0

		radio
			icon = 'objects.dmi'
			icon_state = "radio"
			value = 10
			initial_value = 10
			sale_value = 5
			body_loc = BELT
			weight = 1

			var

				tmp/sending = 0

			desc = "Frequencies: 2.2-18.8\nA radio used to send radio waves to selected frequency. Can be in the form of a message, or you can use it to detonate explosives operating on the same frequency."

			rec_signal(mob/M, msg, freq)
				..()

				for(var/mob/m in range(1, src))
					play_sound(m,m.loc,'eo_radio.wav',0)

					m<<" <font color=red>\[[freq]]</font color> <b>[M.name] :</b> [msg]"

			get_hit_self(mob/M)
				if(!M || (!M.client)) return

				if(sending) return
				sending = 1

				var/t = input("Radio signal") as null|text
				if(!t)
					sending = 0
					return
				if(!M.client)
					sending = 0
					return
				if(!src)
					sending = 0
					return


				for(var/obj/small/electronics/e in world)
					if(e.freq == src.freq)
						e.rec_signal(usr, t, src.freq)



				sending = 0
			verb


				freq(t as num)
					set src in usr
					set category = null
					t = max(2.2,t)
					t = min(18.8,t)
					t = round(t,0.1)
					usr<<"\blue Frequency set to [t]."
					src.suffix = "([t])"
					src.freq = t