extends Control

const MODE_FRAMETIME = 0
const MODE_STATIC_MEMORY = 1
const MODE_DYNAMIC_MEMORY = 2

onready var _benchmark_list = get_node("BenchmarkList")
onready var _version_list = get_node("HSplitContainer/VersionList")
onready var _chart = get_node("HSplitContainer/VBoxContainer/GraphArea/MainGraph")
onready var _secondary_chart = get_node("HSplitContainer/VBoxContainer/GraphArea/SecondaryGraph")
onready var _mode_selector = get_node("HSplitContainer/VBoxContainer/GraphSettings/ModeSelector")
onready var _main_label = get_node("HSplitContainer/VBoxContainer/GraphSettings/MainLabel")
onready var _secondary_label = get_node("HSplitContainer/VBoxContainer/GraphSettings/SecondaryLabel")

var _data = {}
var _current_benchmark = null
var _current_version = null
var _current_mode = MODE_FRAMETIME
var _comparing_version = null


func _ready():
	_mode_selector.add_item("Frametime", MODE_FRAMETIME)
	_mode_selector.add_item("Static Memory", MODE_STATIC_MEMORY)
	_mode_selector.add_item("Dynamic Memory", MODE_DYNAMIC_MEMORY)
	
	_main_label.text = ""
	_secondary_label.text = ""


func load_data(all_versions):
	_data = {}
	
	for version in all_versions:
		var version_data = all_versions[version]
		if not version_data.has("scale_benchmarks"):
			continue
		var data = version_data["scale_benchmarks"]
		
		for benchmark_name in data:
			var benchmark_data = data[benchmark_name]
			
			if not _data.has(benchmark_name):
				_data[benchmark_name] = {
					"description": benchmark_data.description,
					"metric_description": benchmark_data.metric_description,
					"versions": []
				}
			
			_data[benchmark_name]["versions"].append({
				"version": version,
				"frames": benchmark_data.frames
			})
		
	_benchmark_list.clear()
	_version_list.clear()

	for benchmark_name in _data:
		var benchmark = _data[benchmark_name]
		var i = _benchmark_list.get_item_count()
		_benchmark_list.add_item(benchmark.description)
		_benchmark_list.set_item_metadata(i, benchmark_name)


func _on_BenchmarkList_item_selected(index):
	var benchmark_name = _benchmark_list.get_item_metadata(index)
	var benchmark = _data[benchmark_name]
	
	_version_list.clear()
	
	for version in benchmark.versions:
		var i = _version_list.get_item_count()
		_version_list.add_item(version.version)
		_version_list.set_item_metadata(i, version.version)
	
	_current_benchmark = benchmark

	_set_comparing_version(null)


func _on_VersionList_item_selected(index):
	assert(_current_benchmark != null)
	_current_version = _version_list.get_item_metadata(index)
	_main_label.text = _current_version
	_update_graph_data(_chart, _current_version)
	if _comparing_version == null:
		_chart.scale_to_fit()


func _update_graph_data(chart, p_version):
	
	if _current_benchmark == null:
		return
	
	var data
	for version in _current_benchmark.versions:
		if version.version == p_version:
			data = version
	
	var gdata = []
	
	for frame in data.frames:
		var x = frame.metric
		
		var y
		match _current_mode:
			MODE_DYNAMIC_MEMORY:
				y = frame.dynamic_memory
			MODE_STATIC_MEMORY:
				y = frame.static_memory
			MODE_FRAMETIME:
				y = frame.frametime
		
		gdata.append(Vector2(x, y))
	
	chart.set_data(gdata)
	chart.update()


func _on_ModeSelector_item_selected(ID):
	_current_mode = ID
	
	if _comparing_version != null:
		_update_graph_data(_secondary_chart, _comparing_version)
		_secondary_chart.scale_to_fit()
	
	_update_graph_data(_chart, _current_version)
	
	if _comparing_version != null:
		_chart.set_window(_secondary_chart.get_window())


func _on_ReferenceCheckbox_toggled(button_pressed):
	if _current_version == null:
		return
	if button_pressed:
		_set_comparing_version(_current_version)
	else:
		_set_comparing_version(null)


func _set_comparing_version(version):
	if version != null:
		_secondary_label.text = version
		_secondary_chart.show()
		_secondary_chart.set_data(_chart.get_data())
		_secondary_chart.scale_to_fit()
		_chart.set_window(_secondary_chart.get_window())
	else:
		_secondary_label.text = ""
		_secondary_chart.hide()
	_comparing_version = version
