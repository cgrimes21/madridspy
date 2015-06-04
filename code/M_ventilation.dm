obj
	vent
		density = 0
		icon = 'vents.dmi'


		opening
			icon_state = "vent"
			invisibility = 0
			var/closed = 1

			interact(mob/M)


				if(get_dist(M,src)<=1)

					if(istype(M.hand, /obj/small/screwdriver))
						src.closed = !src.closed
						src.icon_state = "vent[src.closed ? "" : "o"]"
						var/turf/vents/exit/e = locate(src.x,src.y,2)
						if(e)
							e.closed = src.closed
							e.icon_state = "exit[src.closed ? "" : "o"]"
						return
					if(!src.closed)
						M.loc = src.loc
						M.z = 2

						play_music(M,'fan.ogg',1,1)


		top_layer_vents
			invisibility = 5
			layer = TURF_LAYER

			//these are placed within the actual map to get a feel of the ventilation layout with technology

		gas
			icon_state = "gas"

		fan
			icon_state = "fan"
			density = 1
			var/panel_out = 0
			var/id

			explode()
				..()

				src.icon_state = "fan0"
				src.density = 0
				spawn(rand(400,500))
					src.density = 1
					src.icon_state = "fan"
			interact(mob/M)
				if(M.hand)
					if(istype(M.hand,/obj/small/screwdriver))
						src.panel_out = !src.panel_out
						src.icon_state = "fan[src.panel_out ? "panelopen" : ""]"
			verb
				hack()
					set src in oview(1)
					var/obj/small/h = locate(/obj/small/hacker) in usr

					if(h)
						if(h.dura>3)
							h.dura -= 3

							if(src.density)
								src.density = 0
								src.icon_state = "fan0"

								usr<<"\blue Fan was successfully hacked!"
								spawn(rand(200,400))
									if(src)
										if(!src.density)
											src.icon_state = "fan"
											src.density = 1
										return
									return


								h.break_r(usr)



turf

	black
		luminosity = 1
		opacity = 1
		density = 1
		icon_state = "black"