obj/machinery

	item_catcher	//strips items from an agent and sends them to an out of reach location

		icon = 'base objects.dmi'

		var/on = 0

		terminal
			icon_state = "magneto"
		end
			icon_state = "catchero"
		tube
			icon_state = "tube"
		button
			icon_state = "magnetswitcho"