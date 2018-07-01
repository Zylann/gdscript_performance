
extends Node

func _ready():
	var s = load("res://test_singleton.gd").new()
	add_child(s)
	s.begin_tests()
	get_tree().quit()


