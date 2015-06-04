mission/tutorial1

	part2
		//this is where your looking at the hall and a guard drags the 'mole' into your cell
		begin(mob/who)
			var/mission/tutorial1/tut = who.mission

			//spawn a guard, and the npc mole (only 1 exists at a time for new players)
			var/obj/t = locate(/obj/missions/spawns/tut1_2)
			var/mob/g = new (t.loc)
			var/mob/m = new (t.loc)

			g.icon = 'newagent.dmi'
			m.icon = 'newagent.dmi'
			g.icon_state = ""
			g.name = "guard1"
			g.mission_id = src.id
			m.mission_id = src.id
			g.agency = "tut1"
			var/obj/small/id_card/c = new (g)
			c.agency = "tut1"
			g.w_id = c
			var/obj/small/weapon/gun/gun = new(g)
			gun.model = 7
			g.sniper_out = 1
			g.refresh_overlays()

			m.x=t.x+2
			m.y=t.y
			m.z=t.z

			g.x = t.x+1
			g.y=t.y
			g.z=t.z

			m.icon_state = "dead"
			m.ko = 20
			//who.can_move = 0
			tut.mole = m
			tut.guard1 = g

			who.client.eye = locate(who.x,who.y-2,who.z)
			m.can_move = 0
			g.pulling = m
			var/ttt = g.x-8
			while(g.x != ttt)	//take 4 steps
				step(g,WEST)
				sleep(4)

			who<<"<b>Guard:</b> *mumble.. mumble.."
			tut.guard1.sayb("mumble  mumble")
			sleep(10)
			who.x-=1
			step(g,NORTH)
			sleep(10)
			step(g,NORTH)
			sleep(5)
			step(g,NORTH)
			who.client.eye = locate(who.x+1,who.y,who.z)
			who<<"<b>Guard:</b> Get in here you filthy peice of trash!"
			tut.guard1.sayb("get in here you filthy peice of trash")
			m.y += 1
			sleep(7)
			m.y += 1
			sleep(10)
			who<<"<b>Guard:</b> damn it!"
			tut.guard1.sayb("damn it")
			g.pulling = null
			step(g,SOUTH)
			sleep(10)
			step(g,SOUTH)
			sleep(4)
			step(g,SOUTH)
			var/nn = g.x + 9
			while(g.x != nn)
				step(g,EAST)
				sleep(4)
			who.client.eye = who
			who.can_move = 1
			d2 = 1
			spawn(50)
				who<<"<b>mysterious figure:</b> ahuhgg.... "
				tut.mole.sayb("ahuhgg")

				spawn(20)
					m.icon_state = ""
					m.can_move = 1
					m.ko = 0
					var/mission/tutorial1/part3/p = new
					who.part = p
					p.begin(who)