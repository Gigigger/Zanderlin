/mob/living/simple_animal/hostile/retaliate/trogfish
	icon = 'icons/roguetown/mob/monster/trogfish.dmi'
	name = "trogfish"
	desc = ""
	icon_state = "trogfish"
	icon_living = "trogfish"
	icon_dead = "trogfish_dead"

	faction = list(FACTION_SEA)
	emote_hear = list("gurgles.")
	emote_see = list("oozes.")
	move_to_delay = 4
	vision_range = 2
	aggro_vision_range = 2


	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/fat = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/reagent_containers/food/snacks/meat/strange = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/fat = 2,
						/obj/item/reagent_containers/food/snacks/meat/strange = 2)

	health = 70
	maxHealth = 70
	food_type = list(/obj/item/reagent_containers/food/snacks,
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/simple/bite)
	attack_sound = 'sound/combat/wooshes/punch/punchwoosh (2).ogg'
	melee_damage_lower = 12
	melee_damage_upper = 14

	base_constitution = 8
	base_strength = 3
	base_speed = 6

	//for gibbing
	var/burst_liquid = /datum/reagent/toxin/acid/trogfish
	var/burst_range = 3
	var/threat_scale = 2

	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 40
	defdrain = 5
	retreat_health = 0.3
	aggressive = TRUE
	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/trogfish
	body_eater = TRUE
	gender = NEUTER

	ai_controller = /datum/ai_controller/trogfish

	food_type = list(
		/obj/item/reagent_containers/food/snacks/cheddarslice,
		/obj/item/reagent_containers/food/snacks/cheese_wedge,
		/obj/item/reagent_containers/food/snacks/cheddar,
		/obj/item/reagent_containers/food/snacks/cheese,
	)
	tame_chance = 25
	bonus_tame_chance = 15

	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/fetch,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/obj/effect/decal/remains/trogfish
	name = "remains"
	gender = NEUTER
	icon_state = "trogfish_dead"
	icon = 'icons/roguetown/mob/monster/trogfish.dmi'

/mob/living/simple_animal/hostile/retaliate/trogfish/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

	var/datum/action/cooldown/mob_cooldown/trogfish_burst/burst = new()
	burst.Grant(src)
	ai_controller?.set_blackboard_key(BB_TARGETED_ACTION, burst)

/mob/living/simple_animal/hostile/retaliate/trogfish/proc/start_gibbing(datum/looping_sound/sound_loop)
	addtimer(CALLBACK(src, PROC_REF(gib), TRUE, TRUE, TRUE, TRUE, sound_loop), 3 SECONDS)
	var/matrix/M = matrix()
	M.Scale(1.4, 1.2)
	animate(src, time = 40, transform = M, easing = SINE_EASING)

/mob/living/simple_animal/hostile/retaliate/trogfish/gib(no_brain, no_organs, no_bodyparts, burst = FALSE, datum/looping_sound/sound_loop = null)
	var/turf/epicenter = get_turf(src)
	if(epicenter && burst)
		if(sound_loop)
			sound_loop.stop(TRUE)
			qdel(sound_loop)
		visible_message(span_userdanger("[src] violently bursts!"))

		var/list/turflist = list(epicenter)
		for(var/turf/T in view(1, epicenter))
			if(CanReach(T) && T.uses_integrity && !isindestructiblewall(T) && !isopenspace(T)) // probably needs more fine tuning
				turflist |= T
		for(var/turf/T in turflist)
			T.acid_act(80, 30)
			if(iswallturf(T))
				T.take_damage(1500, BURN, "acid", 0) // there's no acid processing for turfs so this is what i'm doin for now

		var/datum/reagents/R = new(100, NO_REACT)
		R.add_reagent(burst_liquid, 80)
		chem_splash(epicenter, burst_range, list(R, reagents), threatscale = src.threat_scale)
		qdel(R)
	. = ..()

/datum/action/cooldown/mob_cooldown/trogfish_burst
	name = "Burst"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "acid"
	desc = "Contract your trogbladder, killing you in and producing a mass of acidic bile."
	cooldown_time = 10 SECONDS

	var/already_gibbing = FALSE
	var/sound_type = /datum/looping_sound/invokefire

/datum/action/cooldown/mob_cooldown/trogfish_burst/Activate(atom/target)
	if(isdead(owner) || already_gibbing)
		return FALSE
	owner.visible_message(span_boldwarning("[owner]'s skin starts to boil and expand!"))
	var/datum/looping_sound/sound_loop
	if(sound_type)
		sound_loop = new sound_type(_parent = owner, start_immediately = TRUE)

	//this makes this not copy-pasteable
	var/mob/living/simple_animal/hostile/retaliate/trogfish/trog = owner
	trog.start_gibbing(sound_loop)
	already_gibbing = TRUE
	StartCooldown()
	return TRUE
