
extends Node

class TestSession:
	var version = ""
	var tests = []
	
	func get_max_time():
		var maxt = 0
		for test in tests:
			maxt = max(maxt, test["time"])
		return maxt


const MODE_LINE = 0
const MODE_HISTOGRAM = 1


var _sessions = []
var _histogram_data = {}
var _current_results_index = 0
var _mode = MODE_LINE
var _lines = []


func _ready():
	_load_results()
	get_node("HButtonArray").connect("button_selected", self, "_on_mode_selected")
	_apply_mode()


func _on_mode_selected(idx):
	set_mode(idx)

func set_mode(mode):
	if _mode != mode:
		_mode = mode
		_apply_mode()

func _apply_mode():
	if _mode == MODE_LINE:
		_build_line_view()

	else:
		_build_histogram_data()
		_build_histogram_view()



func _load_results():
	var files = get_file_list(TestSingleton.RESULT_SAVE_DIRECTORY, "json")
	print("Found " + str(files.size()) + " files")
	files.sort()
	_sessions.clear()
	for fname in files:
		var file = File.new()
		var fpath = TestSingleton.RESULT_SAVE_DIRECTORY + fname
		var ret = file.open(fpath, File.READ)
		if ret != 0:
			print("Error reading file " + fpath + ", error code is " + str(ret))
			continue
		var d = {}
		d.parse_json(file.get_line())
		var s = TestSession.new()
		s.version = fname
		s.tests = d["test_results"]
		_sessions.append(s)


func _show_test_lines(engine_version):
	if _sessions.size() == 0:
		print("No result to show")
		return
	
	var session = get_session_by_version(engine_version)
	var max_time = max(session.get_max_time(), 0.001)
	var line_res = preload("result_line.tscn")
	#var item_list = get_node("ItemList")
	
	for line in _lines:
		line.queue_free()
	_lines.clear()
	
	var content = get_node("split/content")
	content.get_node("Histogram").hide()
	
	var pos = Vector2(0,0)
	for test in session.tests:
		var line = line_res.instance()
		line.set_pos(pos)
		content.add_child(line)
		line.set_test_name(test["name"])
		line.set_test_time_ratio(test["time"] / max_time)
		pos.y += line.get_size().y
		_lines.append(line)


func _build_histogram_data():
	var histogram_data = {}
	
	for session_index in range(0, _sessions.size()):
		var session = _sessions[session_index]
		for test in session.tests:
			var test_times
			if histogram_data.has(test.name):
				test_times = histogram_data[test.name]
			else:
				test_times = []
				histogram_data[test.name] = test_times
			test_times.resize(session_index+1)
			test_times[session_index] = test.time
	
	_histogram_data = histogram_data


func get_session_by_version(version):
	for session in _sessions:
		if session.version == version:
			return session
	return null


func _build_line_view():
	var selector = get_node("split/test_selector")
	selector.set_max_columns(1)
	selector.clear()
	for session in _sessions:
		selector.add_item(session.version)


func _build_histogram_view():
	for line in _lines:
		line.queue_free()
	_lines.clear()

	var selector = get_node("split/test_selector")
	selector.set_max_columns(1)
	selector.clear()
	for test_name in _histogram_data:
		selector.add_item(test_name)
	if not selector.is_connected("item_selected", self, "_on_item_selected"):
		selector.connect("item_selected", self, "_on_item_selected")


func _on_item_selected(i):
	var selector = get_node("split/test_selector")
	var name = selector.get_item_text(i)
	if _mode == MODE_HISTOGRAM:
		_show_test_histogram(name)
	else:
		_show_test_lines(name)


func _show_test_histogram(test_name):
	var view = get_node("split/content/Histogram")
	var times = _histogram_data[test_name]
	var tags = []
	for session in _sessions:
		tags.append(session.version)
	view.set_test_times(times, tags)
	view.show()


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
			var file_ext = file.extension()
			for ext in exts:
				if ext == file_ext:
					list.append(file)
					break
	return list


