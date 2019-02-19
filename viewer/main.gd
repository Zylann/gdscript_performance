extends Node

const RESULTS_FOLDER = "../results"


onready var _micro_benchmarks_viewer = get_node("Panel/TabContainer/MicroBenchmarks")
onready var _scale_benchmarks_viewer = get_node("Panel/TabContainer/ScaleBenchmarks")


func _ready():
	var filenames = get_file_list(RESULTS_FOLDER, "json")
	var all_versions = {}
	
	for filename in filenames:
		
		var fpath = RESULTS_FOLDER + "/" + filename
		var res = load_json_file(fpath)
		if res == null:
			continue
		
		all_versions[filename] = res
	
	_micro_benchmarks_viewer.load_data(all_versions)
	_scale_benchmarks_viewer.load_data(all_versions)
	

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

