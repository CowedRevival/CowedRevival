berry_effects
	var
		name = "" // label for the effect
		// Effects
		sleep = 0 // Positive increases need to sleep, negative reduces need to sleep.
		poison = 0 // Slowly hurts you.
		food = 0 // Positive reduces hunger, negative increases it
		endurance = 0 // Counters poison and some damage.
		heal = 0 // Increases health
		alcohol = 0 // *hic*

	proc

		add_to(var/berry_effects/E)
			E.sleep += src.sleep
			E.poison += src.poison
			E.food += src.food
			E.endurance += src.endurance
			E.heal += src.heal
			E.alcohol += src.alcohol
			E.react()

			src.sleep = 0
			src.poison = 0
			src.food = 0
			src.endurance = 0
			src.heal = 0
			src.alcohol = 0

		copy_of(var/berry_effects/E)
			src.name = E.name
			src.sleep = E.sleep
			src.poison = E.poison
			src.food = E.food
			src.endurance = E.endurance
			src.heal = E.heal
			src.alcohol = E.alcohol
			src.react()

		react()
			// balance out any effects
			if(poison && endurance)
				. = poison-endurance
				if(.<0)
					endurance = endurance-poison
					poison = 0

		on_mob_life(var/mob/M)
			var/updateHUD = 0
			if(sleep<0) // Reduce need to sleep
				sleep ++
				M.SLEEP = min(M.SLEEP+1,100)
				updateHUD = 1

			if(sleep>0) // Increase need to sleep
				sleep --
				M.SLEEP --
				updateHUD = 1

			if(poison)
				poison --
				if(M.state == "alive") M.HP--
				M.checkdead(M)
				updateHUD = 1

			if(food>0) // Reduce hunger
				food --
				M.HUNGER = min(M.HUNGER+1,100)
				updateHUD = 1

			if(food<0) // Increase hunger
				food ++
				M.HUNGER --
				updateHUD = 1

			if(endurance)
				endurance --

			if(heal) // heal me up
				M.HP = min(M.HP+1,100)
				updateHUD = 1

			if(alcohol)
				alcohol--
				if(M.state == "ghost" || M.state == "ghost-i" || M.state == "skeleton") M.HP -= 5
				updateHUD = 1

			if(updateHUD) hud_main.UpdateHUD(M)


	Poison
		name = "Poison"
		poison = 10

	Sleep
		name = "Sleep"
		sleep = 10

	Caffeine
		name = "Caffeine"
		sleep = -10

	Hunger
		name = "Hunger"
		food = -10

	Food
		name = "Food"
		food = 10

	Alcohol
		name = "Alcohol"
		alcohol = 10
		sleep = -4

var/list/Berry_Effects = list()

proc/Random_Berry_Effects()
	// Randomise Effects
	var/list/effects = list(/berry_effects/Poison,/berry_effects/Sleep,/berry_effects/Caffeine,/berry_effects/Hunger,/berry_effects/Food,/berry_effects/Alcohol)
	while(effects.len)
		var/E = pick(effects)
		Berry_Effects += E
		effects -= E

proc/Make_Berry_Book()
	var
		list/Berries = list()
	for(var/T in typesof(/item/misc/new_berries)-/item/misc/new_berries)
		if(!istype(T, /item/misc/new_berries/glass_vial)) Berries += new T
	var/text={"
<title>Berries</title>
<body>
<STYLE>BODY{font: 12pt 'Papyrus', sans-serif; color:black}</STYLE>
<table cellpadding="0" cellspacing="0" border="0" can_resize=1 can_minimize=0 align="center">
<td>
<center>
<b><u>Berries</u></b></br>
</br>
Berry  -  Effect</br>
</br>
"}
	for(var/item/misc/new_berries/N in Berries)
		if(!istype(N, /item/misc/new_berries/glass_vial)) text+="[N.name]  -  [N.Effects.name]</br>"
	text+={"
</td>
</table>
</body>
</html>
"}
	return text