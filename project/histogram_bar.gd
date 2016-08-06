
extends Control


func set_unit_value(v):
	var fill = get_node("TextureFrame")
	var h = get_size().y
	fill.set_margin(MARGIN_TOP, h * v)

