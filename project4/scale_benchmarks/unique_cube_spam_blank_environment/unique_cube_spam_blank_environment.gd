extends "../scale_benchmark.gd"

func get_description():
	return "Spamming unique cube meshes with empty environment"


func get_metric_description():
	return "Number of cubes"


func get_metric():
	return get_child_count() - 2


func process(delta):
	for i in range(0, 100):
		var mesh = BoxMesh.new()
		mesh.size = Vector3(1,1,1) * randf_range(0.9, 1.1)
		var mi = MeshInstance3D.new()
		mi.mesh = mesh
		mi.position = Vector3(randf_range(-10, 10), randf_range(-10, 10), randf_range(-10, 10))
		add_child(mi)
