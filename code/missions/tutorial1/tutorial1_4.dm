mission/tutorial1
	part4


		begin(mob/who)
			var/mission/tutorial1/tut = who.mission
			spawn(30)
				tut.mole.ko = 0
				tut.mole.can_move = 1
				tut.mole.sayb("*groans* cyanide is rough..")
				who<<"<b>mysterious figure :</b> *groans* cyanide is rough..\n"
				sleep(40)
				who<<"<b>mysterious figure :</b> good job, now loot his keys. to loot, drag his body on top of yours."
				tut.mole.sayb("good job, now loot his keys. to loot, drag his body ontop of yours.")
				sleep(40)
				tut.mole.sayb("keep looting until he drops his ID card. I will tell you what to do when you obtain it.")
				who<<"<b>mysterious figure :</b> keep looting until he drops his ID card. I will tell you what to do when you obtain it."

		end_dialog(mob/who)
			var/mission/tutorial1/tut = who.mission
			tut.mole.sayb("drag that guard and hide him under the bed")
			who<<"<b>mysterious figure: </b> drag that guard and hide him under the bed, if anybody sees him it will trigger the alarm."
			tut.mole.group += who
			spawn(40)
				tut.mole.sayb("to pull him, face him and use the pull command")
				who<<"<b>mysterious figure: </b> to pull him, face him and use the pull command, bump into him to push him away."
			walk_to(tut.mole,who,1,3)
			return

		reach_obj(mob/M, what="")
			if(!M)
				return

			var/mission/tutorial1/tut = M.mission

			if(what=="lootid")
				if(!tut.ko_guard)
					return
				if(tut.dropped_guard_id)
					return
				tut.dropped_guard_id = 1
					//must have done this first
				tut.mole.sayb("good now click the ID on the floor to move it into your left hand. a right click will move it into your right hand")
				M<<"<b>mysterious figure: </b> good now click the ID on the floor to move it into your left hand. a right click will move it into your right hand"
			if(what == "getid")
				var/dialog/tutorial1_4/t = new

				M.c_dialog = t
				begin_dialog(t,M)