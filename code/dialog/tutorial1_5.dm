dialog/page/tutorial1_5	//tutorial 1, part 2
	head = "mysterious figure"
	a

		body = {"
Before we move ahead, I want to warn you about security.
"}
	b
		body = {"
Security is a MAJOR part of any system/organization that you will encounter, especially with the recent move into the technology revolution.

There will generally be a computer terminal within each division of a corporation, interacting wirelessly with the security devices around it.
 "}

	c
		body = {"
These terminals control all security devices within that division (usually a small room) and will run 1 of 4 systems;

P-Logic v.1.1
Optika v.2.2
Jupiter v.3.4
Bridge v.4.3 - 5.0 beta

		"}
	d
		body = {"
Each system is only capable of certain abilities. A terminal runnning P-Logic for their security control will be easiest to hack and won't have \
 a lot of programs to interact with, while a terminal running Bridge will be the hardest to hack and will have the software capable of handling \
 advanced security nodes.
	"}

	e
		body = {"
Lets put that into terms you can relate to.

A terminal in cell B runs P-Logic (most basic system) to operate a camera and a security turret. Now in cell A you have a terminal that is running\
 Optika (a little better system). By running optika, cell A can now support ID scanning security devices.

The more advanced system a terminal is running, the higher developed security devices it can operate with.
			"}
	f
		body = {"
Later on I will describe in more detail the types of security devices available in todays corporations.

Right now I want you to hack the terminal just above you. Walk up to it and hit it with an open hand (left/right click).
			"}








dialog
	tutorial1_5
		can_close = 0
		cont = newlist(

/dialog/page/tutorial1_5/a,
/dialog/page/tutorial1_5/b,
/dialog/page/tutorial1_5/c,
/dialog/page/tutorial1_5/d,
/dialog/page/tutorial1_5/e,
/dialog/page/tutorial1_5/f



		)//,/dialog/page/tuto