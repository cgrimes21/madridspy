
world
	Topic(href,add)

		var/list/hl = list()
		hl = params2list(href)

		world<<hl
		if(href == "ping")

			world.Export("byond://184.82.12.166:1277?ping;answer=1")
		..()