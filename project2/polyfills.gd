# This test suite should be useable on many Godot versions,
# because one goal of this test suite is to be able to compare them


static func is_instance_of(a, klass):
	return a extends klass


static func get_time_msec():
	return OS.get_ticks_msec()


static func is_debug_build():
	return OS.is_debug_build()


static func get_extension(s):
	return s.extension()


static func convert_to_json(d):
	return d.to_json()
