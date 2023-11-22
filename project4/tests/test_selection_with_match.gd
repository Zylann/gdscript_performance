extends "test.gd"

func get_description() -> String:
	return "Switch using match with 10 entries"


func execute():
	var v := 9
	
	for i in range(0, ITERATIONS):
		match v:
			0:
				pass
			1:
				pass
			2:
				pass
			3:
				pass
			4:
				pass
			5:
				pass
			6:
				pass
			8:
				pass
			9:
				pass
