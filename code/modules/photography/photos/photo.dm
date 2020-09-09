/*
 * Photo
 */
/obj/item/photo
	name = "Фотография"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "photo"
	inhand_icon_state = "paper"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 50
	grind_results = list(/datum/reagent/iodine = 4)
	var/datum/picture/picture
	var/scribble		//Scribble on the back.

/obj/item/photo/Initialize(mapload, datum/picture/P, datum_name = TRUE, datum_desc = TRUE)
	set_picture(P, datum_name, datum_desc, TRUE)
	return ..()

/obj/item/photo/proc/set_picture(datum/picture/P, setname, setdesc, name_override = FALSE)
	if(!istype(P))
		return
	picture = P
	update_icon()
	if(P.caption)
		scribble = P.caption
	if(setname && P.picture_name)
		if(name_override)
			name = P.picture_name
		else
			name = "Фотография - [P.picture_name]"
	if(setdesc && P.picture_desc)
		desc = P.picture_desc

/obj/item/photo/update_icon_state()
	if(!istype(picture) || !picture.picture_image)
		return
	var/icon/I = picture.get_small_icon(initial(icon_state))
	overlays += I

/obj/item/photo/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] бросает последний взгляд на \the [src]! Похоже, [user.p_theyre()] умер!</span>")//when you wanna look at photo of waifu one last time before you die...
	if (user.gender == MALE)
		playsound(user, 'sound/voice/human/manlaugh1.ogg', 50, TRUE)//EVERY TIME I DO IT MAKES ME LAUGH
	else if (user.gender == FEMALE)
		playsound(user, 'sound/voice/human/womanlaugh.ogg', 50, TRUE)
	return OXYLOSS

/obj/item/photo/attack_self(mob/user)
	user.examinate(src)

/obj/item/photo/attackby(obj/item/P, mob/user, params)
	if(burn_paper_product_attackby_check(P, user))
		return
	if(istype(P, /obj/item/pen) || istype(P, /obj/item/toy/crayon))
		if(!user.is_literate())
			to_chat(user, "<span class='notice'>You scribble illegibly on [src]!</span>")
			return
		var/txt = stripped_input(user, "Что бы Вы хотели написать на обратной стороне?", "Изменение текста", "", 128)
		if(txt && user.canUseTopic(src, BE_CLOSE))
			scribble = txt
	else
		return ..()

/obj/item/photo/examine(mob/user)
	. = ..()

	if(in_range(src, user) || isobserver(user))
		show(user)
	else
		. += "<span class='warning'>Вам нужно подойти ближе, чтобы детально рассмотреть фотографию!</span>"

/obj/item/photo/proc/show(mob/user)
	if(!istype(picture) || !picture.picture_image)
		to_chat(user, "<span class='warning'>[src] seems to be blank...</span>")
		return
	user << browse_rsc(picture.picture_image, "tmp_photo.png")
	user << browse("<html><head><meta http-equiv='Content-Type' content='text/html; charset=utf-8'><title>[name]</title></head>" \
		+ "<body style='overflow:hidden;margin:0;text-align:center'>" \
		+ "<img src='tmp_photo.png' width='480' style='-ms-interpolation-mode:nearest-neighbor' />" \
		+ "[scribble ? "<br>Написано на обороте:<br><i>[scribble]</i>" : ""]"\
		+ "</body></html>", "window=photo_showing;size=480x608")
	onclose(user, "[name]")

/obj/item/photo/verb/rename()
	set name = "Переименовать фото"
	set category = "Объект"
	set src in usr

	var/n_name = stripped_input(usr, "Как бы вы хотели переимновать фотографию?", "Изменение информации", "", MAX_NAME_LEN) //Не самый точный перевод, стоит подумать в этом месте
	//loc.loc check is for making possible renaming photos in clipboards
	if(n_name && (loc == usr || loc.loc && loc.loc == usr) && usr.stat == CONSCIOUS && !usr.incapacitated())
		name = "Фотография[(n_name ? text("- [n_name]") : null)]"
	add_fingerprint(usr)

/obj/item/photo/old
	icon_state = "photo_old"
