mission/tutorial1
	part5

		begin(mob/who)

			var/dialog/tutorial1_5/t = new
			who.can_move = 0
			who.c_dialog = t
			begin_dialog(t,who)

		end_dialog(mob/who)
			who.can_move = 1