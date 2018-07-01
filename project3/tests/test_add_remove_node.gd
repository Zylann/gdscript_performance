extends "test.gd"

var description = "Add and remove node"


func setup():
	ITERATIONS /= 50


func execute():
	
	var root = tree_root
	var node = Node.new()
	
	# NOTE: I found this test is biased, and I can't do anything about it.
	# Godot appears to run it slower if there are more iterations.
	# Adding and removing nodes has a race condition over the time it takes.

	for i in range(0, ITERATIONS):
		root.add_child(node)
		root.remove_child(node)
	
	node.free()



