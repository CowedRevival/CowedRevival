admin_panel/UpdateScreen(screen)
	. = ..()
	if(screen != "books") return .
	if(master.rank == "Support" || master.rank == "Spy") return
	. += {"<div class="box">
		<h1>Pending Books</h1>
		<table class="table" width="571">
			<tr>
				<th>Title</th>
				<th>Pages</th>
				<th>Author</th>
				<th>Last Update</th>
				<th>Actions</th>
			</tr>"}
	if(books) for(var/i = 1 to books.len)
		var
			x = books[i]
			item/misc/book/I = books[x]
		if(I.approved) continue

		if(!I.updated) I.updated = world.realtime
		. += "<tr><td>[x]</td><td>[I.contents.len] page\s</td><td>[I.author ? I.author : "(unknown)"]</td><td>[time2text(I.updated)]</td><td>\
		<a href=\"byond://?src=\ref[src];cmd=approve;book=[i]\">Approve</a> &middot; <a href=\"byond://?src=\ref[src];cmd=reject;book=[i]\" onclick=\"return confirm('Are you sure?');\">Reject</a>\
		</td></tr>"
	. += {"</table></div><div class="box">
		<h1>Approved Books</h1>
		<table class="table" width="571">
			<tr>
				<th>Title</th>
				<th>Pages</th>
				<th>Author</th>
				<th>Last Update</th>
				<th>Actions</th>
			</tr>"}
	if(books) for(var/i = 1 to books.len)
		var
			x = books[i]
			item/misc/book/I = books[x]
		if(!I.approved) continue
		if(!I.updated) I.updated = world.realtime
		. += "<tr><td>[x]</td><td>[I.contents.len] page\s</td><td>[I.author ? I.author : "(unknown)"]</td><td>[time2text(I.updated)]</td><td>\
		<a href=\"byond://?src=\ref[src];cmd=delete_book;book=[i]\" onclick=\"return confirm('Are you sure?');\">Delete</a>\
		</td></tr>"
	. += "</table></div>"
