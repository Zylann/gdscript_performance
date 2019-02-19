extends "test.gd"

var description = "Increment Vector3 coordinate by coordinate"

func execute():
	var a = Vector3(0,0,0)
	var b = Vector3(1,1,1)
	
	for i in range(0, ITERATIONS):
		a.x += b.x
		a.y += b.y
		a.z += b.z
