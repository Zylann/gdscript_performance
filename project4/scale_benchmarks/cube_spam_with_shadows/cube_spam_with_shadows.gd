extends "../scale_benchmark.gd"

func get_description():
	return "Spamming cubes with empty environment"


func get_metric_description():
	return "Number of cubes"


func get_metric():
	return get_child_count() - 2


func process(delta):
	var mesh = BoxMesh.new()
	for i in range(0, 100):
		var mi = MeshInstance3D.new()
		mi.mesh = mesh
		mi.position = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))
		add_child(mi)
