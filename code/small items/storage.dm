/obj/small/storage/proc/show_to(mob/who)

	//shows who whats inside storage container below their gui interface

/obj/small/storage/proc/hide(mob/who)

	//hides contents from who's gui
/*
/item/storage/toolbox/attack(mob/M as mob, mob/user as mob)

	..()
	if ((prob(30) && M.stat < 2))
		var/mob/H = M

		if(M.gmode&32)
			M<<"\red A magical aura repels the attack!"
			return

		// ******* Check

		if ((istype(H, /mob/human) && istype(H, /item/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(10, 120)
		if (prob(90))
			if (M.paralysis < time)
				M.paralysis = time
		else
			if (M.stunned < time)
				M.stunned = time
		M.stat = 1
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall.", 2)
			//Foreach goto(169)
		M.show_message(text("\red <B>This was a []% hit. Roleplay it! (personality/memory change if the hit was severe enough)</B>", time * 100 / 120))
	return
	*/
