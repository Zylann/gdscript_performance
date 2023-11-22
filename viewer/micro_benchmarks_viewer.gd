extends Control

const BAR_WIDTH = 12
const BAR_SPACING = 1

@onready var _test_list : ItemList = $TestList
@onready var _graph_area : Control = $RightPane/GraphArea
@onready var _zoom_slider : Slider = $RightPane/GraphBottom/ZoomSlider

class TestVersion:
	var version := ""
	var time := 0.0


class Test:
	var name := ""
	var description := ""
	var versions : Array[TestVersion] = []


var _results_per_test := {}
var _current_test : Test = null


func load_data(all_versions: Dictionary):
	_results_per_test = {}
	
	for version_filename in all_versions:
		var version_data : Dictionary = all_versions[version_filename]
		if not version_data.has("micro_benchmarks"):
			continue
			
		var file_data : Array = version_data["micro_benchmarks"]
		
		for file_test_data in file_data:
			var test_data : Test
			
			var test_name : String = file_test_data.name
			
			if _results_per_test.has(test_name):
				test_data = _results_per_test[test_name]
			else:
				test_data = Test.new()
				test_data.name = test_name
				test_data.description = file_test_data["description"]
				
				_results_per_test[test_name] = test_data
			
			var test_version := TestVersion.new()
			test_version.version = version_filename
			test_version.time = file_test_data["time"]
			
			test_data.versions.append(test_version)
	
	_test_list.clear()
	
	for test_name in _results_per_test:
		var test : Test = _results_per_test[test_name]
		var i = _test_list.get_item_count()
		_test_list.add_item(test.description)
		_test_list.set_item_metadata(i, test.name)
	
	_test_list.sort_items_by_text()


func _on_TestList_item_selected(index: int):
	var test_name : String = _test_list.get_item_metadata(index)
	var test : Test = _results_per_test[test_name]
	_current_test = test
	
	for i in _graph_area.get_child_count():
		var child := _graph_area.get_child(i)
		if child is ColorRect:
			_graph_area.get_child(i).queue_free()
	
	var bar_width := BAR_WIDTH
	var bar_spacing := BAR_SPACING
	
	var yscale := _zoom_slider.value
	
	for i in test.versions.size():
		var test_result := test.versions[i]
		var bar := ColorRect.new()
		bar.tooltip_text = test_result.version
		bar.color = Color(1, 0.5, 0)
		bar.anchor_left = 0
		bar.anchor_top = 1
		bar.anchor_right = 0
		bar.anchor_bottom = 1
		bar.offset_left = (bar_width + bar_spacing) * i + 1
		bar.offset_top = -test_result.time * yscale
		bar.offset_right = bar.offset_left + bar_width
		bar.offset_bottom = 0
		_graph_area.add_child(bar)


func _on_ZoomSlider_value_changed(yscale: float):
	_update_yscale(yscale)


func _update_yscale(yscale: float):
	if _current_test == null:
		return
	
	if _current_test.versions.size() != _graph_area.get_child_count():
		print("Wut, different count?")
		return
	
	for i in _current_test.versions.size():
		var test_result := _current_test.versions[i]
		var bar : Control = _graph_area.get_child(i)
		bar.offset_top = -test_result.time * yscale


