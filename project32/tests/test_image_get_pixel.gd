extends "test.gd"

var description = "Image get pixel"


func execute():
	var im = Image.new()
	im.create(512, 512, false, Image.FORMAT_RGB8)
	
	im.lock()

	for i in range(0, ITERATIONS):
		im.get_pixel(42, 84)
	
	im.unlock()

