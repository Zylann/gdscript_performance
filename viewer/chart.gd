extends Control

export var line_color = Color(1, 1, 0)

var _data = []
var _window = Rect2(0, 0, 1, 1)
var _transform = Transform2D()


func set_data(data):
	assert(typeof(data) == TYPE_ARRAY)
	_data = data


func scale_to_fit():
	
	if len(_data) != 0:
		var xmin = _data[0].x
		var xmax = xmin
		var ymin = _data[0].y
		var ymax = ymin
	
		for v in _data:
			xmin = min(xmin, v.x)
			xmax = max(xmax, v.x)
			ymin = min(ymin, v.y)
			ymax = max(ymax, v.y)
		
		_window = Rect2(Vector2(xmin, ymin), Vector2(xmax - xmin, ymax - ymin))
	
	update()
	

func _update_transform():
	var xscale = 1.0
	var yscale = 1.0
	
	if _window.size.x > 0:
		xscale = rect_size.x / _window.size.x
	if _window.size.y > 0:
		yscale = rect_size.y / _window.size.y
	
	var h = rect_size.y
	
	# TODO Non-zero origin
	_transform = Transform2D(Vector2(xscale, 0.0), Vector2(0.0, -yscale), Vector2(0, h))


func get_window():
	return _transform


func set_window(win):
	_window = win
	update()


func _draw():
	_update_transform()
	
	var ci = self
	var col = line_color
	
	for i in range(1, len(_data)):
		var p0 = _transform.xform(_data[i - 1])
		var p1 = _transform.xform(_data[i])
		ci.draw_line(p0, p1, col)


