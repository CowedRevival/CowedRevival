var/computer/computer/computer = new
computer
	command
		var
			list
				strings
				allow_ranks
			priority = 0
			command_function = 1
		proc
			canInvoke(mob/M, msg, inview = 0)
			process(mob/M, msg, inview = 0)
			process_abort(mob/M, msg, inview = 0)
		localize_commands
			command_function = 0
			priority = 1
			strings = list(list("localize", "localization"), list("command"), list("functions"))
			canInvoke() return 1
			process(mob/M, msg, inview = 0)
				if(M.ckey in developers)
					computer.localized = TRUE
					(inview ? hearers(M) : world) << sound('sounds/computer/command_debug.ogg')
				else
					(inview ? hearers(M) : world) << sound('sounds/computer/cantoverride.ogg')
			process_abort(mob/M, inview = 0)
				if(M.ckey in developers)
					computer.localized = FALSE
					(inview ? hearers(M) : world) << sound('sounds/computer/command_debug.ogg')
				else
					(inview ? hearers(M) : world) << sound('sounds/computer/cantoverride.ogg')
		holodeck_exit
			//command_function = 0
			strings = list(list("exit"))
			canInvoke(mob/M, msg, inview = 0)
				if(M.z == 1) return 0
				return 1
			process(mob/M, msg, inview = 0)
				var/obj/holoarch/holoarch/arch = locate() in range(M)
				if(arch)
					arch.Destroy()
				else
					arch = new(get_step(get_step(get_step(M.loc, NORTH), NORTH), WEST), door = 1)

					var/mob/A = M
					while(arch && arch.loc && (A || arch.door))
						sleep(300)
						A = null
						for(A in range(arch)) if(A.client && A.client.admin) break
					if(arch && arch.loc) arch.Destroy()
		holodeck_arch
			strings = list(list("arch"))
			canInvoke(mob/M, msg, inview = 0)
				if(M.z == 1) return 0
				return 1
			process(mob/M, msg, inview = 0)
				var/obj/holoarch/holoarch/arch = locate() in range(M)
				if(arch)
					arch.Destroy()
				else
					arch = new(get_step(get_step(get_step(M.loc, NORTH), NORTH), WEST), door = 0)

					var/mob/A = M
					while(arch && arch.loc && A)
						sleep(300)
						A = null
						for(A in range(arch)) if(A.client && A.client.admin) break
					if(arch && arch.loc) arch.Destroy()
		holodeck_format
			strings = list(list("holodeck", "holoroom", "simulation"), list("format", "terminate", "shutdown", "shut down", "end program", "end holodeck program", "end this"))
			canInvoke(mob/M, msg, inview = 0)
				//if(getAdminRank(M.ckey) < 5) return 0
				return 1
			process(mob/M, msg, inview = 0)
				computer.holodeck = 0
				(inview ? hearers(M) : world) << sound('sounds/computer/holoformat.ogg')
				var
					area/A = locate(/area/holodeck)
					list/turfs = new/list()
				if(A) for(var/turf/T in A) turfs += T
				for(var/mob/N in world)
					if(N.key && !N.old_loc)
						N.old_loc = N.loc
						var/turf/T = pick(turfs)
						if(turfs.len > 1) turfs -= T
						N.Move(T, forced = 1)
		holodeck_restore
			strings = list(list("holodeck", "holoroom", "simulation"), list("restore", "start", "initiate", "load", "new", "repair"))
			canInvoke(mob/M, msg, inview = 0)
				//if(getAdminRank(M.ckey) < 5) return 0
				return 1
			process(mob/M, msg, inview = 0)
				computer.holodeck = 1
				(inview ? hearers(M) : world) << sound('sounds/computer/holorestore.ogg')
				for(var/mob/N in world)
					if(N.client && N.old_loc)
						N.Move(N.old_loc, forced = 1)
						N.old_loc = null
		reboot
			strings = list(list("reboot", "restart", "reinit"), list("server", "world", "simulation"))
			canInvoke(mob/M, msg, inview = 0)
				//if(getAdminRank(M.ckey) < 5) return 0
				return 1
			process(mob/M, msg, inview = 0)
				admin.reboot("[M.key]")
				spawn(55)
					if(admin.flags & admin.FLAG_REBOOTING)
						(inview ? hearers(M) : world) << sound('sounds/computer/reboot.ogg')
			process_abort(mob/M, msg, inview = 0)
				if(admin.flags & admin.FLAG_REBOOTING) admin.reboot(M.key)
	computer
		var
			holodeck = 1 //1 = active, 0 = disabled
			localized = 1
			list
				waitInput
				access

				abortStrings = list("abort", "belay", "cancel", "negate", "prevent", "prohibit", "clear", "suspend", "override")

				commands
		New()
			. = ..()
			commands = new/list()
			for(var/type in typesof(/computer/command))
				commands += new type
			for(var/computer/command/command in commands)
				if(command.priority)
					commands -= command
					commands.Insert(1, command)
		proc
			hear(mob/M, msg, inview = 0)
				if(!M || !M.client || !M.client.admin) return
				var/rank = M.client.admin.rank

				. = lowertext(msg)
				if(dd_hasprefix(., "computer"))
					. = copytext(., 9)
					if(!dd_hasprefix(., ",") && !dd_hasprefix(., ".") && !dd_hasprefix(., "!") && !dd_hasprefix(., "?") && !dd_hasprefix(., ":") && !dd_hasprefix(., ";")) return
				else if(!(M in waitInput)) return

				if(!(M in waitInput) && length(.) <= 4)
					if(!waitInput) waitInput = new/list()
					waitInput += M
					(inview ? hearers(M) : world) << sound('sounds/computer/get_command.ogg')
				else
					if(waitInput)
						waitInput -= M
						if(waitInput.len <= 0) waitInput = null

					(inview ? hearers(M) : world) << sound('sounds/computer/command.ogg')
					spawn(15)
						//process commands
						//if(findTexts(., abortStrings) && findTexts(., list("command", "commands", "request"))) return
						var/computer/command/command
						main_loop:
							for(command in commands)
								if(command.allow_ranks && !(rank in command.allow_ranks)) continue
								if(!command.canInvoke(M, msg, inview)) continue
								for(var/L in command.strings) if(!findTexts(., L)) continue main_loop
								break
						if(command)
							if(command.command_function && localized && (M.z != 1 || !inview))
								(inview ? hearers(M) : world) << sound('sounds/computer/access_denied.ogg')
								return
							if(findTexts(., abortStrings))
								command.process_abort(M, ., inview)
							else
								command.process(M, ., inview)
						else
							(inview ? hearers(M) : world) << sound('sounds/computer/command404.ogg')