extends "test.gd"

var description = "Increment with local (inside loop)"

func execute():
	var a = 0
	
	for i in range(0, ITERATIONS):
		var b = 1
		a += b

