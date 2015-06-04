
data	//data to store in the network
	var/name = "data"
	var/content = ""

	var/hash = ""

	data_chip		//a portable data chip containing information, possible to
					//modify and turn into advanced viruses
	record
		var
			last_seen
			current_mission

			agency

			authorization

			fingerprint
			wname
			version = 1

	program
		var/kind = ""

		firmware
			var/protocol_code = ""

	activity		//bought/sold activity
	dispatches
	mission_debriefs

//authorization for computer
//codes for network




//to confirm identity it takes your card
//if the codes are on your card it reads them, if not you must
//enter codes
//having records inside an agency of you will make them think you
//belong to that agency

//pickpocket ID cards much easier
//codes to networks and keypads/security around the agency are given to corresponding
//agents on their ID card. knocking out somebody will allow you to look at ID cards and
//if you have a camera take a picture of the card to copy it later
//then the enemy reads the codes and uses them to hack the database
//when your caught accessing the database and you used codes, codes change
//fingerprints trace your real name unless using special glove
//all players will have an ID number identical to their NAME
//all IDs have a version variable, increasing this makes all less versions void
//only the person whos true name matches the name on the card can increase versions
//at a price though. this prevents enemy agents from running around stealing your identity
//each mob has original identification number, and is represented on the card
//the number on the card is run through the database to find any matching records for
//authentication. the data on the card is compared with the records

//



//////////Identification
























