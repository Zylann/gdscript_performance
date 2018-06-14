
extends Node

func _ready():
	var s = preload("res://test_singleton.gd").new()
	s.begin_tests()
	get_tree().quit()


