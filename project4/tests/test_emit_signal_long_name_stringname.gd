extends "test.gd"

func get_description() -> String:
	return "Emit not-connected signal with very long name using StringName"

signal test_signal_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name


func execute():
	for i in range(0, ITERATIONS):
		emit_signal(&"test_signal_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name")

