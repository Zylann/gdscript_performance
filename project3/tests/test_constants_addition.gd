extends "test.gd"

var description = "Add two constants"

const CONST01 = 0
const CONST02 = 0

func execute():
	for i in range(0,ITERATIONS):
		var x = CONST01 + CONST02
