extends "../scale_benchmark.gd"


func get_description():
	return "Spamming sprites"


func get_metric_description():
	return "Number of sprites"


func get_metric():
	return get_child_count()


func process(delta):
	var tex = load("res://icon.png")
	for i in range(0, 100):
		var sprite = Sprite.new()
		sprite.set_texture(tex)
		sprite.set_position(Vector2(rand_range(100, 400), rand_range(100, 400)))
		add_child(sprite)
