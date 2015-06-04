obj
	spawns

		icon = 'spawns.dmi'

		New()
			..()
			src.icon = null
			src.tag = "[src.tage]"

		var/tage
		begin
			icon_state = "begin"
			tage = "begins"
		freelancer
			icon_state = "freelancer"
			tage="freelancers"
		civi
			icon_state = "civi"
			tage="civis"
		ris
			icon_state = "ris"
			tage="riss"
		oss
			icon_state = "oss"
			tage="osss"
		tut1
			//tutorial 1
			icon_state = "tut1"
			tage="tut1s"