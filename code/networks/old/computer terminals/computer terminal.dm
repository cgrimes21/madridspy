obj/machinery/computer/terminal
//prism to deflect laser



	var


		auth = 0
		mob/using 	//only one person can use at a time

		obj/machinery/computer/main_server/server


	New()
		..()
		spawn()	//wait for main computer list to be populated
			//if there is a side on this computer, it belongs to an agency.
			//lets link up to that network

			src.trans = new /obj/machinery/transmitter


			src.find_home_network()


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
			if(src.server.disabled)
				return

			if(src.using)
				usr<<"\blue Someone is already using this terminal."
				return


			src.auth = 0
			src.using = usr

			if(src.server.trans && src.trans)		//both computers have transmitters
				if(!src.server.trans.disabled && !src.trans.disabled)

					if(src.server.trans.freq == src.trans.freq)

						//everything checks out, show them the login screen
						usr<<"\blue Connected to ip: [src.server.ip]"
						src.server.login_interface(usr)
			else
				usr<<"\blue Cannot connect to server..."
				return




	proc




		find_home_network()	//finds the network they are supposed to be on

			if(src.side && (!(src.disabled)))


				for(var/obj/machinery/computer/main_server/c in main_comp)

					if(c.side == src.side)

						src.server = c			//reference to main server
						src.trans.freq = c.trans.freq		//set frequencies

//JUST DIFFERENT SIDES
	ris
		side = RIS
	oss
		side = OSS
	fob
		side = FOB
	nsa
		side = NSA
	je
		side = JE


