extends "test.gd"

var description = "While time (one very long while)"


func should_subtract_loop_duration():
	return false


func execute():
	var i = 0
	while i < ITERATIONS:
		i += 1
