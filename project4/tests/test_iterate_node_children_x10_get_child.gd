extends "test.gd"


func get_description() -> String:
	return "Iterate 10 node children using get_child"


func _get_child_count_to_setup() -> int:
	return 10


func setup():
	for i in _get_child_count_to_setup():
		tree_root.add_child(Node.new())


func execute():
	var parent : Node = tree_root
	
	for i in range(0, ITERATIONS):
		for j in parent.get_child_count():
			parent.get_child(j)

