#define BUY_TAX		0.93		//buy tax percentage, minimum is .6  	O .93
#define SALE_TAX	0.436		//sale tax percentage, maximum is .58	O .436
#define FUND_TAX	0.20		//take 20% and sink it back into central funds on sales


//maximum shift is .3

//every purchase brings the items worth up 0.01 and all other items down 0.01
//maximum is .3 both ways (-.3)
var/list
	section1 = list()
	section2 = list()
	section3 = list()
var/global
	central_funds = 0	//pays for all expenses

proc
	economy()
		var/buffer = 0
		var/counter = 0
		for(var/mob/agent/P in world)
			buffer += P.money
			counter ++
		buffer = (buffer / counter)/10000
		return buffer



	get_sell_price(var/obj/small/what, trust = 0, section = 1)		//get the initial value
		if(what && ((what.mdura && what.dura) || (!what.mdura)))
			//if what exists and if has mdura it has to be okay, if not okay or not mdura,
			//it checks if it doesnt have a mdura, if it does then its broken and return

			//var/price = round((what.dura**1.600071)*(what.initial_value+0.652))


			var/am = 1
			var/mult = 0
			var/discount = 0
			if(istype(what, /obj/small/bulk))
				var/obj/small/bulk/b = what
				mult = b.amount/100
				//cut it so it doesnt round up (example 5.78 will become 5)
				mult = num2text(mult, 25)
				mult = copytext(mult, 1,2)
				mult = text2num(mult)



				am = b.amount
			if(!(mult % 1))
				//one number without decimals
				discount = (mult * 0.03)

			var/st = 0
			if(section == 1)
				if(section1["[what.type]"])
					st = section1["[what.type]"]	//get the economic shift
			if(section == 2)
				if(section2["[what.type]"])
					st = section2["[what.type]"]
			if(section == 3)
				if(section3["[what.type]"])
					st = section3["[what.type]"]


			var/price = (what.initial_value*(( (SALE_TAX + st)+discount)+(trust*0.0012))) * am

			return price

	get_buy_price(var/obj/small/what, trust = 0, section = 1)
		if(what && ((what.mdura && what.dura) || (!what.mdura)))


			var/am = 1
			var/mult = 0
			var/discount = 0
			if(istype(what, /obj/small/bulk))
				var/obj/small/bulk/b = what
				mult = b.amount/100
				//cut it so it doesnt round up (example 5.78 will become 5)
				mult = num2text(mult, 25)
				mult = copytext(mult, 1,2)
				mult = text2num(mult)

				am = b.amount

			if(!(mult % 1))
				discount = (mult * 0.03)	//even number without decimals


			var/st = 0
			if(section == 1)
				if(section1["[what.type]"])
					st = section1["[what.type]"]	//get the economic shift
			if(section == 2)
				if(section2["[what.type]"])
					st = section2["[what.type]"]
			if(section == 3)
				if(section3["[what.type]"])
					st = section3["[what.type]"]

			var/price = (what.initial_value*(( (BUY_TAX + st)-discount)-(trust*0.00275))) * am

			return price

	initialize_section_lists()
		for(var/v in typesof(/obj/small)-/obj/small)
			section1["[v]"] = 0
			section2["[v]"] = 0
			section3["[v]"] = 0
		debuggers<<"Section economic buffers re-initialized."

	remove_economic_else(var/obj/small/what, var/section = 1)
		//takes 0.01 away from all except what.type in section
		//used to keep the section's economic flow fluctuating (as one thing goes up, the rest goes down)
		if(!what) return



		switch(section)
			if(1)
				for(var/v in section1)


					if(v != "[what.type]")



						var/this = 0
						this = section1["[v]"]
						this -= 0.01

						section1["[v]"] = this

						this = min(max(this,-0.30),0.30)
						section1["[v]"] = this

			if(2)
				for(var/v in section2)
					if(v != what.type)
						var/this = 0
						this = section2["[v]"]
						this -= 0.01

						section2["[v]"] = this

						this = min(max(this,-0.30),0.30)
						section2["[v]"] = this

			if(3)
				for(var/v in section3)
					if(v != what.type)
						var/this = 0
						this = section3["[v]"]
						this -= 0.01

						section3["[v]"] = this

						this = min(max(this,-0.30),0.30)
						section3["[v]"] = this

		for(var/ag in section1)
			debuggers<<"[ag]  [section1["[ag]"]]"

	add_economic_value(var/obj/small/what, var/howmuch = 0.01, var/section = 1)
		if(section == 1)
			var/this = 0
			this = section1["[what.type]"]
			this += howmuch

			section1["[what.type]"] = this

			//cap it
			this = min(max(this,-0.30),0.30)
			section1["[what.type]"] = this

			remove_economic_else(what, 1)	//lower every thing else

			debuggers<<"section1's [what.type]'s economic shift has changed. [section1["[what.type]"]]"

		if(section == 2)
			var/this = 0

			this = section2["[what.type]"]
			this += howmuch
			section2["[what.type]"] = this
			this = min(max(this,-0.30),0.30)
			section2["[what.type]"] = this

			remove_economic_else(what, 2)

			debuggers<<"section2's [what.type]'s economic shift has changed. [section2["[what.type]"]]"
		if(section == 3)
			var/this = 0

			this = section3["[what.type]"]
			this += howmuch
			section3["[what.type]"] = this
			this = min(max(this,-0.30),0.30)
			section3["[what.type]"] = this

			remove_economic_else(what, 3)

			debuggers<<"section3's [what.type]'s economic shift has changed. [section3["[what.type]"]]"



mob
	proc
		lose_trust(var/trus = 0, var/mob/who)	//src loses trust with who
			src<<"You lose trust with [who.name]."
			var/t = 0
			//default is zero

			//if a trust record already exists and its above zero,
			if(!src.trust_values) src.trust_values = list()
			if(who.trust_values["[src.real_name]"])
				t = who.trust_values["[src.real_name]"]
				t -= trus
				t = max(t, 0)	//cap it

			//if trust record wasnt found or its not above zero, just set it to default t (0)

			who.trust_values["[src.real_name]"] = t

		gain_trust(var/trus = 0, var/mob/who)
			src<<"You gain trust with [who.name]."
			var/t = trus
			if(!src.trust_values) src.trust_values = list()
			if(who.trust_values["[src.real_name]"])
				t = who.trust_values["[src.real_name]"]
				t += trus
				t = min(t, 120)

			who.trust_values["[src.real_name]"] = t





mob/npc
	blackmarket_vendors

		rank = 20
		//var/section = "downtown"		//the section of the cities they are in
		//prices differ
		agency = "civilian"
		var/quality = 1			//level of quality the items are, higher this is
							//the more valuable the items are

		var/min_money = 5000	//minimum amount of money, once this is reached they wont buy from you
							//so they will use these funds to purchase more items

		var/max_money = 100000	//maximum amount of money.

		var/list/names = list("The Spider","Wood","Swiss","Bern","Madrid","Dulles",
		"Rhine","Schweizer","Bundes","Bahnhof","Kirchenfeld",
		"Dublin", "Abetz","Franco","Aires","Buenos","Werner","Zurich","Alman","Koy",
		"Jenkes","Herr")
		proc/sold(var/obj/small/what, var/mob/who)	//called when src sells what to who
			return

		proc/bought(var/obj/small/what, var/mob/who)//called when src buys what from who
			return

		proc/sell_to(var/obj/small/what, mob/who, var/thi = 1)	 //thi = 1 is default (use get_buy_price)
																//thi = 0 will sell using sell_price

			if(!what) return
			if(!who) return
			if(!what.owned) return
			if(!(what in src)) return

			var/trus = 0
			if(!src.trust_values) src.trust_values = list()
			if(src.trust_values["[who.name]"])
				trus = src.trust_values["[who.name]"]	//set trust based on name allowing
														//disguises to change trust


		//	if(who.disguised)	//your disguised
		//		if(prob(25))
		//			who<<"<b>Trying to trick me huh?! Scram!</b>"

		//			who.lose_trust(rand(1,2),src)


					//unmask
			//		who.unmask()
			//		return
			if(src.agency!="civilian" && (src.agency!=who.agency) ) //the vendor belongs to an agency
																	//and you dont belong to that agency
				who<<"You do not have authorization. Scram!\n"
				return

			var/value = 0
			if(thi)
				value = get_buy_price(what,trus, who.section)
			else
				value = get_sell_price(what, trus, who.section)

			if(who.money < value)
				who<<"You do not have sufficient funds."
				return
			if(istype(who, /mob/npc/blackmarket_vendors))
				var/mob/npc/blackmarket_vendors/v = who
				if(v.money < v.min_money)
					return	//dont let them buy it

			who.money -= value
			src.money += value
			what.owned = TRUE
			what.Move(who)

			who.recalc_stats()
			who<<"You have purchased [what.name] for $[value]."
			if(istype(who, /mob/agent))	//only players trigger trust and calculate economic value
				if(prob(50))
					who.gain_trust(1,src)

				//every time an item is bought, add economic value to it
				add_economic_value(what, 0.01, who.section)

			src.sold(what,who)	//src sold what to who
			return


	//the only instance this will be called is when a player is selling to an npc, that is all
	//all other sales between npcs are handled with sell_to

		proc/buy_from(var/obj/small/what, mob/who)			//npc is buying what from who
			if(!what) return
			if(!who) return
			if(!what.owned) return
			if(!(what in who)) return

			var/trus = 0
			if(!src.trust_values) src.trust_values = list()
			if(src.trust_values["[who.name]"])
				trus = src.trust_values["[who.name]"]	//set trust based on name allowing
														//disguises to change trust
			//check if npc, increase trust to 300

		//	if(who.disguised)	//your disguised
		//		if(prob(25))
		//			who<<"<b>Trying to trick me huh?! Scram!</b>"

		//			who.lose_trust(rand(1,2),src)

					//unmask
		//			who.unmask()
		//			return

			if(src.agency!="civilian" && (src.agency!=who.agency) ) //the vendor belongs to an agency
																	//and you dont belong to that agency
				who<<"You do not have authorization. Scram!\n"
				return

			var/value = get_sell_price(what,trus)

			if((src.money < value) || (src.money - value < src.min_money))
				who<<"[src.name] does not have sufficient funds."
				return

			if(istype(who, /mob/npc/blackmarket_vendors))
				var/mob/npc/blackmarket_vendors/v = who
				if(v.money < v.min_money)
					return	//dont let them buy it

			who.money += value
			src.money -= value
			what.owned = TRUE
			what.Move(src)

			src.recalc_stats()
			who<<"You have sold [what.name] for $[value]."

			if(prob(50))
				who.gain_trust(1,src)

			src.bought(what,who)
			return

		process()
			..()

			if(src.money < src.min_money)
				if(src.money < 0)
					src.money = 0
				src.money += 18






		main_importer		//buys with their own money from exporter to import items into
							//the area's market
			money = 50000





			Reinhardt
			Albert
			Lisbon

		vendor			//all the small vendors that recieve from the importer
			icon = 'agent.dmi'
			money = 25000
			Andrus
			Linford
			Brown
			New()
				..()
				while(src)
					sleep(10)
					src.process()

			process()
				..()

				src.ticks += 1
				if(!(src.ticks % 3))

					step(src,pick(NORTH,SOUTH,EAST,WEST))
				if(!(src.ticks % 6))
					//6 seconds
					var/list/L = new
					switch(src.section)
						if(1)
							for(var/co in section1)
								L["[co]"] = section1["[co]"]
						if(2)
							for(var/co in section2)
								L["[co]"] = section1["[co]"]
						if(3)
							for(var/co in section3)
								L["[co]"] = section1["[co]"]



					if(prob( 7 ))
						for(var/v in L)
							var/ca = copytext(v, 1, 23)
							if(ca != "/obj/small/weapon/gun/")
								L -= v

						//pick(prob(40),object;prob(30),object;)
						var/t = pickweight_byindex( L )
						if(!t)
							t = 1
						t = L[t]

						var/obj/small/s = new t
						s.owned = TRUE
						src.payfor(s)	//go through the process (equivilent to  selling only to nothing)



		proc/pcheck(var/obj/small/what, var/mob/npc/blackmarket_vendors/who = src)
			if(!what) return
				//its gone

			if(what in who)	//still in you
				if(who.money > who.min_money)	//youve got money to afford more
					//sell to intermediate for some scrap cash
					var/v = get_buy_price(what, 0, who.section)
					v = v/3

					who.money += v	//money coming into circulation
					central_funds += (get_buy_price(what, 0, who.section))*0.20
					gfc += (get_buy_price(what, 0, who.section))*0.20
					game_del(what)
				else
					//you dont have money to afford more, check back in 2.25 mins

					spawn( 1350 )
						if(what)

							src.pcheck(what)
						return


		proc/payfor(var/obj/small/what, var/mob/npc/blackmarket_vendors/who = src)

			var/value = get_sell_price(what, 0, who.section)

			if(who.money <= who.min_money)	//dont do anything
				return
			//if you can afford it, buy it
			who.money -= value	//money coming out of circulation, add to central funding
			central_funds += (value*FUND_TAX) //only 20% goes into funding
			gfc += value*FUND_TAX
			what.Move(who)

			spawn( 2700 )
				if(what)

					src.pcheck(what)	//check what for src
				return



//money will be equivilent value in our world pretty much.
//therefore, $1,000 will be fairly expensive

