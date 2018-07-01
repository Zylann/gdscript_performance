extends "test.gd"

var description = "get_node() where only one child"


func setup():
	var node = Node.new()
	node.set_name("GetNodeTest")
	tree_root.add_child(node)


func execute():
	for i in range(0, ITERATIONS):
		tree_root.get_node("GetNodeTest")
