obj
	decals
		bed
			icon = 'objects.dmi'
			icon_state = "bed"
			layer = layer_bed



		vendor_door
			icon = 'vendor_door.dmi'
			opacity = 1
			density = 1
			bumped(atom/movable/a)
				if(istype(a, /mob))

					var/obj/small/card/c = locate(/obj/small/card) in a
					if(c)
						for(c in a)

							if(c.icon_state == "[src.icon_state]c")
								a.loc = src.loc



		holding_cell
			icon = 'holdingcell.dmi'
		bush
			density = 1
			icon = 'turfs.dmi'
			icon_state = "bush"
			layer = MOB_LAYER+1
			bumped(mob/M)
				..()
				if(istype(M,/mob/agent))
					var/mob/agent/a = M
					a.loc = src.loc
					a.hide()
					a.stun = 1
				//	a.stuck = 80
					//a.slip()

		carpet
			icon = 'turfs.dmi'
			icon_state = "carpet"
		bench
			icon = 'turfs.dmi'
			icon_state = "bench"

		trash_can
			icon = 'base objects.dmi'
			icon_state = "trash"
			density = 1
			layer = MOB_LAYER + 2
			bumped(mob/M)
				..()
				if(istype(M,/mob/agent))
					var/mob/agent/a = M
					a.loc = src.loc
					a.hide()
					a.stun = 1

			jump	//trashcan jump
				var/jx
				var/jy
				var/jz
				var/side = null

				oss_out_jump

					jx = 51
					jy = 70
					jz = 1

				oss_trash_jump
					jx = 72
					jy = 86
					jz = 1
					side = 1

				get_hit_hand(mob/M)
					if(get_dist(M,src) <= 1)

						if(src.side)
							if("[src.side]" != "[M.agency]")
								return
						M.loc = locate(jx,jy,jz)


