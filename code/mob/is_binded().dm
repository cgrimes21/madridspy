mob/proc/is_Binded(var/p = 0)	//if p = 1 then you can use inventory so skip the things
							//that would disallow using inv.
	.=0

	if(!src.can_move)	//if they cant move,
		if(p)			//they cant move but they arent dead/binded by rope, so allow inventory

			.=0
		else			//they cant use inventory
			.=1			//they are binded.

	if(src.stuck>0)
		if(p)
			.=0
		else
			.=1
	if(src.w_cuff)
		.=1
	if(src.fell)
		.=1		//cant use inventory when fallen

	//this is last check
	if(src.health <= 0)	//unconscious, cant move
		.=1
	if(src.ko>0)	//unconscious
		.=1
	if(src.stun>0)
		.=1


	//check here if they are binded by rope

	return .

/*Okay so the usage here may be a little confusing.
Basically what this procedure does is check if a
spy cant move, either by their cant move variable,
if they're dead, or if they are binded by rope.
Now the parameter is here only for use for checking
if the spy can use something. For example equiping a gun.
What you would do here is under the equip call the
is_Binded proc BUT since this is using your inventory,
the parameter would now be 1. This makes it so even if you can't
move you will still be able to equip it AT THE SAME TIME
checking if your dead/binded by rope and returning zero. If you
are not dead/unconscious and are not binded by rope then even if
you can't move then you should still be able to equip the gun.
That is how its used with a parameter of 1 and where you use it.
*/

