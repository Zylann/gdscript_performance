# This script prints how much time GDScript takes to performs specific instructions.

# Times values are in arbitrary units but share the same scale,
# so for example if test A prints 100 and test B prints 200,
# we can say that test A is 2x faster than test B.

# All tests run a very long loop containing the code to profile,
# in order to obtain a reasonable time information.
# The cost of the loop itself is then subtracted to all tests.
# Iteration count is the same for all tests.
# There shouldn't be race conditions between loops.

# Results will be approximate and vary between executions and CPU speed,
# but the error margin should be low enough to make conclusions on most tests.
# If not, please set the ITERATIONS constant to higher values to reduce the margin.


# TODO Output results in a JSON file so we can reload and compare them afterwards
# TODO Add tests for complete algorithms such as primes, fibonacci etc

tool
extends Node

var ITERATIONS = 1000000 # var because it is used to estimate loop time the same way tests do
const RESULT_SAVE_DIRECTORY = "../results/"
const RESULT_FILE_NAME = "last_results.json"

var TestBase = load("tests/test.gd")

var _time_before = 0
var _for_time = 0
var _test_name = ""
var _test_description = ""
var _test_results = []

var polyfills = null


func begin_tests():
	
	# TODO Load different polyfills depending on Godot version
	polyfills = load("polyfills.gd")
	
	print("-------------------")
	
	# Tests all use a for loop to execute their operation many times,
	# so we estimate the cost of that loop in order to subtract it from test results
	_time_before = polyfills.get_time_msec()
	for i in range(0, ITERATIONS):
		pass
	_for_time = polyfills.get_time_msec() - _time_before
	print("For time: " + str(_for_time))
	
	print("")
	print("The following times are in seconds for the whole test.")
	print("")
	
	execute_filebased_tests()
	
	print("-------------------")
	
	print("Saving results...")
	save_results()
	
	print("Done.")


func execute_filebased_tests():

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
			
		#if not test.can_run(context):
		#	continue

		test.ITERATIONS = ITERATIONS
		
		_start(test_name, test.description)
		test.execute()
		_stop(test.should_subtract_loop_duration())


func _start(test_name="", desc=""):

	_test_name = test_name
	_test_description = desc
	_time_before = polyfills.get_time_msec()


func _stop(subtract_loop_duration=true):

	var time = polyfills.get_time_msec() - _time_before
	if _test_name.length() != 0:
		var test_time = time
		
		if subtract_loop_duration:
			test_time -= _for_time
		
		print(_test_description + ": " + str(test_time))# + " (with for: " + str(time) + ")")
		
		_test_results.append({
			name = _test_name,
			description = _test_description,
			time = test_time
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
	file.store_line(to_json(d))
	file.close()


static func get_file_list(dir_path, exts):
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
			var file_ext = file.get_extension()
			for ext in exts:
				if ext == file_ext:
					list.append(file)
					break
	return list

