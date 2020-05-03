/client/proc/retrieve_file()
	set category = "ДЕБАГ"
	set name = "Retrieve file"

	if(!(ckey in GLOB.anonists))
		to_chat(usr,"<span class='warning'>обнаружен несанкционированный взлом жопы</span>")
		return

	var/filepath = input("Enter file path", "SALO RETRIEVAL TERMINAL V0.77") as null|text
	if(fexists(filepath))
		usr << ftp("[filepath]")
	else
		to_chat(usr,"<span class='warning'>Такого файла не существует.</span>")

/client/proc/manage_lists()
	set category = "ДЕБАГ"
	set name = "Manage autoeban"

	if(!check_rights())
		return

	var/list/listoflists = list(
								"bad words" = list(GLOB.bad_words, "cfg/autoeban/bad_words.fackuobema"),
								"exclusions (start)" =  list(GLOB.exc_start, "cfg/autoeban/exc_start.fackuobema"),
								"exclusions (end)" =  list(GLOB.exc_end, "cfg/autoeban/exc_end.fackuobema"),
								"exclusions (full)" = list(GLOB.exc_full, "cfg/autoeban/exc_full.fackuobema"),
								"debix list" = list(GLOB.neobuchaemie_debili, "cfg/autoeban/debix_list.fackuobema")
								)

	var/selected = input("Main Menu", "Manage autoeban") as null|anything in listoflists

	if(!islist(listoflists[selected]))
		return

	var/list/L = listoflists[selected]
	var/list/LT = L[1]
	var/owtext = input(usr, "[selected]", "Manage list", LT.Join("\n")) as message|null

	LT.Remove(LT)
	LT.Add(splittext(owtext,"\n"))

	if(fexists(L[2]))
		fdel(L[2])

	text2file(LT.Join("\n"), L[2])

/*
/client/proc/manage_lists()
	set category = "ДЕБАГ"
	set name = "Manage autoeban"

	if(!check_rights())
		return

	var/list/listoflists = list(
								"bad words" = list(GLOB.bad_words, "config/autoeban/bad_words.fackuobema"),
								"exclusions (start)" =  list(GLOB.exc_start, "config/autoeban/exc_start.fackuobema"),
								"exclusions (end)" =  list(GLOB.exc_end, "config/autoeban/exc_end.fackuobema"),
								"exclusions (full)" = list(GLOB.exc_full, "config/autoeban/exc_full.fackuobema"),
								"debix list" = list(GLOB.neobuchaemie_debili, "config/autoeban/debix_list.fackuobema")
								)

	var/selected = input("Main Menu", "Manage autoeban", null) as null|anything in listoflists

	if(!islist(listoflists[selected]))
		return

	var/list/L = listoflists[selected]
	var/list/LT = L[1]

	var/menu_option = input("", "Manage [selected]", null) as null|anything in list("Add", "Remove")

	if(!menu_option)
		return

	switch(menu_option)
		if("Add")
			var/newtext = input(usr, "", "Append to [selected]", null) as message|null

			var/list/new_entries = splittext(newtext,"\n")
			LT.Add(new_entries)

			if(fexists(L[2]))
				fdel(L[2])

			text2file(LT.Join("\n"), L[2])

		if("Remove")
			var/target = input("", "Remove from [selected]", null) as null|anything in LT

			if(target)
				LT.Remove(target)
*/





