obj/small/clothing/mask



	weight = 1
	body_loc = HEAD//"head"
	icon = 'hats.dmi'

	swat
		name = "helmet"
		desc = "Protects from bludgeoning attacks."
		icon_state = "helmet"

		value = 670
		initial_value = 670
		sale_value = 650


		//force=1
		//var/dose = 5
		//range = 1
		body_loc = HEAD
		dura = 100
		mdura = 100
		weight = 3


	swat_thermal
		weight = 2
		name = "thermals"
		desc = "Able to see spies through walls."

		icon_state = "helmet2"


		value = 970
		initial_value = 970
		sale_value = 650


		//force=1
		//var/dose = 5
		//range = 1
		body_loc = HEAD
		dura = 100
		mdura = 100

	tophat
		icon_state = "tophat"

		remove(mob/M)
			..()
			var/image/this = image('head.dmi',icon_state = "helmet2",layer=MOB_LAYER+1)
			M.overlays -= this
			M.Overlays -= this
			M.see_in_dark = initial(M.see_in_dark)
		wear(mob/M)
			..()
			var/image/this = image('head.dmi',icon_state = "helmet2",layer=MOB_LAYER+1)
			M.overlays += this
			M.Overlays += this
			M.see_in_dark = 10

