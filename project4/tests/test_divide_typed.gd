extends "test.gd"

func get_description() -> String:
	return "Divide (typed)"

func execute():
	var a := 9999
	for i in range(0, ITERATIONS):
		a /= 2
