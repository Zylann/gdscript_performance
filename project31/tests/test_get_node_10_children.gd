extends "test.gd"

var description = "get_node() where 10 children"


func setup():
	for i in 10:
		var n = Node.new()
		n.set_name("GetNodeTest_" + str(i))
		tree_root.add_child(n)


func execute():
	for i in range(0, ITERATIONS):
		tree_root.get_node("GetNodeTest_9")
