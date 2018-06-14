
extends Node

func _ready():
	var s = load("res://test_singleton.gd").new()
	#get_node("/root/TestSingleton")
	s.begin_tests()
	get_tree().quit()


