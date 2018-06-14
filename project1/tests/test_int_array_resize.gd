extends "test.gd"

var description = "IntArray resize(1000)"

func execute():
	for i in range(0, ITERATIONS):
		var line = IntArray()
		line.resize(1000)
