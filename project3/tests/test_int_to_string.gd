extends "test.gd"

var description = "String str(i)"


func execute():
	for i in range(0, ITERATIONS):
		str(i)

