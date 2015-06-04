mob
	var
		tmp/list/quick_select_main
		place = 1	//place holder
		tmp/obj/selected
		tmp/obj/m
		tmp/obj/l
		tmp/obj/r
		tmp/obj/hand_overlay

	proc/reveal_hand()			//reveals selected item
		if(src.selected)
			if(src.selected in src)//it exists within you, then you can bring it out

				src.hand_overlay = image('right_hand.dmi',icon_state = "[src.selected.icon_state]", layer = layer_rhand_overlay)
			//	src.selected.Move(src.hand)
				src.hand = src.selected
				if(istype(src.selected, /obj/small/weapon))
					//its a weapon, equip it
					var/obj/small/weapon/ss = src.selected
					ss.equip(src)


				src.overlays += src.hand_overlay

				play_sound(src,src.loc,'reveal.ogg',0)
			else
				src.selected = null

	proc/conceal_hand()
		if(src.hand)

			if(istype(src.hand, /obj/small/weapon))
					//its a weapon, equip it
				var/obj/small/weapon/ss = src.hand
				ss.uequip(src)
			//src.selected = src.hand
			//src.hand.Move(src.selected
			src.hand = null
			src.overlays -= src.hand_overlay
			src.hand_overlay = null

			play_sound(src,src.loc,'reveal.ogg',0)


	proc/update_places()
		//src.client.screen = null
		for(var/obj/hud_objects/quick/h in src.client.screen)
			if(istype(h,/obj/hud_objects/quick))
				h.icon = null
				h.overlays = null
				h.underlays = null
		//	del h

		if(src.m)

			var/obj/hud_objects/quick/h = new()

			h.name = m.name
			h.icon = m.icon
			h.icon_state = m.icon_state
			h.underlays += image('screen.dmi',"back")
			h.screen_loc = "main:1,1"
			src.client.screen += h

			src<<output("[src.m.desc]","quicks.des")
			src<<output("[src.m.name]","quicks.dn")

		if(src.l)

			var/obj/hud_objects/quick/h = new()

			h.name = l.name
			h.icon = l.icon
			h.icon_state = l.icon_state
			h.underlays += image('screen.dmi',"back")
			h.screen_loc = "left:1,1"
			src.client.screen += h

			//src<<output(src.l.icon,"quicks.left")


		if(src.r)
			var/obj/hud_objects/quick/h = new()

			h.name = r.name
			h.icon = r.icon
			h.icon_state = r.icon_state
			h.underlays += image('screen.dmi',"back")
			h.screen_loc = "right:1,1"
			src.client.screen += h


	verb
		qs()
			set hidden = 1
			play_sound(src,src.loc,'wpnselect.ogg',1)
			src.quick_select_main = list()

			for(var/obj/small/s in src)

				src.quick_select_main += s


			if(src.place > quick_select_main.len)
				src.place = quick_select_main.len
			if(src.place<1)
				src.place = 1

			if(!src.quick_select_main.len)
				src<<"You have nothing to select from."
				return

				//nothing in inventory to show

			if(src.quick_select_main[src.place])
				src.m = src.quick_select_main[src.place]
			if(src.place-1>0)//its not zero

			//	if(quick_select_main[src.place-1])
				src.l = src.quick_select_main[src.place-1]




			if((src.place+1)<=src.quick_select_main.len)

				//if(quick_select_main[src.place+1])
				src.r = src.quick_select_main[src.place+1]


			src.update_places()

			winshow(usr,"quicks",1)
			//winset(src,"quicks","pos='250x-50'")
			winset(src,"quicks","is-maximized=true")
		item_act()
			set hidden = 1
			if(src.selected)
				src.selected.activate_item(usr)
		ext()
			set hidden = 1
			winshow(usr,"quicks",0)
			src<<"[m.name] selected"
			src.selected = src.m
			play_sound(src,src.loc,'wpnselect.ogg',1)


		prev()
			set hidden = 1

			//if theres a place to the left, select it and make it in the middle
			if(((src.place-1)>0) && (src.place-1 <= quick_select_main.len))
				src.place -=1
				src.m = src.quick_select_main[src.place]

				//find the item to this place's right, make it your right
				if((src.place+1)<=src.quick_select_main.len)
					src.r = src.quick_select_main[src.place+1]
				else
					src.r = null	//nothing



				//do same to left
				if((src.place-1)>0)
					src.l = src.quick_select_main[src.place-1]
				else
					src.l = null




				src.update_places()
				play_sound(src,src.loc,'wpnswitch.ogg',1)



		next()
			set hidden = 1
			//if theres a place to the left, select it and make it in the middle
			if(((src.place+1)>0) && (src.place+1 <= quick_select_main.len))
				src.place +=1
				src.m = src.quick_select_main[src.place]

				//find the item to this place's right, make it your right
				if((src.place+1)<=src.quick_select_main.len)
					src.r = src.quick_select_main[src.place+1]
				else
					src.r = null	//nothing



				//do same to left
				if((src.place-1)>0)
					src.l = src.quick_select_main[src.place-1]
				else
					src.l = null



				src.update_places()
				play_sound(src,src.loc,'wpnswitch.ogg',1)
		upp()
			set hidden = 1
			//world<<"/"
		down()
			set hidden = 1
			//world<<"/"
		itemuse()
			set hidden = 1
			winshow(usr,"quicks",0)
			if(src.hand)
				//interact src.hand with src.m
				src.m.activate_item(src)
			//src.interact()
			play_sound(src,src.loc,'wpnselect.ogg',0)

		out()
			set hidden = 1
			winshow(usr,"quicks",0)

			play_sound(src,src.loc,'wpnselect.ogg',1)
			src.selected = src.m
			src.reveal_hand()

		reveal()
			set hidden = 1
			if(src.hand)
				src.conceal_hand()
			else
				src.reveal_hand()

