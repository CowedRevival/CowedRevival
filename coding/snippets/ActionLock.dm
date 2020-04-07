datum
    var/list/actionlock
    var/tmp/actiontime = 0

    proc/ActionLock(action="", duration=0)
        if(!action) return

        if(!actiontime) actiontime = world.time
        if(!actionlock) actionlock = list()
        else
        //Every time the proc is called, we run through the existing locks
        // to see if they've expired.  If any lock is precisely equal to
        // zero, we simply remove it entirely.
            var/time_since_last_action = (world.time-actiontime)
            if(time_since_last_action > 0)
                for(var/lock in actionlock)
                    var/lock_duration = actionlock[lock]
                    if(lock_duration > 0)
                        lock_duration -= time_since_last_action

                        //Prevent high negative numbers of action locks, but preserve
                        // negative floating point decimals between -1 and 0 so they
                        // will accrue against further actions.
                        if(lock_duration < 0)
                            lock_duration += round(abs(lock_duration))

                        //Remove locks from memory if they are now blank, but preserve
                        // all other locks (including decimals).
                        if(!lock_duration)
                            actionlock -= lock
                        else actionlock[lock] = lock_duration

        //Now that we've successfully run through all of the existing locks,
        // we can safely update the current action time.
        actiontime = world.time

        //If provided a list of locks instead of just a single lock
        if(istype(action,/list))
            //Confirm all locks are not set
            for(var/X in action) if(actionlock[X] > 0) return 1
            //If this point is reached, no locks are set; set all locks
            // to the duration (if the duration exists)
            if(duration) for(var/X in action) actionlock[X] += duration
        else //provided just one lock
            //Confirm the lock is not set
            if(actionlock[action] > 0) return 1

            //If the lock is not set, set it to the duration (if given a
            // duration)
            if(duration) actionlock[action] += duration
        return 0