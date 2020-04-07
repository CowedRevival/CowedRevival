client
	proc/ExportSafeFile(savefile/s)
		var/safetext = RC5_Encrypt(s.ExportText("/"), "omg")
		var/savefile/s2 = new
		s2["safetext"] << safetext
		src.Export(s2)

	proc/ImportSafeFile()
		var/f = src.Import()
		if (f)
			var/savefile/s = new(f)
			var/safetext
			s["safetext"] >> safetext
			if (safetext)
				del(s)
				s = new()
				s.ImportText("/", RC5_Decrypt(safetext, "omg"))
				return s