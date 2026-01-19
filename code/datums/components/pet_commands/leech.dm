/datum/pet_command/attack/leech_blood
	command_name = "Leech"
	command_desc = "Command your pet to drink the blood from a target."
	requires_pointing = TRUE
	radial_icon_state = "leech"
	speech_commands = list("drain", "leech", "suck", "drink")
	attack_behaviour = /datum/ai_behavior/interact_with_target/drink_blood

/datum/pet_command/attack/give_blood
	command_name = "Feed"
	command_desc = "Command your pet to feed their blood to a target."
	requires_pointing = TRUE
	radial_icon_state = "feed"
	speech_commands = list("feed", "help", "give")
	command_feedback = "nods"
	attack_behaviour = /datum/ai_behavior/interact_with_target/drink_blood/feed
