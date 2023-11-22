

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
			var file_ext := file.get_extension()
			for ext in exts:
				if ext == file_ext:
					list.append(file)
					break
	return list
