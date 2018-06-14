extends "test.gd"

var description = "Increment Vector2"

func execute():
	var a = Vector2(0,0)
	var b = Vector2(1,1)
	
	for i in range(0, ITERATIONS):
		a += b

