extends "test.gd"

var description = "String concat with 10 numbers str vararg"


func setup():
	# That test is quite long
	ITERATIONS /= 2


func execute():
	var a = 42
	for i in range(0, ITERATIONS):
		str("abc ", str(a), " abc ", str(a), " abc ", str(a), " abc ", str(a), " abc ", str(a), " abc ", str(a), " abc ", str(a), " abc ", str(a), " abc ", str(a), " abc ", str(a))

