mob/agent/Stat()
	..()

	src<<output("health","stats.statt:1,1")
	src<<output("[round(src.health)] / [src.mhealth]","stats.statt:2,1")
	src<<output("money","stats.statt:1,2")
	src<<output("[src.money]","stats.statt:2,2")

	/*
	statpanel("Stats")

	stat("[src.name]  Health: [src.health]/[src.mhealth]")
	stat("Money: [src.money]")


	stat("Running: [src.running]")
	stat("Moved Recently: [src.moved_recently]")
	stat("Shadow: [src.shadow]")
	stat("Elevation: [src.elevation]")
	stat("hand",src.hand)
	stat("selected",src.selected)
	*/

	statpanel("Inventory")
	stat("cpu:",world.cpu)
	stat("hand:",src.hand)
	stat("current id card:",src.w_id)
	stat("")
	stat("------------------")
	stat(src.contents)

//	statpanel("Skills")


	if(src.buy_contents)
		statpanel("vendor")
		stat(src.buy_contents)

	statpanel("rankings")
	if(topgun)
		stat(topgun.real_name,topgun.kills)

	for(var/mob/agent/v in rankers)
		stat(v.real_name,v.kills)
	stat("___________________")
	stat("Office of Strategic Services: [oss_score]")
	stat("Ritter Intelligence Services: [ris_score]")




