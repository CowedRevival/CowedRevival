/*
 * This file shows an example of a simple test and a more complex test.
 * The isValidName() proc in Game.dm is set to fail, so you can see how a test failure
 * looks.  You can fix this by uncommenting the lines in Game.dm.
 *
 * Most tests are shorter than these -- often a test is no more than 3 lines -- but
 * these are verbose to help explain the process.
 */

obj/test/verb/isValidName_test()
	/*
	 * This tests isValidName(), to provide an example of a simple test.
	 * As shown above, the test needs to be a verb added to the obj/test class.
	 * In our game, the only name rule is that spaces in the name aren't allowed,
	 * so make sure names without spaces are accepted, and names with spaces don't
	 * get past.
	 */
	if (!isValidName("Deadron"))
		die("isValidName() didn't allow legal name: Deadron")

	if (isValidName("Deadron rulez"))
		die("isValidName() allowed illegal name: Deadron rulez")
	return

obj/test/verb/teleport_test()
	/*
	 * This is a more complex test, to check if our game's teleport
	 * verb works as expected. The teleport verb is defined below.
	 *
	 * There are two things to test here:
	 *
	 * 1) Does teleport work under normal circumstances?
	 *
	 * 2) If you try to move off the map, does it catch that and move you to the edge instead?
	 *
	 * To do this test, we'll create a mob and teleport him around a bit, then delete him.
	 * It should happen so fast that nothing will be visible to the players.
	 */
	var/error_message

	var/starting_loc = locate(5, 5, 1)
	var/mob/testmob = new(starting_loc)

	 // Are we where we think we are?  Might not be if we bumped into something.
	if (testmob.x != 5 || testmob.y != 5)
		error_message = "teleport_test() got wrong starting location: x: [testmob.x] y: [testmob.y]"
		goto error

	// Do a teleport to a real location and see if that works.
	// Let's move 2 to the left.
	testmob.teleport("w", 2)
	if (testmob.x != 3)
		error_message = "teleport() move west got x: [testmob.x] instead of expected x: 3"
		goto error

	// Let's make sure if we try to go off the edge, it puts us at the edge.
	testmob.teleport("w", world.maxx + 1)
	if (testmob.x != 1)
		error_message = "teleport() move off edge got x: [testmob.x] instead of expected x: 1"
		goto error

	// Using a label here so we only have to delete the mob and call die() in one place.
	error:
	del(testmob)
	if (error_message)
		die(error_message)
	return
