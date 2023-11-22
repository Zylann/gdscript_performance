extends "test.gd"

func get_description() -> String:
	return "Increment with dictionary member"


func execute():
	var a = 0
	var dic = {b = 1}
	for i in range(0,ITERATIONS):
		a += dic.b

