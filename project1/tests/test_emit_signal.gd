extends "test.gd"

var description = "Emit not-connected signal"

#signal test_signal


func execute():
	for i in range(0, ITERATIONS):
		emit_signal("test_signal")

