extends "test.gd"

func get_description() -> String:
	return "String str(i)"


func execute():
	for i in range(0, ITERATIONS):
		str(i)

