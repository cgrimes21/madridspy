////
//	Procedures are listed in utilities.dm
////

obj
	small	//all these are items
		MouseEntered(loc,con,param)
			..()
			src.get_desc(loc,con,usr)

		mouse_over_pointer = MOUSE_HAND_POINTER
		weight = 1

		//Market variables
		var/dura = 0			//value changes with durability
		var/mdura = 0			//durability (if mdura 0 cant break)  if mdura>0 and dura<=0 it breaks
		var/value = 0			//what its worth
		var/initial_value = 0

		////////////////////
		var/value_mod = 0.05
		var/sale_value = 0
		///Above two vars explained in market.dm

		var/version	= 0		//which agency it belongs to, 5 is black market item

		var/range = 1

		var/force = 0		//how much damage it does
		var/delay = 15
		var/damt //= damage_type_bludgeon	//the damage type

		var/owned = 0			//is it owned or just a floater item
		var/tmp/mob/last_owned		//the mob who owned it before you

		var/list/modifiers = list()
		var/list/effects = list()
			//mods and effects


		var/passive = 0			//if its one, only carry the item to have the effects
		var/stored = 0			//is it stored?

		var/lootable = 1		//can this item be taken when the agent is down?
		var/indestructable = 0	//will pass garbage collector
		var/sellable = 1
		var/dropable = 1
		var/bagable = 1
		var/protected = 0
		var/storable = 1
		var/disabled = 0

		var/min_rank = 0	//minimum rank required to have
		var/body_loc = null //nowhere
		var/throwing = 0	//used to calculate throwing



/obj/small/get_hit_hand(mob/who,hander=0)
	..()

	if(who.is_Binded(1))
		return
	var/obj/h = who.get_hand(hander)
	if(h)	//if we have a hand that is busy, return
		CRASH("We have a hand (hander [hander]) who is busy when proc being called should have noticed this sooner. something is amiss")
		return
	src.add_fingerprint(who)
	if(src.loc == who)
		who.u_equip(src)		//unequip from any slots
		who.set_hand(src,hander)//move item to hand that clicked
		who.refresh_overlays()


		//unequip from slots if already in you
	else	//attempt to pick it up

		if(src.elevation != who.elevation)
			who<<"\blue [src.name] is out of reach!"
			return

		var/v = who.check_weight()

		if(v + src.weight > MAX_WEIGHT)
			who<<"You can't carry any more items."
			return
		else
			if(!src) return

			if(!(who in range(1,src)))
				return

			if(who.rank < src.min_rank)
				who<<"You must have a minimum rank of [src.min_rank] to carry this item."
				return

			if(istype(src,/obj/small/id_card))
				var/obj/small/id_card/c = src
				if(c.written_name == who.real_name)
					game_del(src)
					return
					//its your id, you cant have it. you should already have an ID
			if(src.Move(who))
				who.set_hand(src,hander)
				src.pickup(who)
				who<<"You get the [src.name]."
				who.do_objective("getid")

	who.refresh_clothings()

/obj/small/attack(mob/who,mob/target,hander=0)
	..()
//	target.get_hit(who,src)
	if(!src)
		return
	if(!who)
		return
	if(!target)
		return
	if(!src.force)
		return	//cant attack with this.

	var/range = 1
	if(istype(src,/obj/small/weapon))
		var/obj/small/weapon/w = src
		range = w.range

	if((get_dist(who,target)>range))
		who<<"\blue target is out of reach."
		return

	var
		tp_b = 1	//target protection, bludgeon
		tp_s = 1	//slash
		tp_p = 1	//peircing
		tp_e = 1	//electric
		tp_f = 1	//fire
		tp_po = 1	//poison


	for(var/obj/small/s in target)
		if((s == target.w_mask)||(s == target.w_armor)||(s == target.w_head)||(s == target.w_boot))
			if(s.damt & damage_type_bludgeon)
				tp_b += s.force
			if(s.damt & damage_type_slash)
				tp_s += s.force
			if(s.damt & damage_type_piercing)
				tp_p += s.force
			if(s.damt & damage_type_electric)
				tp_e += s.force
			if(s.damt & damage_type_fire)
				tp_f += s.force
			if(s.damt & damage_type_poison)
				tp_po += s.force
//system changed by cody grimes
//	6.21.11
	//if(src.damt & damage_type_slashing)


	if(src.damt & damage_type_piercing)

		if(tp_p>1 && prob(75))
			if(prob(65))
				target<<"you're protected from a piercing attack."
				who<<"[target.name] is protected from the attack."
				return
		target.get_hit(who,src,rand(src.force+2,src.force+3))
		play_sound(null,target.loc,'sounds/three/genhit2.ogg',0)
		if(prob(65))
			if(!(target.stun) && !(target.ko))
				var/time = rand(10,15)
				target.stuck = time
				//lineedit
				viewers(5,target)<<"[who.name] has stunned [target.name]!"
				return
		else
			if(prob(40))
				if(!(target.ko))
					var/time = rand(5,30)
					target.ko = time
					viewers(5,target)<<"[who.name] knocked [target.name] unconscious!"
					return

	if(src.damt & damage_type_bludgeon)
		if(target.ko || target.fell || (target.health <= 0))
			return

		if((src.damt & damage_type_bludgeon) && (tp_b>1) && (prob(75)))
			//if bludgeon protection, 75% chance of this line happening

			if(prob(80))	//20% of being hit
				target<<"\red you're protected from a bludgeon attack."
				who<<"\red [target.name] is protected from the attack."
				return
		target.get_hit(who,src,rand(1,src.force))
		play_sound(null,target.loc,'sounds/three/bludgeonimpact.ogg',0)
		//take away damage.

		//calculate k.o, stun or down
		if(prob(src.force + (target.mhealth-target.health) + 50))//more health your low on, the more vulnerable you are
			if(prob(20 + (target.mhealth-target.health)))

				var/time = rand(10,60)
				if(!target.ko)
					viewers(5,target)<<"[who.name] knocked [target.name] unconscious!"
					target.ko = time
				return
			else

				var/time = rand(10,40)
				if(!target.stun)
					viewers(5,target)<<"[who.name] has stunned [target.name]!"
					target.stuck = time
					//lineedit
					//stun
				return

		if(prob(70))

			var/time = rand(10,20)
			if(!target.fell)
				viewers(5,target)<<"[who.name] has knocked [target.name] over!"
				target.fell = time




/*
	if(who.intent == "kill")	//dealing damage
		if(hand.damt & damage_type_bludgeon)
			if(prob( 100*(hand.force/tp_b) ))
				target<<"you were hit with a chance of [hand.force/tp_b]"
			else
				target<<"you were saved from a hit with chance of [hand.force/tp_b]"
	else if(who.intent == "disable")
		//we are disabling them, not harming them
		//bludgeon has highest chances of disabling them
		if((hand.damt & damage_type_bludgeon) && (tp_b>1) && prob(75) )
			if(prob(20))
				target<<"you got hit in the head"
			else
				target<<"you were saved from bludgeon attack to head"
			return

		if((hand.damt & damage_type_bludgeon)&&prob(100*(hand.force/15)))//bludgeon objs have higher chance to ko than others
			target<<"calculating ko"
			if(prob(90))
				//ko
				target<<"your knocked out"
			else
				if(prob(60))
					target<<"your stunned"
				else
					target<<"you get knocked down"
*/
/*

bludgeon
if has protection, 75% chance of being protected, 20% chance of being hit
25% chance of calling prob(src.force)
	if called, has chance of 60% of being knocked out, 10% chance of being knocked over, 30% chance of being stunned
*/


obj/small/rope
	desc = "A rope that is very durable."

obj/small/card
	desc = "Access card"
	icon = 'vendor_door.dmi'
	icon_state = null

	set_stats()
		if(src.icon_state)
			return

		var/r = rand(1,4)
		switch(r)
			if(1)
				src.icon_state = "penkovskiyc"
				src.name = "penkovskiy access card"
			if(2)
				src.icon_state = "andrusc"
				src.name = "andrus access card"
			if(3)
				src.icon_state = "linfordc"
				src.name = "linford access card"
			if(4)
				src.icon_state = "dullesc"
				src.name = "dulles access card"

obj/small/blindfold
	desc = "A blind fold. Will blind fold any person wearing this, useful for captures."

obj/small/earplugs
	desc = "A device that, when put into someone's ear, emits a low-frequency sound wave that will block all other sounds coming into the ear. Great for blocking your conversations from enemy captives."

obj/small/note
	var/writing = ""
	desc = "A small slip of paper"
	icon = 'base objects.dmi'
	icon_state = "paper"
	name = "paper"
	value = 10
	initial_value = 10
	sale_value = 1

	verb
		label()
			set src in usr
			src.writing = input("Write on the slip of paper:","",src.writing) as null|message
			if(!usr || !usr.client) return
			if(!src.writing) return

			src.set_desc()
		read()
			set src in usr
			usr<<browse("<font face=courier><font size=1>[src.writing]","window=note")


	set_desc()
		desc = "A small slip of paper,\nIt has something written on it."


