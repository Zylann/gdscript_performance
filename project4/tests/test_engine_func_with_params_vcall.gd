extends "test.gd"


func get_description() -> String:
	return "Call engine func with params (str, bool, bool) using `call` (typed)"


func execute():
	var obj := Node.new()
	
	var a := "a"
	var b := false
	var c := false
	
	# Function was chosen for almost doing nothing C++ side
	for i in range(0,ITERATIONS):
		obj.call(&"find_child", a, b, c)
	
	obj.free()

