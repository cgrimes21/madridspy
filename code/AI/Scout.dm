mob
	npc
		proc


			Scout()		//called in ticks. scouts all area's AI_event variables and reacts accordingly



				for(var/atom/a in view(src))
					if(a.AI_event)
						src.React(a.AI_event,a)


				for(var/mob/agent/M in view(src))
					if(M.shadow < 4)
						if(get_dist(M,src) <= M.shadow)
						//they see you
							if(prob( M.shadow*25))

								src.React(AI_SEE_ENEMY_ALERT,M)
						//they have to be x amount of range away to see you
					else	///it is 4, your light up
						if(prob(90))
							src.React(AI_SEE_ENEMY_ALERT,M)
				//everything is fine
				if(src.stress <= 0)
					src.patrol = 1	//go back to patrol