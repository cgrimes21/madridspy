proc
	initialize_hole(mob/M)

		var/icon/i = icon('fadeh2.dmi')
		M.client.view = "19x19"//15
		for(var/v in icon_states(i))
			var/obj/o = new()
			o.icon = 'fadeh2.dmi'

			var
				p1 = copytext("[v]",1,findtext("[v]",","))
				p2 = copytext("[v]",findtext("[v]",",")+1)
			p1 = text2num(p1)
			p2 = text2num(p2)

			p1 -=1
			p2 -= 1

		//	v = "[p1],[p2]"
			o.icon_state = "[v]"
			o.screen_loc = "[v]"
			o.mouse_opacity = 0
			o.layer = 999
			M.client.screen += o
