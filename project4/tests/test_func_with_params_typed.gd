extends "test.gd"

# Arguments mimick `test_engine_func_typed.gd`
func get_description() -> String:
	return "Call script class func(str, bool, bool) (typed)"

class TestObj:
	func foo(a: String, b: bool, c: bool):
		pass


func execute():
	var obj := TestObj.new()
	
	var a := ""
	var b := false
	var c := false
	
	for i in range(0,ITERATIONS):
		obj.foo(a, b, c)

