extends "../scale_benchmark.gd"


func get_description():
	return "Nodes with empty process function"


func get_metric_description():
	return "Number of processing nodes"


func get_metric():
	return get_child_count()


func process(delta):
	var processor_scene = load("res://scale_benchmarks/node_spam_with_process/processor.gd")
	for i in range(0, 1000):
		var processor = processor_scene.new()
		add_child(processor)
