
# Set by the main test script
var ITERATIONS := 0
var tree_root : Node

func get_description() -> String:
	return "<Test base class>"


func can_run(context):
	return true


func should_subtract_loop_duration() -> bool:
	return true


func setup():
	pass


func execute():
	pass


#func get_variant_count() -> int:
#	return 1
