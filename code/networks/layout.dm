lists:

List of all frequencies belonging to networks. There really should be 3 frequencies for each organizations network.
No frequency for LANs because they are local.

Computer_ids is a list containing all unique identifier codes (ip) of each type of computer, which will only be terminals and laptops.

network/computers is simply a list of identifiers of computers active on the network. Connecting a laptop to the server will add your
laptop id to this list.

active_users is simply the user name (as appears on authorization) logged into the system.


A network can be offline, disabled, and locked.It has a code to enter the network generally (terminals/laptops).
All these variables can be seperate in servers. A single server can be offline,disabled, and locked and requires authentication code
to gain access.

Lans have all the options a network has, can be offline, locked, and disabled. Also can require code to enter. A lan will have no frequency,
and only the computers listed in a lans computers list has access to the lan.

Navigation:
	To navigate through all this, it is set up as so.
	To find a network externally, search for frequency.
	When tuned into the networks frequency, you see a list of all computer ips
	Choose one and you will be located to that terminal.
	Access the terminals programs as you would if you were there, only your on your laptop.

	Lans.
		You will have to download a broadcasting program to broadcast the signal a few meters to hack within some safety.
		You can choose any terminal on the lan to download to, but you will only have access to that terminals lan servers. However
		it will be wireless, so you can hide somewhere close while hacking.

Terminals
	A terminal will have a network datum that relates to the network it is connected to. This is set at runtime
	and should never be tampered with by the program or user.

	A terminal has an auth variable, and if its zero, your kicked out of the system and back to square 1, the login page.
	When you access the terminal, it will open network.login to bring you to the choices.





	The login page:
		When you access a terminal for the first time, you will have some options:
			Authenticate
				-> gains access to specific servers
			Insert_Data
				-> insert a data chip
			Open_Program
				->	choose a program to run, if terminal has own programs it will show up on a list with
					whatever programs are on your data chip
