extends "test.gd"

var description = "String concat with 1 number"


func execute():
	var a = 42
	for i in range(0, ITERATIONS):
		"abc" + str(a)

