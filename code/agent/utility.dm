mob
	agent

		proc
			begin()
				//when they log in, make them invisible then feed them their image using client/image
				//for tutorial purposes
				src.began = 1
				src.money = 327

				var/obj/o = locate(src.get_spawn_point()) in world
				//var/obj/o = locate(/obj/spawns/tut1)
				if(o)
					src.loc = o.loc

				src<<sound(null,0,0,1)
				src<<sound('ItBegins.ogg',0,0,1)

				spawn(700)
					//wait till its done
					src<<sound(null,0,0,1)
					play_ambience(src)

/*
				alert(src,"You are cast into a world full of deception, chaos and espionage.\n\nTo begin, seek out the appropriate employer. \
			Or you can choose to be a freelancer, free of the agencies limitations.\n\nIt is extremely recommended that you read the guide in the forums prior to play, unless you like to figure things out the hard way. \
			\n\nPress 'H' for help.","a strange voice","Continue")
			*/
				if(src.ragency == RIS)
					alert(src,"To enter your agency, speak the words '[ris_code]' to the clerk.")
					/*
					\nTo get a mission speak 'get mission' to clerk.\n \
					To start a mission contract, speak 'start mission' to the clerk.\n \
					To end a mission speak 'finish mission' to the clerk.")
*/
				if(src.ragency == OSS)

					alert(src,"To enter your agency, click the trashcan below.")
					/* \nTo get a mission speak 'get mission' to clerk.\n \
					To start a mission contract, speak 'start mission' to the clerk.\n \
					To end a mission speak 'finish mission' to the clerk.")
*/
			init_options()	//display current options to the window


				src.screen_res = winget(src,"m_default","size")

				winset(src, "m_option_select.resolution","text='[src.screen_res]'")

				if(src.sound)
					winset(src, "m_option_select.sound","is-checked='true'")
				else
					winset(src, "m_option_select.sound","is-checked='false'")

				if(src.music)
					winset(src, "m_option_select.music","is-checked='true'")
				else
					winset(src, "m_option_select.music","is-checked='false'")


				winset(src, "m_option_select.maxi","is-checked='[src.max]'")

				winset(src, "m_option_select.bar","is-checked='[src.bar]'")

				winset(src, "m_option_select.toggleinfo","is-checked='true'")	//always showing upon startup

				winset(src, "m_option_select.textb","is-checked='false'")	//always start out with this


				//world<<s

			set_options()		//takes your variables and resets windows

				winset(src, "m_default","is-maximized='[src.max]'")
				if(src.max == "false")
					if(src.screen_res)
						winset(src, "m_default","size='[src.screen_res]'")




				winset(src, "m_default","titlebar='[src.bar]'")


			reset_options() //resets and calculates the options

				var/w = winget(src, "m_option_select.resolution","text")
				winset(src, "m_default", "size='[w]'")

				var/m = winget(src, "m_option_select.maxi","is-checked")
				winset(src, "m_default", "is-maximized='[m]'")


				var/bar = winget(src, "m_option_select.bar","is-checked")
				winset(src, "m_default","titlebar='[bar]'")

				var/textb = winget(src,"m_option_select.resizetext","is-checked")
				winset(src, "m_output","can-resize='[textb]'")

				var/toggleinfo = winget(src,"m_option_select.toggleinfo","is-checked")

				if(toggleinfo == "false")
					winshow(src,"infowindow",0)
				if(toggleinfo == "true")
					winshow(src,"infowindow",1)




				src.screen_res = w
				src.max = m
			//	var/savefile/f = new("fuckshit")
			//	f["this"] << max2
				src.bar = bar
				var/so = winget(src, "m_option_select.sound","is-checked")
				var/mu = winget(src,"m_option_select.music","is-checked")

				if(so == "false")
					src.sound = 0
				if(so == "true")
					src.sound = 1
				if(mu == "false")
					src.music = 0
					src<<sound(null,0,1,1)
				if(mu == "true")
					src.music = 1

					if(!src.amb)
						src.amb = 1
						play_ambience(src)


			init_overlays()
				if((!src.Overlays) || (!(istype(src.Overlays,/list))))
					src.Overlays = new /list()


			save_version()		//compares versions in savefile and updates accordingly
		//if(src.saveversion == 2)
			//change whatever you changed in version 2 ex. take out an item
				src.saveversion = SAVE_VERSION
				return
			save()
				src.oe = src.elevation
				src.ll = 0
				if(src.luminosity)
					src.ll = src.luminosity

				src.luminosity = 0
				if(!src.x || !src.y || !src.z)	//you are nowhere
					src.loc = locate(src.lx,src.ly,src.lz)

				src.lx = src.x
				src.ly = src.y
				src.lz = src.z
				src.ld = src.dir
				src.saveversion = SAVE_VERSION
				//fdel("players/[copytext(ckey(src.real_name), 1,2)]/[ckey(src.real_name)]")
				var/savefile/f = new("players/[copytext(ckey(src.real_name), 1,2)]/[ckey(src.real_name)]")

				/*

				var/list/built_in = list(

				"type","parent_type","gender","verbs","vars","group",
				"ckey","client","key","vars","verbs"



				)



				var/list/temp = list(

				"accumulator","action_speed","amb","pulling","attack_delay",
				"can_move","current_sound","just_set","quick_select_main",
				"machinegun_out","new_move","noav","hand_overlay","l","m",
				"r","selected","boot","looking","hand","sleeve","pistol_out",
				"po","rejuv","shadow","sniper_out","xrays","next_search",
				"dead_for","buy_contents",

				///skip lists?

				)
				for(var/v in src.vars)

					//if(1==1)
					//	world<<"not saved: [v] = [src.vars[v]]"
					//r	continue	//global/const/tmp

					if(v in temp)
						continue

					if(!(v in built_in))
						f["[v]"] << src.vars[v]
						world<<"[v] = [src.vars[v]]"
				*/

				src.Write(f)
/*
				for(var/v in f.dir)

					if(v in src.vars)
						if(v in list("name","key","contents","icon","password"))
							continue

						var/holder
						if(!(f["[v]"]))
							CRASH("Failed at afterwrite in save() variable [v] is causing trouble")
						f["[v]"]>>holder


						if("[holder]" != "[src.vars[v]]")	//fucking byond skipped one
							f["[v]"] << src.vars[v]	//write it in ourselves
							debuggers<<"byond skipped variable [v] when saving [src.real_name] ([src.key])"
							wlog<<"[get_time()] byond skipped writing variable [v] on [src.real_name] ([src.ckey]) variable rewritten correctfully"
*/

				f["lz"] << src.z
				f["max"] << src.max
				f["overlays"] << null
				f["underlays"] << null

				src<<"[src.name] saved."
				src.luminosity = ll



			set_spawn_point()

				switch(src.ragency)
					if("1")
						var/area/a = locate(/area/inside/agencies/OSS_r/spawnpoint)
						if(a)
							src.spawnx = a.x
							src.spawny = a.y
							src.spawnz = a.z
					if("2")
						var/area/a = locate(/area/inside/agencies/RIS_r/spawnpoint)
						if(a)
							src.spawnx = a.x
							src.spawny = a.y
							src.spawnz = a.z
					if("3")
						var/area/a = locate(/area/inside/agencies/FOB_r/spawnpoint)
						if(a)
							src.spawnx = a.x
							src.spawny = a.y
							src.spawnz = a.z
					if("4")
						var/area/a = locate(/area/inside/agencies/NSA_r/spawnpoint)
						if(a)
							src.spawnx = a.x
							src.spawny = a.y
							src.spawnz = a.z
					if("5")
						var/area/a = locate(/area/inside/agencies/JE_r/spawnpoint)
						if(a)
							src.spawnx = a.x
							src.spawny = a.y
							src.spawnz = a.z
					if("freelancer")
						var/area/a = locate(/area/freelancer_spawn)
						if(a)
							src.spawnx = a.x
							src.spawny = a.y
							src.spawnz = a.z
					if("civilian")
						var/area/a = locate(/area/civilian_spawn)
						if(a)
							src.spawnx = a.x
							src.spawny = a.y
							src.spawnz = a.z





	proc
		fill()

			set category = "window debug"
			var/t = winget(src, "m_Map", "size")
			var/x = copytext(t,1,findtext(t,"x"))
			var/y = copytext(t,findtext(t,"x")+1,length(t)+1)
			x = text2num(x)
			y = text2num(y)

			y = round(y/32,1)
			x = round(x/32,1)
			src.client.view = "[x]x[y]"