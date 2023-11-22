extends "test.gd"

func get_description() -> String:
	return "Instance class with long name (no member variables)"

class TestClassWithLongNameWithLongNameWithLongNameWithLongNameWithLongNameWithLongNameWithLongNameWithLongNameWithLongName:
	func foo():
		pass

func execute():
	for i in range(0, ITERATIONS):
		TestClassWithLongNameWithLongNameWithLongNameWithLongNameWithLongNameWithLongNameWithLongNameWithLongNameWithLongName.new()

