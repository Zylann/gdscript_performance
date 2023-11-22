extends "test.gd"


func get_description() -> String:
	return "Call engine func getter"


func execute():
	var obj = Node.new()
	for i in range(0,ITERATIONS):
		obj.get_index()
	obj.free()

