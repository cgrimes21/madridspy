var/list/computer_ids = list()	//contains all ip addresses of all computers


/obj/machinery/computer
	icon = 'computers.dmi'
	icon_state = "computer"
	name = "Computer"
	density = 1


	var
		ip
		tick = 0
		auth = 0
		mob/using 	//only one person can use at a time

		var/data/data_chip/chip
		var/data/program/program_running

	proc
		grant_access(mob/m)
		grant_server_access(mob/m,networks/servers/s)
		run_program(data/program/p)		//runs a program
		insert_data(data/data_chip/c)		//inserts a data chip

		generate_ip()

			var/a = rand(111,999)
			var/b = rand(111,999)
			var/c = rand(111,999)
			if("[a].[b].[c]" in computer_ids)
				generate_ip()
				return

			src.ip = "[a].[b].[c]"
			wlog<<"[get_time()] computer terminal (side [src.side]) established IP of [src.ip]<br>Adding to computer_ids list"
			computer_ids += src.ip
	New()
		..()

		src.generate_ip()	//every computer generates ip
		src.tag = src.ip