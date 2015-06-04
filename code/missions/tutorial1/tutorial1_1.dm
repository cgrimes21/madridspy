mission/tutorial1


	begin(mob/who)
		var/dialog/tutorial1/t = new
		who.can_move = 0
		who.c_dialog = t
		begin_dialog(t,who)

	end_dialog(mob/who)
		if(!d1)
			d1 = 1	//finished first tutorial
			who<<"Click on your surroundings to interact with them."
			var/mission/tutorial1/part2/p = new
			who.part = p
			spawn()
				p.begin(who)