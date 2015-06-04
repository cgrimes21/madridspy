/obj/small/poison_antidote
	desc = "5 uses. Combats any poison exposure."
	set_desc()
		src.desc = "[src.dose] use\s. Combats any poison exposure."

	value = 125
	initial_value = 125
	sale_value = 99
	icon = 'shit.dmi'
	icon_state = "antidote"
	force=1
	var/dose = 5
	range = 1
	body_loc = BELT


	attack(mob/who,mob/target)
		if(!who)
			return
		if(!target)
			return
		if(target.poison)
			target<<"Combating poison..."
			if(target!=who)
				who<<"You fed [target.name] a poison antidote."
			target.poison -= rand(20,30)
			target.poison = max(target.poison,0)
		else
			target<<"You did not have any poison to combat."
			if(target!=who)
				who<<"[target.name] didn't have any poison to combat."
		src.dose -= 1
		src.set_desc()
		if(src.dose<=0)
			who<<"Antidote was used up!"
			game_del(src)
			return
	verb
		swallow()
			set src in usr
			var/mob/agent/m
			if(istype(usr,/mob/agent))
				m = usr

			if(m && m.poison)
				m<<"Combating poison..."
				m.poison -= rand(20,30)
				if(m.poison<=0)
					m.poison = 0
			if(m && !m.poison)
				m<<"You did not have any poison to combat"
			src.dose -= 1
			src.set_desc()
			if(src.dose<=0)
				usr<<"Antidote was used up!"
				game_del(src)
				return
