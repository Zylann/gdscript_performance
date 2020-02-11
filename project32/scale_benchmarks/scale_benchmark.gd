extends Node

# The benchmark will stop when any of these limits is reached
const MAX_MEMORY = 1000000000 # 1Gb
const MAX_FRAMETIME_MSEC = 1000 / 15 # 15 fps
const MAX_BENCHMARK_DURATION_MSEC = 60 * 1000 # 1 minute

# The benchmark will not stop until a minimum of frames have been done
const MIN_FRAMES = 10

var polyfills = null

var _prev_time = 0.0
var _frame_stats = []
var _extra_static_memory = 0
var _extra_dynamic_memory = 0
var _frame_count = 0
var _verbose = true
var _max_benchmark_duration_msec = MAX_BENCHMARK_DURATION_MSEC


func get_description():
	return "<desc>"


func get_metric_description():
	return "<metric_desc>"


func get_metric():
	return 0


func setup():
	pass


func process(delta):
	pass


func get_frames_to_ignore():
	return 1


func _ready():
	polyfills = load("res://polyfills.gd")
	
	var args = OS.get_cmdline_args()
	for arg in args:
		
		if arg == "--noprint":
			_verbose = false
			
		elif arg == "--fastrun":
			_max_benchmark_duration_msec = 1000
			print("Overriding to fast run")
	
	_prev_time = polyfills.get_time_msec()
	
	set_process(true)
	setup()


func _process(delta):
	
	var time = polyfills.get_time_msec()
	var elapsed = time - _prev_time
	
	var static_memory = OS.get_static_memory_usage()
	var dynamic_memory = OS.get_dynamic_memory_usage()
	
	_frame_stats.append({
		"frametime": elapsed,
		"metric": get_metric(),
		"static_memory": 0,
		"dynamic_memory": 0
	})

	_extra_static_memory += OS.get_static_memory_usage() - static_memory
	_extra_dynamic_memory += OS.get_dynamic_memory_usage() - dynamic_memory
	
	static_memory = OS.get_static_memory_usage() - _extra_static_memory
	dynamic_memory = OS.get_dynamic_memory_usage() - _extra_dynamic_memory
	
	_frame_stats[-1]["static_memory"] = static_memory
	_frame_stats[-1]["dynamic_memory"] = dynamic_memory
	
	var total_memory = static_memory + dynamic_memory
	
	if _verbose:
		print("Frametime: ", elapsed, "ms")

	if _frame_count > MIN_FRAMES and (elapsed > MAX_FRAMETIME_MSEC or total_memory > MAX_MEMORY or polyfills.get_time_msec() > _max_benchmark_duration_msec):
		_finish()
	else:
		_prev_time = polyfills.get_time_msec()
		process(delta)
	
	_frame_count += 1


func _finish():
	var data = {
		"description": get_description(),
		"metric_description": get_metric_description(),
		"frames": _frame_stats
	}
	
	var file_path = get_filename().get_base_dir().plus_file("results.json")
	
	var file = File.new()
	var ret = file.open(file_path, File.WRITE)
	if ret != 0:
		print("Failed to write " + file_path + ", error code is " + str(ret))
		return
	
	var json = polyfills.convert_to_json(data)
	file.store_line(json)
	file.close()
	
	print("Done.")

	set_process(false)
	get_tree().quit()


