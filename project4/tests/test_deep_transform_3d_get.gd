extends "test.gd"

func get_description() -> String:
	return "Deep transform change querying leaf"


var _root_spatial = null
var _leaf_spatial = null


func setup():
	var parent = tree_root
	
	for d in 10:
		var child = Node3D.new()
		child.name = "Node3D"
		parent.add_child(child)
		_leaf_spatial = child
		parent = child
	
	_root_spatial = tree_root.get_node("Node3D")


func execute():
	var root = _root_spatial
	var leaf = _leaf_spatial

	var t1 = Transform3D(Basis(), Vector3(1, 2, 3))
	var t2 = Transform3D(Basis().rotated(Vector3(0, 1, 0), 33), Vector3())
	
	var iterations = ITERATIONS / 2
	
	for i in range(0, iterations):
		root.set_transform(t1)
		leaf.get_global_transform()
		root.set_transform(t2)
		leaf.get_global_transform()
