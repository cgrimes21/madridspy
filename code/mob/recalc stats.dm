mob
	proc/recalc_stats()	//recalculate stats


		//if(!src.icon)
		//	src.icon = 'agent.dmi'
		//src.overlays = null

		src.mhealth = 22
		var/pistol = 0	//only one pistol is concealed.
		src.pistol_out = 0
		src.machinegun_out = 0
		src.sniper_out = 0
/**********
System redone by Cody Grimes on 6/26/10
***********/

		var/obj/small/weapon/gun/g = locate() in src
		var/obj/small/clothing/c	= locate() in src
		var/obj/small/s				= locate() in src

		//lets scan for mods on clothes and weapons
		if( (s && s.modifiers.len && s.passive) || (c && c.modifiers.len) )
			//If found anything that changes your stats, lets set them to default now
			for(var/v in src.stats)
				src.stats[v] = 0
				//default stats are zero


		if(g && (g in src) && (!(g.invisibility)) )
			for(g in src)

				if(g.model <= 4)
					if(!pistol)			//first pistol? conceal it
						pistol = 1
					else				//already have a pistol out, reveal this
						src.pistol_out = 1
				if((g.model > 4) & (g.model <= 8))
					src.sniper_out = 1
			//	src.refresh_overlays()

		//any clothing found, reset stats
		if(c && (c in src) && (!(c.invisibility)) )


			for(c in src)
				if(c.worn)
					if(c.modifiers.len)

						for(var/t in c.modifiers)
							src.stats[t] += s.modifiers[t]
							if(t == "mhealth")
								src.mhealth += s.modifiers[t]
		if(s && (s in src) && (!(s.invisibility)) )
			for(s in src)
				if(s.modifiers.len && s.passive)
					//got to be passive, edit stats
					for(var/t in s.modifiers)
						src.stats[t] += s.modifiers[t]
						if(t == "mhealth")
							src.mhealth += s.modifiers[t]
		//src.refresh_overlays()