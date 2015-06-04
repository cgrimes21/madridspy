

obj/small/bulk
	icon = 'shit.dmi'
	icon_state = "mission"
	desc = "A voucher that warrants a shipment of supplies."

	set_stats()
		src.initial_value = (what.initial_value * src.amount)
		src.set_desc()

	set_desc()
		desc = "This voucher warrants you to a shipment of [src.name]s \blue([src.amount])."
	initial_value = 500
	var
		amount = 1
		obj/small/what		//what item this slip represents



obj/small/bundle	//a bundle of items used for exporting/importing market
	var/level = 1	//level pertaining to npc quality