extends Node

var imports_img={}


func is_packaged_exe() -> bool:
	# The executable path will point to the Godot editor if running in editor
	var exe_path = OS.get_executable_path().get_base_dir().to_lower()
	# Check if it contains "godot" in the path (editor) or not (packaged game)
	return not ("godot" in exe_path)


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


func Dir_Root() -> String:
	if is_packaged_exe():
		return OS.get_executable_path().get_base_dir()+'/'
	return "res://"

func IMPORT_ImageAsTexture(path) -> ImageTexture:
	if imports_img.has(path):
		return imports_img[path]
	var img=Image.new()
	img.load(path)
	var imgT=ImageTexture.new()
	imgT.set_image(img)
	imports_img[path]=imgT
	return imgT

func FILE_LoadAsJson(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		# Create default empty dictionary
		var default_dict = {}
		# Save it to file
		var file = FileAccess.open(path, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(default_dict))
			file.close()
		return default_dict
	
	# If file exists, load it as before
	var file = FileAccess.get_file_as_string(path)
	var dict = JSON.parse_string(file)
	return dict if dict else {}

func FILE_SaveAsJson(data: Dictionary, path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
