extends "test.gd"

var description = "Increment"

func execute():
	var a = 0
	for i in range(0, ITERATIONS):
		a += 1

