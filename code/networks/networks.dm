
////Frequency range
//	2.2 - 18.8 giving 166 frequencies. (each frequency is rounded to nearest 0.1
//	2.2 is public chat.
/obj/machinery/computer/terminal/ris
	side = RIS

var/networks/ris_network = new()
var/networks/oss_network = new()
var/list/network_freqs = list()

/proc/initialize_networks()

	wlog<<"[get_time()]	initializing networks:"

	ris_network.create()
	ris_network.agency = 2
	ris_network.name = "Ritter Intelligence Services Private Network"
	ris_network.frequency = "[ris_network.get_freq()]"

	if(ris_network.code)
		ris_network.code = ris_network.gen_code()

	/////////////
	wlog<<"[get_time()] RIS [ris_network.name] on frequency [ris_network.frequency]"
	wlog<<"<br>RIS Agency Number: [ris_network.agency]"
	wlog<<"<br>RIS network code: [ris_network.code]"
	////////////

	oss_network.create()
	oss_network.agency = 1
	oss_network.name = "Office of Strategic Services Private Network"
	oss_network.frequency = "[oss_network.get_freq()]"//5
	oss_network.code = oss_network.gen_code()

	//////////
	wlog<<"[get_time()] OSS [oss_network.name] established on frequency [oss_network.frequency]"
	wlog<<"<br>OSS agency number: [oss_network.agency]"
	wlog<<"<br>OSS network code: [oss_network.code]"
	////////



	////////
	wlog<<"[get_time()] appointing terminals"

	for(var/obj/machinery/computer/terminal/t in world)
		if(t.side == ris_network.agency)
			wlog<<"<br>[t.ip] IP address (terminal) loaded onto ritter computers list"
			ris_network.computers += t.ip
		if(t.side == oss_network.agency)
			wlog<<"<br>[t.ip] IP address (terminal) loaded onto oss computers list"
			oss_network.computers += t.ip


	wlog<<"[get_time()] End network initialization."





networks	//each organization has their own network, and multiple lans

	proc
		login(mob/m,obj/machinery/computer/c)
			var/choice = input(m,"You have connected to the [src.name] from computer terminal:[c.ip]. \n") as null|anything in list("Authenticate","Load_Data","Open_Program")

			if(choice == "Authenticate")
				if(m.agency == src.agency)

					if(src.code)
						var/t = input(m,"This server is locked with a code.","") as null|text
						if(t == src.code)
							//change code
							src.code = gen_code()
							src.computers += c.ip
							src.active_users += m
							c.auth = 1		//your authenticated
							c.grant_access(m)
					else
						//your in agency, your allowed to access it
						c.auth = 1
						c.grant_access(m)
				//you have to be apart of the agency, then if you get the code right if iss one your in


		disconnect(mob/m, obj/machinery/computer/c)
			//disconnects a user and his computer from network
			c.auth = 0
			c.using = 0
			if(c.ip in src.computers)
				src.computers -= c.ip
			if(m in src.active_users)
				src.active_users -= m

		get_freq()
			var/f = rand(22,188)
			f = round(f/10,0.1)

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


		////////


		networks/servers/communication/comm_server
		networks/servers/fileserver/fileserver
		networks/servers/schematics/schematic_server
		networks/servers/security/security_server
		networks/servers/cameras/camera_server
		networks/servers/bank/bank_server
	New()
		..()
	proc/create()
		comm_server = new ()
		fileserver = new()
		schematic_server  = new()
		security_server = new()
		camera_server = new()
		bank_server = new()

	lan
		fileserver
		catalog
		frequency = 0

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
		bank
			var/list/accounts = list()

		//Agency networks
		mission_debreifs
		shipment_orders
		records
			var/list/entries = list()