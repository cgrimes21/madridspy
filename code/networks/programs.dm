
data	//data to store in the network
	var/name = "data"
	var/content = ""

	var/hash = ""

	data_chip		//a portable data chip containing information, possible to
					//modify and turn into advanced viruses
		var/list/entries = list()

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

	bank_account

		var
			uname
			id
			pass
			balance
			loan
			list/statements = list()