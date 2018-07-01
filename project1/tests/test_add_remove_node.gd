extends "test.gd"

var description = "Add and remove node"


func setup():
	ITERATIONS /= 50


func execute():
	
	var root = tree_root
	var node = Node.new()
	
	for i in range(0, ITERATIONS):
		root.add_child(node)
		root.remove_child(node)
	
	node.free()



