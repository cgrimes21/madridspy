dialog


	var/list/cont = list()	//list of pages
	var/place = 1		//which page you are on
	var/can_close = 1	//can you close it before reach end? default: yes


	proc/action(mob/m)	//perform certian action when you get to certain page

	proc/view_page(p=1,mob/m)	//p as page number
		if(!m) return
		if(!m.client) return

		if(p<=0) return
		if(p>cont.len) return

		play_sound(m,m.loc,'sounds/mouseclick.wav',1)

		winshow(m,"msg",1)
		var/dialog/page/tempage = cont[p]
		var/header = tempage.head
		var/body = tempage.body
		var/act = tempage.action
		var/can_c = src.can_close

		m<<output("[header]","msg.header")
		m<<output("[body]","msg.body")

		//hide/show appropriate buttons

		if(p-1 <= 0)
			winshow(m,"msg.previous",0)
		else
			winshow(m,"msg.previous",1)
		if(p+1 > cont.len)
			winshow(m,"msg.next",0)
		else
			winshow(m,"msg.next",1)
		if(!can_c)

			if(p == cont.len)
				winshow(m,"msg.close",1)
			else
				winshow(m,"msg.close",0)
		else	//can close at any time, show close button
			winshow(m,"msg.close",1)

		//play actions
		if(act)
			action(m)

	page
		var/head
		var/body
		var/list/l1
		var/action = 0	//no action


proc/begin_dialog(dialog/d,mob/who)
	if(!d) return
	if(!who) return

	var/dialog/dia = new d.type
	who.c_dialog = dia
	dia.view_page(1,who)

mob/var/tmp/dialog/c_dialog

mob/verb
	previousmsg()
		set hidden = 1
		var/dialog/d = src.c_dialog
		if(!d) return
		var/h = d.place - 1
		if(!d.cont[h])
			return
		d.place -= 1
		d.view_page(h,src)

	nextmsg()
		set hidden = 1
		var/dialog/d = src.c_dialog
		if(!d) return
		var/h = d.place + 1
		if(!d.cont[h])
			return
		d.place += 1
		d.view_page(h,src)

	closemsg()
		set hidden = 1
		if(!src.part)
			if(src.mission)	//not on second part yet
				src.mission.end_dialog(src)
		else
			src.part.end_dialog(src)

		winshow(src,"msg",0)
		src.c_dialog = null
