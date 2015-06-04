obj/small/clothing/vest



	sneak_suit
		name = "Sneak Suit"
		desc = "Wearing this suit will hide you within the shadows."
		body_loc = "suit"
		var/blend = 0
		remove(mob/m)
			..(m)
			src.blend = 0
			m.icon = m.oicon




