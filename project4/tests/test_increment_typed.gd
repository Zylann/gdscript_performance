extends "test.gd"

func get_description() -> String:
	return "Increment (typed)"

func execute():
	var a := 0
	for i in range(0, ITERATIONS):
		a += 1

