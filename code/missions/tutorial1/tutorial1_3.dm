mission/tutorial1
	part3

		reach_obj(mob/M,what = "")
			if(what=="koguard1")
				if(M)
					if(istype(M.mission,/mission/tutorial1))
						var/mission/tutorial1/t = M.mission
						if(t.ko_guard)
							return	//already did
						else
							t.ko_guard = 1
							var/mission/tutorial1/part4/p = new
							M.part = p
							p.begin(M)


		begin(mob/who)

			var/dialog/tutorial1_3/t = new
			who.can_move = 0
			who.c_dialog = t
			begin_dialog(t,who)

		end_dialog(mob/who)
			who.can_move = 1
			spawn(30)
				var/mission/tutorial1/tut = who.mission

				tut.mole.y+=1
				sleep(4)
				tut.mole.y+=1
				sleep(4)
				tut.mole.x+=1
				tut.mole.dir = EAST
				spawn(30)
					who<<"<b>mysterious figure falls down dead</b>"
					tut.mole.icon_state = "dead"
					tut.mole.ko = 1000
					tut.mole.can_move = 0
				spawn(70)
					var/v = tut.guard1.x - 9
					while(tut.guard1.x != v)
						step(tut.guard1,WEST)
						sleep(5)
					sleep(10)
					who<<"Wake up! Its time for your execution."
					tut.guard1.sayb("wake up its time for your execution")
					sleep(10)
					step(tut.guard1,NORTH)
					sleep(6)
					step(tut.guard1,NORTH)
					sleep(20)
					who<<"What the hell is this!?"
					tut.guard1.sayb("what the hell is this")
					sleep(40)
					tut.guard1.y ++
					tut.guard1.dir = NORTH
					sleep(4)
					tut.guard1.y ++
					tut.guard1.dir = NORTH
					sleep(4)
					tut.guard1.y ++
					tut.guard1.dir = NORTH
