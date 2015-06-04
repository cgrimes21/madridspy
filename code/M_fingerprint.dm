
atom/add_fingerprint(mob/M as mob)
	if(!istype(M, /mob))
		return
	if(!( src.flags ) & FPRINT)			//this cant be fingerprinted
		return
	//check if mob is wearing gloves


	if(!src.fingerprints)	//nobodys touched yet
		src.fingerprints = "[md5(M.real_name + "fp")]"		//whoever their IDed as they will leave their fp
	else
		var/list/L = params2list(src.fingerprints)
		L -= md5(M.real_name + "fp")
		while(L.len >= 3)
			L -= L[1]
		L += md5(M.real_name + "fp")
		src.fingerprints = list2params(L)
	return
