extends "test.gd"

func get_description() -> String:
	return "String format with 10 numbers"


func can_run(context):
	var v = context.engine_version.major
	return v != "1" and v != "2"


func setup():
	# This test takes long
	ITERATIONS /= 5


func execute():
	var a = 42
	for i in range(0, ITERATIONS):
		"abc {0} abc {1} abc {2} abc {3} abc {4} abc {5} abc {6} abc {7} abc {8} abc {9}".format([a,a,a,a,a,a,a,a,a,a])
