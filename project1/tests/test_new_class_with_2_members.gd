extends "test.gd"

var description = "Instance class (2 member variables)"

class TestClass2:
	var x = 0
	var y = 0
	func foo():
		pass

func execute():
	for i in range(0, ITERATIONS):
		TestClass2.new()
