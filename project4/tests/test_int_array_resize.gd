extends "test.gd"

func get_description() -> String:
	return "IntArray resize(1000)"

func execute():
	for i in range(0, ITERATIONS):
		var line = PackedInt32Array()
		line.resize(1000)
