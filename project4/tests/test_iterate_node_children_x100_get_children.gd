extends "test_iterate_node_children_x10_get_children.gd"


func get_description() -> String:
	return "Iterate 100 node children using get_children"


func _get_child_count_to_setup() -> int:
	return 100

