extends "test.gd"

func get_description() -> String:
	return "Emit not-connected signal using new Godot 4 syntax"

signal test_signal


func execute():
	for i in range(0, ITERATIONS):
		test_signal.emit()

