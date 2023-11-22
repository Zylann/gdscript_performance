extends "test.gd"

# Arguments mimick `test_engine_func.gd`
func get_description() -> String:
	return "Call script class func(str, bool, bool)"


class TestObj:
	func foo(a, b, c):
		pass


func execute():
	var obj = TestObj.new()
	
	var a = ""
	var b = false
	var c = false
	
	for i in range(0,ITERATIONS):
		obj.foo(a, b, c)


