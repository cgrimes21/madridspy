mob/npc
	var/can_die = 1	//can the npc die?
	New()
		..()
		spawn()

			src.spawnx = src.x
			src.spawnz = src.z
			src.spawny = src.y

			src.LoadGuns()
			src.opatrol = src.loc

			src.name = pick(gen_names)
			src.real_name = src.name



	//agency employers
	employer
		can_die = 0
		var/work
		var/original_loc
		icon = 'agent.dmi'
		New()
			..()
			spawn()
				src.original_loc = src.loc
				src.name = pick(gen_names)

		proc/begin_conv(mob/M)
			spawn()
				if(M.ragency)
					M<<"<b>[src.name]:</b> Are you enjoying life in the field of espionage?"
					return

				var/o1 = "Continue"
				var/o2 = "Dismiss"
				var/o3 = "Yes"
				var/o4 = "No"
				view(M)<<"[M.name] vanishes!"
				view(src)<<"[src.name] vanishes!"
				M.loc = locate(21,116,1)
				src.loc = locate(20,117,1)
				var/choice
				choice = alert(M,"We can talk safely here...",,o1,o2)
				if(choice == o2)
					src.loc = locate(src.spawnx,src.spawny,src.spawnz)
					view(src)<<"[src.name] vanishes!"
					return
				choice=alert(M,"So you are interested in joining the network of espionage? \
				Belonging to an agency is a great way to begin learning about the field of espionage. \
				\
				While it may have some limitations, guidlines and certian expectations and responsibilities \
				asked from you by your head master, the challenges in the agency are quite rewarding. ",,o1,o2)
				if(choice == o2)
					src.loc = locate(src.spawnx,src.spawny,src.spawnz)
					view(src)<<"[src.name] vanishes!"
					return

				choice = alert(M,"The agency will ask you to do things that may be against your nature.",,o1,o2)
				if(choice == o2)
					src.loc = locate(src.spawnx,src.spawny,src.spawnz)
					view(src)<<"[src.name] vanishes!"
					return

				choice = alert(M,"The agency will expect you to live up to required expectations,\
				 there is no room for slip-ups.",,o1,o2)
				if(choice == o2)
					src.loc = locate(src.spawnx,src.spawny,src.spawnz)
					view(src)<<"[src.name] vanishes!"
					return

				choice = alert(M,"Belonging to an agency will require tremendous responsibility and skillful tactics.",,o1,o2)
				if(choice == o2)
					src.loc = locate(src.spawnx,src.spawny,src.spawnz)
					view(src)<<"[src.name] vanishes!"
					return


				choice = alert(M,"The path is long, arduous, very dangerous, and I guarantee you nothing. \
				 You are aware that being caught in the act of espionage, we will deny all relations to your existence.",,o1,o2)
				if(choice == o2)
					src.loc = locate(src.spawnx,src.spawny,src.spawnz)
					view(src)<<"[src.name] vanishes!"
					return

				choice = alert(M,"Are you ready to make this commitment? You are entrusted to withold all agency secrets or face possible termination!",,o3,o4)
				if(choice == o4)
					src.loc = locate(src.spawnx,src.spawny,src.spawnz)
					view(src)<<"[src.name] vanishes!"
					return

				var/c = alert(M,"Choose an agency.",,"RIS","OSS")

				M<<"<b>[src.name]:</b> Let me get the paperwork ready for your transfer... Please wait"
				src.loc = locate(src.spawnx,src.spawny,src.spawnz)
				view(src)<<"[src.name] vanishes!"

				if(c == "RIS")
					M.ragency = 2
					M.agency = 2
					M<<"To enter your agency, speak the words '[ris_code]' to the clerk.\nTo get a mission speak 'get mission' to clerk.\n \
					To start a mission contract, speak 'start mission' to the clerk.\n \
					To end a mission speak 'finish mission' to the clerk."



				if(c == "OSS")
					M.ragency = 1
					M.agency = 1
					M<<"To enter your agency, click the trashcan below. \nTo get a mission speak 'get mission' to clerk.\n \
					To start a mission contract, speak 'start mission' to the clerk.\n \
					To end a mission speak 'finish mission' to the clerk."

				for(var/obj/small/id_card/cc in M)
					if(cc.written_name == M.real_name)
						game_del(cc)
						M.issue_card()

				var/obj/o = locate(M.get_spawn_point()) in world
				if(o)
					M.loc = o.loc





				M<<"Welcome to the field of espionage."

/*
				var/data/record/r = new()
				r.written_name = M.real_name
				r.agency = "Ritter Intelligence Services"
				M.agency = r.agency
				M.ragency = r.agency
				M.nagency = RIS
				r.nagency = RIS
				r.fingerprint = md5(M.real_name)
				for(var/network/n in networks)
					if("[n.side]" == "[RIS]")
						for(var/network/nn in n.data)
							if(nn.name == "records")
								nn.data += r
								M<<"<b>[src.name]:</b> Records uploaded into database... Updating ID card..."
				sleep(25)
				for(var/obj/small/id_card/I in M)
					I.nagency = RIS
					I.agency = "Ritter Intelligence Services"
					I.set_desc()
					M<<"<b>[src.name]:</b> ID card updated. Welcome to the agency."
*/


		NoticeSound(atom/A, soundname, range, volume)
			return
			var/mob/M

			if(get_dist(src,A)<=range)
				if(findtext(soundname,"agency"))
					if(istype(A,/mob))
						M = A
					if(!M.client)
						return
					if(!src)
						return

					src.begin_conv(M)





		interact(mob/M)
			M<<"[src.name] looks at you."
			return



		one
			work = "Office of Strategic Services"
		two

			work = "Ritter Intelligence Service"
			agency = "Ritter Intelligence Service"

			agency = RIS
			health =  2500
			mhealth = 400
		three
			work = "Foreign Office in Bern"
		four
			work = "National Security Agency"