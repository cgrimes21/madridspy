obj/small/id_card
	icon = 'objects.dmi'
	icon_state = "id"
	var/written_name
	var/auth	//level of authorization
	var/agency
	var/nagency	//agency as a number
	var/occupation
	dropable = 1

	weight = 0
	set_desc()
		src.desc = "Name: [src.written_name]\nAgency: [FetchAgencyName(src.agency)]"//Authorization Access: [src.auth]"//Title: [src.occupation]"

	proc
		wear(mob/b)

			b<<"[src.written_name]'s ID card worn."
			b<<"You have taken on the name '[src.written_name]'."

		remove(mob/b)

			b<<"You are back to yourself again. You will most likely not have access anywhere."
/mob/agent/issue_card()
	var/obj/small/id_card/i = new(src)
	i.written_name = src.real_name
	i.agency = src.ragency
	i.suffix = "[i.written_name]"
	//i.desc = "Name: [i.written_name]\nAgency: [FetchAgencyName(i.agency)]"

	i.set_desc()// = "Name: [i.written_name]\nAgency: [i.agency]\nAuthorization Access: 0\nTitle: none"

	src.w_id = i	//put it on
	src.refresh_clothings()
