# This test suite should be useable on many Godot versions,
# because one goal of this test suite is to be able to compare them


static func is_instance_of(a, klass):
	return a is klass


static func get_time_msec():
	return OS.get_ticks_msec()


static func is_debug_build():
	return OS.is_debug_build()


# Unfortunately this ITSELF is a polyfill requirement so it can't even be here...
#static func get_engine_version():
#	if OS.has_method("get_engine_version"):
#		var version = OS.get_engine_version()
#		return version
#	
#	else:
#		if false:#EditorPlugin.new().has_method("add_control_to_bottom_panel"):
#			pass
#			return {
#				major = "2",
#				minor = "1",
#				string = "2.1-beta (official)"
#			}
#		else:
#			return {
#				major = "2",
#				minor = "0",
#				string = "2.0 or before"
#			}

