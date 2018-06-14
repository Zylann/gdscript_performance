extends "test.gd"

var description = "Instance class (no member variables)"


class TestClass1:
	func foo():
		pass


func execute():
	for i in range(0, ITERATIONS):
		TestClass1.new()
