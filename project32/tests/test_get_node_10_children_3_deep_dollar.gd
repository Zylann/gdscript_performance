extends "test.gd"

var description = "get_node() 3 parents deep having 10 children with $"

# `$` is reserved to classes extending `Node`, but `test.gd` doesn't extend that
class MyNode extends Node:
	var ITERATIONS
	func execute():
		for i in range(0, ITERATIONS):
			$GetNodeTest_9/GetNodeTest_9/GetNodeTest_9

var _my_node

func setup():
	var root = tree_root
	_my_node = MyNode.new()
	_my_node.ITERATIONS = ITERATIONS
	root.add_child(_my_node)
	root = _my_node
	for d in 3:
		for i in 10:
			var n = Node.new()
			n.set_name("GetNodeTest_" + str(i))
			root.add_child(n)
		root = root.get_node("GetNodeTest_9")


func execute():
	_my_node.execute()
