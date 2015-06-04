mob
	var/tmp/slip = 0
	agent

		verb
			flash_card()

				if(src.w_id)

					for(var/mob/m in view(5,usr))
						m<<{"\n<b>[usr.name] shows you their identification card:\n</b>[src.w_id.desc]"}
				else
					src<<"You do not have an id card worn to flash."


			pull()
				for(var/atom/M in get_step(src,src.dir))
					if(istype(M, /obj/corpse) || istype(M,/mob))
						src.pulling = M

			who_()
				src<<""
				src<<"<b>Players:</b>"
				//src<<"<b>\red Ritter Intelligence Services</b>"
				var/counter = 0
				src<<"<b>\red RIS</b></font>"
				for(var/mob/agent/A in world)
					if(A.client)

						if(A.ragency == RIS)
							counter ++
							src<<"<font size=1>  [A.real_name], </font>"
				src<<"<b>\red OSS</b></font>"
				for(var/mob/agent/A in world)
					if(A.client)

						if(A.ragency == OSS)
							counter ++
							src<<"<font size=1>  [A.real_name], </font>"
				src<<"-------------"
				src<<"<b>Total: - [counter]</b>"


			slip()
				src.hide()
				//halle
			/*
				var/obj/I = new
				I.mouse_opacity = 0
				I.screen_loc = "1,1"
				I.icon = 'border6.png'
				src.client.screen += I
*/
			buttonemenu()
				set hidden = 1
				world<<"open menu"
			options()
				src.init_options()
				winshow(src, "m_option_select",1)

			submit_options()
				set hidden = 1
				winshow(src, "m_option_select",0)
				winset(src,"m_default","focus=true")
				src.reset_options()
				src.set_options()
				src.save()




			fn()
				set hidden = 1
				src.dir = NORTH
			fs()
				set hidden = 1
				src.dir = SOUTH
			fe()
				set hidden = 1
				src.dir = EAST
			fw()
				set hidden = 1
				src.dir = WEST


			help()

				help_open = !help_open
				winshow(src,"m_help",help_open)
				winset(src,"m_default","focus=true")


			shout(t as text)
				t = copytext(t, 1, 212)
				world<<"\icon[src][src.real_name] shouts, \"[html_encode(t)]\""


			say(t as text)
				t = copytext(t, 1, 212)
				src.sayb(t)

				for(var/atom/M in view(src))			//includes eavsdropping gadgets
					//under alerts or something within notice sound, simply call spawn before them
					spawn()

						if(M.elevation != src.elevation)
							continue
						//if its a mob and they arent on the same elevation, continue
						if(istype(M,/mob) || istype(M, /obj))
							M<<"\red <b>[src.name]: </b>\"[html_encode(t)]\""
							M.NoticeSound(src, "[html_encode(t)]", 6, 100)

					//go through all instantly and then do accordingly. may take up some time?
					//but if m.noticesound gets bound up it wont hold off other surrounding items