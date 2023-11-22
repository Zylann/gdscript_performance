# This test suite should be useable on many Godot versions,
# because one goal of this test suite is to be able to compare them


static func get_time_msec() -> int:
	return Time.get_ticks_msec()


static func is_debug_build() -> bool:
	return OS.is_debug_build()


static func get_extension(s: String) -> String:
	return s.get_extension()


static func convert_to_json(d) -> String:
	return JSON.stringify(d)


static func get_file_list(dir_path: String, exts: PackedStringArray) -> PackedStringArray:
	var dir = DirAccess.open(dir_path)
	if dir == null:
		var open_code := DirAccess.get_open_error()
		print("Cannot open directory! Code: " + str(open_code))
		return PackedStringArray()
	var list := PackedStringArray()
	dir.list_dir_begin()
	for i in range(0, 1000):
		var file := dir.get_next()
		if file == "":
			break
		if not dir.current_is_dir():
			var file_ext := get_extension(file)
			for ext in exts:
				if ext == file_ext:
					list.append(file)
					break
	return list

