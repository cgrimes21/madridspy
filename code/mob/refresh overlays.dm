mob
	verb/*
		debuggs()
			for(var/obj/i in src.Overlays)
				world<<"this is i - [i.name]"
			var/obj/o = src.Overlays[1]
			if(o)
				world<<"this is one [o.name]"
		clear_list()
			src.Overlays = list()


		defragger()
			//defrags the list


			var/obj/o
			var/flag = 0
			for(var/i=1, i<src.Overlays.len, i++)
				if(!src.Overlays[i])

					for(var/b = i, b<=src.Overlays.len-1, b++)
						if(src.Overlays[b+1])
							o = src.Overlays[b+1]
							flag = b+1
							break
					if(o && flag)

						src.Overlays[i] = o
						src.Overlays[flag] = null
*/
	proc/refresh_overlays()	//refresh weapon overlays



		src.overlays = null
		if(src.slip) return	//dont do it
		//src.Overlays = list()

		//if(!src.Overlays)
		//	src.Overlays = list()
		//	return



/*

		for(var/obj/overlays/o in src.Overlays)

			if((o.name == "pistol_overlay") || (o.name=="sniper_overlay")|| (o.name == "swat"))
				src.Overlays -= o
*/
	/*
		for(var/i=1, i<=src.Overlays.len, i++)

			if(src.Overlays[i])

				o=src.Overlays[i]
				if((o.name == "pistol_overlay") || (o.name=="sniper_overlay")|| (o.name == "swat"))

					src.Overlays[i] = null

*/
		if(src.w_head)
			if(istype(src.w_head,/obj/small/clothing/mask/swat_thermal))
				var/obj/overlays/o = new()
				o.icon = 'head.dmi'
				o.icon_state = "helmet2"
				o.name = "swat"
				o.layer = layer_weapon+1
				o.layer = layer_weapon+1

				src.overlays += o

			if(istype(src.w_head,/obj/small/clothing/mask/swat))

				var/obj/overlays/o = new()
				o.icon = 'head.dmi'
				o.icon_state = "helmet"
				o.name = "swat"
				o.layer = layer_weapon+1
				o.olayer = layer_weapon+1
				src.overlays += o




		if(src.pistol_out)
			var/obj/overlays/I = PISTOL_OVERLAY

			src.overlays += I

		if(src.machinegun_out)
			var/obj/overlays/I = MACHINEGUN_OVERLAY
			//if(!(I in src.Overlays))
			src.overlays += I



		if(src.sniper_out)
			var/obj/overlays/sniper_overlay/I = SNIPER_OVERLAY



			src.overlays += I



		if(src.hand)
			src.overlays += src.hand_overlay
/*
		for(var/obj/v in src.Overlays)
			if(v == null || v==" " || !(v))
				game_del(v)

				*/
			//src.overlays += v
		//src.overlays += src.Overlays

		//do other stuff here