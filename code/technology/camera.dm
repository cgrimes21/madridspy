mob/var/tmp/obj/small/camera/looking
mob/var/tmp/po = 1
mob/verb/camera_r()
	set hidden = 1
	if(src.looking)
		src.po ++

		src.po = max(src.po,1)
		src.po = min(src.po,20)
		src.looking.load_pic(src.po,src)
		src<<output("Picture [src.po]/20","camera.pictureo")

mob/verb/camera_l()
	set hidden = 1
	if(src.looking)
		src.po --

		src.po = max(src.po,1)
		src.po = min(src.po,20)
		src.looking.load_pic(src.po,src)
		src<<output("Picture [src.po]/20","camera.pictureo")
obj/small/camera
	name = "camera"
	icon = 'shit.dmi'
	desc = "A camera."
	icon_state = "camera"
	var/pictures[20][100]
	var/maxpics = 20
	var/pic = 1
	//only carry 20 pictures

	verb/activate()

		usr<<"click. data stored"
		src.desc = "A camera that is carrying [src.pic]/[src.maxpics] data storage."
	//	src.Move(usr.loc)
		//winshow(usr,"camera",1)
		src.update_view(usr)

	verb/look()
		usr.looking = src
		src.load_pic(usr.po, usr)
		usr<<output("Picture [usr.po]/20","camera.pictureo")
		winshow(usr,"camera",1)

	proc/load_pic(pic,mob/M)
		for(var/obj/hud_objects/n in M.client.screen)
			M.client.screen -= n

		for(var/v in src.pictures["[pic]"])
			M.client.screen += v
	//	M<<"finished loading picture [pic]."
		winshow(usr,"camera",1)

	proc/update_view(mob/M)
		if(src.pic >19)
			M<<"This camera is holding the maximum amount of data."
			return
		for(var/obj/hud_objects/n in M.client.screen)
			M.client.screen -= n
		var/list/L = list()

		var/xmin = M.x - 8
		xmin = max(xmin,1)
		xmin = min(xmin,world.maxx)

		var/ymin = M.y - 8
		ymin = max(ymin,1)
		ymin = min(ymin,world.maxy)

		for(var/atom/a in view(7,M))

		//	if(istype(a, /area))
		//		continue



			var/nx = a.x - xmin

			var/ny = a.y-ymin

			if(nx<0 || ny<0)
				continue

			var/obj/hud_objects/b = new()//image(a.icon,a.icon_state,a.layer,a.dir)
			b.icon = a.icon
			b.icon_state = a.icon_state
			b.layer = a.layer
			b.name = a.name
			b.dir = a.dir

			if(istype(a, /turf))

				var/turf/aa = a


				b.overlays += image('light.dmi',,num2text(text2num(aa.lighted)),990)
				L["[nx],[ny]"] = b
				continue


			//space is taken? combine them
			if(L["[nx],[ny]"])
				var/obj/hud_objects/ho = L["[nx],[ny]"]
				if(istype(ho))
					//ho.overlays += L["[nx],[ny]"]
					ho.dir = b.dir
					ho.name = b.name
					ho.overlays += b


					L["[nx],[ny]"] = ho
			else

				L["[nx],[ny]"] = b


		//now we convert the atoms we found into images


		var/list/total = list()

		for(var/v in L)
			var/obj/hud_objects/n = L[v]

			if(istype(n))


				n.screen_loc = "camera:[v]"

				M.client.screen += n

				total += n

		src.pictures["[src.pic]"] = total
		src.pic ++ //move onto the next pic

obj
	hud_objects
		quick
		cam