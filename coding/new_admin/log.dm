admin_log
	var
		admin //administrator that initiated the log entry (key)
		text //text in the log
		date //date for the log
		log_type
		target
	New(admin, text, date, type, target)
		src.admin = admin
		src.text = text
		src.date = date
		src.log_type = type
		src.target = target