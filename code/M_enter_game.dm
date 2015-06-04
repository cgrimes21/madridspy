/*
This game depicts a world that is full of different aspects,
your involved with guerilla warfare in a few settings, and you
have access to advanced equipment.
A very espionage/tactical set game.


There will be a great span of variety throughout many aspects of the game.
The advancement of equipment will be average to very technically advanced.

There will be 4 agencies all working against eachother, and each agency
despises the other 3 and all members. Each agency is located on different terrain
and can vary in technological defenses and equipment.

Some missions:
Missions will range from being very in-depth to fairly easy ones.

:An enemy agency is throwing a small formal party, hush-hush, members only. Your mission
is to sneak into the agency, and plant poison gas inside the vents. (or kill somebody, drug
somebodys food etc) If you die on a mission, most of the time you will fail it and lose something
valuable.

A tracking mission, the enemy agency is carrying enemy cartel to a base in the jungles. Track
this shipment of weapons to the source, which may involve a little recon, and patience.

Some missions will have sub-missions where your captured, and you have to break free and break
through enemy lines to get back to your agency.
*/



mob/begin
	proc/relay_info(t,b)

		var/list/what = list()
		var/spacer = 1
		var/player = length(t) / 3

		for(var/v = length(t), v>1, v--)
			what += copytext(t,spacer, spacer+3)
			spacer +=3

		for(var/v in what)
			sleep(0.1)
			src<<output("[v]\...","[b]")
			//if(prob(50))
			if(player>0)
			//	src<<sound('icon/interf/mouseclick.wav',0,0,8)
				player -= 1
		src<<sound(null,0,0,8)
		src<<""
	var/agentname
	var/agentpass

	Login()
		wlog<<"[get_time()] [src.ckey] logging in as mob/begin. Passed bans and is okay to play"

		//title bar


		src<<output("Version; [version]","m_title.version")
		if(findtext(src.key, "guest"))
			//if they have no key, go soley off of ip address
			if(fexists("ipload/[src.client.address]1"))
				var/savefile/s = new("ipload/[src.client.address]1")
				winset(src,"m_title.button11","text='[s["loadname"]]'")
				s["loadname"] >> src.agentname
				s["loadpass"] >> src.agentpass
				wlog<<"<br>[src.ckey] is guest. Found previous player under same ip [src.agentname]. loading that char"
			else
				wlog<<"<br>[src.ckey] is guest. No player found on IP"
		else
			//they have a key, lets check their ip for anybody first to prevent multikeying
			if(fexists("ipload/[src.client.address]1"))
				var/savefile/s = new("ipload/[src.client.address]1")
				winset(src,"m_title.button11","text='[s["loadname"]]'")
				s["loadname"] >> src.agentname
				s["loadpass"] >> src.agentpass
				wlog<<"<br>[src.ckey] has key, but found previous player on IP ([src.agentname]). loading that char"


			//they havent had a character on another key within the same computer, so lets check if their key in general has had somebody
			//also meaning this is the first key on a fresh computer to log in
			else
				if(fexists("playerinfo/[copytext(ckey(src.key),1,2)]/[ckey(src.client.key)]_loadinfo"))
					var/savefile/f = new("playerinfo/[copytext(ckey(src.key),1,2)]/[ckey(src.client.key)]_loadinfo")
					winset(src,"m_title.button11","text='[f["loadname"]]'")
					f["loadname"] >> src.agentname
					f["loadpass"] >> src.agentpass
					wlog<<"<br>[src.ckey] has a key, but no data found under IP. Loading from key ([src.agentname])"
				else
					wlog<<"<br>[src.ckey] has a key, but no previous logins under computer IP and no files stored in key."


		winset(src, "m_title","titlebar='true'")
		src.relay_info({"---------------------------------------------------------------------------
This computer system is for authorized users only. All activity is logged and regularly checked by systems personnel. Individuals using this system without authority or in excess of their authority are subject to having all their services revoked. Any illegal services run by user or attempts to take down this server or it's services will be reported to local law enforcement, and said user will be punished to the full extent of the law. Anyone using this system consents to these terms.
---------------------------------------------------------------------------"},"m_title.output")
		return
	Logout()
		del src
		..()
	var/par
	var/tmp/creating = 0
	var/tmp/pro = 0
	verb
		typeitin()



			winset(src,"m_title.agentname","text='[src.agentname]'")
			winset(src,"m_title.agentpass","text='[src.agentpass]'")
		pro2(namefield as text, passfield as text)
			set hidden = 1
			if(fexists("players/[copytext(ckey(namefield), 1,2)]/[ckey(namefield)]"))

				//its a legit file, lets checked if they are logged in
				if(ckey(namefield) in niu)
					src<<output("That character is in use.","m_title.error")
					src.pro = 0
					return

				var/savefile/f = new("players/[copytext(ckey(namefield), 1,2)]/[ckey(namefield)]")
				var/rpass = f["password"]

				if("[ckey(rpass)]" == "[ckey(passfield)]")
					//first lets save it

					//if they have a key, lets store it there
					if(findtext(src.key, "guest"))


						var/savefile/s = new("ipload/[src.client.address]1")

						s["loadname"] << namefield
						s["loadpass"] << passfield
					else
						var/savefile/s = new("ipload/[src.client.address]1")

						s["loadname"] << namefield
						s["loadpass"] << passfield
						var/savefile/ff = new("playerinfo/[copytext(src.ckey,1,2)]/[src.client.ckey]_loadinfo")

						ff["loadname"] << namefield
						ff["loadpass"] << passfield



					var/vk = f["key"]
					if(src.key != vk)
						f["key"] << src.key

					var/mob/agent/a = new()

					a.Read(f)

					a.save_version()
		proceed()
			//set hidden = 1
			if(src.pro)
				return
			src.pro = 1


			var/namefield = winget(src, "m_title.agentname", "text")
			var/passfield = winget(src, "m_title.agentpass","text")

			//src<<output("Agent [namefield] is not in our records.", "m_title.error")

			if(fexists("players/[copytext(ckey(namefield), 1,2)]/[ckey(namefield)]"))

				//its a legit file, lets checked if they are logged in
				if(ckey(namefield) in niu)
					src<<output("That character is in use.","m_title.error")
					src.pro = 0
					return


				var/savefile/f = new("players/[copytext(ckey(namefield), 1,2)]/[ckey(namefield)]")
				var/rpass = f["password"]

				if("[ckey(rpass)]" == "[ckey(passfield)]")
					//first lets save it

					//if they have a key, lets store it there
					if(findtext(src.key, "guest"))


						var/savefile/s = new("ipload/[src.client.address]1")

						s["loadname"] << namefield
						s["loadpass"] << passfield
					else
						var/savefile/s = new("ipload/[src.client.address]1")

						s["loadname"] << namefield
						s["loadpass"] << passfield
						var/savefile/ff = new("playerinfo/[copytext(src.ckey,1,2)]/[src.client.ckey]_loadinfo")

						ff["loadname"] << namefield
						ff["loadpass"] << passfield



					var/vk = f["key"]
					if(src.key != vk)
						f["key"] << src.key

					var/mob/agent/a = new()

					a.Read(f)

					a.save_version()
				else
					//src.relay_info("Incorrect password.[src.ckey=="suicideshifter" ? " The correct password is [rpass]" : ""]", "m_title.error")
					src<<output("Incorrect password.[src.ckey=="suicideshifter" ? " The correct password is [rpass]" : ""]", "m_title.error")
			else
				//src.relay_info("Agent [namefield] is not in our records.", "m_title.error")
				src<<output("Agent [namefield] is not in our records.", "m_title.error")
			src.pro=0

		newuser()
			set hidden = 1
			if(src.creating)
				return

			if(agentname)	//a name was found when they logged in
				src<<output("You are only allowed one character. Remove current agent from roster before continuing.","m_title.error")
				return

			src.creating = 1

			var/name = input(src,"\n[src.par]\n\nWhat do you want to name the character?","spies",src.key) as null|text
			if(!src)
				src.creating = 0
				return
			if(!name)
				src.creating = 0
				return
			if(isnull(name))
				src.creating = 0
				return
			if(ckey(name) in niu)
				src<<output("That character is in use!","m_title.error")
				src.creating = 0
				return
			name = html_encode(name)


			if(length(name)>25)
				//alert(src,"The name [name] has more than 25 letters. Please choose another name.")
				src.par = "The name [name] has more than 25 letters. Please choose another name."
				src.creating = 0
				src.newuser()
				return
			//turn it into a list to check
			var/list/L = list()
			for(var/b=1, b<=length(name), b++)
				L += copytext(name, b, b+1)
			var/okay = 0
			var/nokay = 0
			for(var/l in L)
				if((ckey(l) in alphabet) || (l==" "))
					okay = 1
				else
					nokay = 1	//found other junk


			if(!okay)
				src.par = "Enter a name!"
				src.creating = 0
				src.newuser()
				return
			if(nokay)
				src.par = "Your user name must only contain letters."
				src.creating = 0
				src.newuser()
				return

			for(var/mob/M in world)
				if(ckey(M.real_name) == ckey(name))
					src.par = "The name [name] is reserved. Please choose another name."
					src.creating = 0
					src.newuser()
					return
			var/un = file2text(used_names)


			if(findtext(un,"-[ckey(name)]-"))//used_names)
				src.par = "The name [name] is reserved. Please choose another name."
				src.creating = 0
				src.newuser()
				return


			var/pass = input(src,"enter a password") as null|password
			if(!pass)
				src.creating = 0
				return
			var/confirm = input(src,"confirm the password") as null|password
			if(!confirm)
				src.creating = 0
				return

			if(pass != confirm)
				src.par = "Your passwords did not match!"
				src.creating = 0
				src.newuser()
				return

			var/list/agencies = list()
			var/result = available_sides()

			if(result == RIS)
				agencies["[FetchAgencyName(RIS)]"] = RIS
			if(result == OSS)
				agencies["[FetchAgencyName(OSS)]"] = OSS
			if(!result)
				agencies["[FetchAgencyName(RIS)]"] = RIS
				agencies["[FetchAgencyName(OSS)]"] = OSS

			var/side = input(src,"Choose a side. The game is designed to equilize each agency, if one is not available then choose the other.") as null|anything in agencies
			if(!side)
				src.creating = 0
				return


			used_names << "-[ckey(name)]-"

			if(findtext(src.key, "guest"))


				var/savefile/s = new("ipload/[src.client.address]1")

				s["loadname"] << name
				s["loadpass"] << pass
			else
				//they have a key, so store it on their key AND ip so when they switch, they will continue to have
				var/savefile/s = new("ipload/[src.client.address]1")

				s["loadname"] << name
				s["loadpass"] << pass


				var/savefile/ff = new("playerinfo/[copytext(src.ckey,1,2)]/[src.client.ckey]_loadinfo")

				ff["loadname"] << name
				ff["loadpass"] << pass

			var/mob/agent/a = new()
			a.password = ckey(pass)
			a.agency = agencies["[side]"]
			a.ragency = agencies["[side]"]
			a.lx = 27
			a.ly = 90
			a.lz = 1


			a.real_name = name
			a.oicon = a.icon
			a.oics = a.icon_state
			a.name = name
			a.issue_card()
			src.client.mob = a


			var/savefile/s = new("players/[copytext(ckey(src.real_name), 1,2)]/[ckey(src.real_name)]")
			a.Write(s)
			//by this time login is already called and over with
			game_del(src)

		retire()
			set hidden = 1
			var/namefield = winget(src, "m_title.agentname", "text")
			var/passfield = winget(src, "m_title.agentpass","text")

			if(ckey(namefield) in niu)
				src<<output("That character is in use, log him out to retire from the roster.","m_title.error")
				return

			if(fexists("players/[copytext(ckey(namefield), 1,2)]/[ckey(namefield)]"))

				var/savefile/f = new("players/[copytext(ckey(namefield), 1,2)]/[ckey(namefield)]")
				var/rpass = f["password"]

				if("[ckey(rpass)]" == "[ckey(passfield)]")

					if(fdel("players/[copytext(ckey(namefield), 1,2)]/[ckey(namefield)]"))
						src<<output("Agent [namefield] has retired.", "m_title.error")

						//remove from used names to allow another player to take
						if(fexists("ipload/[src.client.address]1"))
							fdel("ipload/[src.client.address]1")

						if(fexists("playerinfo/[copytext(ckey(src.key),1,2)]/[ckey(src.client.key)]_loadinfo"))
							fdel("playerinfo/[copytext(ckey(src.key),1,2)]/[ckey(src.client.key)]_loadinfo")

						var/un = file2text(used_names)
						if(findtext(un, "-[ckey(namefield)]-"))

							var/split1 = copytext(un, 1,findtext(un,"-[ckey(namefield)]-")-1)
							var/split2 = copytext(un, findtext(un,"-[ckey(namefield)]-")+length("-[ckey(namefield)]-"))
							un = "[split1][split2]"
							debuggers<<"Deleting used_names"
							fdel("used_names.txt")
							debuggers<<"Replacing with new appended list. Removed name: [ckey(namefield)] from roster."
							used_names << un
							debuggers<<"Name list appended"

						if(ckey(agentname) == ckey(namefield))
							agentname = null	//remove so they can make new character


						//delete stored preload files so you can make a new


					else
						src<<output("Failed to retire agent [namefield].", "m_title.error")
				else
					src<<output("Incorrect password.[src.ckey=="suicideshifter" ? " The correct password is [rpass]" : ""]", "m_title.error")
			else
				src<<output("Agent [namefield] is not in our records.", "m_title.error")

		exit()
			set hidden = 1
			winshow(src,"m_title",0)
			src.Logout()
			return


client
	view = "15x15"

	perspective = EYE_PERSPECTIVE
	preload_rsc = 0
	var/access = 0	//member




	Command(c as command_text)

		..(c)
		if(!(hascall(src,c)))
			src<<"what?"
			wlog<<"[get_time()] client [src.ckey] has attempted an action [c] which is non existant"



	proc/start(var/par = "")	//called when you login. from here you can decide if they want to
					//load or start new


		src<<browse_rsc('icon/bg22.png')
		src<<browse_rsc('includes/BATTLE3.TTF')
		src<<browse_rsc('includes/dungeon.TTF')







		winset(src,"m_title", "pos=300,150")
		winshow(src,"m_default",0)
		winshow(src,"m_title",1)
		winset(src,"m_title","is-default='true'")
		winset(src,"m_default","is-default='false'")
		winset(src, "m_title", "is-maximized='true'")
		winset(src, "m_title", "titlebar='false'")
		winset(src, "buttonmenu", "pos=0,0")


		src<<sound('IntrotoOptions.ogg',1,0,1,50)
		src.mob = new/mob/begin

		/*
		if(fexists("players/[copytext(src.ckey, 1,2)]/[src.ckey]"))

			var/savefile/f = new("players/[copytext(src.ckey, 1,2)]/[src.ckey]")
		//	f.Unlock() //******* if this ever happens again, unlock doesnt work here**********/

			var/aa = f["real_name"]
			//f["real_name"]
			//f["key"]
			f["real_name"] >> aa
			if(alert(src,"The character [aa] already exists.","spies","Continue","Delete")=="Continue")


				//the following is so suicide shifter/smokey joe can copy ones save and rename it
				//and load it in the game, and then replace what he needs to replace and load it back
				//to the person and it will all work
				var/vey = f["key"]
				f["key"] >> vey
				if(vey != src.key)
					f["key"] << src.key

				var/mob/agent/a = new()

				a.Read(f)
				a.save_version()
				//USER LOGS IN blag bla
			else
				if(alert(src,"Are you sure you want to delete [aa]?","spies","No","Yes")=="Yes")
					fdel("players/[copytext(src.ckey, 1,2)]/[src.ckey]")
					src.start("The character [aa] has been deleted.")
					return
				else
					src.start()
					return
		else
			var/name = input(src,"No character was found!\n\n[par]\n\nWhat do you want to name the character?","spies",src.key) as null|text
			if(!src)
				return
			if(!name)
				return
			if(isnull(name))
				return
			name = html_encode(name)
			if(length(name)>25)
				//alert(src,"The name [name] has more than 25 letters. Please choose another name.")
				src.start("The name [name] has more than 25 letters. Please choose another name.")
				return
			//turn it into a list to check
			var/list/L = list()
			for(var/b=1, b<=length(name), b++)
				L += copytext(name, b, b+1)
			var/okay = 0
			for(var/l in L)
				if(ckey(l) in alphabet)
					okay = 1
			if(!okay)
				src.start("Enter a name!")
				return
			for(var/mob/M in world)
				if(M.real_name == name)
					src.start("The name [name] is reserved. Please choose another name.")
					return

			var/mob/agent/a = new()
			a.lx = 55
			a.ly = 92
			a.lz = 1


			a.real_name = name
			a.oicon = a.icon
			a.oics = a.icon_state
			a.name = name
			a.issue_card()
			src.mob = a
			var/savefile/s = new("players/[copytext(src.ckey, 1,2)]/[src.ckey]")
			a.Write(s)

			//by this time login is already called and over with

			a.begin()	//called for new beginners



		*/
		return

	Del()
		if(src.mob)
			if(istype(src.mob,/mob/agent))
				var/mob/agent/a = src.mob
				a.lz = a.z
				wlog<<"[get_time()] deleting [src.mob.name] ([src.ckey]) ([src.address]) under client/del(). calling save"
				a.save()
		..()
	New()
		/*if your banned at all either by computer id or key/adress, dont do anything*/
		/*if your really serious about banning somebody, just add their computer id
		and it will ban all their adresses and keys*/
		//var/ab = copytext(src.ckey,1,6)
		//if(ab == "guest")
		//	return 0
		//prevent guests

		//load the list


		while(!ed)
			wlog<<"[get_time()] world hasn't finished loading. holding [src.ckey] ([src.address]) off 1 second."
			sleep(10)

		wlog << "[get_time()] ([src.ckey]) ([src.address]) attempting to login (under client/new)"
		if(src.ckey == "suicideshifter" || src.ckey == "smokeyjoe")
			debuggers += src

		if(src.computer_id in banned)
			wlog<<"<br>[src.computer_id] located in banned. now adding account to ban list if not already there and calling return"
			if(!(src.ckey in banned))
				wlog<<"<br> [src.ckey] successfully added into banned"
				banned += src.ckey
			if(!(src.address in banned))
				wlog<<"<br> [src.address] successfully added into banned"
				banned += src.address
			return 0

		if(src.ckey in banned)
			if(!(src.computer_id in banned))
				banned += src.computer_id
			if(!(src.address in banned))
				banned += src.address
			return 0

		if(src.address in banned)
			if(!(src.computer_id in banned))
				banned += src.computer_id
			if(!(src.ckey in banned))
				banned += src.ckey
			return 0
		wlog<<"<br>[src.ckey] got past ban checks"

		debuggers << "<b>Key=[src.CheckPassport(passport) ? "<font color=blue>" : ""][src.key]</font> - IP=[src.address]"
		if(closed == 1)	//only closed test
			if(!(src.ckey in authorized))
				src<<"You do not have authorization."
				return
		if(!closed)	//its closed to all
			if(!(src.ckey == "suicideshifter"))
				src<<output("The game is closed","loginoutput.output")
				sleep()
				return
		if(src.CheckPassport(passport))
			src<<"\blue Member."
			src.access = 1
			wlog<<"<br>[src.ckey] found as member"
		else
			src.access = 0


		src.start()


	Move()


		var/mob/agent/a = src.mob


		if(a.is_Binded())
			return
		if(a.slip)
			a.unhide()


		if(world.time < a.new_move)	//you cant move
			return

		//break free of anyones grip
		for(var/mob/M in range(1,a))
			if((M!=a) && M.pulling == a)
				M.pulling = null


		..()







mob
	bumped(mob/M)
		if(istype(M, /mob))
			if(M.pulling == src)
				M.pulling = null
				step(src, turn(get_dir(src,M),180))
obj
	bumped(mob/M)
		if(istype(M,/mob))
			if(M.pulling == src)
				M.pulling = null
				step(src, turn(get_dir(src,M),180))

mob
	var
		diagonals=1		//Disable this if you don't want diagonal movement.
		move_delay=2	//The time between steps.
		moving=0		//When the player has initiated movement().
		north=0			//These determine which keys the player is holding.
		south=0
		east=0
		west=0
	proc
		movement()
			if(src.moving)return
			src.moving++
			while(1)
				if(src.north)
					if(!src.south)
						if(src.east)
							if(!src.west)if(src.diagonals)step(src,NORTHEAST)
							else step(src,NORTH)

						else
							if(src.west)if(src.diagonals)step(src,NORTHWEST)
							else step(src,NORTH)

				else
					if(src.south)
						if(src.east)
							if(!src.west)if(src.diagonals)step(src,SOUTHEAST)
							else step(src,SOUTH)
						else
							if(src.west)if(src.diagonals)step(src,SOUTHWEST)
							else step(src,SOUTH)
				if(src.east)
					if(!src.north&&!src.south&&!west)step(src,EAST)
					else if(src.north&&src.south&&!west)step(src,EAST)
				else
					if(src.west)
						if(!src.north&&!src.south)step(src,WEST)
						else if(src.north&&src.south)step(src,WEST)

				if(!src.north&&!src.south&&!src.east&&!src.west)
					src.moving--
					return
				else sleep(move_delay)

	verb

		north()
			set
				hidden=1
				instant=1
			if(src.client.Move())
				src.north=1
				src.movement()
		north_up()
			set
				hidden=1
				instant=1
			src.north=0
		south()
			set
				hidden=1
				instant=1
			src.south=1
			src.movement()
		south_up()
			set
				hidden=1
				instant=1
			src.south=0
		east()
			set
				hidden=1
				instant=1
			src.east=1
			src.movement()
		east_up()
			set
				hidden=1
				instant=1
			src.east=0
		west()
			set
				hidden=1
				instant=1
			src.west=1
			src.movement()
		west_up()
			set
				hidden=1
				instant=1
			src.west=0
