extends Control

@export var line_color := Color(1, 1, 0)

var _data := PackedVector2Array()
var _window := Rect2(0, 0, 1, 1)
var _transform := Transform2D()


func set_data(data: PackedVector2Array):
	_data = data


func get_data():
	return _data


func scale_to_fit():
	if len(_data) != 0:
		# TODO Have this as parameter maybe?
		var xmin = 0.0#_data[0].x
		var xmax = xmin
		var ymin = 0.0#_data[0].y
		var ymax = ymin
	
		for v in _data:
			xmin = minf(xmin, v.x)
			xmax = maxf(xmax, v.x)
			ymin = minf(ymin, v.y)
			ymax = maxf(ymax, v.y)
		
		_window = Rect2(Vector2(xmin, ymin), Vector2(xmax - xmin, ymax - ymin))
	
	queue_redraw()
	

func _update_transform():
	var xscale := 1.0
	var yscale := 1.0
	
	if _window.size.x > 0:
		xscale = size.x / _window.size.x
	if _window.size.y > 0:
		yscale = size.y / _window.size.y
	
	var h := size.y
	
	# TODO Non-zero origin
	_transform = Transform2D(Vector2(xscale, 0.0), Vector2(0.0, -yscale), Vector2(0, h))


func get_chart_window() -> Rect2:
	return _window


func set_chart_window(win: Rect2):
	_window = win
	queue_redraw()


func _draw():
	_update_transform()
	
	var ci := self
	var col := line_color
	
	for i in range(1, _data.size()):
		var wp0 := _data[i - 1]
		var wp1 := _data[i]
		var p0 := _transform * wp0
		var p1 := _transform * wp1
		ci.draw_line(p0, p1, col)


