extends "test.gd"

func get_description() -> String:
	return "Increment with array member using typed GDScript (TypedArray)"

func execute():
	var a := 0
	var arr : Array[int] = [1]
	for i in range(0, ITERATIONS):
		a += arr[0]
