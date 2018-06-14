extends "test.gd"

var description = "Emit not-connected signal with very long name"

signal test_signal_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name


func execute():
	for i in range(0, ITERATIONS):
		emit_signal("test_signal_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name_long_name")

