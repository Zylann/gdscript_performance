extends "../scale_benchmark.gd"


func get_description():
	return "Bunnymark"


func get_metric_description():
	return "Number of bunnies"


func get_metric():
	return get_child_count()


func process(delta):
	for i in range(0, 10):
		var bunny_scene : PackedScene = load("res://scale_benchmarks/bunnymark/bunny.tscn")
		var bunny = bunny_scene.instantiate()
		add_child(bunny)
