/*
 *	This is the sample game code.
 *	The tests are defined in Tests.dm.
 *	There are two tests: one for isValidName() and one for mob.teleport().
 *	Each proc is setup to fail so you can see how the test process works.
 *	The procs contain instructions for how to change them so they will succeed.
 */
proc/isValidName(name)
	/*
	 *	Don't allow names with spaces in them.
	 *	To force a test failure, the code lines are commented out.
	 *	To make the tests succeed, uncomment the lines.
	 */
//	if (findText(name, " "))
//		return 0
	return 1

mob
	Login()
		// Do they have a valid name?
		if (!isValidName(key))
			src << "Your name violates our naming guidelines. You need to change it!"

		// Move them away from edge of map on login.
		var/center_x = round(world.maxx / 2)
		var/center_y = round(world.maxy / 2)
		var/center = locate(center_x, center_y, 1)
		Move(center)
		return ..()

	verb/teleport(direction = "n" as null|anything in list("n", "s", "e", "w"), distance as num)
		var/new_x = x
		var/new_y = y

		// BUG: This is the wrong way to do it -- player can teleport off map to null.
		switch(direction)
			if ("n")	new_y = y + distance
			if ("s")	new_y = y - distance
			if ("e")	new_x = x + distance
			if ("w")	new_x = x - distance

/***
		// CORRECT: This is the right way to do it...use this code instead to have the test succeed.
		// The min/max checks keep us from moving off the map.
		switch(direction)
			if ("n")	new_y = min(y + distance, world.maxy)
			if ("s")	new_y = max(y - distance, 1)
			if ("e")	new_x = min(x + distance, world.maxx)
			if ("w")	new_x = max(x - distance, 1)
***/

		var/new_loc = locate(new_x, new_y, z)

		/*
		 *	We should use Move and make sure that new_loc equals something, just in case,
		 *	but we're a bad programmer here.  This means that if we don't use the commented
		 *	out code above, then the player can teleport themselves off the map to null, and
		 *	they end up in a black void.
		 */
		loc = new_loc

mob
	icon = 'hunter.dmi'

turf
	icon = 'ground.dmi'