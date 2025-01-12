extends Node


func FILES_ListInDirectory(path: String, extension: String = "", recursive: bool = false) -> Array:

	var files = []
	var dir = DirAccess.open(path)
	
	if dir == null:
		push_warning("Failed to access path: " + path)
		return files
	
	# Begin directory scanning
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
			
		# Skip hidden files and current/parent directory markers
		if file.begins_with("."):
			continue
			
		var full_path = path.path_join(file)
		
		if dir.current_is_dir():
			if recursive:
				# Recursively scan subdirectories
				files.append_array(FILES_ListInDirectory(full_path, extension, true))
		else:
			# Check extension filter if specified
			if extension == "" or file.ends_with(extension):
				files.append(full_path)
	
	dir.list_dir_end()
	
	return files
