
icon
	proc/ChangeOpacity(opacity = 255.0)
		opacity = (opacity / 255)
		MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,opacity, 0,0,0,0)


obj/block
	mouse_opacity = 0
	icon = 'light.dmi'
	icon_state = "block"
obj/b_light
	icon = 'light.dmi'
	icon_state = "lbulb"


var
	list/shadows[][]

vector

	position
		var/X
		var/Y

world
	icon_size = 32
proc
	draw_light(obj/b_light/s)
		if(!shadows)
			shadows = new/list(world.maxx*4, world.maxy*4)

		var
			minx = ((s.x - 5)*4)-3
			miny = ((s.y - 5)*4)-3

			maxx = (s.x + 5)*4
			maxy = (s.y + 5)*4

			sourcex = (s.x*4)-2
			sourcey = (s.y*4)-2

			vector/position/dist = new

			shadow = 0


		for(var/num1 = minx, num1 <= maxx, num1++)
			for(var/num2 = miny, num2 <= maxy, num2++)

				dist.X = (sourcex - num1)
				dist.Y = (sourcey - num2)

				shadow = ((abs(dist.X + dist.Y))/2)*11.5
				shadow = round(shadow,1)
				shadow = max(0,min(255,shadow))



				shadows[num1][num2] = shadow





	draw_screen(mob/m)

		var
			minx = ((m.x - 5)*4)-3
			miny = ((m.y - 5)*4)-3

			maxx = (m.x + 10)*4
			maxy = (m.y + 10)*4

			x_l = 0
			y_l = 0
		//world<<"maxy = [maxy]"

		for(var/num1 = minx, num1 <= maxx, num1++)
			x_l += 1
			y_l = 0

			for(var/num2 = miny, num2 <= maxy, num2++)

			//	world<<"num2 - [num2]"
				y_l += 1

				draw_block(m, shadows[num1][num2], x_l, y_l)



	draw_block( mob/m, alpha = 0, x, y)
		var/obj/block/b = new
		b.layer = 50
		var/icon/I = new('light.dmi', "block")

		I.ChangeOpacity(alpha)

		b.icon = I

		var/num1 = 1//round(x/4) + 1
		var/num2 = 1//round(y/4) + 1


		//if(!(x % 4))

		//sleep(10)





		b.screen_loc = "[num1]:[x*8],[num2]:[y*8]"
		if(m)
			if(m.client)
				m.client.screen += b


