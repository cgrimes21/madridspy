obj/balloon
	icon = 'balloontext.dmi'
	mouse_opacity = 0
	layer = 99
	text
		icon = 'alphabet.dmi'
		layer = 100

	tl
		icon_state = "tl"
		pixel_x = -20
		pixel_y = 46
	tr
		icon_state = "tr"
		pixel_x = 44
		pixel_y = 46
	bl
		icon_state = "bl"
		pixel_x = -20
		pixel_y = 14
	br
		icon_state = "br"
		pixel_x = 44
		pixel_y = 14
	top
		icon_state = "tm"
		pixel_x = 12
		pixel_y = 46
	cl
		icon_state = "cl"
		pixel_x = 2
		pixel_y = 46
	cr
		icon_state = "cr"
		pixel_x = 111
		pixel_y = 46
	bottom
		icon_state = "bm"
		pixel_x = 12
		pixel_y = 14
	middle
		icon_state = "cm"
		pixel_x = 11
		pixel_y = 46
	tail
		icon_state = "tail"
		pixel_x  = 0
		pixel_y = 22
		layer = OBJ_LAYER + 99.1

mob/var/saying = 0
mob/var/timesaid = 0

mob/proc/sayb(t)

	if(src.saying)

		for(var/obj/V in Overlays)
			if(istype(V,/obj/balloon))// == "balloon")
				game_del(V)

		src.refresh_overlays()
		src.saying = 0
		src.timesaid = 0

	src.saying = 1
	src.timesaid += 36
	balloon(t, src)


proc
	balloon(t as text,mob/m)

		var
			len = lentext(t)
			//width and height of box

			width = 0
			height = 0

			obj/balloon/tl/tl = new
			obj/balloon/tr/tr = new

			obj/balloon/bl/bl = new
			obj/balloon/br/br = new
			obj/balloon/top/tm = new

			obj/balloon/top/tm1 = new
			obj/balloon/top/tm2 = new
			obj/balloon/top/tm3 = new

			obj/balloon/top/tm4 = new
			obj/balloon/top/tm5 = new
			obj/balloon/top/tm6 = new
			obj/balloon/top/tm7 = new

			obj/balloon/bottom/bm1 = new
			obj/balloon/bottom/bm2 = new
			obj/balloon/bottom/bm3 = new
			obj/balloon/middle/m1 = new
			obj/balloon/middle/m2 = new
			obj/balloon/middle/m3 = new
			obj/balloon/middle/m4 = new

			obj/balloon/cl/l = new
			obj/balloon/cl/ll = new
			obj/balloon/cr/rr = new
			obj/balloon/cr/r = new

			obj/balloon/bottom/bm = new
			obj/balloon/tail/tail = new


		if(len > 7)
			var/add = len - 7
			width += add*6

			var/icon/I = new('balloontext.dmi',"tm")
			var/icon/B = new('balloontext.dmi',"bm")

			bm1.pixel_x = 44
			bm1.pixel_y = 37

			tm1.pixel_x = 44
			tm1.pixel_y = 46

			B.Crop(1,24,width,32)
			I.Crop(1,1,width,9)
			tm1.icon = I
			bm1.icon = B


		if(width>66)
			width=66
		if(width>32)
			//make another and crop it
			var/w = width-32
			var/icon/I = new('balloontext.dmi',"tm")
			var/icon/B = new('balloontext.dmi',"bm")

			bm2.pixel_x = 44+32
			bm2.pixel_y = 37

			tm2.pixel_x = 44+32
			tm2.pixel_y = 46

			B.Crop(1,24,w,32)
			I.Crop(1,1,w,9)	//	I.Crop(1,24,w,32)
			tm2.icon = I
			bm2.icon = B
		if(width>64)
			var/w = width-64

			var/icon/I = new('balloontext.dmi',"tm")
			var/icon/B = new('balloontext.dmi',"bm")

			bm3.pixel_x = 44+64
			bm3.pixel_y = 37

			tm3.pixel_x = 44+64
			tm3.pixel_y = 46

			B.Crop(1,24,w,32)
			I.Crop(1,1,w,9)	//	I.Crop(1,24,w,32)
			tm3.icon = I
			bm3.icon = B

		if(len > 17)
			height += 13
		if(len > 17*2)
			height += 13
		if(len > 17*3)
			height += 13
		//68 total
		if(len > 17)
			//chop cl by 12
			var/icon/I = new('balloontext.dmi',"cl")
			var/icon/R = new('balloontext.dmi',"cr")



			if(len>17*3)

				var/icon/LL = new('balloontext.dmi',"cl")
				var/icon/RR = new('balloontext.dmi',"cr")

				RR.Crop(1,1,9,7)
				LL.Crop(24,1,32,7)
				ll.icon = LL
				rr.icon = RR

				rr.pixel_y+=32
				//rr.pixel_y += 32

				ll.pixel_y += 32
				m.Overlays += ll
				m.Overlays += rr


				var/icon/TM4 = new('balloontext.dmi',"cm")
				var/icon/TM5 = new('balloontext.dmi',"cm")
				var/icon/TM6 = new('balloontext.dmi',"cm")
				var/icon/TM7 = new('balloontext.dmi',"cm")

				TM7.Crop(1,1,width-62,7)
				TM6.Crop(1,1,32,7)
				TM5.Crop(1,1,32,7)
				TM4.Crop(1,1,32,7)

				tm7.pixel_y += 32
				tm7.pixel_x += 95
				tm7.icon = TM7

				tm6.pixel_y += 32
				tm6.pixel_x += 63
				tm6.icon = TM6

				tm5.pixel_y += 32
				tm5.pixel_x += 31
				tm5.icon = TM5

				tm4.pixel_y += 32
				tm4.pixel_x -= 1
				tm4.icon = TM4

				m.Overlays += tm4
				m.Overlays += tm5
				m.Overlays += tm6
				m.Overlays += tm7



			R.Crop(1,1,9,height)
			I.Crop(24,1,32,height)
			r.icon = R
			l.icon = I

			m.Overlays += l
			m.Overlays += r

			var/icon/M1 = new('balloontext.dmi',"cm")
			var/icon/M2 = new('balloontext.dmi',"cm")
			var/icon/M3 = new('balloontext.dmi',"cm")
			var/icon/M4 = new('balloontext.dmi',"cm")

			M1.Crop(1,1,32,height)
			M2.Crop(1,1,32,height)
			M3.Crop(1,1,32,height)
			M4.Crop(1,1,width-62,height)

			m1.icon = M1
			m2.icon = M2
			m3.icon = M3
			m4.icon = M4

			m2.pixel_x += 32
			m3.pixel_x += 64
			m4.pixel_x += 96

			m.Overlays += m1
			m.Overlays += m2
			m.Overlays += m3
			m.Overlays += m4



		tr.pixel_x += width
		br.pixel_x += width

		tm1.pixel_y += height
		tm2.pixel_y += height
		tm3.pixel_y += height
		tl.pixel_y += height
		tr.pixel_y += height
		tm.pixel_y += height

		if(len>7)
			m.Overlays += tm1
			m.Overlays += bm1

		if(width>32)
			m.Overlays += tm2
			m.Overlays += bm2

		if(width>64)
			m.Overlays += tm3
			m.Overlays += bm3

		m.Overlays += tail
		m.Overlays += tl
		m.Overlays += tr
		m.Overlays += bl
		m.Overlays += br
		m.Overlays += tm
		m.Overlays += bm


		//thats the balloon, now time for text
		var/list/text = list()
		for(var/i = 2, i<=len+1, i++)
			text += copytext(t, i-1, i)

		var/xx = 7
		var/yy = 41 + height
		var/c = 0
		var/tot = 0
	//	var/trigger = 0	//if 1, backup to nearest space and then add another

		for(var/v in text)
			c++
			tot ++
			var/obj/balloon/text/a = new
			a.icon_state = "[v]"
			a.pixel_x = xx
			a.pixel_y = yy
			if(v == "g")
				a.pixel_y -= 1
				a.pixel_x -=1
			if(v == "y")
				a.pixel_y -= 1
			if(v == "p")
				a.pixel_y -= 1

			xx += 6
			if(v == "i")
				xx -= 2
			if(v == "l")
				xx -= 2
			if(v == " ")
				xx -= 2
			if(c>18)
			//	trigger = 1
			//	if(v != " ")	//not a space, backup
			//		for(var/i = tot, i>1, i--)

				xx = 7
				yy -= 12
				c=0
			if(tot>68)
				break	//break and do nomore
			m.Overlays += a
		m.refresh_overlays()
		//m.overlays += m.Overlays









