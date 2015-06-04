dialog/page/tutorial1_3	//tutorial 1, part 2
	head = "mysterious voice"
	a

		body = "whaa.. who are you??"
	b

		body = {"Never mind that, never mind. Listen, they just executed a mole within the agency.
		I don't know how they figured their employee was a mole but he is dead, and we are next.


		We have at most 5 minutes before those guards come back and execute us both,
		I don't plan on that happening. Im getting out of here, if you want out then follow my steps."}
	c

		body = {"We are going to have to trust each other, we have only one shot at this.

		I'm going to take a cyanide pill which will render me dead for a good 10 minutes.
		When the guard comes in to gather us for execution he will see me lying in the corner.
		Once he begins to investigate I want you to slowly walk up behind the guard and press the 'G' button. This will grab ahold of him.
		"}
	d
		body = {"
		Be cautious, as you only have about 3 seconds to do what you intend to do with him before he releases himself or worse, stabs you with his free hand.

		Once you have a hold of the guard, press the 'G' button again to knock him out. "}

	e

		body = {"We will go from there, we have limited time!


		*mysterious figure swallows a cyanide pill*
		"}









dialog
	tutorial1_3
		can_close = 0
		cont = newlist(

/dialog/page/tutorial1_3/a,
/dialog/page/tutorial1_3/b,
/dialog/page/tutorial1_3/c,
/dialog/page/tutorial1_3/d,
/dialog/page/tutorial1_3/e,
		)//,/dialog/page/tuto