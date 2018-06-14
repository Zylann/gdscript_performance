extends "test.gd"

var description = "String format with 1 number"

func can_run(context):
	var v = context.engine_version.major
	return v != "1" and v != "2"


func execute():
	var a = 42
	for i in range(0, ITERATIONS):
		"abc {0}".format([a])
