extends "test.gd"

func get_description() -> String:
	return "VariantArray set element"


func execute():
	var v_array = []
	v_array.resize(100)
	
	for i in range(0, ITERATIONS):
		v_array[42] = 0
