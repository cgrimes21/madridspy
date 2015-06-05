obj/teammate
	icon = 'shit.dmi'
	icon_state = "tranq dart"
	layer = MOB_LAYER
	pixel_y = 32
	mouse_opacity = 0
mob
	agent

		icon = 'newagent.dmi'
		icon_state = ""

		var/version1 = 0
		var/version2 = 0

		Login()
			src.elevation = 0
			..()

			wlog<<"[get_time()] ([src.key]) ([src.client.address]) logging in as [src.real_name] "
			if(!version1)

				src.kills = 0
				src<<"\blue You have logged in with an old save file. Updating..."
				src.version1 = 1


			if(!(ckey(src.real_name) in niu))
				niu += ckey(src.real_name)
				debuggers << "names_in_use added [ckey(src.real_name)]"
			else
				debuggers<<"[src.real_name] logging in, their name appears to be already in the niu list when it shouldn't."

			if(src.health<=0)
				src<<"You have blacked out."

			//hide title, show default
			winshow(src,"m_title",0)
			winshow(src,"m_default",1)

			//make default default, title not
			winset(src, "m_default","is-default='true'")
			winset(src, "m_title", "is-default='false'")

			//maximize default
			winset(src,"m_default","is-maximized=true")

			//set map
			winset(src, "m_default.child","left='m_map'")

			winshow(src,"infowindow",1)
			/*
			888,4
			6,5
			888,599
			3,367


385x399

			1280x800
			*/
			//set up size of output window, and adjust all windows according to resolution
			winset(src, "m_output","size='376x344'")
			winset(src,"equipmentwindow","size='192x111'")//385x399'")
			//winset(src, "m_output","size='283x565'")
			var/tt = winget(src, "m_Map", "size")
			var/xx = copytext(tt,1,findtext(tt,"x"))
			var/yy = copytext(tt,findtext(tt,"x")+1,length(tt)+1)
			xx = text2num(xx)
			yy = text2num(yy)


			var/infox = (69.375*xx)/100
			var/infoy = (0.5*yy)/100
			var/outx = 	(0.3125*xx)/100
			var/outy = 	(0.625*yy)/100
			var/statx = (69.375*xx)/100
			var/staty = (74.875*yy)/100
			var/ex = 	(0.234375*xx)/100
			var/ey =	(45.875*yy)/100

			winshow(src,"stats",1)
			winset(src,"infowindow","pos=[infox],[infoy+40]")
			winset(src,"m_output","pos=[outx],[outy+40]")
			winset(src,"stats","pos=[statx],[staty+40]")
			winset(src,"equipmentwindow","pos=[ex+150],[ey+40]")
			//show output
			winshow(src,"m_output",1)
			src<<output({"Welcome to spies. This is a quick help file.
You can drag small windows such as this by dragging the small tab located on top of this window.
Left click to interact with things using your left hand.
Right click to interact with things using your right hand.

Goal: Pick up/buy gadgets from your vendor and assassinate enemies. Take their ID, bring it to your main office and say 'kill'.

The Keys:
A attempts to use antidotes, for quick relief.
S will slip into the shadows.
G will try to grab an enemy. You must face their back.
H toggles this help file."},"m_help.output")



			world<<"<b>[src.real_name] logs in!</b>\n"
			if(!world.GetMedal("civilian", src))
				world.SetMedal("civilian",src)
			src<<"<b><font color=red>Welcome to spies; version [version]</b>\nIt is year [round(rev,1)].\nRead the guide '<a href='http://penkovskiy.com/gameplay.php'>getting started</a>' before play."//Read the guide '<a href='http://penkovskiy.com/spiesf/index.php?topic=18.msg18'>getting started</a>' in the forums before play."
			src<<"<b><font color=red>If you are not going to read the guide, please at least read the help, using the 'help' command.</b></font>\n"


			src<<browse_rsc('updateinfo and screens/style.css')
			src<<output('updateinfo and screens/changelog.html',"updatewindow.browser")
			winshow(src, "updatewindow",1)


			src.icon = initial(src.icon)
			if(src.lh && istype(src.lh,/obj/small/grab))
				del src.lh
				src.lh = null

			if(src.rh && istype(src.rh,/obj/small/grab))
				del src.rh
				src.rh = null

			src.unmask()
			//unmask them

			/*
			var/obj/I = new
			I.mouse_opacity = 0
			I.screen_loc = "1,1"
			I.icon = 'border6.png'
			if(src.client)
				src.client.screen += I
*/
			if(src.agency == RIS)
				src<<"Your agency's pass code is [ris_code]"



			//locate your last location
			if((src.lx || src.ly || src.lz) && (src.began))//only if you have begun, otherwise your about to relocate anyway so skip this
				src.loc = locate(src.lx,src.ly,src.lz)
				if(src.ld)
					src.dir = src.ld
			spawn()						//wait until the world is done loading light, then update
				src.luminosity = src.ll
				if(src.luminosity)		//it has luminosity,  update
					var/turf/t = src.loc
					if(t)
						t.lighted ++
					src.update_light()

			src.recalc_stats()

			//lets place their previous items back.
			for(var/obj/small/weapon/w in src)
				if(w.suffix == "equipped")
					switch(w.body_loc)
						if(RIGHT_HAND)
							src.hand = w
						if(BOOT)
							src.boot = w
						if(SLEEVE)
							src.sleeve = w
			//places all previous equipables back in tmp variable slots
			src.refresh_clothings()
			src.refresh_overlays()

			var/obj/roof/R = locate(/obj/roof) in src.loc
			if(R && (src.oe>0))
				src.invisibility = R.invisibility
				src.see_invisible = R.elevation
				src.elevation = R.elevation
				src.layer = R.layer + 1
				if(src.elevation >=1)
					src.sight |= (SEE_OBJS|SEE_TURFS|SEE_MOBS)
				else
					src.sight &= ~(SEE_OBJS|SEE_TURFS|SEE_MOBS)
			else
				src.invisibility = 0
				src.see_invisible = 0
				src.elevation = 0
				src.layer = MOB_LAYER

				src.sight &= ~(SEE_OBJS|SEE_TURFS|SEE_MOBS)

			src.saveversion = SAVE_VERSION
			if(src.ckey == "suicideshifter" || src.ckey == "penkovskiy")//|| src.ckey=="zxcvdnm" || src.ckey=="D4RK354B3R")
				src.verbs += typesof(/mob/admin/test/verb)

			src.set_options()
			src.initialize_gui()

			var/l = FALSE
			for(var/obj/small/id_card/c in src)
				if(c.written_name == src.real_name)
					if(!src.w_id)	//no id being worn, move id to the worn position

						src.u_equip(c)//take it out of whatever its in,
						//if(src.client)
						//	src.client.screen -= c

						src.w_id = c	//this is your default card - move it to your id slot
						src.refresh_clothings()	//update screen

					l = TRUE//found true id card in user, so dont issue another

			if(l == FALSE)
				src.issue_card()



		//	initialize_hole(src)

			if(!src.began)
				src.begin()
			else
				src<<sound(null,0,0,1)
				play_ambience(src)

			src.client.onResize()


		Logout()
			wlog<<"[get_time()] [src.real_name](([src.ckey])) logging out"
			if(src.client)
				wlog<<"[src.real_name] -> with a client of  ([src.client.address]) logging out"
			world<<"<b>[src.real_name] logs out!</b>"
			viewers(5,src)<<"[src.name] slips into the shadows."
			if(ckey(src.real_name) in niu)
				niu -= ckey(src.real_name)
				debuggers<<"names_in_use removed [ckey(src.real_name)]"
			del src
			..()