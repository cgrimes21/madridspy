obj
	small
		DblClick(l)
			if(l=="vendor")
				if(usr.is_Binded(1))
					return
				if(src.min_rank > usr.rank)
					usr<<"You must have a minimum of rank [src.min_rank] to use this!"
					return


				if(src && (!(src.owned)))

					var/atom/t = src.loc

					if(istype(t, /obj))

						var/obj/vendors/v = t

						if(src.value <= usr.money)

							if(get_dist(v, usr) <= 1)
								if(usr.check_weight() > MAX_WEIGHT)
									usr<<"You cannot carry any more."
									return
								usr<<"You purchase the [src.name]."
								var/mob/agent/a = usr

								if(!src)
									return
								if(!t)
									return
								if(!(src in t))
									return

								a.money -= src.value
								increase_sell_rate(src)
								src.owned = TRUE
								src.Move(a)
								a.recalc_stats()
						else
							usr<<"You don't have enough money for the transaction."
							return




		proc/get_desc(l,ct,mob/m)
			..()
			var/head = "\n<b>\icon[src] [src.name]</b>[src.suffix ? "	\blue ([src.suffix])" : ""]\n</font>"
			var/e
			if(src.protected)
				e += "<font color=[rgb(0,136,0)]>This item is protected.</font>\n"
			if(src.mdura)
				e += "Durability: [src.dura==src.mdura ? "[src.dura]" : "[src.dura]/[src.mdura]"]\n"
			if(src.passive)
				e += "This item must be carried to be effective.\n"
			if(src.desc)
				e += "[src.desc]\n"
			for(var/v in src.vars)
				switch(v)
					if("damage")
						if(src.vars[v]!=null)
							e += "Damage: [src.vars[v]]\n"
					if("range")
						if(src.vars[v]!=null)
							e += "Range: [src.vars[v]]\n"
					if("modifiers")
						if(src.vars[v]!=null)
							for(var/t in src.vars[v])
								e += "Effect: [t] [src.vars[v][t]>0 ? "+" : "-"] [src.vars[v][t]]\n"
					if("effects")
						if(src.vars[v]!=null)
							for(var/t in src.vars[v])
								e += "Effect: [t] [src.vars[v][t]>0 ? "+" : "-"] [src.vars[v][t]]\n"
					if("delay")
						if(src.vars[v]!=null)
							e += "Delay: [(src.vars[v] * 0.1)]\n"
					if("reload")
						if(src.vars[v]!=null)
							e += "Reload time: [(src.vars[v] * 0.1)]\n"
					if("clip")
						if(src.vars[v]!=null)
							e += "Clip: [src.vars["in_chamber"]!=null ? "[src.vars["in_chamber"]]" : ""]/[src.vars[v]]\n"
					if("noise")
						if(src.vars[v]!=null)
							e += "Noise level: [src.vars[v]]\n"
					if("poison")
						if(src.vars[v]!=null)
							e += "Poison: [src.vars[v]]\n"
					if("what")
						if(src.vars[v]!=null)
							e += "Warrants [src.vars[v]]s\n"
					//all they need to know is the time left, which is in the items suffix.
					//this is internals they dont need to see
					/*
					if("capacity")
						if(src.vars[v]!=null)
							e += "Cell capacity: [src.vars[v]]/100"
					*/
			if(l == "vendor")

				var/value = get_value(src)

				e += "[value<=usr.money ? "<font color=[rgb(51,153,102)]>" : "\red "]Price: [value]\n"
				//src.value = value //so we can easily refer to it in the dbl click, everytime they want to buy this will always be set

			if(istext(l))

				winset(m,"infowindow.itemdesc","max-lines=1")
				m<<output("~","infowindow.itemdesc")
				winset(m,"infowindow.itemdesc","max-lines=1000")
				m<<output("[head][e]","infowindow.itemdesc")

/*
		proc

			get()
				//hand=1 means right hand
				//set src in oview(1)
				//set category = null
				var/mob/who = usr
				if(who.is_Binded(1))
					return
				if(src.elevation != who.elevation)
					who<<"\blue [src.name] is out of reach!"
					return

				var/v = who.check_weight()
				if(v + who.weight > MAX_WEIGHT)
					who<<"You can't carry any more items."
					return
				else
					if(!src) return

					if(!(who in oview(1,src)))
						return

					if(who.rank < src.min_rank)
						who<<"You must have a minimum rank of [src.min_rank] to carry this item."
						return

					if(src.Move(who))

						src.pickup(who)
						who<<"You get the [src.name]."
			drop()
			//	set src in usr
			//	set category = null
				if(usr.is_Binded(1))
					return

				if(!src.dropable)
					usr<<"You can't drop this item."
					return

				if(!src) return
				if(!(src in usr)) return



				if(src.Move(usr.loc))

					src.dropped(usr)
					usr<<"You drop the [src.name]."

*/