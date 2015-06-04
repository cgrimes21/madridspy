//The vendor system


/*
Central funds pays for all items made by vendors. In return, taxation for selling off
to PLAYERS (not selling out) will closely return those funds back into central funding.
If nobody buys, they sell out and central funds loses that cash


central funding pays 10% of item cost to make,
tax is 20% of item cost
selling out will remove the item, not circulating any back into funding
*/

proc/pickweight(var/list/L)
  var/totweight = 0
  var/item
  for(item in L)
    var/weight = L[item]
    if(isnull(weight) || !weight)
      weight = 1; L[item] = 1
    totweight += weight
  totweight *= rand()
  world<<"hA[totweight]"
  for(var/i=1, i<=L.len, ++i)
    var/weight = L[L[i]]
    totweight -= weight
    if(totweight < 0)
      return L[i]

proc/pickweight_byindex(var/list/L)
  var/totweight = 0
  var/item
  for(item in L)
    var/weight = L[item]
    if(isnull(weight) || !weight)
      weight = 1; L[item] = 1
    totweight += ((weight+0.31)*100)/8
  totweight *= rand()
  for(var/i=1, i<=L.len, ++i)
    var/weight = L[L[i]]
    totweight -= ((weight+0.31)*100)/8
    if(totweight < 0)
      return i
  return 0





var
	list/statistic = list("minutes" = list("taken from central funds"=0,"given to central funds"=0) )

	tfc = 0
	gfc = 0
	minutes = 0

obj/vendor
	density = 1
	icon = 'agent.dmi'
	proc/sell_it()
	proc/buy_it()
	proc/payfor()	//stocks the item
	proc/sellout()	//sells the item to get scrap cash
	proc/pcheck()	//check and sellout accordingly

	var/min_money = 500
	var/agency = "civilian"
	verb
		black_market_vendor()
			set src in oview(1)
			var/mob/agent/sr = usr
			sr.buy_contents = src.contents
	penkovskiy
		icon = 'possiblebases.dmi'
		icon_state = "a"
		//weapons guy
		process()
			..()
			if(!(src.ticks % 6))	//6 seconds

				if(prob(7))

					var/s = pick(typesof(new /obj/small/weapon/gun)-/obj/small/weapon/gun)

					var/obj/small/t = new s ()
					//these guns are sorted when interacted by their min_rank
					t.owned = TRUE
					t.loc = src
					spawn(2700)
						if(t)
							if(t in src)
								game_del(t)
								return


	process()
		..()


		src.ticks ++
		if(!(src.ticks % 3))
			if(prob(7))
				view(src)<<"[src.name] looks around suspiciously..."
		//	step(src,pick(NORTH,SOUTH,EAST,WEST))

			//	src.payfor(t)






obj/vendor/sell_it(var/obj/small/what,var/mob/who)
	//called when vendor sells to somebody
	if(!(what.owned)) return
	if(!(what in src)) return
	if(!(who)) return

	//if(get_dist(src,who)>1)	return


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
		//	who.unmask()
		//	return

	if(src.agency != "civilian" && (src.agency != who.agency) )
		who<<"You do not have authorization. Scram!\n"
		return

	var/se = 1
	var/area/h = src.loc.loc
	if(h)
		se = h.section
	var/value = get_buy_price(what, trus, se)
	if(who.money < value)
		who<<"You do not have sufficient funds."
		return

	var/tax = (value*0.20)
	value = value + tax	//tax 20 percent

	central_funds += tax
	debuggers<<"Central funds reimbursed for [tax] amount."

	who.money -= value
	what.owned = TRUE
	what.Move(who)

	who.recalc_stats()
	who<<"You have purchased [what.name] for $[value]."
	if(istype(who, /mob/agent))	//only players trigger trust and calculate economic value
		if(prob(50))
			who.gain_trust(1,src)

		//every time an item is bought, add economic value to it
		add_economic_value(what, 0.01, se)


	return



obj/vendor/buy_it(var/obj/what,var/mob/who)
	//called when vendor buys from somebody (not npc)


obj/vendor/payfor(var/obj/what)
	//central funds donates to make the item
	var/area/b = src.loc.loc
	var/c = 1
	if(b)
		c = b.section

	var/price = get_sell_price(what, 0, c)
	price = (price*0.10)	//central funds pays for 10% to make
	if(central_funds - price <= 0)
		//debuggers<<"Central funds failed to support agency vendor."
		return
	central_funds -= price
	tfc += price
	debuggers<<"central funds funding [price]  towards a [what.name]."

	what.Move(src)

	spawn( 2700 )
		if(what)
			src.pcheck(what)
		return




obj/vendor/sellout(var/obj/what)
	//cant sell to players, sell out
	if(!what) return
	if(!(what in src)) return

	if(central_funds > src.min_money)	//central funds will pay for a new object, then its safe
										//to sell out
		game_del(what)



obj/vendor/pcheck(var/obj/what)
	//call after ___ minutes to check if you need to sellout or not
	if(!what) return

	if(!(what in src)) return

	if(central_funds > src.min_money)	//you have funds to pay for more
		//sell off the item
		src.sellout(what)
	else
		spawn( 1350 )	//wait 2.5 mins and come back again
			if(what)
				src.pcheck(what)
			return