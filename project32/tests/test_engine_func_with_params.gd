extends "test.gd"


var description = "Call engine func with params (str, bool, bool)"


func execute():
	var obj = Node.new()
	
	var a = ""
	var b = false
	var c = false
	
	# Function was chosen for almost doing nothing C++ side
	for i in range(0,ITERATIONS):
		obj.find_node(a, b, c)
	
	obj.free()

