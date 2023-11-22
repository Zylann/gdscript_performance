
# This script runs tests in series and writes their result in a JSON file.
# Time measurements are in microseconds and may vary with CPU speed.

# Please note that this script is written in a way to be compatible with as many Godot versions as
# possible, so if a difference shows up in a new version, it may be encapsulated into util.gd.

# TODO Add tests for complete algorithms such as primes, fibonacci etc

extends Node

const RESULT_SAVE_DIRECTORY = "../results/"
const RESULT_FILE_NAME = "last_results.json"

const Util = preload("util.gd")
const TestBase = preload("tests/test.gd")

var _time_before := 0
var _for_time_usec := 0.0
var _test_name := ""
var _test_description := ""
var _test_results : Array[Dictionary] = []
var _base_iterations := 1000000
var _verbose := true


func parse_cmd_args():
	var args := OS.get_cmdline_args()
	
	for arg in args:
		if arg.begins_with("--iterations="):
			_base_iterations = arg.to_int()
			print("Overriding base iterations: ", _base_iterations)

		elif arg == "--noprint":
			_verbose = false
		
		elif arg == "--fastrun":
			_base_iterations = 1000
			print("Overriding to fast run")


func begin_tests():
	parse_cmd_args()
	
	if _verbose:
		print("-------------------")
		print("The following times are in microseconds, for one occurence of a test.")
		print("")

	_calculate_for_time()
	
	print("Running micro benchmarks...")
	execute_micro_benchmarks()
	
	if _verbose:
		print("-------------------")
		print("Saving results...")

	save_results()
	
	print("Done.")


func _calculate_for_time():
	# Tests all use a for loop to execute their operation many times,
	# so we estimate the cost of that loop in order to subtract it from test results
	_time_before = Util.get_time_msec()
	for i in range(0, _base_iterations):
		pass
	var for_time = Util.get_time_msec() - _time_before
	var k = 1000.0 / float(_base_iterations)
	_for_time_usec = k * float(for_time)
	if _verbose:
		print("For time: " + str(_for_time_usec), "us")


func execute_micro_benchmarks():
	var dir := "res://tests"
	var tests = Util.get_file_list(dir, PackedStringArray(["gd"]))
	#print(tests)
	
	for test_name in tests:
		var file_name : String = dir + "/" + test_name
		var test_script : GDScript = load(file_name)
		
		if test_script == null:
			print("Script cannot be loaded")
			continue
		
		if test_script == TestBase:
			continue
		
		var test_script_instance = test_script.new()
		
		if not is_instance_of(test_script_instance, TestBase):
			print("Wut, test doesn't inherit base? ", test_name)
			continue
		
		var test : TestBase = test_script_instance
		
		test.ITERATIONS = _base_iterations
		test.tree_root = self
		
		var test_description : String = test.get_description()
		if _verbose:
			print(test_description, "...")
		
		test.setup()
		
		_start(test_name, test_description)
		test.execute()
		_stop(test.should_subtract_loop_duration(), test.ITERATIONS)
		
		while get_child_count() != 0:
			var child := get_child(get_child_count() - 1)
			remove_child(child)
			child.free()


func _start(test_name := "", desc := ""):
	_test_name = test_name
	_test_description = desc
	_time_before = Util.get_time_msec()


func _stop(subtract_loop_duration: bool, iterations: int):
	var time := Util.get_time_msec() - _time_before

	if _test_name.length() != 0:
		var k := 1000.0 / float(iterations)
		var test_time_usec := float(time) * k
		
		if subtract_loop_duration:
			test_time_usec -= _for_time_usec
		
		if _verbose:
			print("    ", str(test_time_usec), "us (", iterations, " iterations)")
		
		_test_results.append({
			name = _test_name,
			description = _test_description,
			time = test_time_usec,
		})


func save_results():
	var dir := RESULT_SAVE_DIRECTORY
	if not Util.is_debug_build():
		dir = "user://results_release"
	
	var file_path := dir + RESULT_FILE_NAME
	
	print("Saving results to ", file_path)
	
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		var ret := FileAccess.get_open_error()
		print("Failed to open " + file_path + ", error code is " + str(ret))
		return
	
	var d := { test_results = _test_results }
	file.store_line(Util.convert_to_json(d))
	file.close()

