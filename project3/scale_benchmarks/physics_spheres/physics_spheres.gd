extends "../scale_benchmark.gd"


func get_description():
	return "Spamming spheres with physics"


func get_metric_description():
	return "Number of spheres"


func get_metric():
	return get_child_count() - 7


func process(delta):
	var scene = load("res://scale_benchmarks/physics_spheres/sphere_body.tscn")
	for i in range(0, 1):
		var s = scene.instance()
		s.set_translation(Vector3(rand_range(-1, 1), 50, rand_range(-1, 1)))
		add_child(s)
