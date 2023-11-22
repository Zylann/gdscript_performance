extends "test.gd"

func get_description() -> String:
	return "Increment with array member"

func execute():
	var a = 0
	var arr = [1]
	for i in range(0, ITERATIONS):
		a += arr[0]
