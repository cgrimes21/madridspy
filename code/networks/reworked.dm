////////////
//	Networks redone by Cody Grimes on 10/1/10
///////////
/obj/machinery/computer/terminal/ris
	side = RIS



////Frequency range
//	2.2 - 18.8 giving 166 frequencies. (each frequency is rounded to nearest 0.1
//	2.2 is public chat.

var/networks/ris_network = new()
var/networks/oss_network = new()
var/list/network_freqs = list()

/proc/initialize_networks()

	ris_network.agency = 2
	ris_network.name = "Ritter Intelligence Services Private Network"
	ris_network.frequency = ris_network.get_freq()
	ris_network.code = ris_network.gen_code()
	world.log<<"called init networks"


	oss_network.agency = 1
	oss_network.name = "Office of Strategic Services Private Network"
	oss_network.frequency = oss_network.get_freq()//5
	oss_network.code = oss_network.gen_code()



	////////
	for(var/obj/machinery/computer/terminal/t in world)
		if(t.side == ris_network.agency)
			ris_network.computers += t.ip
		if(t.side == oss_network.agency)
			oss_network.computers += t.ip





networks	//each organization has their own network, and multiple lans

	proc
		get_freq()
			var/f = rand(min_freq,max_freq)
			if(f in network_freqs)
				get_freq()
				return
			else
				network_freqs += f
				return f
		gen_code()
			var/ret = "83684"
			if(prob(50))
				ret = pick("carrissa",
"acetsys",
"bkmsjtv",
"packname",
"padshahs",
"pagescmt",
"paintbox",
"palatini",
"palisado",
"palmerjo",
"palterer",
"panalall",
"pandiyah")
			else
				var/tt = 5
				ret = ""
				while(tt)

					var/a = pick(alphabet)
					ret += "[a]"
					tt -= 1
			return "[ret]"

	var
		agency = 0
		name = "computer network"
		locked = 0
		offline = 0
		disabled = 0

		list/active_users()	//who is connected

		code = 0	//if 0, no code is required to logon

		frequency = 0	//the frequency the network is on
		var/list/computers = list()	//list of IP addresses connected to this server

	/*
		////////
		networks/servers/comm_server = new
		networks/servers/fileserver = new
		networks/servers/schematic_server  = new
		networks/servers/security_server = new
		networks/servers/camera_server = new
	*/

	lan
		fileserver
		catalog

	servers

		//General/Organization networks

		communication
			var/list/com = list()	//a list of posted communications
		fileserver
			var/list/data = list()

		schematics
			var/list/entries = list()
		security	//controls all security controls and remote access to electric devices within each room
		cameras

		//Agency networks
		mission_debreifs
		shipment_orders
		records
			var/list/entries = list()

obj/machinery/computer
	icon = 'computers.dmi'
	icon_state = "computer"
	name = "Computer"
	density = 1


	var
		ip
		side = 0
		disabled = 0
		tick = 0

	proc
		generate_ip()

			var/a = rand(111,999)
			var/b = rand(111,999)
			var/c = rand(111,999)

			src.ip = "[a].[b].[c]"
	New()
		..()
		spawn()
			src.generate_ip()	//every computer generates ip
			src.tag = src.ip

obj/machinery/computer/terminal




	var


		auth = 0
		mob/using 	//only one person can use at a time

		networks/network = new()

	proc/get_home_network()
		world.log<<"getting home network"
		switch(src.side)
			if(1)
				src.network = oss_network
				world.log<<"was 1, oss"
			if(2)
				src.network = ris_network
				world.log<<"was 2, ris"


	New()
		..()
		spawn()
			src.get_home_network()
	process()
		..()


		src.tick ++

		//check if the user is still there
		if(src.using)				//someone is logged on

			if(!(locate(using) in range(1,src)))
				src.using = null
	verb
		access_terminal()
			set src in oview(1)

			if(src.disabled)
				return
			if(src.network.locked)
				return
			if(src.network.disabled)
				return

			/*
				locked = 0
		offline = 0
		disabled = 0

		list/active_users()	//who is connected

		code = 0	//if 0, no code is required to logon

		frequency = 0	//the frequency the network is on
			*/

			if(src.using)
				usr<<"\blue Someone is already using this terminal."
				return


			src.auth = 0
			src.using = usr



						//everything checks out, show them the login screen
			usr<<"\blue Connected to ip: [src.ip] on frequency: [src.network.frequency]"
