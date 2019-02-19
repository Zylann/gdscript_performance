extends "test.gd"

var description = "get_node() 3 parents deep having 10 children"


func setup():
	var root = tree_root
	for d in 3:
		for i in 10:
			var n = Node.new()
			n.set_name("GetNodeTest_" + str(i))
			root.add_child(n)
		root = root.get_node("GetNodeTest_9")


func execute():
	for i in range(0, ITERATIONS):
		tree_root.get_node("GetNodeTest_9/GetNodeTest_9/GetNodeTest_9")
