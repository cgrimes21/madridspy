/*
what I want is that when an npc's stress goes up, surrounding npcs notice this and should
cautiously follow the npc whos stress is up. OR since I see this as a problem should do an
cautionry sweep of the immediate environment

*/

mob
	npc
		proc
			React(event,atom/A)		//ACT ACCORDINGLY BASED ON ABOVE DEFINITIONS
				src.patrol = 0//cut patrol
				switch(event)

					if(AI_CHANGED_LIGHT_SWITCHED)
						if(src.current_priority)
							if(src.current_priority < 0.020)
								return//doing something else more important

						view(src)<<"<b>[src.name]:</b> Who turned out that light?"
						play_music(src,'Assault.ogg',0,1)

						src.stress = 1
						src.wait = 2		//gives him time to realize what happened


						src.goal = AI_CHANGED_LIGHT_SWITCHED
						src.current_priority = 0.015
						src.goal_target = A

						A.AI_event = null





					if(AI_SEE_ENEMY_ALERT)

						src.current_priority = 0.010
						src.stress = 1
						src.goal = AI_SEE_ENEMY_ALERT

						play_music(src,'Assault.ogg',0)

						src.goal_target = A.loc