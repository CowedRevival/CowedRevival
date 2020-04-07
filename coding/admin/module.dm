admin/module
	var
		admin/record/master
	proc
		_update()
			if(!master || !master.client) return 0
			return update()

		update()
		Command(href, href_list[])
	Topic(href, href_list[])
		if(!master || !master.client || master.client != usr.client) return
		return Command(href, href_list)