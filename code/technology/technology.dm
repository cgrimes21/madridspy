/*These are simply concept technological designs that are going to be implemented into the game
at some point in time.



Biomechanics:

A biomechanical suit that contains chromatophoric cells which are stimulated by a central
processing unit that mimics the electrical signals sent from the brain to the stimuli of a
generic cephalopod.


Atom Reconstructor can restructure the physical bone structure of the face and body.


Other:

binoculars
lockpicks

disintegrate - completely become invisible only within the darkest shadows.
*/
obj
	jeep
		icon = 'jeep.dmi'
		density = 1


obj/small/memory_flash
	icon = 'shit.dmi'
	var/uses = 5
	var/des = "Wipes out near-by agent's recent memories. WARNING: This will wipe your memory too unless\
	 you have the proper equipment."
	set_desc()
		src.desc = "[src.des]\nContains [uses] uses."
	verb/flash()


		uses--
		src.set_desc()
		for(var/mob/agent/p in view(usr))
			winset(p, "outputwindow.output", "max-lines=1")
			p<<"\blue You seem to lose grasp on your recent memory."
			winset(p,"outputwindow.output","max-lines=1000")
		if(!uses)
			usr<<"The memory flasher was used up."
			game_del(src)
			return
obj/small/lock_pick
	icon_state = "lock_pick"
	icon = 'lock_pick.dmi'
	desc = "A simple device used to pick a wide variety of locks. Simply hold the item and click a door, or press C."
	value = 50
	initial_value = 50
	dura = 100
	mdura = 100
	sale_value = 27
	range = 1
	body_loc = SLEEVE || BSLOT || BELT



obj/small/optic_cam
/*
mob/var/atom/creating
mob/verb
	create_wall()
		usr.creating = /turf/wall
	create_floor()
		usr.creating = /turf/floor2
	create_grass()
		usr.creating = /turf/grass
	create_door()
		usr.creating = /obj/door
	create_light()
		usr.creating = /obj/other/light



turf/Click()
	new usr.creating (src)
turf/MouseDrag(a,b,s)
	new usr.creating (s)

#define DMP_IGNORE_AREAS 1
#define DMP_IGNORE_TURFS 2
#define DMP_IGNORE_OBJS 4
#define DMP_IGNORE_NPCS 8
#define DMP_IGNORE_PLAYERS 16
#define DMP_IGNORE_MOBS 24
dmp_writer{
	/*
		/dmp_writer version 1.4.1
			Released February 8th, 2007.

		defines the object /dmp_writer
			- provides the public method write_dmp()
				- Returns a text string of the map in dmp format
					ready for output to a file.
			- provides the public method save_map()
				- Returns a .dmp file if map is saved
				- Returns FALSE if map fails to save

		The /dmp_writer approximates DM's map saving process in order to allow dynamic map
		saving.	To save a map at runtime, create an instance of /dmp_writer, and then call
		write_map(), which accepts three arguments:
			- A turf representing one corner of a three dimensional grid (Required).
			- Another turf representing the other corner of the same grid (Required).
			- Any, or a combination, of several bit flags (Optional, see documentation).

		The order in which the turfs are supplied does not matter, the /dmp_writer will
		determine the grid containing both, in much the same way as DM's block() function.
		write_map() will then return a string representing the saved map in dmp format;
		this string can then be saved to a file, or used for any other purose.
		*/
	var{
		quote = "\""
		list/letter_digits = list(
			"a","b","c","d","e",
			"f","g","h","i","j",
			"k","l","m","n","o",
			"p","q","r","s","t",
			"u","v","w","x","y",
			"z",
			"A","B","C","D","E",
			"F","G","H","I","J",
			"K","L","M","N","O",
			"P","Q","R","S","T",
			"U","V","W","X","Y",
			"Z"
			)
		}
	verb{
		save_map(var/turf/t1 as turf, var/turf/t2 as turf, var/map_name as text, var/flags as num){
			//Check for illegal characters in file name... in a cheap way.
			if(!((ckeyEx(map_name)==map_name) && ckeyEx(map_name))){
				CRASH("Invalid text supplied to proc save_map, invalid characters or empty string.")
				}
			//Check for valid turfs.
			if(!isturf(t1) || !isturf(t2)){
				CRASH("Invalid arguments supplied to proc save_map, arguments were not turfs.")
				}
			var/file_text = write_dmp(t1,t2,flags)
			if(fexists("[map_name].dmp")){
				fdel("[map_name].dmp")
				}
			var/saved_map = file("[map_name].dmp")
			saved_map << file_text
			return saved_map
			}
		write_dmp(var/turf/t1 as turf, var/turf/t2 as turf, var/flags as num){
			//Check for valid turfs.
			if(!isturf(t1) || !isturf(t2)){
				CRASH("Invalid arguments supplied to proc write_dmp, arguments were not turfs.")
				}
			var/turf/nw = locate(min(t1.x,t2.x),max(t1.y,t2.y),min(t1.z,t2.z))
			var/turf/se = locate(max(t1.x,t2.x),min(t1.y,t2.y),max(t1.z,t2.z))
			var/list/templates[0]
			var/template_buffer = {""}
			var/dmp_text = {""}
			for(var/pos_z=nw.z;pos_z<=se.z;pos_z++){
				for(var/pos_y=nw.y;pos_y>=se.y;pos_y--){
					for(var/pos_x=nw.x;pos_x<=se.x;pos_x++){
						var/turf/test_turf = locate(pos_x,pos_y,pos_z)
						var/test_template = make_template(test_turf, flags)
						var/template_number = templates.Find(test_template)
						if(!template_number){
							templates.Add(test_template)
							template_number = templates.len
							}
						template_buffer += "[template_number],"
						}
					template_buffer += ";"
					}
				template_buffer += "."
				}
			var/key_length = round/*floor*/(log(letter_digits.len,templates.len-1)+1)
			var/list/keys[templates.len]
			for(var/key_pos=1;key_pos<=templates.len;key_pos++){
				keys[key_pos] = get_model_key(key_pos,key_length)
				dmp_text += {""[keys[key_pos]]" = ([templates[key_pos]])\n"}
				}
			var/z_level = 0
			for(var/z_pos=1;TRUE;z_pos=findtext(template_buffer,".",z_pos)+1){
				if(z_pos>=length(template_buffer)){break}
				if(z_level){dmp_text+={"\n"}}
				dmp_text += {"\n(1,1,[++z_level]) = {"\n"}
				var/z_block = copytext(template_buffer,z_pos,findtext(template_buffer,".",z_pos))
				for(var/y_pos=1;TRUE;y_pos=findtext(z_block,";",y_pos)+1){
					if(y_pos>=length(z_block)){break}
					var/y_block = copytext(z_block,y_pos,findtext(z_block,";",y_pos))
					for(var/x_pos=1;TRUE;x_pos=findtext(y_block,",",x_pos)+1){
						if(x_pos>=length(y_block)){break}
						var/x_block = copytext(y_block,x_pos,findtext(y_block,",",x_pos))
						var/key_number = text2num(x_block)
						var/temp_key = keys[key_number]
						dmp_text += temp_key
						sleep(-1)
						}
					dmp_text += {"\n"}
					sleep(-1)
					}
				dmp_text += {"\"}"}
				sleep(-1)
				}
			return dmp_text
			}
		}
	proc{
		make_template(var/turf/model as turf, var/flags as num){
			var/template = ""
			var/obj_template = ""
			var/mob_template = ""
			var/turf_template = ""
			if(!(flags & DMP_IGNORE_TURFS)){
				turf_template = "[model.type][check_attributes(model)],"
				} else{ turf_template = "[world.turf],"}
			var/area_template = ""
			if(!(flags & DMP_IGNORE_OBJS)){
				for(var/obj/O in model.contents){
					obj_template += "[O.type][check_attributes(O)],"
					}
				}
			for(var/mob/M in model.contents){
				if(M.client){
					if(!(flags & DMP_IGNORE_PLAYERS)){
						mob_template += "[M.type][check_attributes(M)],"
						}
					}
				else{
					if(!(flags & DMP_IGNORE_NPCS)){
						mob_template += "[M.type][check_attributes(M)],"
						}
					}
				}
			if(!(flags & DMP_IGNORE_AREAS)){
				var/area/m_area = model.loc
				area_template = "[m_area.type][check_attributes(m_area)]"
				} else{ area_template = "[world.area]"}
			template = "[obj_template][mob_template][turf_template][area_template]"
			return template
			}
		check_attributes(var/atom/A){
			var/attributes_text = {"{"}
			for(var/V in A.vars){
				sleep(-1)
				if((!issaved(A.vars[V])) || (A.vars[V]==initial(A.vars[V]))){continue}
				if(istext(A.vars[V])){
					attributes_text += {"[V] = "[A.vars[V]]""}
					}
				else if(isnum(A.vars[V])||ispath(A.vars[V])){
					attributes_text += {"[V] = [A.vars[V]]"}
					}
				else if(isicon(A.vars[V])||isfile(A.vars[V])){
					attributes_text += {"[V] = '[A.vars[V]]'"}
					}
				else{
					continue
					}
				if(attributes_text != {"{"}){
					attributes_text+={"; "}
					}
				}
			if(attributes_text=={"{"}){
				return
				}
			if(copytext(attributes_text, length(attributes_text)-1, 0) == {"; "}){
				attributes_text = copytext(attributes_text, 1, length(attributes_text)-1)
				}
			attributes_text += {"}"}
			return attributes_text
			}
		get_model_key(var/which as num, var/key_length as num){
			var/key = ""
			var/working_digit = which-1
			for(var/digit_pos=key_length;digit_pos>=1;digit_pos--){
				var/place_value = round/*floor*/(working_digit/(letter_digits.len**(digit_pos-1)))
				working_digit-=place_value*(letter_digits.len**(digit_pos-1))
				key = "[key][letter_digits[place_value+1]]"
				}
			return key
			}
		}
	}
mob/verb/savemap(var/map_name as text)
	/*
		The save() verb saves a map with name "[map_name].dmp".
		*/
	if((ckey(map_name) != lowertext(map_name)) || (!ckey(map_name)))
		usr << "The file name you supplied includes invalid characters, or is empty. Please supply a valid file name."
		return
	var/dmp_writer/D = new()
	var/turf/south_west_deep = locate(1,1,1)
	var/turf/north_east_shallow = locate(world.maxx,world.maxy,world.maxz)
	D.save_map(south_west_deep, north_east_shallow, map_name, flags = DMP_IGNORE_PLAYERS)
	usr << {"The file [map_name].dmp has been saved. It can be found in the same directly in which this library resides.\n\
 (Usually: C:\\Documents and Settings\\Your Name\\Application Data\\BYOND\\lib\\iainperegrine\\dmp_writer)"}
*/