extends "test.gd"

var description = "Increment (x5)"

func execute():
	var a = 0
	for i in range(0,ITERATIONS):
		a += 1
		a += 1
		a += 1
		a += 1
		a += 1
