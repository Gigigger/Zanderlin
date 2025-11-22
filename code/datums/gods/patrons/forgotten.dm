/datum/patron/psydon
	name = "Psydon"
	display_name = "Orthodox Psydonite"
	domain = "God of Humenity, Dreams and Creation"
	desc = "Deceased, slain by Necra in His final moments. She ripped His body apart to create The Ten... we must put Him back together again. Psydon lives. He will return."
	flaws = "Grudge-Holding, Judgemental, Self-Sacrificing"
	worshippers = "Grenzelhofters, Inquisitors, Heroes"
	sins = "Apostasy, Demon Worship, Betraying thy Father"
	boons = "None. His power is divided."
	associated_faith = /datum/faith/psydon
	confess_lines = list(
		"THERE IS ONLY ONE GOD!",
		"THE SUCCESSORS HALT HIS RETURN!",
		"PSYDON LIVES!",
	)
	profane_words = list()

/datum/patron/psydon/can_pray(mob/living/carbon/human/follower)
	//We just kind of assume the follower is a human here
	if(
		istype(follower.wear_wrists, /obj/item/clothing/neck/psycross) || istype(follower.wear_neck, /obj/item/clothing/neck/psycross) || istype(follower.get_active_held_item(), /obj/item/clothing/neck/psycross)
		)
		return TRUE

	to_chat(follower, span_danger("I can not talk to Him... I need His cross!"))
	return FALSE
