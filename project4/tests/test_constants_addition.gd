extends "test.gd"

const CONST01 = 0
const CONST02 = 0


func get_description() -> String:
	return "Add two constants"


func execute():
	for i in range(0,ITERATIONS):
		var x = CONST01 + CONST02
