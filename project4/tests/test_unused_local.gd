extends "test.gd"

func get_description() -> String:
	return "Unused local (declaration cost)"


func execute():
	for i in range(0, ITERATIONS):
		var b = 1
