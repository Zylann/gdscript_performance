extends "test.gd"

var description = "Deep transform change without querying leaf"

var _root_spatial = null
var _leaf_spatial = null


func setup():
	var root = tree_root
	for d in range(0, 10):
		var s = Spatial.new()
		s.set_name("Spatial")
		root.add_child(s)
		root = s
		_leaf_spatial = s
	_root_spatial = tree_root.get_node("Spatial")


func execute():
	var root = _root_spatial

	var t1 = Transform(Matrix3(), Vector3(1, 2, 3))
	var t2 = Transform(Matrix3().rotated(Vector3(0, 1, 0), 33), Vector3())
	
	var iterations = ITERATIONS / 2
	
	for i in range(0, iterations):
		root.set_transform(t1)
		root.set_transform(t2)
