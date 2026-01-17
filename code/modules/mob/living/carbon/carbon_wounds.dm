/mob/living/carbon/get_embedded_objects()
	. = ..()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(!length(bodypart.embedded_objects))
			continue
		. += bodypart.embedded_objects

/mob/living/carbon/proc/bodypart_with_embedded_object(obj/item/embedder)
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.is_object_embedded(embedder))
			return bodypart

/mob/living/carbon/proc/remove_embedded_object(obj/item/embedder)
	var/obj/item/bodypart/bodypart = bodypart_with_embedded_object(embedder)
	if(bodypart)
		return bodypart.remove_embedded_object(embedder)
	return FALSE

/mob/living/carbon/get_wounds()
	. = ..()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(!length(bodypart.wounds))
			continue
		. += bodypart.wounds
