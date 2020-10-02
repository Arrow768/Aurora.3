/datum/ghostspawner/mining_drone
	short_name = "mining_drone"
	name = "Mining Drone"
	desc = "Join in as a Mining Drone, assist the miners, get lost on the asteroid and cry synthetic tears."
	tags = list("Stationbound")

	respawn_flag = MINISYNTH //Flag to check for when trying to spawn someone of that type (CREW, ANIMAL, MINISYNTH)
	jobban_job = "Cyborg"
	loc_type = GS_LOC_ATOM

	spawn_mob = /mob/living/silicon/robot/drone/mining
