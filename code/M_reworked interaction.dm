///////////////////////////
////////
///////	New interaction system, created by Cody Grimes on 10/10/10
//////
//////////////////////////
/*Usage:

Left Click interacts left hand with src
Right click does opposite as above

If hand is empty, call src.get_hit_hand(usr)
	this is what src does when hit with a hand
If hand is occupied,
	check if src == src.hand, if so call src.get_hit_self(usr)

	this is what src does when interacted with itself

	-If hand doesnt match src, call src.get_hit(usr,usr.hand)
	-- this is what src does when hit by usr with whats in usrs hand

Attack is called when src attacks mob, is here for space saving purposes
(you would have to define under mob/get_hit every possible thing that mob can
get hit with. With attack, when your defining a new obj simply call its
attack)

*/
#define gui_LH			"equipment:1,2"
#define gui_RH			"equipment:3,2"
#define gui_armor  		"equipment:2,2"
#define gui_boot 		"equipment:2,1"
#define gui_bslot  		"equipment:1,1"
#define gui_head 		"equipment:2,3"
#define gui_mask 		"equipment:1,3"
#define gui_id 			"equipment:3,3"
#define gui_p1 			"equipment:4,1"
#define gui_p2 			"equipment:5,1"
#define gui_back  		"equipment:4,3"
#define gui_belt 		"equipment:6,1"
#define gui_suit  		"equipment:5,2"
#define gui_drop		"equipment:6,2"
#define gui_sleeve		"equipment:3,1"

//storage
#define gui_blank1		"storage1:1,1 to 10,1"
#define gui_cancel1		"storage1:11,1"
#define gui_blank2		"storage2:1,1 to 10,1"
#define gui_cancel2		"storage2:11,1"
atom
	Click(loc,control,params)
		var/list/L = params2list(params)
		var/l = L["left"]
		var/hand = 0		//default is left

		if(!l)	//if right handed click, set hand to 1, otherwise assume left click
			hand = 1
		src.interact(usr,hand)

	proc/interact(mob/M ,hander=0)	//M interacts with src
		if(!M)
			return

		var/obj/hand = M.get_hand(hander)
		if(!hand)
			src.get_hit_hand(M,hander)	//hit src with hand
			return

		if(hand == src)
			//self
			if((src in M) && (hand in M))//have to be within m
				src.get_hit_self(M)
				return
			if(istype(src,/obj/small/grab))	//wont be in M
				src.get_hit_self(M)
				return
		//it wasnt itself, wasnt open hand, its another obj
		src.get_hit(M,hand)
		return

	proc/get_hit(mob/who, obj/small/w, damage = 0)
		//debuggers<<"[src.name] getting hit by [who.name] with [w.name]"

		return
	proc/attack(mob/who,mob/target)
	//	debuggers<<"[src.name] attacking [target.name] by [who.name]"

		return
	proc/get_hit_hand(mob/who,hander)
	//	debuggers<<"[src.name] getting hit with open hand by [who.name]"

		return
	proc/get_hit_self(mob/who)
	//	debuggers<<"[src.name] getting hit with own self within [who.name]"

		return

/mob/proc/get_hand(hander)

	if(!hander)
		return src.lh
	else
		return src.rh
/mob/proc/get_hand_obj(obj/what)
	if(!what) return

	if(src.lh == what)
		return 0
	if(src.rh == what)
		return 1

/mob/proc/set_hand(obj/s,hander)
	if(!s) return

	if(!hander)
		if(!src.lh)
			src.lh = s
	else
		if(!src.rh)
			src.rh = s



/*

intents
kill
disable
search
loot

attacking with kill intent deals damage
attacking with disable intent will either stun or knock target out depending on item used
again, time spent in this state depends again on item used. A toolbox will knock somebody out,
but not as long as a knife can.

when knocked out, target drops items in hand


james cotton heard your getting married
hoopin and jumpin
johnly hooker


*/
//magic slim prison farm blues

//3 handed woman
/obj/gui_o
	layer=OBJ_LAYER-0.1
//	New(loc,sl="1,1",state="",icon)

/obj/gui
	layer=OBJ_LAYER-0.1
	icon = 'screen.dmi'
	drop
		icon_state = "drop"
		screen_loc = gui_drop
		interact(mob/M,hander)
			if(!hander)
				if(M.lh)
					if(istype(M.lh,/obj/small/grab))
						game_del(M.lh)
						M.lh = null

					M.drop_item(M.lh)
			else
				if(M.rh)

					if(istype(M.rh,/obj/small/grab))
						game_del(M.rh)
						M.rh = null
					M.drop_item(M.rh)
	resize
		icon_state = "resize"
		screen_loc = "equipment:5,3"
		var/size=64
		Click()
			if(src.size==64)
				src.size=32
			else
				src.size=64
			usr<<"resize coming soon."
		//	winset(usr,"equipment","icon-size=[src.size]")
	get_hit_hand(mob/who,hander)
		..()
		if(!who)
			return
		switch(src.screen_loc)
			if(gui_p1)
				if(who.w_p1)
						//ease of interface

					who.w_p1.interact(who,hander)//hit it with your hand

					return
				else
					return

	get_hit(mob/user,obj/small/h)
		..()
		if(!user)
			return
		if(!(h in user))
			return
		switch(src.screen_loc)
			if(gui_id)
				if(user.w_id) return
				if(!istype(h,/obj/small/id_card)) return
				user.u_equip(h)
				user.w_id = h
			if(gui_LH)
				if(user.lh) return
				user.u_equip(h)
				user.lh = h
			if(gui_RH)
				if(user.rh) return
				user.u_equip(h)
				user.rh = h
			if(gui_p1)
				if(istype(user.w_p1,/obj/small/grab))
					user.w_p1 = null
				if(h.weight >= 3) return
				if(user.w_p1)

					return
				if(istype(h,/obj/small/grab)) return
				user.u_equip(h)
				user.w_p1 = h
			if(gui_head)
				if(user.w_head)
					return
				if(h.body_loc & HEAD)
					user.u_equip(h)
					user.w_head = h

			if(gui_p2)

				if(h.weight >= 3) return
				if(user.w_p2) return
				if(istype(h,/obj/small/grab)) return
				user.u_equip(h)
				user.w_p2 = h
			if(gui_bslot)
				if(user.w_bootslot) return

				if(h.body_loc & BSLOT)
					user.u_equip(h)
					user.w_bootslot = h

			if(gui_belt)
				if(user.w_belt) return

				if(h.body_loc & BELT)
					user.u_equip(h)
					user.w_belt = h
			if(gui_back)
				if(user.w_back) return

				//if its worn on back, put it there
				if(h.body_loc & BACK)
					user.u_equip(h)
					user.w_back = h
		play_sound(user,user.loc,'sounds/three/rustle5.ogg',0)
		user.refresh_overlays()
		user.refresh_clothings()


	New(loc,screen_loc="1,1",state="")
		..()
		src.screen_loc = screen_loc
		src.icon_state = state

/mob/proc/refresh_clothings()


	src.name = src.real_name
	src.agency = src.ragency
	//GE
	//changed by cody grimes on 2/1/11
	//instead of not having an id card and reverting to your real name, if you dont have an id card you wont have a name

	//not in effect. think about it
	//to put: a stat bit flag that defines if your face is recognizable or not

	if(src.w_id)
		src.w_id.screen_loc = gui_id
		var/obj/small/id_card/c = src.w_id
		src.name = c.written_name
		src.agency = c.agency

	if(src.w_cuff || src.ko>0 || src.health<=0 )	//anything cuffed, if your knocked out, or health below zero,
		src.pulling = null
		if(src.lh)
			src.force_drop_item(src.lh)
		if(src.rh)
			src.force_drop_item(src.rh)

	if(src.w_head)
		src.w_head.screen_loc = gui_head
	if(src.lh)
		//add overlay
		src.lh.screen_loc = gui_LH
	if(src.rh)
		src.rh.screen_loc = gui_RH
	if(src.w_p1)
		src.w_p1.screen_loc = gui_p1
	if(src.w_p2)
		src.w_p2.screen_loc = gui_p2

	if(src.w_bootslot)
		src.w_bootslot.screen_loc = gui_bslot
	if(src.w_belt)
		src.w_belt.screen_loc = gui_belt
	if(src.w_back)
		src.w_back.screen_loc = gui_back
	if(src.client)
		src.client.screen-=src.contents
		src.client.screen+=src.contents
	return

mob/proc/initialize_gui()

	if(!src.client)
		return
	src.client.screen += new /obj/gui (screen_loc=gui_bslot, state="bootslot")
	src.client.screen += new /obj/gui (screen_loc=gui_boot,state="boot")
	src.client.screen += new /obj/gui (screen_loc=gui_sleeve,state="sleeve")
	src.client.screen += new /obj/gui (screen_loc=gui_p1,state="blank")
	src.client.screen += new /obj/gui (screen_loc=gui_p2,state="blank")
	src.client.screen += new /obj/gui (screen_loc=gui_belt,state="belt")

	src.client.screen += new /obj/gui (screen_loc=gui_LH,state="lefthand")
	src.client.screen += new /obj/gui (screen_loc=gui_armor,state="armor")
	src.client.screen += new /obj/gui (screen_loc=gui_RH,state="righthand")
	src.client.screen += new /obj/gui (screen_loc="equipment:4,2",state="glove")
	src.client.screen += new /obj/gui (screen_loc=gui_suit,state="suit")

	src.client.screen += new /obj/gui (screen_loc=gui_mask,state="mask")
	src.client.screen += new /obj/gui (screen_loc=gui_head,state="head")
	src.client.screen += new /obj/gui (screen_loc=gui_id,state="id")

	src.client.screen += new /obj/gui (screen_loc=gui_back,state="back")

	src.client.screen += new /obj/gui/resize (screen_loc="equipment:5,3",state="resize")
	src.client.screen += new /obj/gui/drop	 (screen_loc=gui_drop,state="drop")

//storage


mob/proc
	init_storagegui()
		if(!src.client)
			return

		var/obj/gui/s = new(screen_loc = gui_blank1,state="storage")
		var/obj/gui/c = new(screen_loc = gui_cancel1,state="cancel")
		s.name = "storage1"
		c.name = "cancel1"
		src.client.screen += s
		src.client.screen += c


	remove_storagegui()
		if(!src.client)
			return
		for(var/obj/o in src.client.screen)
			if(o.name == "storage1" || o.name == "cancel1")
				game_del(o)

