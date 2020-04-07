mob/proc
	score_Add(score, val = 1)
		if(!client || !client.player) return
		var/player/P = client.player
		if(P && ("score_[score]" in P.vars))
			P.vars["score_[score]"]  += val
			spawn P.UpdateScore() //branch this off to avoid problems (e.x., double king bug)
	score_Rem(score, val = 1) return score_Add(score, -val)
	medal_Award(medal)
		if(!client || !client.player) return
		var/player/P = client.player
		return P.AwardMedal(medal)
	medal_Remove(medal)
		if(!client || !client.player) return
		var/player/P = client.player
		return P.RemoveMedal(medal)
	medal_Report(medal, additional)
		if(!client || !client.player) return
		var/player/P = client.player
		return P.ReportMedal(medal, additional)

proc
	medal2text(medal)
		var/list
			special = list("Photonic Trickery", "The Data's Brow Award", "Ruzka's Award For Bravery")
			situational = list("Vanity Rules", "Vigilante")
		if(medal in special) return "<font color=\"#CC3232\">[medal]</font>"
		else if(medal in situational) return "<font color=\"#3232CC\">[medal]</font>"
		else return "<font color=\"#32AA32\">[medal]</font>"
	ScoreDenied()
		return dd_file2list("data/deny_score.txt", "\n")
	MedalDenied()
		return dd_file2list("data/deny_medal.txt", "\n")