extends "test.gd"

var description = "Increment with member var using self"

var _test_a = 0


func execute():
	var a = 0
	for i in range(0,ITERATIONS):
		a += self._test_a

