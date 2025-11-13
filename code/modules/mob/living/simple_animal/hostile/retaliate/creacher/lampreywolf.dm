/mob/living/simple_animal/hostile/retaliate/lampreywolf
	icon = 'icons/roguetown/mob/monster/lamprey_volf.dmi'
	name = "luperey" // lupe like dog
	desc = ""
	icon_state = "lampreyvolf1"
	icon_living = "lampreyvolf1"
	icon_dead = "lampreyvolf1_dead"
	SET_BASE_PIXEL(-4, 0)

	faction = list(FACTION_SEA)
	emote_hear = null
	emote_see = null
	see_in_dark = 9
	move_to_delay = 2
	vision_range = 9
	aggro_vision_range = 9

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/fur/volf = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/natural/fur/volf = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/fur/volf = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 2)
	head_butcher = /obj/item/natural/head/volf

	health = LAMPREYVOLF_HEALTH
	maxHealth = LAMPREYVOLF_HEALTH
	gender = MALE
	var/is_pack_alpha = FALSE

	food_type = list(/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/simple/bite/lampreywolf)
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')

	// pack tactics, steal blood and get out of there
	melee_damage_lower = 5
	melee_damage_upper = 10
	melee_attack_cooldown = 1.7 SECONDS
	var/blood_steal = 30 // how much blood are we stealing per bite
	retreat_health = 0.3

	base_constitution = 8
	base_strength = 8
	base_speed = 12

	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 35
	defdrain = 5
	del_on_deaggro = 999 SECONDS

	//these change when tamed
	can_buckle = FALSE
	buckle_lying = FALSE
	can_saddle = FALSE

	dodgetime = 17
	aggressive = 1
	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/lampreywolf

	ai_controller = /datum/ai_controller/lampreywolf
	var/static/list/pet_commands = list(
		/datum/pet_command/fish,
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

/mob/living/simple_animal/hostile/retaliate/lampreywolf/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)

	ADD_TRAIT(src, TRAIT_GOOD_SWIM, TRAIT_GENERIC)
	if(is_pack_alpha)
		ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
	else
		ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
		if(prob(50))
			gender = FEMALE
			icon_living = "lampreyvolf2"
			icon_state = icon_living
			remains_type = /obj/effect/decal/remains/lampreywolf/f

	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/lampreywolf/death(gibbed)
	..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/lampreywolf/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	if(ssaddle)
		var/mutable_appearance/saddlet = mutable_appearance(icon, "lampreyvolf_saddle_above", 4.3)
		. += saddlet
		saddlet = mutable_appearance(icon, "lampreyvolf_saddle")
		. += saddlet
	if(has_buckled_mobs())
		var/mutable_appearance/mounted = mutable_appearance(icon, "[icon_living]_mounted", 4.3)
		. += mounted

/mob/living/simple_animal/hostile/retaliate/lampreywolf/tamed(mob/user)
	. = ..()
	deaggroprob = 30
	can_buckle = TRUE
	can_saddle = TRUE
	AddComponent(/datum/component/riding/lampreywolf)

/mob/living/simple_animal/hostile/retaliate/lampreywolf/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/lampreywolf/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/lampreywolf/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()


/mob/living/simple_animal/hostile/retaliate/lampreywolf/AttackingTarget(mob/living/passed_target)
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		var/bloodToLose = min(blood_steal, L.blood_volume)
		L.blood_volume = max(L.blood_volume - bloodToLose, 0)
		L.handle_blood()

		blood_volume = min(blood_volume + bloodToLose, BLOOD_VOLUME_MAXIMUM)
		handle_blood()



/mob/living/simple_animal/hostile/retaliate/lampreywolf/alpha
	name = "alpha luperey"
	desc = ""
	icon_state = "lampreyvolf3"
	icon_living = "lampreyvolf3"
	icon_dead = "lampreyvolf_dead"

	is_pack_alpha = TRUE

	melee_damage_lower = 10
	melee_damage_upper = 15
	blood_steal = 50
	retreat_distance = 3
	retreat_health = 0.2

	defprob = 50

	health = ALPHA_LAMPREYVOLF_HEALTH
	maxHealth = ALPHA_LAMPREYVOLF_HEALTH

	base_constitution = 10
	base_strength = 10
	base_speed = 14


/obj/effect/decal/remains/lampreywolf
	name = "remains"
	gender = MALE
	icon_state = "lampreyvolf1_dead"
	icon = 'icons/roguetown/mob/monster/lamprey_volf.dmi'

/obj/effect/decal/remains/lampreywolf/f
	gender = FEMALE
	icon_state = "lampreyvolf2_dead"

/obj/effect/decal/remains/lampreywolf/alpha
	icon_state = "lampreyvolf3_dead"

/datum/intent/simple/bite/lampreywolf
	penfactor = 5
	blade_class = BCLASS_STAB
