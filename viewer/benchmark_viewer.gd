extends Panel

const RESULTS_FOLDER = "../results"

onready var _test_list = get_node("HSplitContainer/TestList")
onready var _graph_area = get_node("HSplitContainer/RightPane/GraphArea")
onready var _zoom_slider = get_node("HSplitContainer/RightPane/GraphBottom/ZoomSlider")

var _results_per_test = {}
var _current_test = null


func _ready():
	var filenames = get_file_list(RESULTS_FOLDER, "json")
	
	_results_per_test = {}
	
	for filename in filenames:
		
		var fpath = RESULTS_FOLDER + "/" + filename
		var res = load_json_file(fpath)
		if res == null:
			continue
		
		var file_data = res["test_results"]
		
		for file_test_data in file_data:
			
			var test_data = null
			
			if not _results_per_test.has(file_test_data.name):
				test_data = {
					name = file_test_data.name,
					description = file_test_data.description,
					versions = []
				}
				_results_per_test[test_data.name] = test_data
			else:
				test_data = _results_per_test[file_test_data.name]
			
			test_data.versions.append({
				version = filename,
				time = file_test_data.time
			})
	
	for test_name in _results_per_test:
		var test = _results_per_test[test_name]
		var i = _test_list.get_item_count()
		_test_list.add_item(test.description)
		_test_list.set_item_metadata(i, test.name)


func _on_TestList_item_selected(index):
	var test_name = _test_list.get_item_metadata(index)
	var test = _results_per_test[test_name]
	_current_test = test
	
	for i in range(_graph_area.get_child_count()):
		var child = _graph_area.get_child(i)
		if child is ColorRect:
			_graph_area.get_child(i).queue_free()
	
	var bar_width = 20
	var bar_spacing = 1
	
	var yscale = _zoom_slider.value
	
	for i in range(len(test.versions)):
		var test_result = test.versions[i]
		var bar = ColorRect.new()
		bar.hint_tooltip = test_result.version
		bar.color = Color(1, 0.5, 0)
		bar.anchor_left = 0
		bar.anchor_top = 1
		bar.anchor_right = 0
		bar.anchor_bottom = 1
		bar.margin_left = (bar_width + bar_spacing) * i + 1
		bar.margin_top = -test_result.time * yscale
		bar.margin_right = bar.margin_left + bar_width
		bar.margin_bottom = 0
		_graph_area.add_child(bar)


func _on_ZoomSlider_value_changed(yscale):
	_update_yscale(yscale)


func _update_yscale(yscale):
	
	if _current_test == null:
		return
	
	if len(_current_test.versions) != _graph_area.get_child_count():
		print("Wut, different count?")
		return
	
	for i in range(len(_current_test.versions)):
		var test_result = _current_test.versions[i]
		var bar = _graph_area.get_child(i)
		bar.margin_top = -test_result.time * yscale


static func load_json_file(fpath):
	var f = File.new()
	var code = f.open(fpath, File.READ)
	if code != OK:
		print("Cannot open ", fpath, ", code=", code)
		return null
	var contents = f.get_as_text()
	f.close()
	var res = JSON.parse(contents)
	if res.error != OK:
		print("Cannot parse ", fpath, ", code=", res.error)
		return null
	return res.result


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

