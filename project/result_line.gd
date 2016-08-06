extends Control


func set_test_name(name):
	get_node("Label").set_text(name)


func set_test_time_ratio(ratio):
	var bar = get_node("bar")
	var fill = bar.get_node("fill")
	fill.set_margin(MARGIN_RIGHT, ratio * bar.get_size().x)

