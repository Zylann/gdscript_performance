extends "test.gd"

# Arguments mimick `test_engine_func_typed.gd`
func get_description() -> String:
	return "Call script class func(str, bool, bool) using Callable"

class TestObj:
	func foo(a: String, b: bool, c: bool):
		pass


func execute():
	var obj = TestObj.new()
	
	var a := ""
	var b := false
	var c := false
	
	var callable : Callable = obj.foo
	
	for i in range(0,ITERATIONS):
		callable.call(a, b, c)

