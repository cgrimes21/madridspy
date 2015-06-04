obj
	small
		clothing
			icon = 'shit.dmi'
			icon_state = "armor"
		

/*
			drop()
				if(src.worn)
					src.remove(usr)
				var/mob/agent/a
				if(istype(usr, /mob/agent))
					a = usr
				if(a)
					a.recalc_stats()
				..()

*/
			activate_item(mob/M)

				if(!src) return
				if(!(src in M)) return

				if(src.worn)
					src.remove(M)
					if(M)
						M.recalc_stats()
					return
				else
					for(var/obj/small/clothing/c in M)
						if(c.worn)
							if(c.body_loc == src.body_loc)
								c.remove(M)

					src.wear(M)
					if(M)
						M.recalc_stats()

			proc/wear(mob/m)
				m<<"\blue You wear the [src.name]."
				src.worn = 1
				src.suffix = "worn"

			proc/remove(mob/m)
				m<<"\blue You remove the [src.name]."
				src.worn = 0
				src.suffix = null

			body_loc = "head"	//the location to check if anything is already there when you equip
			var/worn = 0
			weight = 2			//slightly heavier than small items









/*
record
	//we attempt to retrieve a file from the network off the
	//main computer, we request the file and the protocol
	//creates an appropriate hash, appoints it to the original file,
	// and sends it along


	protocol_hash = "somesecrethashingpass"
	hash = md5(protocol_hash + record_name + data)


	//computer b recieves the file and the hash,
	//and recalculates to see if its been tampered with,
	//now computer a and b have the same protocol language
	//which means the protocol_hash password should be the same


	if(hash == md5(protocol_hash + record_name + data)
		//the file is now stored as a copy in computer b
		//whos hash variable is equal to the hash variable
		//residing in the main computer

		return

	//this isn't to say someone could have edited the
	//data and then hashed it appropriately, which is complicated
	//now the server needs to be able to manipulate it
	//accordingly and send it back without error


	//this is where hacking comes into play,*

	//*Read about this at the end of the article.


	newhash = md5(protocol_hash + record_name + data + "edited")

	//the file and the new hash are then sent to the main computer's protocol

	//now the computer checks if it wasn't hashed appropriately

	//see if it wasnt interfered and tampered with along the way to computer A
	if(newhash != md5(protocol_hash + record_name + data + "edited")
		alert(file tampered with!)
		return

	//check if the record was hashed accordingly through the correct protocol
	if(md5(protocol_hash + record_name + data + "edited") == newhash)
		//the hash was created through the appropriate protocol, it is valid
		update_file

	else if(hash == newhash)
		//the file's hash equals the same hash within computer a's record
		//nothing was changed
		return
	else
		alert(file tampered with)



Now a protocol will hash the edited file, and attempt to send it back
it assumes that if it wasn't hashed through the protocol, it is invalid
which means if you know how it works, you can use a protocol uploaded by yourself,
(needs to be done from your laptop, as most high security computers won't allow this)
writing a hash using a third party program, installing the file
to a laptop






*/
