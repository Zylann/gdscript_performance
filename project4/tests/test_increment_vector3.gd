extends "test.gd"

func get_description() -> String:
	return "Increment Vector3"


func execute():
	var a = Vector3(0,0,0)
	var b = Vector3(1,1,1)
	
	for i in range(0, ITERATIONS):
		a += b
