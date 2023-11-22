extends "test.gd"

func get_description() -> String:
	return "Increment with class member"

class TestClassForMemberAccess:
	var x = 0

func execute():
	var a = 0
	var c = TestClassForMemberAccess.new()
	for i in range(0, ITERATIONS):
		a += c.x

