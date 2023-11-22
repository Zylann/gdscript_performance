extends Node

const RESULTS_FOLDER = "../results"

const ScaleBenchmarksViewer = preload("res://scale_benchmarks_viewer.gd")
const MicroBenchmarksViewer = preload("res://micro_benchmarks_viewer.gd")
const Util = preload("./util.gd")

@onready var _micro_benchmarks_viewer : MicroBenchmarksViewer = $Panel/TabContainer/MicroBenchmarks
@onready var _scale_benchmarks_viewer : ScaleBenchmarksViewer = $Panel/TabContainer/ScaleBenchmarks
@onready var _loading_panel : Control = $Panel/Loading
@onready var _loading_progress_bar : ProgressBar = $Panel/Loading/ProgressPanel/ProgressBar


func _ready():
	_loading_panel.show()
	_loading_progress_bar.ratio = 0
	await get_tree().process_frame
	
	var filenames := Util.get_file_list(RESULTS_FOLDER, PackedStringArray(["json"]))
	var all_versions := {}
	
	for i in filenames.size():
		var filename := filenames[i]
		
		var fpath := RESULTS_FOLDER + "/" + filename
		var res = load_json_file(fpath)
		if res == null:
			continue

		_loading_progress_bar.ratio = float(i) / float(len(filenames))
		await get_tree().process_frame
		
		all_versions[filename] = res
	
	_micro_benchmarks_viewer.load_data(all_versions)
	_scale_benchmarks_viewer.load_data(all_versions)

	_loading_panel.hide()
	

static func load_json_file(fpath: String):
	var f := FileAccess.open(fpath, FileAccess.READ)
	if f == null:
		var code := FileAccess.get_open_error()
		push_error("Cannot open ", fpath, ", code=", code)
		return null
	var contents := f.get_as_text()
	f = null
	
	var test_json_conv := JSON.new()
	var err := test_json_conv.parse(contents)
	if err != OK:
		print("Cannot parse ", fpath, ": ", test_json_conv.get_error_message())
		return null
	return test_json_conv.data


