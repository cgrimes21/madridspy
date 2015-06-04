obj/small
	flash_bomb
		body_loc = BELT || BSLOT || SLEEVE
		value = 320
		initial_value = 340
		sale_value = 30

		icon = 'objects.dmi'
		icon_state = "flash"
		weight=1

		proc/smoke(mob/who)
			for(var/atom/t in range(5,src))
				if(istype(t, /mob))
					var/mob/m = t
					if(!m.blinded)
						if(m == who)
							m<<"You were protected from a blinding flash."
						else
							m.blinded = rand(4,8)
				if(istype(t, /turf))
					var/turf/tt = t
					tt.flasher()







		throwend(mob/who)	//who threw
			src.smoke(who)
			game_del(src)
			return

		throwhit(mob/who)	///who threw
			src.smoke(who)
			game_del(src)
			return

	bomb
		body_loc = BELT || BSLOT || SLEEVE
		value = 350
		initial_value = 350
		sale_value = 30

		icon = 'objects.dmi'
		icon_state = "flash"
		weight=1

		proc/smoke(mob/who)
			for(var/atom/t in range(1,src))
				if(istype(t, /area))
					continue
				if(istype(t, /mob))
					var/mob/mm = t
					mm.last_hostile = who

				play_sound(src,src.loc,'explode1.wav',0)
				t.explode()




		throwend(mob/who)	//who threw
			src.smoke(who)
			game_del(src)
			return

		throwhit(mob/who)	///who threw
			src.smoke(who)
			game_del(src)
			return

	smoke_bomb

		body_loc = BELT || BSLOT || SLEEVE
		value = 120
		initial_value = 120
		sale_value = 30

		icon = 'objects.dmi'
		icon_state = "flash"
		weight=1

		proc/smoke(mob/who)	//who set off the smoke
			play_sound(null,src,'sounds/three/smoke.ogg',0)
			create_smoke(src.loc,0,who)


		get_hit_self(mob/m)
			play_sound(m,m.loc,'sounds/three/smoke.ogg',0)
			create_smoke(m)	//follows you for now
			game_del(src)
			return


		throwend(mob/who)	//who threw
			src.smoke(who)
			game_del(src)
			return

		throwhit(mob/who)	///who threw
			src.smoke(who)
			game_del(src)
			return



