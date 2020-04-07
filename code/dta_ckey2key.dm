var/list/dta_ckey2key
proc
	dta_ckey2key(ckey) //retrieves the BYOND key when given a ckey. caches it's results.
		if(!ckey) return
		if(!dta_ckey2key) dta_ckey2key = new/list()
		. = ckey(ckey)
		if(. in dta_ckey2key) return dta_ckey2key[.]
		var/http[] = world.Export("http://www.byond.com/members/[.]?format=text")
		if(http && ("CONTENT" in http))
			var
				savefile/F = new()
				content = file2text(http["CONTENT"])
			F.ImportText("/", content)
			if(!F || !F.dir || !F.dir.len) return

			if(!dta_ckey2key) dta_ckey2key = new/list()
			dta_ckey2key[.] = F["/general/key"] //cache the result
			. = F["/general/key"]

world
	New()
		var/savefile/F = new("dta_ckey2key.sav")
		F >> dta_ckey2key
		return ..()
	Del()
		var/savefile/F = new("dta_ckey2key.sav")
		F << dta_ckey2key
		return ..()