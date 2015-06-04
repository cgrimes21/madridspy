

var/list/main_comp = list()
//a quick list of all the computers so we don't have to scan the world every time


obj/machinery/computer/main_server	//main computer defines
	icon = 'computers.dmi'
	icon_state = "computer"
	name = "Main Computer"
	density = 1


	var
		temp_admin = "rosen"


	New()
		..()

		src.trans = new /obj/machinery/transmitter
		src.trans.model = 2		//a receiver
		src.trans.freq = rand(101.111, 199.999)

		//add this server to main list
		main_comp += src

	proc
		generate_temp()
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


		login_interface(mob/m)	//shows a login interface
		check_login(user,pass,obj/machinery/computer/c)	//checks login name and pass with database

		disconnect()	//called whenever someone disconnects
			temp_admin = "[generate_temp()]"



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

		/*
		log_in(mob/m)
			if(src.net.lockdown)
				m<<"The system has been locked out."
				return
			var/list/L = list()
			for(var/obj/small/id_card/a in usr)
				if(istype(a))
					L["[a.written_name]"] += a//.written_name
			var/obj/small/id_card/i = input(usr,"Select an ID card to login.") as null|anything in L
			i = L[i]
			if(!i) return
			if(src.authenticate(i))
				src.logged_in = i.written_name
				m<<output("Logged in as: [src.logged_in]","network_records.label3")
				for(var/network/n in src.net.data)
					if(n.name == "records")

						for(var/data/record/d in n.data)
							m<<output("[d.written_name]","network_records.entries")


							m<<output("2","network_records.entries:")
			else
				m<<output("Failed to authenticate [i.written_name].","network_records.output")
				src.net.tries ++
				src.net.try_cool += 100
				if(src.net.tries > 3 && src.net.try_cool > 300)
					m<<output("You tripped the alarm.","network_records.output")

					src.net.lockdown()
		interact(mob/M)
			if(!src.net)

				for(var/network/n in networks)

					if("[n.side]" == "[src.side]")

						src.net = n
						usr<<output("Copyright of [src.net.name]","network_records.owner")

			if(get_dist(src,usr)>1) return
			if(src.disabled) return
			//if(src.logged_in) usr<<"the computer is being used";return
			if(src.using)

				for(var/mob/m in oview(1,src))
					if((src.using == m)&&(src.using!=usr))

						usr<<"the computer is being used"
						return

				src.using = null	//if it made it to this line, the mob using the computer isn't around anymore
			if(src.net.lockdown)
				usr<<"The system has been locked out. Unlock in [src.net.lock_time] seconds."
				return
			winshow(usr,"network_records",1)

			src.using = usr

		verb
			record_login()
				set src in oview(1)
				set hidden = 1
				src.log_in(usr)


*/