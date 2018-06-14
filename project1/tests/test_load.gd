extends "test.gd"

var description = "Cost of load() (regardless of resource)"

func execute():
	# Hold a reference to the resource so we are sure to only measure the time to fetch it from cache
	# Godot 1.1 apparently cannot load with relative path...
	var res = load("res://tests/test.gd")
	
	for i in range(0, ITERATIONS):
		load("res://tests/test.gd")

