extends Control

const Chart = preload("res://chart.gd")

const MODE_FRAMETIME = 0
const MODE_STATIC_MEMORY = 1
const MODE_DYNAMIC_MEMORY = 2

@onready var _benchmark_list : ItemList = $BenchmarkList
@onready var _version_list : ItemList = $HSplitContainer/VersionList
@onready var _chart : Chart = $HSplitContainer/VBoxContainer/GraphArea/MainGraph
@onready var _secondary_chart : Chart = $HSplitContainer/VBoxContainer/GraphArea/SecondaryGraph
@onready var _mode_selector : OptionButton = $HSplitContainer/VBoxContainer/GraphSettings/ModeSelector
@onready var _main_label : Label = $HSplitContainer/VBoxContainer/GraphSettings/MainLabel
@onready var _secondary_label : Label = $HSplitContainer/VBoxContainer/GraphSettings/SecondaryLabel

class ScaleBenchmarkFrame:
	var metric := 0.0
	var dynamic_memory := 0
	var static_memory := 0
	var frametime := 0


class ScaleBenchmarkVersion:
	var version := ""
	var frames : Array[ScaleBenchmarkFrame] = []


class ScaleBenchmark:
	var description := ""
	var metric_description := ""
	var versions : Array[ScaleBenchmarkVersion] = []
	

var _data := {}
var _current_benchmark : ScaleBenchmark = null
var _current_version_name := ""
var _current_mode := MODE_FRAMETIME
var _comparing_version_name := ""


func _ready():
	_mode_selector.add_item("Frametime", MODE_FRAMETIME)
	_mode_selector.add_item("Static Memory", MODE_STATIC_MEMORY)
	_mode_selector.add_item("Dynamic Memory", MODE_DYNAMIC_MEMORY)
	
	_main_label.text = ""
	_secondary_label.text = ""


func load_data(all_versions: Dictionary):
	_data = {}
	
	for version_name in all_versions:
		var version_data : Dictionary = all_versions[version_name]
		if not version_data.has("scale_benchmarks"):
			continue
		var benchmarks_data : Dictionary = version_data["scale_benchmarks"]
		
		for benchmark_name in benchmarks_data:
			var benchmark_data : Dictionary = benchmarks_data[benchmark_name]
			
			var benchmark : ScaleBenchmark
			
			if _data.has(benchmark_name):
				benchmark = _data[benchmark_name]
			else:
				benchmark = ScaleBenchmark.new()
				benchmark.description = benchmark_data["description"]
				benchmark.metric_description = benchmark_data["metric_description"]

				_data[benchmark_name] = benchmark
			
			var version := ScaleBenchmarkVersion.new()
			version.version = version_name
			
			var frames_data : Array = benchmark_data["frames"]

			for frame_data in frames_data:
				var frame := ScaleBenchmarkFrame.new()

				frame.metric = frame_data["metric"]
				frame.dynamic_memory = frame_data.get("dynamic_memory", 0)
				frame.static_memory = frame_data["static_memory"]
				frame.frametime = frame_data["frametime"]

				version.frames.append(frame)
			
			benchmark.versions.append(version)
		
	_benchmark_list.clear()
	_version_list.clear()

	for benchmark_name in _data:
		var benchmark : ScaleBenchmark = _data[benchmark_name]
		var i := _benchmark_list.get_item_count()
		_benchmark_list.add_item(benchmark.description)
		_benchmark_list.set_item_metadata(i, benchmark_name)


func _on_BenchmarkList_item_selected(index: int):
	var benchmark_name : String = _benchmark_list.get_item_metadata(index)
	var benchmark : ScaleBenchmark = _data[benchmark_name]
	
	_version_list.clear()
	
	for version in benchmark.versions:
		var i := _version_list.get_item_count()
		_version_list.add_item(version.version)
		_version_list.set_item_metadata(i, version.version)
	
	_current_benchmark = benchmark

	_set_comparing_version("")


func _on_VersionList_item_selected(index: int):
	assert(_current_benchmark != null)
	_current_version_name = _version_list.get_item_metadata(index)
	_main_label.text = _current_version_name
	_update_graph_data(_chart, _current_version_name)
	if _comparing_version_name == "":
		_chart.scale_to_fit()


func _update_graph_data(chart: Chart, p_version_name: String):
	if _current_benchmark == null:
		return
	
	var data : ScaleBenchmarkVersion
	for version in _current_benchmark.versions:
		if version.version == p_version_name:
			data = version
	
	var gdata := PackedVector2Array()
	
	for frame in data.frames:
		var x := frame.metric
		
		var y : float
		match _current_mode:
			MODE_DYNAMIC_MEMORY:
				y = frame.dynamic_memory
			MODE_STATIC_MEMORY:
				y = frame.static_memory
			MODE_FRAMETIME:
				y = frame.frametime
		
		gdata.append(Vector2(x, y))
	
	chart.set_data(gdata)
	chart.queue_redraw()


func _on_ModeSelector_item_selected(id: int):
	_current_mode = id
	
	if _comparing_version_name != "":
		_update_graph_data(_secondary_chart, _comparing_version_name)
		_secondary_chart.scale_to_fit()
	
	_update_graph_data(_chart, _current_version_name)
	
	if _comparing_version_name != "":
		_chart.set_chart_window(_secondary_chart.get_chart_window())


func _on_ReferenceCheckbox_toggled(button_pressed: bool):
	if _current_version_name == "":
		return
	if button_pressed:
		_set_comparing_version(_current_version_name)
	else:
		_set_comparing_version("")


func _set_comparing_version(version_name: String):
	if version_name != null:
		_secondary_label.text = version_name
		_secondary_chart.show()
		_secondary_chart.set_data(_chart.get_data())
		_secondary_chart.scale_to_fit()
		_chart.set_chart_window(_secondary_chart.get_chart_window())
	else:
		_secondary_label.text = ""
		_secondary_chart.hide()
	_comparing_version_name = version_name

