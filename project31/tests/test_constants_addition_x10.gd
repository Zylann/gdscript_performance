extends "test.gd"

var description = "Add 10 constants"

const CONST01 = 0
const CONST02 = 0
const CONST03 = 0
const CONST04 = 0
const CONST05 = 0
const CONST06 = 0
const CONST07 = 0
const CONST08 = 0
const CONST09 = 0
const CONST10 = 0

func execute():
	for i in range(0, ITERATIONS):
		var x = CONST01 + CONST02 + CONST03 + CONST04 + CONST05 + CONST06 + CONST07 + CONST08 + CONST09 + CONST10
