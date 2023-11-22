extends "test.gd"


func get_description() -> String:
	return "Iterate 10 node children using get_children"


func _get_child_count_to_setup() -> int:
	return 10


func setup():
	for i in _get_child_count_to_setup():
		tree_root.add_child(Node.new())


func execute():
	var parent : Node = tree_root
	
	for i in range(0, ITERATIONS):
		for child in parent.get_children():
			pass

