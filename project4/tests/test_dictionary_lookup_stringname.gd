extends "test.gd"

func get_description() -> String:
	return "Dictionary lookup with StringName key (x10)"


var _dict : Dictionary = {}

func setup():
	for i in 100:
		_dict[StringName(str("string_key_", i))] = true


func execute():
	for i in range(0, ITERATIONS):
		_dict[&"string_key_0"]
		_dict[&"string_key_10"]
		_dict[&"string_key_20"]
		_dict[&"string_key_30"]
		_dict[&"string_key_40"]
		_dict[&"string_key_50"]
		_dict[&"string_key_60"]
		_dict[&"string_key_70"]
		_dict[&"string_key_80"]
		_dict[&"string_key_90"]

