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

		obj/machinery/transmitter/trans		//current transmitter

		data/data_chip/dc		//the data chip inserted, from there you can run programs
								//from the data chip


	proc
		generate_ip()

			var/a = rand(111,999)
			var/b = rand(111,999)
			var/c = rand(111,999)

			src.ip = "[a].[b].[c]"
	New()
		..()

		src.generate_ip()	//every computer generates ip


