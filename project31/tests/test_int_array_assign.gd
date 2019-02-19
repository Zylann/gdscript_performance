extends "test.gd"

var description = "IntArray set element"

func execute():
	var i_array = PoolIntArray()
	i_array.resize(100)
	
	for i in range(0, ITERATIONS):
		i_array[42] = 0
