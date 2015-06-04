dialog/page/tutorial1_4	//tutorial 1, part 2
	head = "mysterious figure"
	a

		body = {"Now you have the guard's ID card in either your left/right hand.

To interact with anything, click it. A left click will attempt to interact your left hand with the item, as a right click will interact your right hand.

This includes your GUI on the left side of the screen. Clicking slots will attempt to equip items in your hand with that slot, or unequip that item and move it into your hand."}
	b

		body = {"Let's practice this when this dialog box closes. You will have your issued ID card already equipped in your ID slot.
We need to move this in order to put the guard's ID on. With your free hand (left or right) interact with the card on the ID slot.
This will move your ID card into your free hand.

Now with the hand that is holding the guard's ID, click the empty ID slot. You should now be disguised as the guard and can now open the cell door."}










dialog
	tutorial1_4
		can_close = 0
		cont = newlist(

/dialog/page/tutorial1_4/a,
/dialog/page/tutorial1_4/b,

		)//,/dialog/page/tuto