
/obj/machinery/computer/terminal

	var
		networks/network = new()


	proc/get_home_network()

		switch(src.side)

			if(1)
				src.network = oss_network

			if(2)
				src.network = ris_network

	process()
		..()


		src.tick ++

		//check if the user is still there
		if(src.using)				//someone is logged on

			if(!(locate(using) in range(1,src)))
				src.using = null

	New()
		..()
		spawn()
			src.get_home_network()

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
			src.network.login(usr,src)

/obj/machinery/computer/terminal/bank
	side = RIS
	grant_access(mob/m)

		var/choose = input(m, "Welcome to the bank server. Enter an option.") as null|anything in list("Create New Account","Manage Existing Account","Administration")
		if(choose == "Create New Account")
		//	var/na = input("enter your name") as text
		//	var/pa = input("choose a password") as text
		//	var/paa = input("reenter") as text
			alert(m,"your account has been created")
	//	if(choose == "Manage Existing Account")
		//	var/na = input("enter name") as text
		//	var/pa = input("enter pass") as text
		//	var/ch2 = input("choices") as null|anything in list("view account","view statement","transfer money","loans","done")
			;
		/*
			New account
				->enter name
				->enter password
				->retype password
				->create
			Manage existing
				->type name and password

					->view account
						->account name: form
						->account number: 5432
						->balance:	55
						->loan: 4 (20% apr)
						->Done
					->view statement
						Date: :Action:
						5/5:  :from bob: loan
					->transfer money
						->Ac. no. (from):
						->Bank IP (to): (the bank terminal IP)
						->A. no. (to):
						->Amount
						->Transfer (button)
					->loans
						->account name
						->acc no
						->balance
						->loan: 0
						->Increase loan (max 4000)
						->Decrease loan
						->done
					->done
			*/

		//var/networks/servers/bank/s
		//s = src.network.bank_server
		//m<<src.network.bank_server.money


/obj/machinery/computer/terminal/schematics
	side = RIS
	grant_access(mob/m)
		var/choose = input(m,"Wiring schematics") as null|num
		world<<choose