#define UIDEBUG

/var/datum/controller/subsystem/ghostroles/SSghostroles

/datum/controller/subsystem/ghostroles
	name = "Ghost Roles"
	flags = SS_NO_FIRE
	init_order = SS_INIT_MISC_FIRST

	var/list/spawnpoints = list() //List of the available spawnpoints by spawnpoint type
		// -> type 1 -> spawnpoint 1
		//           -> spawnpoint 2

	var/list/spawners = list() //List of the available spawner datums

/datum/controller/subsystem/ghostroles/Recover()
	src.spawnpoints = SSghostroles.spawnpoints
	src.spawners = SSghostroles.spawners

/datum/controller/subsystem/ghostroles/New()
	NEW_SS_GLOBAL(SSghostroles)
	for(var/spawner in subtypesof(/datum/ghostspawner))
		var/datum/ghostspawner/G = new spawner
		//Check if we hae name, short_name and desc set
		if(!G.short_name || !G.name || !G.desc)
			qdel(G)
			continue
		LAZYSET(spawners, G.short_name, G)

//Adds a spawnpoint to the spawnpoint list
/datum/controller/subsystem/ghostroles/proc/add_spawnpoints(var/obj/structure/ghostspawner/G)
	if(!G.identifier) //If the spawnpoint has no identifier -> Abort
		log_ss("ghostroles","Spawner [G] at [G.x],[G.y],[G.z] has no identifier set")
		qdel(G)
		return

	if(!(G.identifier in spawnpoints))
		spawnpoints[G.identifier] = list()
	
	spawnpoints[G.identifier].Add(G)
	
/datum/controller/subsystem/ghostroles/proc/remove_spawnpoints(var/obj/structure/ghostspawner/G)
	spawnpoints[G.identifier].Remove(G)
	return

//Returns the turf where the spawnpoint is located and updates the spawner to be used
/datum/controller/subsystem/ghostroles/proc/get_spawnpoint(var/identifier, var/use = TRUE)
	if(!identifier) //If no identifier ist set, return false
		return FALSE
	if(!spawnpoints[identifier] || !length(spawnpoints[identifier])) //If we have no spawnpoints for that identifier, return false
		return FALSE

	for (var/spawnpoint in spawnpoints[identifier])
		var/obj/structure/ghostspawner/G = spawnpoint
		if(G.is_available())
			if(use)
				G.spawn_mob()
			return get_turf(G)

/datum/controller/subsystem/ghostroles/proc/get_spawner_data(mob/user)
	var/list/data = list()

	for(var/s in spawners)
		var/datum/ghostspawner/G = spawners[s]
		if(G.cant_see(user))
			continue
		data[G.short_name] = list()
		data[G.short_name]["name"] = G.name
		data[G.short_name]["desc"] = G.desc
		data[G.short_name]["cant_spawn"] = G.cant_spawn(user)
		data[G.short_name]["can_edit"] = G.can_edit(user)
		data[G.short_name]["enabled"] = G.enabled
	
	return data

/datum/controller/subsystem/ghostroles/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user,src)
	if(!ui)
		ui = new(user,src,"misc-ghostspawner",500,700,"Ghostspawner")
	ui.open()

/datum/controller/subsystem/ghostroles/vueui_data_change(var/list/newdata, var/mob/user, var/datum/vueui/ui)
	if(!newdata)
		var/list/data = list()
		data["spawners"] = get_spawner_data(user)
		return data
	

	// Here we can add checks for difference of state and alter it
	// or do actions depending on its change
	//if(newdata["counter"] >= 10)
	//	return list("counter" = 0)

/datum/controller/subsystem/ghostroles/Topic(href, href_list)

	if(href_list["action"] == "spawn")
		var/datum/ghostspawner/S = spawners[href_list["spawner"]]
		if(!S)
			return
		if(S.cant_spawn(src))
			return
		S.pre_spawn(src)
		S.spawn_mob(src)
		S.post_spawn(src)
	if(href_list["action"] == "enable")
		var/datum/ghostspawner/S = spawners[href_list["spawner"]]
		if(!S)
			return
		if(!S.can_edit(src))
			return
		S.enable()

	if(href_list["action"] == "disable")
		var/datum/ghostspawner/S = spawners[href_list["spawner"]]
		if(!S)
			return
		if(!S.can_edit(src))
			return
		S.disable()

	return