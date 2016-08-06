
extends Control

#export var bar_width = 20
export var bar_margin = 1

var _ratios = []
#var _tags = ["A", "B", "C", "D"]
var _bars = []
var _hovered_index = -1
onready var _graph = get_node("graph")


#func _ready():
#	connect("input_event", self, "_on_input_event")


func set_test_name(name):
	get_node("Label").set_text(name)


func set_test_times(times, tags):
	_ratios.clear()
	if times.size() == 0:
		return
	
	var max_time = 0
	for i in range(0, times.size()):
		var t = times[i]
		if t != null:
			max_time = max(t, max_time)
	
	_ratios.resize(times.size())
	for i in range(0, times.size()):
		var t = times[i]
		if t != null:
			_ratios[i] = t / max_time
	
	for bar in _bars:
		bar.queue_free()
	
	var pos = Vector2()
	var bar_res = preload("histogram_bar.tscn")
	_bars.resize(_ratios.size())
	for i in range(0, _bars.size()):
		var bar = bar_res.instance()
		_graph.add_child(bar)
		bar.set_unit_value(_ratios[i])
		if tags != null and i < tags.size() and tags[i] != null:
			bar.set_tooltip(tags[i])
		bar.set_pos(pos)
		pos.x += bar.get_size().x + bar_margin
		_bars[i] = bar
	

	#update()


#func _on_input_event(event):
#	print("Event " + str(event.type))
#	if event.type == InputEvent.MOUSE_MOTION:
#		var x = event.x - _graph.get_pos().x
#		var i = int(x / (bar_width + bar_margin))
#		_set_hovered_index(i)
#
#
#func _set_hovered_index(i):
#	if i < 0 or i >= _ratios.size():
#		i = -1
#	if i != _hovered_index:
#		_hovered_index = i
#		if i < _tags.size() and _tags[i] != null:
#			set_tooltip(_tags[i])
#		update()
#
#
#func _draw():
#	var pos = _graph.get_pos()
#	var max_height = _graph.get_size().y
#	for i in range(0, _ratios.size()):
#		var ratio = _ratios[i]
#		if ratio != null:
#			var h = max_height * ratio
#			var color = Color(1,0.5,0)
#			if _hovered_index == i:
#				color = Color(1, 0.7, 0)
#			draw_rect(Rect2(pos + Vector2(0,max_height-h), Vector2(bar_width, h)), color)
#		pos.x += bar_width + 1

