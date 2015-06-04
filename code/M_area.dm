area
	mouse_opacity = 0
	var/lighted = 0
	var/light_image		//the image of the shadows
	var/agency = null
	var/lockdown = 0
	var/section = 1

	proc/light_level()
	proc/lockdown()
		src.lockdown = 1
	proc/unlock()
		src.lockdown = 0

	civilian_spawn




	freelancer_spawn

	inside
		civilian_spawn
		freelancer_spawn
		agencies



			OSS_r

				agency = "1"

				spawnpoint

			RIS_r
				agency = "2"
				spawnpoint
			FOB_r
				agency = "3"
				spawnpoint
			NSA_r
				agency = "4"
				spawnpoint

			JE_r
				agency = "5"	//special agency
				spawnpoint
		luminosity = 0
		vent


		safe
			New()
				..()

				for(var/turf/t in src.contents)
					t.no_fight = 1
	New()
		..()
		//spawn()
		if(!src.tag)
			src.tag = "[src.name]"