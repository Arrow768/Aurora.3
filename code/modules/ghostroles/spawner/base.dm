/datum/ghostspawner
	var/short_name = null
	var/name = null
	var/desc = null
	var/welcome_message = null

	//Vars regarding the spawnpoints and conditions of the spawner
	var/list/spawnpoints = null //List of the applicable spawnpoints (by name)
	var/landmark_name = null //Alternatively you can specify a landmark name
	var/max_count = 0 //How often can this spawner be used
	var/count = 0 //How ofen has this spawner been used
	var/req_perms = null //What permission flags are required to use this spawner
	var/req_head_whitelist = FALSE //If a head of staff whitelist is required
	var/req_species_whitelist = null //Name/Datum of the species whitelist that is required, or null
	var/enabled = TRUE //If the spawnpoint is enabled
	var/enable_dmessage = TRUE //The message to send to deadchat if the ghostspawner is enabled or TRUE for a default message
	var/respawn_flag = null //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	var/jobban_job = null //If this is set to a text, then it will check if the user is banned from that job

	//Vars regarding the mob to use
	var/mob/spawn_mob = null //The mob that should be spawned
	var/list/variables = list() //Variables of that mob
	var/mob_name = FALSE //The name of that mob; If null prompts for it
	var/mob_name_prefix = null //The prefix that should be applied to the mob (i.e. CCIAA, Tpr., Cmdr.)
	var/mob_name_suffix = null //The suffix that should be applied to the mob name
	

//Return a error message if the user CANT see the ghost spawner. Otherwise FALSE
/datum/ghostspawner/proc/cant_see(mob/user) //If the user can see the spawner in the menu
	if(req_perms) //Only those with the correct flags can see restricted roles
		if(check_rights(req_perms, show_msg=FALSE, user=user))
			return FALSE //Return early and dont perform whitelist checks if staff flags are met
		else
			return "Missing Permissions"

	if(req_head_whitelist && !check_whitelist(user))
		return "Missing Head of Staff Whitelist"
	
	if(req_species_whitelist && !is_alien_whitelisted(user, req_species_whitelist))
		return "Missing Species Whitelist"

	if(jobban_job && jobban_isbanned(user,jobban_job))
		return "Job Banned"

	return FALSE

//Return a error message if the user CANT spawn. Otherwise FALSE
/datum/ghostspawner/proc/cant_spawn(mob/user) //If the user can spawn using the spawner
	if(!ROUND_IS_STARTED)
		return "The round is not started yet."
	var/cant_see = cant_see()
	if(cant_see) //If we cant see it, we cant spawn it
		return cant_see
	if(!enabled) //If the spawner id disabled, we cant spawn in
		return "This spawner is not enabled"
	if(respawn_flag && !user.MayRespawn(0,respawn_flag))
		return "You can not respawn at this time"
	if(!config.enter_allowed)
		return "There is an administrative lock on entering the game"
	if(SSticker.mode && SSticker.mode.explosion_in_progress)
		return "The station is currently exploding. Joining would go poorly."
	return FALSE

//Proc executed before someone is spawned in
/datum/ghostspawner/proc/pre_spawn(mob/user) 
	return TRUE

//This proc selects the spawnpoint to use.
/datum/ghostspawner/proc/select_spawnpoint()
	if(!isnull(spawnpoints))
		for(var/spawnpoint in spawnpoints) //Loop through the applicable spawnpoints
			var/turf/T = SSghostroles.get_spawnpoint(spawnpoint) //Gets the first matching spawnpoint or null if none are available
			if(T) //If we have a spawnpoint, return it
				return T
	if(!isnull(landmark_name))
		var/obj/effect/landmark/L
		for(var/obj/effect/landmark/landmark in landmarks_list)
			if(landmark.name == landmark_name)
				L = landmark
				return get_turf(L)

	log_debug("Ghostspawner: Spawner [short_name] has neither spawnpoints nor landmarks or a matching spawnpoint/landmark could not be found")

	return null //If we dont have anything return null

//The proc to actually spawn in the user
/datum/ghostspawner/proc/spawn_mob(mob/user)
	//OVERWRITE THIS IN THE CHILD IMPLEMENTATIONS to return the spawned in mob !!!
	return null

//Proc executed after someone is spawned in
/datum/ghostspawner/proc/post_spawn(mob/user)
	if(welcome_message)
		to_chat(user, welcome_message)
	return TRUE

//Proc to check if a specific user can edit this spawner (open/close/...)
/datum/ghostspawner/proc/can_edit(mob/user)
	if(check_rights(R_ADMIN, show_msg=FALSE, user=user))
		return TRUE
	return FALSE

//Proc to enable the ghostspawner
/datum/ghostspawner/proc/enable()
	enabled = TRUE
	if(enable_dmessage)
		for(var/mob/abstract/observer/O in player_list)
			if(O.client && !cant_see(O))
				if(enable_dmessage == TRUE)
					to_chat(O, "<span class='deadsay'><b>A ghostspawner for a \"[src.name]\" has been enabled.</b></span>")
				else
					to_chat(O, "<span class='deadsay'><b>[enable_dmessage]</b></span>")
	return TRUE

//Proc to disable the ghostspawner
/datum/ghostspawner/proc/disable()
	enabled = FALSE
	return TRUE
