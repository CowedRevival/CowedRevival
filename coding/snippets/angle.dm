proc
	arctan(x)
		var/y=arcsin(x/sqrt(1+x*x))
		if(x>=0) return y
		return -y
/*	angle(atom/A,atom/B)
		if(!A||!B) return
		//get the x and y to the object
		var
			x=A.x-B.x
			y=A.y-B.y
		//if there is no y to the object (objects is directly above or below A)
		if(!y) return (x>=0)?90:270 //return angle for east/west depending on x

		//determine the raw angle to the object
		.=arctan(x/y)

		//the raw angle returns <=90 always. correct this issue with the code below
		if(y<0) .+=180
		else if(x<0) .+=360

		//the issue: (southeast/northwest or northeast) always fails to get the proper angle\
		correct this issue by determining the direction from A to B and compensating if it finds the proper direction
		var/dir=get_dir(A,B)
		if(dir==NORTHWEST||dir==SOUTHEAST)
			.+=180
			if(.>360) .=-.+360+360
			while(.>360) .-=90*/

proc/angle(atom/Ref,atom/Target)
	if(!Ref || !Target) return 0
	var/dx = ((Target.x*32) + Target.pixel_x - 16) - ((Ref.x*32) + Ref.pixel_x - 16)
	var/dy = ((Target.y*32) + Target.pixel_y - 16) - ((Ref.y*32) + Ref.pixel_y - 16)
	var/dev = sqrt(dx * dx + dy * dy)
	var/angle = 0
	if(dev > 0) angle = arccos(dy / sqrt(dx * dx + dy * dy))
	return (dx>=0) ? (angle) : (360-angle)