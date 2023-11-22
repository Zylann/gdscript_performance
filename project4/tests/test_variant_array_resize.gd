extends "test.gd"

func get_description() -> String:
	return "VariantArray resize(1000)"


func execute():
	for i in range(0, ITERATIONS):
		var line = []
		line.resize(1000)
