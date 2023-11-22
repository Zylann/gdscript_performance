extends "test.gd"

func get_description() -> String:
	return "IntArray set element"

func execute():
	var i_array = PackedInt32Array()
	i_array.resize(100)
	
	for i in range(0, ITERATIONS):
		i_array[42] = 0
