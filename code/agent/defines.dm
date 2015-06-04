
mob
	agent

		verb/reshape()
			set hidden = 1
			src.icon_state = ""
			src.icon = 'newagent.dmi'

		Del()
			wlog<<"[get_time()] deleting /mob/agent >([src.real_name])"
			if(src.client)
				wlog<<"<br>[src.real_name] -> with client of [src.client.ckey] ([src.client.address])"
			if(src.luminosity)
				var/turf/t = src.loc
				if(t)
					t.lighted --
			..()
		var


			help_open = 0
			tmp/next_search = 0		//seconds you can search again

			saveversion

			trust = 0			//eh play with this as you put in trust system
			title = ""			//what you specialize in
			age = 0		//how old the character is in minutes active

			//some misc variables
			traced = 0			//how many times you have been 'traced' (caught)
			total_headshots = 0	//your total headshots
			headshots = 0		//if your traced goes up this is reset
			password = ""
			kills = 0

			tmp/list/buy_contents
			tmp/dead_for = 0	//once this reaches 67*2 you die, this is time spent blacked out
									//preventing someone spam hitting you so you never wake up

			ll			//last luminosity
			ld			//last direction
			lx = 3
			ly = 60
			lz = 1


			//some options
			screen_res = null
			//sound = "true"
			max = "true"
			bar = "true"
