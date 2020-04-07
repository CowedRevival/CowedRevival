/*world/New()  //load bans
	..()
	name=""
	if(fexists("Bans.sav"))
		var/savefile/F=new("Bans.sav")
		F["Banz"]>>ipbanz
world/Del()  //save bans
	var/savefile/F=new("Bans.sav")
	F["Banz"]<<ipbanz
	..()

var/list/ipbanz = new
var/list/banz = new*/
mob
	Admin
/*		verb
			Keyban(mob/M)
				set category="Admin"
				if(M.key)
					world<<"[usr] has banned [M]!"
					banz.Add(M.key)
					del M

			Pager_Ban(mob/M)
				set category="Admin"
				world.SetConfig("keyban",ckey(M.key),"reason=Ban;admin=[ckey]")
			Lookban(key as null|text)
				set category="Admin"
				if(key)
					usr << "[key]: [world.GetConfig("keyban",key)]"
				else
					var/lst[] = world.GetConfig("keyban")
					for(key in lst)
						usr << "[key]: [world.GetConfig("keyban",key)]"
			Ban()
				set category="Admin"
				var/list/O=new
				O["Cancel"]="1"
				var/Xk=0
				for(var/mob/X in world)
					if(X.ip_memory)
						Xk=X.key
						O["[X.name],[X.key],[X.ip_memory]"]=X.ip_memory

				var/BIPo=input("Ban somebody's IP","IPBAN") in O
				var/BIP=O["[BIPo]"]
				world<<"banned [BIP]  / [BIPo]"
				if(BIP=="1")return
				else
					ipbanz["[BIP]"]=Xk

				for(var/mob/X in world)
					if(X.ip_memory==BIP && BIP)
						del(X)


			Unban()
				set category="Admin"
				var/list/M = new
				var/list/m =new
				var/i
				for(i=1,i<=ipbanz.len,i++)
					m+=ipbanz[i]
				m+="Cancel"
				var/C=input("unban","Unban") in m
				if(C=="Cancel")return
				M=ipbanz[C]
				world<<"[usr] unbanned [M]/[C]."
				ipbanz.Remove(C)*/
