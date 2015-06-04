obj/machinery/computer/laptop
	/*
	proc


		get_networks()	//returns a list of networks that is within range
			var/list/netw = list()

			for(var/obj/machinery/sattelite/s in satt)
				if(!(s.disabled))
					if(get_dist(src, s)<=s.range)	//your in range
						if(s.main.disabled)
							continue
						if(!(s.main.network_on))
							continue

						netw += s.main.net.name

			return netw*/