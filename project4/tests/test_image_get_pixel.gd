extends "test.gd"


func get_description() -> String:
	return "Image get pixel"


func execute():
	var im := Image.create(512, 512, false, Image.FORMAT_RGB8)
	
	for i in range(0, ITERATIONS):
		im.get_pixel(42, 84)

