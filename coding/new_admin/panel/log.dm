admin_panel/UpdateScreen(screen)
	. = ..()
	if(screen != "log") return .
	. += {"<div class=\"box\">
		<h1>Admin Log</h1>
		<table width="571" class="table">
			<tr>
				<th width="30%">By whom?</th>
				<th width="70%">Action</th>
				[_OutputActionLog(limit = 30)]
			</tr>
		</table>
		<a href="byond://?src=\ref[src];log_start=[max(1, log_start - 25)]">Back</a> &middot; <a href="byond://?src=\ref[src];log_start=[min(admin.admin_log.len, log_start + 25)]">Next</a>
	</div>"}
