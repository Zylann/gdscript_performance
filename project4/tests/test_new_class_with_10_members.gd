extends "test.gd"

func get_description() -> String:
	return "Instance class (10 member variables)"

class TestClass10:
	var v0 = 0
	var v1 = 0
	var v2 = 0
	var v3 = 0
	var v4 = 0
	var v5 = 0
	var v6 = 0
	var v7 = 0
	var v8 = 0
	var v9 = 0
	func foo():
		pass

func execute():
	for i in range(0, ITERATIONS):
		TestClass10.new()
