
tool
extends SceneTree


func _init():
	var node = Node.new()
	node.set_script(preload("test_singleton.gd"))
	get_root().add_child(node)
	node.begin_tests()
	quit()


