extends "test.gd"

var description = "Cost of preload() (regardless of resource)"

func execute():
	# Hold a reference to the resource so we are sure to only measure the time to fetch it from cache
	var res = preload("test.gd")
	
	for i in range(0, ITERATIONS):
		preload("test.gd")

