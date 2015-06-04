
/obj/small/power_cell
	icon = 'objects.dmi'
	icon_state = "lock"
	//A portable cell that stores energy. Used in all things electronical
	var/load_rate = 0.002		//a basic cell takes .002 % of max life per second, giving this cell (w/ max of 100) 8.3 minute life
	var/charge_rate = 0.001
	var/capacity = 100			//100 watts
	var/dead = 0				//is it dead?
	var/load = 0				//is the load on?

	var/turf/home

	mdura = 100
	dura = 100

	//NOTE there are devices that amp up a cell's charge rate for various purposes

	//A quality 1 cell will have a 5 second charge
	//a q 10 will have a 50 second charge
	//a dura 100 will have approx 8.3 minute charge




	set_desc()
		src.desc = "A power cell.\nHas a maxlife of [round(100/( 100* ( (src.load_rate*100) / src.dura )))] seconds."
		return

	process()
		if(!src.loc)	//its nowhere
			//its probably located within the market list, which would have a loc of null
			//dont do anything with this.
			return


		var/ho = (src.load_rate*100) / (src.dura)
		ho *= 100

		if(src.capacity<=0)
			src.capacity = 0
			src.dead = 1
			src.suffix = "dead"
			src.desc = "A dead power cell."
		else
			src.dead = 0
			src.suffix = "[round(((src.capacity/ho))/60,0.01)] minute charge"



		if(src.load)	//there is a load on the cell, diminish
			src.capacity -= ho



		var/turf/t
		t = src.loc
		if(!istype(t, /turf))
			t = src.loc.loc


		if(istype(t,/turf))
			var/turf/tt = t
			if(tt.charge)
				capacity += ho + (ho)		//amp up charge rate to overcome load
				if(capacity >= 100)
					src.capacity = 100


	advanced_cell				//an extremely more advanced cell, capable of lasting up to 83.3 minutes with a durability of 100

		load_rate = 0.0002 		//at quality 100 so we have to start out with a value of 0.02
		charge_rate = 0.0001

		//formula
		//src.load_rate = (src.loadrate*100) / (t)		this makes the .0002 load rate go to 0.02 then if quality is 100 it goes to default
														//of .0002 again, i cant believe it took me this long to figure
		//a durability of 1 will hold a 15 min charge

/obj/machinery/broad_caster
	icon = 'objects.dmi'
	icon_state = "lock"
	//////////////////
	//
	//A broadcaster is a device which charges power cells within range. Agencies and military bases use this.
	//They actually ramp up the power cell's charging rate to overcome the load rate. Only broadcasters of same version
	//(side) can increase power cells of same version's rate. Otherwise the charging is default, which the power load eats
	//faster than the charge can hold
	//
	/////////////////
	var/range = 40	//40 tiles/meters

	proc
		turn_on()
			if(src.disabled)
				return

			for(var/turf/t in range(src.range,src))
				t.charge = 1
		turn_off()
			if(src.disabled)
				return
			for(var/turf/t in range(src.range,src))
				t.charge = 0

		disable()
			src.disabled = 1
			for(var/turf/t in range(src.range,src))
				t.charge = 0
	New()
		..()
		src.turn_on()

	explode()
		..()
		src.disable()
		spawn( 2700)
			if(src && src.disabled)
				src.disabled = 0
				src.turn_on()
			return
		return




