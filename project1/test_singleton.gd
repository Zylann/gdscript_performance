
# This script runs tests in series and writes their result in a JSON file.
# Time measurements are in microseconds and may vary with CPU speed.

# Please note that this script is written in a way to be compatible with all Godot versions,
# so it can be safely copy/pasted for all test projects.
# Functions that differ are put in polyfills.gd.

# TODO Add tests for complete algorithms such as primes, fibonacci etc

extends Node

const RESULT_SAVE_DIRECTORY = "../results/"
const RESULT_FILE_NAME = "last_results.json"

var TestBase = load("tests/test.gd")

var _time_before = 0
var _for_time_usec = 0.0
var _test_name = ""
var _test_description = ""
var _test_results = []
var _base_iterations = 1000000
var _verbose = true

var polyfills = null


func parse_cmd_args():

	var args = OS.get_cmdline_args()
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
	
	polyfills = load("polyfills.gd")

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
	_time_before = polyfills.get_time_msec()
	for i in range(0, _base_iterations):
		pass
	var for_time = polyfills.get_time_msec() - _time_before
	var k = 1000.0 / float(_base_iterations)
	_for_time_usec = k * float(for_time)
	if _verbose:
		print("For time: " + str(_for_time_usec), "us")


func execute_micro_benchmarks():

	var dir = "res://tests"
	var tests = get_file_list(dir, "gd")
	#print(tests)
	
	for test_name in tests:
		var file_name = dir + "/" + test_name
		var test_script = load(file_name)
		
		if test_script == null:
			print("Script cannot be loaded")
			continue
		
		if test_script == TestBase:
			continue
		
		var test = test_script.new()
		
		if not polyfills.is_instance_of(test, TestBase):
			print("Wut, test doesn't inherit base? ", test_name)
			continue

		test.ITERATIONS = _base_iterations
		test.tree_root = self
		
		test.setup()
		
		_start(test_name, test.description)
		test.execute()
		_stop(test.should_subtract_loop_duration(), test.ITERATIONS)
		
		while get_child_count() != 0:
			var child = get_child(get_child_count() - 1)
			remove_child(child)
			child.free()


func _start(test_name="", desc=""):

	_test_name = test_name
	_test_description = desc
	_time_before = polyfills.get_time_msec()


func _stop(subtract_loop_duration, iterations):

	var time = polyfills.get_time_msec() - _time_before
	if _test_name.length() != 0:
		
		var k = 1000.0 / float(iterations)
		var test_time_usec = float(time) * k
		
		if subtract_loop_duration:
			test_time_usec -= _for_time_usec
		
		if _verbose:
			print(_test_description, ": ", str(test_time_usec), "us (", iterations, " iterations)")
		
		_test_results.append({
			name = _test_name,
			description = _test_description,
			time = test_time_usec,
		})


func save_results():

	var dir = RESULT_SAVE_DIRECTORY
	if not polyfills.is_debug_build():
		dir = "user://results_release"
	
	var file_path = dir + RESULT_FILE_NAME
	
	var file = File.new()
	var ret = file.open(file_path, File.WRITE)
	if ret != 0:
		print("Failed to open " + file_path + ", error code is " + str(ret))
		return
	
	var d = { test_results = _test_results }
	file.store_line(polyfills.convert_to_json(d))
	file.close()


func get_file_list(dir_path, exts):
	if typeof(exts) == TYPE_STRING:
		exts = [exts]
	var dir = Directory.new()
	var open_code = dir.open(dir_path)
	if open_code != 0:
		print("Cannot open directory! Code: " + str(open_code))
		return null
	var list = []
	dir.list_dir_begin()
	for i in range(0, 1000):
		var file = dir.get_next()
		if file == "":
			break
		if not dir.current_is_dir():
			var file_ext = polyfills.get_extension(file)
			for ext in exts:
				if ext == file_ext:
					list.append(file)
					break
	return list

