mob
	mouse_over_pointer = MOUSE_CROSSHAIRS_POINTER
	icon = 'spy.dmi'
	glide_size = 8
	animate_movement = 2
	flags = BIOL | FPRINT
	//options
	var/sound = TRUE
	var/music = TRUE
	var/tmp/amb = 0	//is it playing ambience?
	var/began = 0
	var/tmp/xrays = 0		//do you have xrays?


	var/real_name = ""
	var/oicon = 'agent.dmi'
	var/oics
	var/health = 11
	var/mhealth = 22
	var/rank = 0
	var/ragency	= 0//default agency is civilian
	var/agency = 0			//agency




	var/intent = "disarm"

	//intents:
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

	*/
	//action for fighting, intent

	var/spawnx = 0
	var/spawny = 0
	var/spawnz = 0

	var/last_hostile //the last person who attacked you so credit for a kill goes to them

	var/money = 0
	var/binded = 0		//their hands are binded in some way. either with rope/handcuffs/whatever else
	var/blinded = 0		//how long they are blinded for, -1 means permanently (wont count down) until stated otherwise
	//to turn off blinded = -1, set blinded = 1 not zero or it will not switch back
	//DE
	//var/blackout = 0
	var/poison = 0
	var/fell = 0
	var/slowness = 0	//how fatigued you are effects speed. 8 is very fatigued, 6 is average
	var/stuck = 0
	var/stun = 0		//stunned is like stuck only you cannot interact with anything. Stuck is not being able to move
						//stun is the whole deal

	var/ko = 0			//seconds you are unconscious for disregarding current health

	var/slash = 0		//higher this is, the more you stumble around

	var/tmp/rejuv = 0		//how much extra percent you regenerate
	var/tmp/shadow = 0	//4 is completely light up, 0 is completely undetectable within shadows


	var/blood_rating = 0		//how bloody you are
	var/section = 1				//which section your in, 1/3 effects economic values

	var/tmp/pistol_out = 0		//makes it easier for npcs to check visual weapons so
								//they dont have to go through your inventory all the time
	var/tmp/sniper_out = 0
	var/tmp/machinegun_out = 0


	var/list/Overlays
	//equip
	var/tmp/obj/small/hand		//item thats in mobs hand
	var/obj/small
		//slots where items are equipped into
		//w prefix means worn
		lh
		rh
		w_mask
		w_head
		w_id
		w_armor
		w_suit
		w_sleeve
		w_bootslot
		w_boot
		w_p1
		w_p2
		w_belt
		w_back
		w_cuff	//obj that is binding hands


	var/tmp/list/Imager = list()

	var/tmp/obj/small/sleeve
	var/tmp/obj/small/boot

	var/regen = 3.756	//percent of regeneration
	var/regen_rate = 4	//seconds per regeneration

	var/tmp/atom/pulling		//only pull mobs and obj corpses

	var/tmp/attack_delay

	var/tmp/action_speed = 8.5	//how fast the accumulator goes
	var/tmp/can_move = 1		//you can move
	var/tmp/new_move = -1		//the time your allowed to move again
	var/tmp/accumulator = 0		//an accumulator that allows you to gain a tile every so often

	//protection
	var/list/stats = list("gas_AC" = 0, "AC" = 0,"chem_AC" = 0,"poison_AC" = 0,"fire_AC" = 0, "electric_AC" = 0)

