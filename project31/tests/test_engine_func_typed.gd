extends "test.gd"


var description = "Call engine func getter (typed)"


func execute():
	var obj := Node.new()
	for i in range(0,ITERATIONS):
		obj.get_index()
	obj.free()

