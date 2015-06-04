mob/npc
	proc
		Scan_Area()
			//go 5 tiles in a circle, when you hit dense, change directions
							//lets begin north


			var/turf/a = get_step(src,src.scan_dir)
			var/atom/b = locate(/atom) in a
			var/bd = 0

			if(b)
				if(b.density)
					bd = 1

			if(!a)
				src.Next_Scan_Dir()
				return


			if((src.scan_walk<5) && (a.density || bd))
				src.Next_Scan_Dir()
				if(!src.scan_dir)	//your done
					src.goal = AI_CONTINUE_PATROL


			//now lets take 5 steps
			if(src.scan_walk>=5)
				src.Next_Scan_Dir()
				if(!src.scan_dir)
					src.goal = AI_CONTINUE_PATROL

				src.scan_walk = 0
			if(src.scan_dir)
				step(src,src.scan_dir)
				src.scan_walk += 1

