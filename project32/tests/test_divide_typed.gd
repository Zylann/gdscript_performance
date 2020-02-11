extends "test.gd"

var description = "Divide (typed)"

func execute():
	var a := 9999
	for i in range(0, ITERATIONS):
		a /= 2
