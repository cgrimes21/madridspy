////////////////////
//
// A list of procedures and pre-defines constants
//
// File created by cody grimes, april 25th 2010
//
//NSimSun is a great font
///////////////////

obj
	li
		three
			icon = 'light3.png'
			layer = OBJ_LAYER + 3
		two
			icon = 'light2.png'
			layer = OBJ_LAYER + 2
		one
			icon = 'light1.png'
			layer = OBJ_LAYER + 1

turf/addedd
	icon ='neww.dmi'
	tile
		icon_state = "tile"


mob/agent
	osbert
		real_name = "osbert"
		agency = 2
		ragency  = 2
	bana
		real_name = "bana"
		agency = 2
		ragency = 2
	rickochet
		real_name = "richochet"
		agency = 1
		ragency = 1
	bobbi
		real_name = "bobbi"
		agency = 1
		ragency = 1

var
	ed =  0	//world needs to finish first
	wlog

	oop 	//order of 'operations', what comes first?

world
	hub = "suicideshifter.hell"
	hub_password = "oQc7XOH0uZFRZevK"
	status = "Public Test!"
	mob = /mob/agent
	turf = /turf/grass
	tick_lag=1
	icon_size = 32


	Del()
		oop<<"World/Del()"
		wlog<<"[get_time()] deleting world"
		..()
	New()
	//use savefiles as ban holders.
	//if fexists players/banned/computerid/[src.computer_id]
	//if fexists players/banned/ckey/[copytext first letter]/[src.ckey
	//if fexists players/banned/address/src.client.address
		ris_code = pick("al","bo","trey","penske")

		if(fexists("logs/session_oops.txt"))
			fdel("logs/session_oops.txt")
		if(fexists("logs/[time2text(world.realtime,"YYYY_MM_DD")].html"))
			fdel("logs/[time2text(world.realtime,"YYYY_MM_DD")].html")

		wlog = file("logs/[time2text(world.realtime,"YYYY_MM_DD")].html")
		oop = file("logs/session_oops.txt")

		oop << "Calling world/New()"
		wlog<<{"<span style='font-family:"Microsoft Sans Serif"'>"}
		wlog<<"<table border=2 color=black>"

		wlog<<"[get_time()] -world/new()- World initializing."

		create_names()
		wlog<<"[get_time()] -world/new()- Created names, as follows: [list2params(gen_names)]"

		var/b = world.realtime/10/60/60/24
		var/r = b-revstart
		//r = how many days
		rev = r/15.42		//every 5.42 days, there is 1 revolution
		generate_market_list()
		wlog<<"[get_time()] -world/new()- year calculated; [rev]."
//		initialize_sql_database()

//		generate_networks()

		initialize_networks()

		initialize_section_lists()			//initialize each section and their economic shifts

		world.log = file("LOG.txt")

		load_light()

		spawn(20)	//give the world a time to finish the above procs
			main_loop()






		//replace new() procs with load() procs, and call the load here after things are done

/*
243
237
228

rbg values for original output box
*/

//Constants
mob/verb/get_window_poss()
	set hidden = 1
	world<<winget(src, "infowindow","pos")
	world<<winget(src,"m_output","pos")
	world<<winget(src,"stats","pos")
	world<<winget(src, "equipmentwindow","pos")
	world<<"---"

	world<<winget(src,"equipmentwindow","size")


mob/verb/alter_perception()
	src.client.dir = pick(NORTH,SOUTH,EAST,WEST)
#define DEBUG

#define TILE_WIDTH 32
#define TILE_HEIGHT 32
#define MAX_VIEW_TILES 800
#define floorit(x) round(x)
#define ceil(x) (-round(-x))


#define CELLRATE 0.002		//percent load taken from a cell per second (load of 100 watts, -.2 units/s giving the cell life 8.3 mins)
#define CELLCHARGE 0.001	//percent charge per second

#define min_freq 2.2
#define max_freq 18.8	//min and max frequencies available

//////////options for atoms (put these in their flags variable)
//agencies, each agency has different special missions and different technology
//////////////////////////////////////////////
//
//Office of Strategic Services (OSS)
//Ritter Intelligence Service
//Foreign Office in Bern
//Jalbout Embassy (special)
//National Security Agency (most secretive and most protective, specializes in technology)
//
//////////////////////////////////////////////


#define OSS 1
#define RIS 2
#define FOB 3
#define NSA 4
#define JE 	5		//special
#define FL	6		//freelancer, their records cannot be seen either.
#define CV	0		//civilian, there is no way to edit/see civilian records. this is where undercovers are hidden




#define HEAD 		1				//equips to your head
#define CHEST 		2
#define LEFT_HAND 	3
#define RIGHT_HAND 	4
//#define PANTS 		5
#define SUIT		5

#define SLEEVE		7		//hide 1 pound items in your sleeve
#define BOOT		8		//hide 1 pound items in your boot
#define BELT		9		//equip belts for more space (+4 pounds)
#define MASK		10
#define BSLOT		11		//boot slot
#define IDSLOT		12
#define BACK		14
#define GLOVE		15


//models of weapons
//hand guns
#define magnum		1
#define revolver	2
#define coltapc		3
#define deserteagle	4

//snipers
#define r700		5
#define m40a3		6
#define barrett		7
#define m21			8

//sub machines
#define mac			9
#define mp5			10
#define p90			11

//mob stats
//#define


#define MAX_WEIGHT 	10		//10 pounds in weight (10 small items each being 1 pnd)

//object status, exception is FPRINT
#define WINDOW		16
#define WATER		32
#define INV_LIGHT 	64		//never meant to be seen
#define LIGHT 		128			//it is a light
#define FPRINT 		256			//if this is in the flags, it takes fingerprints
#define TABLEP		512		//the item can be put on a table


#define INBELT		1024	//item can be put in belt
#define INBOOT		2048	//can be put in boot
#define INSLEEVE	4096	//can be put in sleeve


#define SAVE_VERSION 1



#define int #define

//a mobs 'status', found in src.flags
int DEAD 		2
int STUNNED		4
int BLINDED		8
int BLACKOUT	16
int STUCK		32
int GRABBED		64
int HANDCUFFED	128
//dont use FPRINT because that applies to all
int PULLED		512
int CANTMOVE	1024
int GRABBING	2048
int BIOL		4096	//are they a biological life form or robot?






//turf types
int turf_type_trap		1	//is it a trap?
int turf_type_trigger	2	//does it trigger anything?
int turf_type_waypoint	4	//for mission
int turf_type_barrier	8	//a special barrier


//Effect types for special skills/objects
int duration_type_instant	0
int duration_type_temporary 1
int duration_type_permanent	2

int effect_type_invalid			0
int effect_type_regenerate		1
int effect_type_deaf			2
int effect_type_ressurect		3
int effect_type_immunity		4
int effect_type_area_of_effect	5
int effect_type_movement_speed	6
int effect_type_stun			7
int effect_type_poison			8
int effect_type_slow			9
int effect_type_snipe_increase	10
int effect_type_invisibility	11
int effect_type_disguise		12
int effect_type_see_invisible	13
int effect_type_blind			14
int effect_type_xray			15
int effect_type_thermal			16
//int effect_type_

//Item properties
//Item properties are in effect as long as you have the item worn.
//if item property is activate_item you need to activate the item and then
//it will read off effect_types
//
//item property constants are passive



//int item_property_
int item_property_trap					1
int item_property_damage_resistance		2
int item_property_damage_reduction		3
int item_property_attack_penalty		4
int item_property_attack_increase		5
int item_property_weapon_increase		6
int item_property_damage_vulnerability	7
int item_property_immunity				8
int item_property_regenerate			9
int item_property_freedom_of_movement	10	//overcome binds and handcuffs
int item_property_activate_item			11


//Object types
int object_type_item			1
int object_type_door			2
int object_type_area_of_effect	4
int object_type_waypoint		8	 	//for missions

//Damage types
int damage_type_bludgeon	1		//brute force

/*
bludgeon
if has protection, 75% chance of being protected, 20% chance of being hit
25% chance of calling prob(src.force)
	if called, has chance of 60% of being knocked out, 10% chance of being knocked over, 30% chance of being stunned



bludgeon has 75% chance of hitting with helmet with bludgeon protection on top of 20% taking a hit
	example:
	if(prob(75))
		if(prob(20))
			you take damage
		else
			you are protected
		return
bludgeon then has prob(src.force) of stunning if failed to block or get hit
var/time=rand(10,120)
if(prob(90))
	if(src.ko < time)
		src.ko = time
else
	stun them
	if(src.stun < time)
		src.stun = time
if intent is kill, harm them


warps (recall chits)
smoke bombs - throwable
scope - movement of vision
container - shifts into anything
cloak field  - cloaks in a 1-3 tile range. dragable
radio
tranquilizer dart
knife
poison sniper (only useable at long range/rooftop?)
shifter - shifts you/anything into any image
emp - disrupts security/devices
signal jammer - jams all devices run on frequency within range

Security -


*/
int damage_type_piercing	2		//bullet
int damage_type_slash		4		//knife
int damage_type_electric	8
int damage_type_fire		16
int damage_type_poison		32
int damage_type_chemical	64


//Mission waypoints
int mission_waypoint_begin_01	1




//Visual Effects (VFX)
int vfx_none			-1


int vfx_electricity		1000
int vfx_smoke			1001
int vfx_water			1002


//special abilities
int special_ability_camo		1


//AI business
int rep_type_friendly		0
int rep_type_enemy			1
int rep_type_nuetral		2

int perception_type_seen_and_heard				0
int perception_type_not_seen_and_not_heard		1
int perception_type_heard_and_not_seen			2
int perception_type_seen_and_not_heard			3
int perception_type_not_heard					4
int perception_type_heard						5
int perception_type_not_seen					6
int perception_type_seen						7

int inventory_disturb_add		0
int inventory_disturb_remove	1
int inventory_disturb_stolen	2

//int projectile_path_

int trap_type_stun_minor	0


int AI_CASUAL_EVENT					0
int AI_CHANGED_DOOR_BROKEN			1
int AI_CHANGED_DOOR_OPENING			2
int AI_CHANGED_BROKEN_OBJECT		3
int AI_CHANGED_BROKEN_CAMERA		4
int AI_CHANGED_DEAD					5
int AI_CHANGED_FLYING_OBJECT		6
int AI_CHANGED_GRENADE				7
int AI_CHANGED_LIGHT_OUT			8
int AI_CHANGED_LIGHT_SWITCHED		9
int AI_CHANGED_MALFUNCTIONING		10
int AI_CHANGED_UNCONSCIOUS			11
int AI_CHANGED_WALLMINE				12
int AI_CHANGED_FOG					13
int AI_CHANGED_OBJECT				14
int AI_CHANGED_DEVICE_ON			15
int AI_CHANGED_DEVICE_OFF			16
int AI_CHANGED_DEVICE_HACKED		17
int AI_CHANGED_TURRET				18
int AI_CHANGED_DOOR_OPENED			19

//VALUES THE AI HAVE
int AI_DEAD							1
int AI_UNCONSIOUS					2
int AI_DESTINATION_OCCUPIED			3
int AI_ENEMY_CHANGED				4
int AI_ENEMY_DEAD					5
int AI_FOUND_DEAD_BODY				6
int AI_GOAL_COMPLETE				7
int AI_GOAL_FAIL					8
int AI_REACHED_ALARM				9
int AI_GRABBED						10
int AI_HEAR_ALARM					11
int AI_HEAR_BIG_SHATTER				12
int AI_HEAR_DISFUNCTION				13
int AI_HEAR_DOOR					14
int AI_HEAR_EXPLOSION				15
int AI_HEAR_FIRE_ALARM				16
int AI_HEAR_GRENADE					17
int AI_HEAR_GUNFIRE					18
int AI_HEAR_GUN_RELOAD				19
int AI_HEAR_WHISTLE					20
int AI_HEAR_HEAVY_FOOTSTEP			21
int AI_HEAR_OBJECT					22
int AI_HEAR_OTHER_ENEMY				23
int AI_HEAR_QUIET_FOOTSTEP			24
int AI_HEAR_RICOCHET				25
int AI_HEAR_SCREAM					26
int AI_HEAR_SMALL_SHATTER			27
int AI_HEAR_LITTLE_VOICE			28
int AI_HEAR_VOICE					29
int AI_HEAR_SHOUT					30
int AI_HEAR_WHISPER					31
int AI_HELP_REQUEST					32
int AI_CONTINUE_PATROL				42


int AI_NEED_RELOAD					33
int AI_SEE_ENEMY_ALERT				34
int AI_SEE_ENEMY_BARELY				35
int AI_SEE_ENEMY_PARTIALLY			36
int AI_SEE_ENEMY_MOSTLY				37
int AI_STOP_FOLLOW					38
int AI_SWITCH_ALARM					39

int AI_SCAN_AREA					40	//scans areas of suspicion
int AI_WAIT							41
//43
int AI_HOSTILE_SCAN					43	//scans area of predicted enemy location very cautiously
int AI_HOSTILE_ATTACK_AREA			44	//blatantly fires in the area predicted to be enemy location


//layers

//int layer_area			1
//int layer_turf			2
int layer_table				2.5
//int layer_obj				3
int layer_corpse			3.4
int layer_bed				3.5
//int layer_mob				4
int layer_weapon			4.5
int layer_rhand_overlay 	5
int layer_light				6
int layer_tree				9
int layer_smoke				991
int layer_roof				992
int layer_mob_on_roof		993




//Todo
//cant create new user Pen with Penkovskiy as taken name

//procedures
//modified 2/3/11 added
//deactivate turrets, gas_room

proc

	get_time()
		return "<tr><td>[time2text(world.timeofday, "MM/DD hh:mm:ss")]</td><td>"

	applyeffect(atom/who, kind, duration)

	deactivate_turrets(stag = "")
		//deactivates all turrets within the world with a tag of arg
	gas_room(stag = "")
		//a tag of vents to release gas, kills all biologicals within a 2-5m range



	switch_view()

	available_sides()	//returns which sides are available for play, value of zero means both are available
		var/riss = 0
		var/osss = 0

		for(var/mob/agent/a in world)
			if(a.ragency == RIS)
				riss ++
			if(a.ragency == OSS)
				osss ++
		//find which one is bigger

		if(riss<osss)	//if more players are in oss, ris is available
			return RIS
		if(riss>osss)	//opposite
			return OSS
		if(riss==osss)
			return 0	//both are available

	FetchAgencyName(side)
		if(!side)
			return

		if(isnum(side))
			switch(side)
				if(OSS)
					.="Office of Strategic Services"
				if(RIS)
					.="Ritter Intelligence Service"
				if(FOB)
					.="Foreign Office in Bern"
				if(NSA)
					.="National Security Agency"
				if(JE)
					.="Jalbout Embassy"
				if(FL)
					.="Freelancer"
				if(CV)
					.="Civilian"
		else
			//its a name
			switch(side)
				if(OSS)
					.="Office of Strategic Services"
				if("Ritter Intelligence Service")
					.=RIS
				if("Foreign Office in Bern")
					.=FOB
				if("National Security Agency")
					.=NSA
				if("Jalbout Embassy")
					.=JE
				if("Freelancer")
					.=FL
				if("Civilian")
					.=CV
		return

obj
	overlays
		layer = layer_weapon
		var/olayer = layer_weapon

		pistol_overlay
			icon = 'pistol_overlay.dmi'
			layer = layer_weapon
			name = "pistol_overlay"
		sniper_overlay
			icon = 'sniper_overlay.dmi'
			layer = layer_weapon
			name = "sniper_overlay"


		machinegun_overlay


var
	obj/overlays/pistol_overlay/PISTOL_OVERLAY		 = new()//'pistol_overlay.dmi',layer=MOB_LAYER+1)
	obj/overlays/sniper_overlay/SNIPER_OVERLAY		 = new()//'sniper_overlay.dmi',layer=MOB_LAYER+1)
	obj/overlays/machinegun_overlay/MACHINEGUN_OVERLAY	 = new()

	image/explosion				 = new('explode.dmi',icon_state = "bright",layer=999)
	image/smokeblank			 = new('effects.dmi',icon_state="smoke2blank",layer=layer_smoke)
	image/smoke					 = new('effects.dmi',icon_state="smoke2",layer=layer_smoke)


	version = 1.12

	used_names = file("used_names.txt")
	list/niu = list()	//Names In Use

	ris_code = "no"
	rev = 0
	revstart = 3431.42//3924.42

	log_on = 0	//is it recording logs?
	logs = file("logs/")

	closed = 2		//closed testing, 2 is open, 1 is restricted (list), 0 is closed
	list/authorized = list("suicideshifter","demon27933","smokeyjoe","lordian","zinned","receptionist")
	list/guides = list()
	list/cardinal = list( NORTH, SOUTH, EAST, WEST)
	list/banned = list()//"nadrew")	//nadrew is a fucker
	list/alphabet = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o",
						"p","q","r","s","t","u","v","w","x","y","z")
	list/debuggers = list()
	list/gen_names = list()

	list/rankers = list()
	mob/agent/topgun


	list/guns = list(

	magnum = ".45 Magnum",
	revolver = ".357 Revolver",
	coltapc = ".45 Colt APC",
	deserteagle = "Desert Eagle",
	r700 = "R700 Bolt Action",
	m40a3 = "M40A3 Bolt Action",
	barrett = "Barrett Semi Automatic",
	m21 = "M21 Semi Automatic",
	mac = "Mac 11",
	mp5 = "Mp5",
	p90 = "P90")


	/**************
	Important Lists
	***************/
	records = list(
1 = list(name = "rat", agency=3, current_mission="", fingerprint="",last_seen="",version=1,ckey=""),
				  )



	passport = "14c9ddf46e1d77a7"

	ticker = 0
	night = 0		//0 for day, 1 for night







proc
	main_loop()
		wlog<<"[get_time()] -world/new()- World main loop initializing, now authorized for logins"
		ed = 1
		while(world)
			sleep(10)
			rankers = list()
			for(var/mob/agent/a in world)
				if(a.client)

					if(!topgun)
						topgun = a
					else
						if(a.kills > topgun.kills)
							topgun = a
					if(topgun)
						if(topgun != a)
							rankers += a


			ticker ++
/*day night broke it
			if(!(ticker % (60*120)))
				if(night)
					day(1)
				else
					day(0)
*/


			for(var/mob/M in world)
				if(istype(M,/mob))
					M.process()
			for(var/obj/cabinet/c in world)
				if(istype(c))
					c.process()


			for(var/obj/playtest/security_turret/t in world)
				if(istype(t,/obj/playtest/security_turret))
					t.process()


			for(var/obj/small/v in world)
				if(istype(v,/obj/small))
					if(v.loc)				//dont do this for things inside the market list
						v.process()

			if(!(ticker % 260))	//~ 4 mins
				garbage_collect()


			if(!(ticker % 6))

				for(var/mob/M in world)
					if(istype(M,/mob))
						M.med_tickle()
				for(var/obj/vendors/v in world)
					if(istype(v,/obj/vendors))
						v.process()
			if(!(ticker % 10))
				dwindle()
				//Controls market flow

			if(!(ticker % 12))
				for(var/mob/M in world)
					if(istype(M,/mob))
						M.slow_tickle()
				for(var/obj/small/ss in world)
					if(istype(ss,/obj/small))
						ss.slow_tickle()
				for(var/obj/other/light/l in world)
					l.slow_tickle()

	garbage_collect()
		for(var/obj/small/o in world)
			if(isturf(o.loc))
				if(!o.owned)
					if(!o.indestructable)
						if(istype(o, /obj/small/id_card))
							game_del(o)

		debuggers<<"garbage collected"

	play_ambience(mob/a)
		if(!istype(a, /mob))
			return

		if(!a.music)
			a<<sound(null,0,1,1)
			a.amb = 0
			return
		a.amb = 1
		//if(rand(1,3) == 2)
		a<<sound('Background Music.ogg',0,1,1,75)
		//a<<sound('ambigen5.ogg',0,1,1)
		//a<<sound('ambigen6.ogg',0,1,1)
		//a<<sound('ambigen7.ogg',0,1,1)
		//if(rand(1,3) == 2)

		a<<sound('Background Music 2.ogg',0,1,1,75)
	//	a<<sound('ambigen8.ogg',0,1,1)
	//	a<<sound('ambigen9.ogg',0,1,1)
	//	a<<sound('ambigen10.ogg',0,1,1)
	//	a<<sound('ambigen11.ogg',0,1,1)
	//	a<<sound('ambigen12.ogg',0,1,1)

		spawn(1200)//spawn(1950)
			if(a)
				play_ambience(a)


	play_music(mob/a,sound,self = 1,repeat = 1)
		if(!istype(a, /mob))
			return

		if(!a.music)
			return

		if(self)
			a<<sound(sound,repeat,0,1)
		else
			for(var/mob/M in view(a))
				if(M.sound == "false")
					continue

				if(M.current_sound != sound)	// i did this to prevent playing same assult music
												//every time they got stressed
					M<<sound(sound,repeat,0,1)
					M.current_sound = sound
					spawn(2400)	//if after 4 minutes the song still playing, get rid of it
						if(M)
							if(M.current_sound == sound)
								M<<sound(null,0,0,1)



	play_sound(mob/a,turf/where, sound,self = 1)
		if(!a && self==1)
			return
		if(!istype(a, /mob) && (self == 1))
			return
			//only play to a mob	if self is 1



		if(self)
			if(!a.sound)
				return
			a<<sound(sound,0,0,5)
		else
			var/atom/wha
			if(a)
				wha = a
			else if(where)
				wha = where
			if(!wha)
				return
			//play from a mob by default, if no mob play from location
			for(var/mob/M in viewers(wha))
				if(!M.sound)
					continue
				var/sound/s = sound(sound,0,0,5)
				if(where)
					s.x = (where.x-M.x)
					s.y = (where.y-M.y)
					s.z = (where.z-M.z)
				M<<s


	create_names()
		var/co = file2text('names.txt')
		oop<<"proc/create_names()"

		for(var/v = 20, v>1, v--)

			var/a = copytext(co,1,findtext(co,"\n"))
			gen_names += a


			co = copytext(co, findtext(co, a)+length(a)+1)
			if(!co) break

	game_del(atom/a)
		if(!a)
			return

		var/list/built_in = list("type","parent_type","gender","verbs","vars","group", "locs")
		for(var/v in a.vars)
			if(!(v in built_in))
				a.vars[v] = null
		del a

/*
mob/verb/testlisterman()
	var/list/L = list("hap","kip","red","blue","yellow")
	var/one
	var/i = L.Find("yellow")
	if(i)
		world<<i
		world<<i % L.len + 1
		world<<10 % 10

		one = L[i % L.len + 1]	recycles through list if reaches end
	world<<one

*/