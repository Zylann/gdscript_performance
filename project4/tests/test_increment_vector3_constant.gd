extends "test.gd"

func get_description() -> String:
	return "Increment Vector3 with constant"


func execute():
	var a = Vector3(0,0,0)
	
	for i in range(0, ITERATIONS):
		a += Vector3(1,1,1)
