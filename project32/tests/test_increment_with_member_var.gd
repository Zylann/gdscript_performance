extends "test.gd"

var description = "Increment with member var"

var _test_a = 0


func execute():
	var a = 0
	for i in range(0,ITERATIONS):
		a += _test_a

