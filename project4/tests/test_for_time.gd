extends "test.gd"

func get_description() -> String:
	return "For time (one very long for)"


func should_subtract_loop_duration():
	return false


func execute():
	for i in range(0, ITERATIONS):
		pass
