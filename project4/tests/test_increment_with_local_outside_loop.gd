extends "test.gd"

func get_description() -> String:
	return "Increment with local (outside loop)"

func execute():
	var a = 0
	var b = 1
	
	for i in range(0,ITERATIONS):
		a += b

