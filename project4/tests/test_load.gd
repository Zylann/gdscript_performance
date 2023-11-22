extends "test.gd"

func get_description() -> String:
	return "Cost of load() (regardless of resource)"

func execute():
	# Hold a reference to the resource so we are sure to only measure the time to fetch it from cache
	var res = load("res://tests/test.gd")
	
	for i in range(0, ITERATIONS):
		load("res://tests/test.gd")

