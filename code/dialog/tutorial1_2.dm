dialog/page/tutorial1_2	//tutorial 1, part 2
	head = "mysterious voice"
	a
		head = "***** - begin radio transmission..."
		body = "*chhk"
	b

		body = "white shadow to benson.. respond, over."
	c

		body = {"We are attempting contact through internal radio devices which have been implanted into your tooth.

Nevermind who this is, what is important is your escape. You have been caught and imprisoned behind enemy lines for the acts of espionage \
and assassination.

Your government has denied all claims towards your existance, the enemy has no use for you and they WILL kill you. "}

	d

		body = {"...... Our frequency is weakening....... there is a mole.....planted  ...... the cell.....find him....



		*end transmission*"}









dialog
	tutorial1_2
		can_close = 0
		cont = newlist(

/dialog/page/tutorial1/a,
/dialog/page/tutorial1/b,
/dialog/page/tutorial1/c,
/dialog/page/tutorial1/d,
		)//,/dialog/page/tutorial/b)