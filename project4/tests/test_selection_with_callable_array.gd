extends "test.gd"

func get_description() -> String:
	return "Switch using array of callables with 10 entries"


var _array : Array[Callable] = []


func setup():
	_array.resize(10)
	_array[0] = _handle_0
	_array[1] = _handle_1
	_array[2] = _handle_2
	_array[3] = _handle_3
	_array[4] = _handle_4
	_array[5] = _handle_5
	_array[6] = _handle_6
	_array[7] = _handle_7
	_array[8] = _handle_8
	_array[9] = _handle_9


func execute():
	var v := 9
	
	for i in range(0, ITERATIONS):
		_array[v].call()


func _handle_0():
	pass

func _handle_1():
	pass

func _handle_2():
	pass

func _handle_3():
	pass

func _handle_4():
	pass

func _handle_5():
	pass

func _handle_6():
	pass

func _handle_7():
	pass

func _handle_8():
	pass

func _handle_9():
	pass

