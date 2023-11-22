extends "test.gd"


func get_description() -> String:
	return "Empty func (void function call cost)"


func execute():
	for i in range(0,ITERATIONS):
		empty_func()


func empty_func():
	pass

