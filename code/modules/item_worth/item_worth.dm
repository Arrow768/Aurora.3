/proc/get_item_value(atom/A) // A can be either type *or* instance; ie get_item_value(/obj) is valid, as is get_item_value(new /obj)
	var/atom/t = ispath(A) ? A : A.type
	while(!(t in SSItemWorths.worths)) // Find the first parent that is in the list
		t = PARENT(t)
		if(!t)
			return 0
	var/value = SSItemWorths.worths[t]
	if(value >= 0) // Value zero or greater than zero, all instances have same value
		return value
	else // Negative. If it's a path, use -x, otherwise call Value() on the instance
		if(ispath(A))
			return -value
		return A.Value(-value)