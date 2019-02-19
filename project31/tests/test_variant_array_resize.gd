extends "test.gd"

var description = "VariantArray resize(1000)"

func execute():
	for i in range(0, ITERATIONS):
		var line = []
		line.resize(1000)
