extends "test.gd"

func get_description() -> String:
	return "Dictionary lookup with int key (x10)"


var _dict : Dictionary = {}

func setup():
	for i in 100:
		_dict[i] = true


func execute():
	for i in range(0, ITERATIONS):
		_dict[0]
		_dict[10]
		_dict[20]
		_dict[30]
		_dict[40]
		_dict[50]
		_dict[60]
		_dict[70]
		_dict[80]
		_dict[90]

