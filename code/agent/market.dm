//////////////////////
//	Within this file contains everything about the market... for now
//	-Cody Grimes on 9/29/10
/////////////////////
/*
obj/small
	var
		value_mod = 0.05	//the percentage of initial value to add every purchase
		sale_value	= 0		//sale value is the same as value and initial value. When bought this goes down and slowly dwindles up
*/


var/list

	market_items = list()	//a list of all types of items and their values. This list is read from to retrieve sale price


proc
	get_sale_value(obj/small/whats,mob/who)
		if(!whats)
			return
		//if(!who) return

		var/market_values/what = locate("[whats.type]") in market_items
		//the who is if you want to do anything special, like rewarding if on different sides or whatever
		if(what)
			return what.sale_value
		else
			return 0


	get_value(obj/small/whats,mob/who)		//used for the purchase price from vendors
		if(!whats)
			return

		var/market_values/what = locate("[whats.type]") in market_items
		if(what)
			return what.value
		else
			return 0

	increase_sell_rate(obj/small/whats)		//what was just bought, now increase its value, reduce sale value

		if(!whats)
			return
		var/market_values/what = locate("[whats.type]") in market_items
		if(!what)	//item requesting is not in market
			return
		debuggers<<"increasing rates on [what.name]"
		what.tracker ++
		what.value += what.initial_value * (what.value_mod)

		what.sale_value -= what.initial_value * (what.value_mod)
		if(what.sale_value < 1)
			what.sale_value = 1		//1 is lowest. Negative values will start giving money back
		wlog<<"[get_time()] increasing rates on [what.name]. Value = [what.value]/[what.initial_value]<br>Sale value = [what.sale_value]<br>value mod = [what.value_mod]"

	//////////////
	//
	//	The above is all you need really. Time and dwindle proc takes care of evening things out so theres
	//	really no reason to add a decrease_sell_rate procedure
	//
	/////////////



	generate_market_list()

		/////////////
		///
		///		Simply creates one new obj of each type and stores it in a list to be later called upon
		///
		////////////

		wlog<<"[get_time()]: generating market list<br>--------<br>"
		wlog<<"<br> Name (value/initial value) - sale value - value modifier<br>"
		for(var/s in typesof(/obj/small))

			var/obj/small/ss = new s()
			wlog<<"<br>[ss.name] ([ss.value]/[ss.initial_value])-[ss.sale_value]-[ss.value_mod] - "
			market_items += new /market_values (ss,ss.value,ss.initial_value,ss.sale_value,ss.value_mod)
			game_del(ss)

		wlog<<"<br>Objects Total: [market_items.len]"
		wlog<<"[get_time()]: end generation"

	dwindle()

		//called every 10 seconds to level out the market prices
		///
		///		Note - COULD be laggy. Check on this
		///
		////////

		for(var/market_values/s in market_items)

			s.value = (0.97716*s.value) + (0.02284*s.initial_value)
			s.sale_value = (0.97716*s.sale_value) + (0.02284*s.initial_value)	//dwindle it back up


market_values

	var
		name = "a datum holding market values for instance"
		value = 0
		initial_value = 0
		sale_value = 0
		value_mod = 0.05

		tracker = 0		//how many times it was purchased from vendors


	New(obj/t,v,i,s,vm)
		..()
		src.name = "[t.name]"
		src.tag = "[t.type]"
		src.value = v
		src.initial_value = i
		src.sale_value = s
		src.value_mod = vm

/*
9 people		-> 1 person
750 dollars		-> 83 dollars
137 mins		-> 15 minutes

332 per hour


*/
