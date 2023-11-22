extends "../scale_benchmark.gd"


func get_description():
	return "Spamming sprites"


func get_metric_description():
	return "Number of sprites"


func get_metric():
	return get_child_count()


func process(delta):
	var tex = load("res://scale_benchmarks/sprite_spam/sprite.png")
	for i in range(0, 100):
		var sprite = Sprite2D.new()
		sprite.texture = tex
		sprite.position = Vector2(randf_range(100, 400), randf_range(100, 400))
		add_child(sprite)
