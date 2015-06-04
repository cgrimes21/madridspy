mob/agent/slow_tickle()
	//every 12 seconds
	for(var/mob/agent/a in world)
		if(a.client)
			if(a.ragency == src.ragency)
				if(!(a in src.teammate))

					var/image/Ii = 	image('shit.dmi',a,"tranq dart",layer=MOB_LAYER)
					Ii.pixel_y += 32
					if(src.client)
						src.client.images += Ii
					src.teammate += a
;
//	src.refresh_overlays()
mob/var/tmp/list/teammate = list()