extends "test.gd"

var description = "Increment (typed)"

func execute():
	var a := 0
	for i in range(0, ITERATIONS):
		a += 1

