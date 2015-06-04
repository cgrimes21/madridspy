mob/admin
	icon = 'agent.dmi'
	test	//debugging and test commands
		verb
			port()
				set category = "_test"
				create_spark(src.loc)
				src.loc = locate(rand(1,100),rand(1,100),1)
				create_spark(src.loc)

			forge_id(t as text, s as anything in list(RIS,OSS))
				set category="_test"
				var/obj/small/id_card/c = new(src)
				c.written_name = t
				c.agency = s
				c.suffix = t
				c.dropable = 1
				c.set_desc()
				//spawn_object(/obj/small/id_card, src)


			go_to(mob/M in world)

				set category = "_test"
				src.loc = M.loc
				view(M)<<"[src.name] appears."
			summon(mob/M in world)
				set category = "_test"
				M.loc = src.loc
				view(src)<<"[M.name] appears."

			get_log()
				set category = "_statistical data"
				src<<ftp('LOG.txt')
			count_mobs()
				set category = "_statistical data"

				var/t = 0
				var/tt = 0
				var/f = 0
				for(var/mob/o in world)
					t++
					if(istype(o,/mob/begin))
						tt ++
					if(istype(o,/mob/agent))
						f ++

				src<<"[tt] mob/begin in world."
				src<<"[t] mobs in world."
				src<<"[f] agents in world."
			count_objects()
				set category = "_statistical data"

				var/t = 0
				var/tt = 0
				for(var/obj/o in world)
					t++
					if(istype(o,/obj/small))
						tt ++

				src<<"[tt] obj/small in world."
				src<<"[t] objects in world."
			show_item_tracker()
				set category = "_statistical data"
				var/total = 0
				for(var/market_values/m in market_items)
					debuggers<<"[m.name] <- bought [m.tracker] times."
					total += (m.initial_value*m.tracker)
				debuggers<<"In total, thats at LEAST $[total] in-game moneys spent."
			kill()
				set category = "_test"
				var/mob/m = input(src, "kill") as null|mob in world
				if(!m)
					return
				m.health = -30

			toggle_logs()
				set category = "_statistical data"
				log_on = !log_on
				if(log_on)
					src<<"logs are on"
				else
					src<<"logs are off"

			seeall()
				set category = "_test"
				src.client.view = "70x70"
				usr.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
				src.client.screen = list()

			find_populated_areas(tt as num)
				set category = "_test"
				for(var/turf/t in range(src,10))
					t.icon = initial(t.icon)
					t.icon += rgb(t.busy*tt,0,0)

			xray()
				//set hidden = 1
				set category = "_test"
				src.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
			spawn_card()
				set category = "_test"

				spawn_object(/obj/small/card,src.loc)


			exploder()
				set category = "_test"
				for(var/turf/t in oview(1))
					t.explode()
					if(istype(t, /turf/steel_wall))
						t.density = 0


			set_side(var/mob/agent/M as mob in world)
				set category = "_char"
				var/side = input("Which side") as null|anything in list(OSS,RIS,FOB,NSA,"civilian","freelancer",0)
				//if(!side) return
				M.ragency = side
				M.agency = side
				usr<<"[M.name] set to [M.ragency]"
			create()
				set category = "_test"
				var/v = input("create") as anything in typesof(/obj/small)
				new v (usr)
				usr<<"new [v] created"
			watch(mob/M in world)
				set category = "_test"
				if(src.client)
					if(src.client.eye != src)
						src.client.eye = src
						return
					else
						src.client.perspective = EYE_PERSPECTIVE
						src.client.eye = M
						src<<"now watching [M.real_name]"
			who()
				set category = "_test"
				for(var/mob/M in world)
					if(M.client)
						src<<"[M.name] ([M.key])"
				src<<""
			play_music(f as sound)
				set category = "_test"
				var/sound/s = new(f,1,0,1)
//	s.frequency = 0.7
				world<<s

			cool_toggle()
				set category = "_test"
				if(!(src.client in debuggers))
					debuggers += src.client
					src<<"on"
				else
					debuggers -= src.client
					src<<"off"
			world_status()
				set category = "_test"
				var/t = input("Enter world status","",world.status) as null|text
				if(!src || !src.client) return
				if(!t) return

				world.status = t
				src<<"Set to [t]"
			world_name(t as text)
				set category = "_test"
				world.name = t
			ban(t as text)
				set category = "_test"
				banned += ckey(t)
				world<<"[t] has been banned."
				for(var/mob/m in world)
					if(m.ckey == t)
						m.Logout()


			rank(mob/m as mob in world, t as num)
				set category = "_char"
				m.rank = t

			money(mob/m as mob in world, t as num)
				set category = "_char"
				m.money = t

			chanview(t as text, a as num, b as num)

				set category = "_statistical data"
				switch(b)
					if(1)
						section1["[t]"] = a
					if(2)
						section2["[t]"] = a
					if(3)
						section3["[t]"] = a


				src<<"<b>-----Logistics-----"

				src<<"<b>\nSection 1 logistics"
				for(var/v in section1)
					src<<"[v] = [section1[v]]"
				src<<"<b>\nSection 2 logistics"

				for(var/v in section2)
					src<<"[v] = [section2[v]]"
				src<<"<b>\nSection 3 logistics"



				for(var/v in section3)
					src<<"[v] = [section3[v]]"

				src<<""
			lighter()
				set category = "_statistical data"
				if(!src.luminosity)
					src.luminosity = 4
					var/turf/t = src.loc

					t.lighted ++  //dont know what the fuck but it fixes it
					src.update_light()
				else
					var/turf/t = src.loc
					t.lighted--
					src.strip_light()
					src.luminosity = 0
			restock_vendors()
				set category = "_statistical data"
				for(var/obj/vendors/v in world)

					var/s = pick(playtest_tech)

					spawn_object(s,v,0,100,100)
						//new argh (v)

			open_shop()
				set category = "_statistical data"
				winshow(src,"shop",1)
				for(var/obj/vendor/v in world)
					var/mob/agent/a = src
					a.buy_contents = v.contents
					var/c = 0
					for(var/obj/bb in a.buy_contents)
						c++
						a<<output(bb, "shopi:1,[c]")


	guide	//guide commands

