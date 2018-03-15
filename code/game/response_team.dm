// ERTs

#define ERT_TYPE_AMBER		1
#define ERT_TYPE_RED		2
#define ERT_TYPE_GAMMA		3

/datum/game_mode
	var/list/datum/mind/ert = list()

var/list/response_team_members = list()
var/responseteam_age = 21 // Minimum account age to play as an ERT member
var/datum/response_team/active_team = null
var/send_emergency_team = 0
var/ert_request_answered = 0

/client/proc/response_team()
	set name = "Dispatch Emergency Response Team"
	set category = "Special Verbs"
	set desc = "Send an emergency response team to the station"

	if(!holder)
		usr << "<span class='danger'>Only administrators may use this command.</span>"
		return
	if(!ROUND_IS_STARTED)
		usr << "<span class='danger'>The round hasn't started yet!</span>"
		return
	if(send_emergency_team)
		usr << "<span class='danger'>[current_map.boss_name] has already dispatched an emergency response team!</span>"
		return
	if(alert("Do you want to dispatch an Emergency Response Team?",,"Yes","No") != "Yes")
		return
	if(get_security_level() != "red") // Allow admins to reconsider if the alert level isn't Red
		switch(alert("The station is not in red alert. Do you still want to dispatch a response team?",,"Yes","No"))
			if("No")
				return
	if(send_emergency_team)
		usr << "<span class='danger'>Looks like somebody beat you to it!</span>"
		return

	var/datum/nano_module/ert_manager/E = new()
	E.ui_interact(usr)


/mob/dead/observer/proc/JoinResponseTeam()
	if(!send_emergency_team)
		to_chat(src, "No emergency response team is currently being sent.")
		return 0

	if(jobban_isbanned(src, "Response Team"))
		to_chat(src, "<span class='warning'>You are jobbanned from the emergency reponse team!</span>")
		return 0

	var/player_age_check = check_client_age(client, responseteam_age)
	if(player_age_check && config.use_age_restriction_for_antags)
		to_chat(src, "<span class='warning'>This role is not yet available to you. You need to wait another [player_age_check] days.</span>")
		return 0

	if(cannotPossess(src))
		to_chat(src, "<span class='boldnotice'>Upon using the antagHUD you forfeited the ability to join the round.</span>")
		return 0

	if(response_team_members.len > 6)
		to_chat(src, "The emergency response team is already full!")
		return 0

	return 1

/proc/trigger_armed_response_team(var/datum/response_team/response_team_type, commander_slots, security_slots, medical_slots, engineering_slots, janitor_slots, paranormal_slots, cyborg_slots)
	response_team_members = list()
	active_team = response_team_type
	active_team.setSlots(commander_slots, security_slots, medical_slots, engineering_slots, janitor_slots, paranormal_slots, cyborg_slots)

	send_emergency_team = 1
	//TODO-ERT: Repalce this with the ghost trap ?
	var/list/ert_candidates = pollCandidates("Join the Emergency Response Team?",, responseteam_age, 600, 1, role_playtime_requirements[ROLE_ERT])
	if(!ert_candidates.len)
		active_team.cannot_send_team()
		send_emergency_team = 0
		return 0

	// Respawnable players get first dibs
	for(var/mob/dead/observer/M in ert_candidates)
		if(jobban_isbanned(M, "Response Team") || jobban_isbanned(M, "Security Officer") || jobban_isbanned(M, "Captain") || jobban_isbanned(M, "Cyborg"))
			continue
		if((M in respawnable_list) && M.JoinResponseTeam())
			response_team_members |= M
	// If there's still open slots, non-respawnable players can fill them
	for(var/mob/dead/observer/M in (ert_candidates - respawnable_list))
		if(M.JoinResponseTeam())
			response_team_members |= M

	if(!response_team_members.len)
		active_team.cannot_send_team()
		send_emergency_team = 0
		return 0

	var/index = 1
	var/ert_spawn_seconds = 120
	spawn(ert_spawn_seconds * 10) // to account for spawn() using deciseconds
		var/list/unspawnable_ert = list()
		for(var/mob/M in response_team_members)
			if(M)
				unspawnable_ert |= M
		if(unspawnable_ert.len)
			message_admins("ERT SPAWN: The following ERT members could not be spawned within [ert_spawn_seconds] seconds:")
			for(var/mob/M in unspawnable_ert)
				message_admins("- Unspawned ERT: [ADMIN_FULLMONTY(M)]")
	for(var/mob/M in response_team_members)
		if(index > emergencyresponseteamspawn.len)
			index = 1

		var/client/C = M.client
		var/mob/living/new_commando = C.create_response_team(emergencyresponseteamspawn[index])
		new_commando.mind.key = M.key
		new_commando.key = M.key
		new_commando.update_icons()
		index++

	send_emergency_team = 0
	active_team.announce_team()
	return 1

/client/proc/create_response_team(var/turf/spawn_location)
	var/class = 0
	while(!class)
		class = input(src, "Which loadout would you like to choose?") in active_team.get_slot_list()
		if(!active_team.check_slot_available(class)) // Because the prompt does not update automatically when a slot gets filled.
			class = 0

//	if(class == "Cyborg")
//		active_team.reduceCyborgSlots()
//		var/cyborg_unlock = active_team.getCyborgUnlock()
//		var/mob/living/silicon/robot/ert/R = new /mob/living/silicon/robot/ert(spawn_location, cyborg_unlock)
//		return R

	var/mob/living/carbon/human/M = new(null)
	var/obj/item/organ/external/head/head_organ = M.get_organ("head")

	var/new_gender = alert(src, "Please select your gender.", "ERT Character Generation", "Male", "Female")

	if(new_gender)
		if(new_gender == "Male")
			M.change_gender(MALE)
		else
			M.change_gender(FEMALE)

	M.set_species("Human",1)
	M.dna.ready_dna(M)
	M.reagents.add_reagent("mutadone", 1) //No fat/blind/colourblind/epileptic/whatever ERT.
	M.overeatduration = 0

	var/hair_c = pick("#8B4513","#000000","#FF4500","#FFD700") // Brown, black, red, blonde
	var/eye_c = pick("#000000","#8B4513","1E90FF") // Black, brown, blue
	var/skin_tone = pick(-50, -30, -10, 0, 0, 0, 10) // Caucasian/black

	head_organ.facial_colour = hair_c
	head_organ.sec_facial_colour = hair_c
	head_organ.hair_colour = hair_c
	head_organ.sec_hair_colour = hair_c
	M.change_eye_color(eye_c)
	M.s_tone = skin_tone
	head_organ.h_style = random_hair_style(M.gender, head_organ.species.name)
	head_organ.f_style = random_facial_hair_style(M.gender, head_organ.species.name)

	//TODO-ERT: Change the Ranks
	M.real_name = "[pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant First Class", "Master Sergeant", "Sergeant Major")] [pick(last_names)]"
	M.name = M.real_name
	M.age = rand(23,35)
	M.regenerate_icons()
	M.update_body()

	//Creates mind stuff.
	M.mind = new
	M.mind.current = M
	M.mind.original = M
	M.mind.assigned_role = "MODE"
	M.mind.special_role = "Emergency Response Team"
	if(!(M.mind in SSticker.minds))
		SSticker.minds += M.mind //Adds them to regular mind list.
	SSticker.mode.ert += M.mind
	M.forceMove(spawn_location)

	job_master.CreateMoneyAccount(M, class, null)

	active_team.equip_officer(class, M)

	return M


/datum/response_team
	var/command_slots = 1
	var/engineer_slots = 3
	var/medical_slots = 3
	var/security_slots = 3
	var/janitor_slots = 0
	var/paranormal_slots = 0
	var/cyborg_slots = 0

	var/command_outfit
	var/engineering_outfit
	var/medical_outfit
	var/security_outfit
	var/janitor_outfit
	var/paranormal_outfit
	var/cyborg_unlock = 0

/datum/response_team/proc/setSlots(com, sec, med, eng, jan, par, cyb)
	command_slots = com
	security_slots = sec
	medical_slots = med
	engineer_slots = eng
	janitor_slots = jan
	paranormal_slots = par
	cyborg_slots = cyb

/datum/response_team/proc/reduceCyborgSlots()
	cyborg_slots--

/datum/response_team/proc/getCyborgUnlock()
	return cyborg_unlock

/datum/response_team/proc/get_slot_list()
	var/list/slots_available = list()
	if(command_slots)
		slots_available |= "Commander"
	if(security_slots)
		slots_available |= "Security"
	if(engineer_slots)
		slots_available |= "Engineer"
	if(medical_slots)
		slots_available |= "Medic"
	if(janitor_slots)
		slots_available |= "Janitor"
	if(paranormal_slots)
		slots_available |= "Paranormal"
	if(cyborg_slots)
		slots_available |= "Cyborg"
	return slots_available

/datum/response_team/proc/check_slot_available(var/slot)
	switch(slot)
		if("Commander")
			return command_slots
		if("Security")
			return security_slots
		if("Engineer")
			return engineer_slots
		if("Medic")
			return medical_slots
		if("Janitor")
			return janitor_slots
		if("Paranormal")
			return paranormal_slots
		if("Cyborg")
			return cyborg_slots
	return 0

/datum/response_team/proc/equip_officer(var/officer_type, var/mob/living/carbon/human/M)
	switch(officer_type)
		if("Engineer")
			engineer_slots -= 1
			M.equipOutfit(engineering_outfit)
			M.job = "ERT Engineering"

		if("Security")
			security_slots -= 1
			M.equipOutfit(security_outfit)
			M.job = "ERT Security"

		if("Medic")
			medical_slots -= 1
			M.equipOutfit(medical_outfit)
			M.job = "ERT Medical"

		if("Janitor")
			janitor_slots -= 1
			M.equipOutfit(janitor_outfit)
			M.job = "ERT Janitor"

		if("Paranormal")
			paranormal_slots -= 1
			M.equipOutfit(paranormal_outfit)
			M.job = "ERT Paranormal"

		if("Commander")
			command_slots = 0

			// Override name and age for the commander
			M.real_name = "[pick("Lieutenant", "Captain", "Major")] [pick(last_names)]"
			M.name = M.real_name
			M.age = rand(35,45)

			M.equipOutfit(command_outfit)
			M.job = "ERT Commander"

/datum/response_team/proc/cannot_send_team()
	command_announcement.Announce("[station_name()], we are unfortunately unable to send you an Emergency Response Team at this time.", "ERT Unavailable")

/datum/response_team/proc/announce_team()
	command_announcement.Announce("Attention, [station_name()]. We are sending a team of highly trained assistants to aid(?) you. Standby.", "ERT En-Route")

// -- AMBER TEAM --

/datum/response_team/amber
	engineering_outfit = /datum/outfit/job/centcom/response_team/engineer/amber
	security_outfit = /datum/outfit/job/centcom/response_team/security/amber
	medical_outfit = /datum/outfit/job/centcom/response_team/medic/amber
	command_outfit = /datum/outfit/job/centcom/response_team/commander/amber
	janitor_outfit = /datum/outfit/job/centcom/response_team/janitorial/amber
	paranormal_outfit = /datum/outfit/job/centcom/response_team/paranormal/amber

/datum/response_team/amber/announce_team()
	command_announcement.Announce("Attention, [station_name()]. We are sending a code AMBER light Emergency Response Team. Standby.", "ERT En-Route")

// -- RED TEAM --

/datum/response_team/red
	engineering_outfit = /datum/outfit/job/centcom/response_team/engineer/red
	security_outfit = /datum/outfit/job/centcom/response_team/security/red
	medical_outfit = /datum/outfit/job/centcom/response_team/medic/red
	command_outfit = /datum/outfit/job/centcom/response_team/commander/red
	janitor_outfit = /datum/outfit/job/centcom/response_team/janitorial/red
	paranormal_outfit = /datum/outfit/job/centcom/response_team/paranormal/red

/datum/response_team/red/announce_team()
	command_announcement.Announce("Attention, [station_name()]. We are sending a code RED Emergency Response Team. Standby.", "ERT En-Route")

// -- GAMMA TEAM --

/datum/response_team/gamma
	engineering_outfit = /datum/outfit/job/centcom/response_team/engineer/gamma
	security_outfit = /datum/outfit/job/centcom/response_team/security/gamma
	medical_outfit = /datum/outfit/job/centcom/response_team/medic/gamma
	command_outfit = /datum/outfit/job/centcom/response_team/commander/gamma
	janitor_outfit = /datum/outfit/job/centcom/response_team/janitorial/gamma
	paranormal_outfit = /datum/outfit/job/centcom/response_team/paranormal/gamma
	cyborg_unlock = 1

/datum/response_team/gamma/announce_team()
	command_announcement.Announce("Attention, [station_name()]. We are sending a code GAMMA elite Emergency Response Team. Standby.", "ERT En-Route")

/datum/outfit/job/centcom/response_team
	name = "Response team"
	var/rt_assignment = "Emergency Response Team Member"
	var/rt_job = "This is a bug"
	id = /obj/item/weapon/card/id/centcom/ERT
	l_ear = /obj/item/device/radio/headset/ert

	implants = list(/obj/item/weapon/implant/loyalty)

/datum/outfit/job/centcom/response_team/pre_equip()
	. = ..()
	backpack_contents.Insert(1, /obj/item/weapon/storage/box/responseteam)
	backpack_contents[/obj/item/weapon/storage/box/responseteam] = 1

/datum/outfit/job/centcom/response_team/imprint_idcard(mob/living/carbon/human/H)
	var/obj/item/weapon/card/id/W = H.wear_id
	if(!istype(W))
		return
	W.assignment = rt_assignment
	W.rank = W.assignment
	W.age = H.age
	W.sex = capitalize(H.gender)
	W.registered_name = H.real_name
	W.name = "[H.real_name]'s ID Card ([rt_job])"
	W.access = get_centcom_access(W.assignment)
	if(H.mind && H.mind.initial_account && H.mind.initial_account.account_number)
		W.associated_account_number = H.mind.initial_account.account_number

/datum/outfit/job/centcom/response_team/imprint_pda(mob/living/carbon/human/H)
	var/obj/item/device/pda/PDA = H.get_equipped_item(slot_r_store)
	if(istype(PDA))
		PDA.owner = H.real_name
		PDA.ownjob = rt_assignment
		PDA.ownrank = rt_assignment
		PDA.name = "PDA-[H.real_name] ([PDA.ownjob])"

/datum/outfit/job/centcom/response_team/commander
	name = "RT Commander"
	rt_assignment = "Emergency Response Team Leader"
	rt_job = "Emergency Response Team Leader"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	back = /obj/item/weapon/storage/backpack/ert/commander
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/swat
	glasses = /obj/item/clothing/glasses/sunglasses

	id = /obj/item/weapon/card/id/centcom/ERT

	l_pocket = /obj/item/weapon/pinpointer
	r_pocket = /obj/item/device/pda/heads

	backpack_contents = list(
		/obj/item/clothing/mask/gas/swat = 1,
		/obj/item/weapon/handcuffs = 1,
		/obj/item/weapon/storage/lockbox/loyalty = 1,
		/obj/item/weapon/melee/telebaton = 1
	)

/datum/outfit/job/centcom/response_team/commander/amber
	name = "RT Commander (Amber)"

	suit = /obj/item/clothing/suit/armor/vest/ert/command
	belt = /obj/item/weapon/gun/energy/gun

/datum/outfit/job/centcom/response_team/commander/red
	name = "RT Commander (Red)"

	suit = /obj/item/clothing/suit/armor/vest/ert/command
	belt = /obj/item/weapon/gun/energy/gun

/datum/outfit/job/centcom/response_team/commander/gamma
	name = "RT Commander (Gamma)"

	suit = /obj/item/clothing/suit/armor/vest/ert/command
	belt = /obj/item/weapon/gun/energy/gun

/datum/outfit/job/centcom/response_team/security
	name = "RT Security"
	rt_job = "Emergency Response Team Officer"
	uniform = /obj/item/clothing/under/ert
	back = /obj/item/weapon/storage/backpack/ert/security
	belt = /obj/item/weapon/storage/belt/security/tactical
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/black
	id = /obj/item/weapon/card/id/centcom/ERT
	glasses = /obj/item/clothing/glasses/sunglasses

	var/has_grenades = FALSE

	backpack_contents = list(
		/obj/item/clothing/mask/gas/swat = 1,
		/obj/item/weapon/storage/box/zipties = 1
	)

/datum/outfit/job/centcom/response_team/security/pre_equip()
	. = ..()
	if(has_grenades)
		var/grenadebox = /obj/item/weapon/storage/box/flashbangs
		if(prob(50))
			grenadebox = /obj/item/weapon/storage/box/teargas
		backpack_contents.Insert(1, grenadebox)
		backpack_contents[grenadebox] = 1

/datum/outfit/job/centcom/response_team/security/amber
	name = "RT Security (Amber)"

/datum/outfit/job/centcom/response_team/security/red
	name = "RT Security (Red)"
	has_grenades = TRUE

	//r_hand = /obj/item/weapon/gun/energy/lasercannon


/datum/outfit/job/centcom/response_team/security/gamma
	name = "RT Security (Gamma)"
	has_grenades = TRUE
	shoes = /obj/item/clothing/shoes/magboots
	gloves = /obj/item/clothing/gloves/combat

	//r_hand = /obj/item/weapon/gun/energy/pulse/carbine

/datum/outfit/job/centcom/response_team/engineer
	name = "RT Engineer"
	rt_job = "Emergency Response Team Engineer"
	back = /obj/item/weapon/storage/backpack/ert/engineer
	uniform = /obj/item/clothing/under/rank/engineer
	shoes = /obj/item/clothing/shoes/magboots
	gloves = /obj/item/clothing/gloves/yellow
	glasses = /obj/item/clothing/glasses/meson

	belt = /obj/item/weapon/storage/belt/utility/full/

	l_pocket = /obj/item/device/t_scanner

	id = /obj/item/weapon/card/id/centcom/ERT

	backpack_contents = list(
		/obj/item/clothing/mask/gas = 1,
	)

/datum/outfit/job/centcom/response_team/engineer/amber
	name = "RT Engineer (Amber)"


/datum/outfit/job/centcom/response_team/engineer/red
	name = "RT Engineer (Red)"

	backpack_contents = list(
		/obj/item/clothing/mask/gas = 1,
		/obj/item/weapon/rcd = 1,
		/obj/item/weapon/rcd_ammo = 3,
		/obj/item/weapon/gun/energy/gun = 1
	)

/datum/outfit/job/centcom/response_team/engineer/gamma
	name = "RT Engineer (Gamma)"

	backpack_contents = list(
		/obj/item/clothing/mask/gas = 1,
		/obj/item/weapon/rcd/ = 1,
		/obj/item/weapon/rcd_ammo = 3,
		/obj/item/weapon/gun/energy/pulse/pistol = 1
	)

/datum/outfit/job/centcom/response_team/medic
	name = "RT Medic"
	rt_job = "Emergency Response Team Medic"
	uniform = /obj/item/clothing/under/rank/medical
	glasses = /obj/item/clothing/glasses/hud/health
	gloves = /obj/item/clothing/gloves/latex
	shoes = /obj/item/clothing/shoes/white
	back = /obj/item/weapon/storage/backpack/ert/medical
	belt = /obj/item/weapon/storage/belt/medical
	id = /obj/item/weapon/card/id/centcom/ERT

	l_pocket = /obj/item/weapon/reagent_containers/hypospray

	backpack_contents = list(
		/obj/item/clothing/mask/surgical = 1,
		/obj/item/weapon/storage/firstaid/o2 = 1,
		/obj/item/weapon/storage/firstaid/brute = 1,
		/obj/item/weapon/storage/firstaid/adv = 1,
	)

/datum/outfit/job/centcom/response_team/medic/amber
	name = "RT Medic (Amber)"

/datum/outfit/job/centcom/response_team/medic/red
	name = "RT Medic (Red)"
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/latex/nitrile


	backpack_contents = list(
		/obj/item/clothing/mask/surgical = 1,
		/obj/item/weapon/storage/firstaid/o2 = 1,
		/obj/item/weapon/storage/firstaid/toxin = 1,
		/obj/item/weapon/storage/firstaid/adv = 1,
		/obj/item/weapon/storage/firstaid/surgery = 1,
		/obj/item/weapon/gun/energy/gun = 1,
		/obj/item/clothing/shoes/magboots = 1
	)

/datum/outfit/job/centcom/response_team/medic/gamma
	name = "RT Medic (Gamma)"
	gloves = /obj/item/clothing/gloves/combat

	backpack_contents = list(
		/obj/item/clothing/mask/gas = 1,
		/obj/item/weapon/storage/firstaid/o2 = 1,
		/obj/item/weapon/storage/firstaid/toxin = 1,
		/obj/item/weapon/storage/firstaid/adv = 1,
		/obj/item/weapon/storage/firstaid/surgery = 1,
		/obj/item/weapon/gun/energy/gun = 1,
		/obj/item/clothing/shoes/magboots = 1
	)

/datum/outfit/job/centcom/response_team/paranormal
	name = "RT Paranormal"
	rt_job = "Emergency Response Team Inquisitor"
	uniform = /obj/item/clothing/under/rank/chaplain
	back = /obj/item/weapon/storage/backpack/ert/security
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/hud/security
	belt = /obj/item/weapon/storage/belt/security
	id = /obj/item/weapon/card/id/centcom/ERT
	backpack_contents = list(
		/obj/item/clothing/mask/gas = 1,
		/obj/item/weapon/storage/box/zipties = 1,
		/obj/item/device/flashlight = 1)

/datum/outfit/job/centcom/response_team/paranormal/amber
	name = "RT Paranormal (Amber)"

	suit = /obj/item/clothing/suit/armor/vest/ert/security
	r_pocket = /obj/item/weapon/nullrod

/datum/outfit/job/centcom/response_team/paranormal/red
	name = "RT Paranormal (Red)"

	suit_store = /obj/item/weapon/gun/energy/gun/nuclear
	r_pocket = /obj/item/weapon/nullrod

/datum/outfit/job/centcom/response_team/paranormal/gamma
	name = "RT Paranormal (Gamma)"
	suit_store = /obj/item/weapon/gun/energy/gun/nuclear
	r_pocket = /obj/item/weapon/gun/energy/pulse/pistol
	shoes = /obj/item/clothing/shoes/magboots/

/datum/outfit/job/centcom/response_team/janitorial
	name = "RT Janitor"
	rt_job = "Emergency Response Team Janitor"
	uniform = /obj/item/clothing/under/purple
	back = /obj/item/weapon/storage/backpack/security
	belt = /obj/item/weapon/storage/belt/janitor 
	gloves = /obj/item/clothing/gloves/purple
	shoes = /obj/item/clothing/shoes/galoshes
	l_ear = /obj/item/device/radio/headset/ert
	id = /obj/item/weapon/card/id/centcom/ERT
	backpack_contents = list(
		/obj/item/weapon/grenade/chem_grenade/antiweed = 2,
		/obj/item/weapon/reagent_containers/spray/cleaner = 1,
		/obj/item/weapon/storage/bag/trash = 1,
		/obj/item/weapon/storage/box/lights/mixed = 1,
		/obj/item/device/flashlight = 1)

/datum/outfit/job/centcom/response_team/janitorial/amber
	name = "RT Janitor (Amber)"
	glasses = /obj/item/clothing/glasses/sunglasses

/datum/outfit/job/centcom/response_team/janitorial/red
	name = "RT Janitor (Red)"
	glasses = /obj/item/clothing/glasses/hud/security
	suit_store = /obj/item/weapon/gun/energy/gun

/datum/outfit/job/centcom/response_team/janitorial/gamma
	name = "RT Janitor (Gamma)"
	glasses = /obj/item/clothing/glasses/hud/security
	gloves = /obj/item/clothing/gloves/combat
	suit_store = /obj/item/weapon/gun/energy/pulse/pistol
	shoes = /obj/item/clothing/shoes/magboots

/obj/item/device/radio/centcom
	name = "centcomm bounced radio"
	frequency = ERT_FREQ
	icon_state = "radio"

/obj/item/weapon/storage/box/responseteam/
	name = "boxed survival kit"

/obj/item/weapon/storage/box/responseteam/New()
	..()
	contents = list()
	sleep(1)
	new /obj/item/clothing/mask/breath( src )
	new /obj/item/weapon/tank/emergency_oxygen/engi( src )
	new /obj/item/device/flashlight/flare( src )
	new /obj/item/weapon/material/hatchet/tacknife( src )
	new /obj/item/device/radio/centcom( src )
	return
