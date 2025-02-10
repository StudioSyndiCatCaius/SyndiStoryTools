extends Control
class_name WG_FileExplorer


# Add new signal for file movement
signal file_moved(from_path: String, to_path: String)
signal file_selected(path: String)

@export var N_ConfirmDialog_Delete: ConfirmationDialog
@export var Filter_Files: Array[TreeExplorerFilter]
@export var root_path = "res://"  

@export_category('internal')
@export var RootTree: Tree
@export var Filter_Folder: TreeExplorerFilter
@export var N_Popup_File: PopupMenu
@export var N_Popup_Folder: PopupMenu
# Change this to your desired root path

func _ready():
	RootTree.set_column_title(0,'File')
	RootTree.set_column_title(1,'Description')
	root_path=APP.Project_GetSubDir('dlg')
	print('Trying to load path for .dlg files: '+root_path)
	# Initialize the tree
	RootTree.set_hide_root(true)
	
	# Connect the built-in signal to our handler
	RootTree.item_selected.connect(ITEM_Selected)
	RootTree.item_activated.connect(ITEM_Activated)
	N_ConfirmDialog_Delete.confirmed.connect(DELETE_Confirm)
	# Create and populate the tree
	_REBUILD()
	
	# Enable drag and drop
	RootTree.set_drag_forwarding(
		Callable(self, "_get_drag_data"),
		Callable(self, "_can_drop_data"),
		Callable(self, "_drop_data")
	)
	
	# Connect drag and drop signals
	#RootTree.get_internal_drag_data.connect(_get_drag_data)
	#RootTree.can_drop_data.connect(_can_drop_data)
	#RootTree.drop_data.connect(_drop_data)

# Add this as a class variable
var _expanded_paths: Array[String] = []

func _REBUILD():
	# Save the expansion state before clearing
	_save_expansion_state(RootTree.get_root())

	# Clear existing items
	RootTree.clear()

	# Create root item
	var root = RootTree.create_item()
	root.set_text(0, "Root")

	# Start recursive population from root path
	populate_recursive(root_path, root)

	# Restore the expansion state
	_restore_expansion_state(RootTree.get_root())

# Add these helper functions
func _save_expansion_state(item: TreeItem):
	_expanded_paths.clear()
	_save_expansion_state_recursive(item)

func _save_expansion_state_recursive(item: TreeItem):
	if not item:
		return
		
	if item.collapsed:
		_expanded_paths.append(get_item_path(item))
	
	# Check children
	var child = item.get_first_child()
	while child:
		_save_expansion_state_recursive(child)
		child = child.get_next()

func _restore_expansion_state_recursive(item: TreeItem):
	if not item:
		return
		
	var path = get_item_path(item)
	if _expanded_paths.has(path):
		item.set_collapsed(false)

	# Check children
	var child = item.get_first_child()
	while child:
		_restore_expansion_state_recursive(child)
		child = child.get_next()

func _restore_expansion_state(root: TreeItem):
	_restore_expansion_state_recursive(root)

func populate_recursive(path: String, parent_item: TreeItem):
	var dir = DirAccess.open(path)
	if dir:
		# Sort directories and files separately
		var directories = []
		var files = []
		
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Skip hidden files and . / ..
			if not file_name.begins_with("."):
				var full_path = path.path_join(file_name)
				
				if dir.current_is_dir():
					directories.append(file_name)
				else:
					# Only add .json files
					files.append(file_name)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
		
		# Sort arrays alphabetically
		directories.sort()
		files.sort()
		
		# First add all directories
		for directory in directories:
			var full_path = path.path_join(directory)
			var item = RootTree.create_item(parent_item)
			item.set_text(0, directory)
			
			# Set folder icon if provided
			if Filter_Folder.icon:
				item.set_icon(0, Filter_Folder.icon)
				
			# Recursively populate the subdirectory
			populate_recursive(full_path, item)
		
		# Then add all files
		for file in files:
			# check if valid extension
			for i in Filter_Files:
				if file.get_extension() == i.extension:
					var item = RootTree.create_item(parent_item)
					item.set_text(0, file)
					var loaded_data=SynFile.FILE_LoadAsJson(path+'/'+file)
					item.set_text(1, loaded_data.get('summary',""))
					
					# Set file icon if provided
					if i.icon:
						item.set_icon(0, i.icon)
					
					# Store the full path as metadata for easy access
					item.set_metadata(0, path.path_join(file))
					
					break

func ITEM_Selected():
	pass

func ITEM_Activated():
	var selected = RootTree.get_selected()
	if selected:
		# Check if this is a file (has metadata) or directory
		var metadata = selected.get_metadata(0)
		if metadata:  # This is a file
			file_selected.emit(metadata)
			

# Helper function to get the full path of an item
func get_item_path(item: TreeItem) -> String:
	var path = []
	
	while item and item != RootTree.get_root():
		path.push_front(item.get_text(0))
		item = item.get_parent()
	
	return root_path.path_join("/".join(path))

func _on_btn_refresh_pressed():
	_REBUILD()

# ==============================================================================
# Drag & Drop
# ==============================================================================

# Add these new functions for drag and drop handling
func _get_drag_data(_position: Vector2) -> Variant:
	var selected = RootTree.get_selected()
	if not selected:
		return null
		
	# Don't allow dragging the root
	if selected == RootTree.get_root():
		return null
	
	# Get the full path of the dragged item
	var drag_data = {
		"type": "file_move",
		"path": get_item_path(selected),
		"is_directory": selected.get_metadata(0) == null  # If no metadata, it's a directory
	}
	
	# Create preview
	var preview = Label.new()
	preview.text = selected.get_text(0)
	RootTree.set_drag_preview(preview)
	
	return drag_data

func _can_drop_data(position: Vector2, data: Variant) -> bool:
	# Check if this is our type of drag and drop
	if not (data is Dictionary and data.has("type") and data["type"] == "file_move"):
		return false

	# Get the item we're hovering over
	var target_item = RootTree.get_item_at_position(position)

	# Allow dropping into root if no item is targeted
	if not target_item:
		return true

	# Only allow dropping into directories
	if target_item.get_metadata(0) != null:  # Has metadata = is file
		return false

	# Don't allow dropping into the source's own directory
	var source_path = data["path"]
	var target_path = get_item_path(target_item)
	if target_path.begins_with(source_path):
		return false

	return true

func _drop_data(position: Vector2, data: Variant) -> void:
	var target_item = RootTree.get_item_at_position(position)
	var source_path = data["path"]

	# If no target_item, we're dropping into root
	var target_path = root_path if not target_item else get_item_path(target_item)
	var file_name = source_path.get_file()
	var new_path = target_path.path_join(file_name)

	# Don't move if source and target are the same
	if source_path == new_path:
		return

	# Perform the actual file move
	var err = DirAccess.rename_absolute(source_path, new_path)

	if err == OK:
		# Emit signal for successful move
		file_moved.emit(source_path, new_path)
		# Rebuild the tree to reflect changes
		_REBUILD()
	else:
		# Handle error
		print("Error moving file: ", error_string(err))

# ===============================================================
# Popup Menus
# ===============================================================

func _on_tree_item_mouse_selected(position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_RIGHT:
		return
	
	var item = RootTree.get_item_at_position(position)
	
	#if not item, show folder
	if not item:
		N_Popup_Folder.position=RootTree.get_screen_position()+position
		N_Popup_Folder.popup()
		return
	
	if item.get_metadata(0) !=null:
		#it's a file
		N_Popup_File.position=RootTree.get_screen_position()+position
		N_Popup_File.popup()
	else:
		N_Popup_Folder.position=RootTree.get_screen_position()+position
		N_Popup_Folder.popup()
		

func DELETE_Confirm():
	var path_to_delete=RootTree.get_selected().get_metadata(0)
	if FileAccess.file_exists(path_to_delete):
		DirAccess.remove_absolute(path_to_delete)
		_REBUILD()

func _on_popup_file_id_pressed(id):
	if id==0:
		N_ConfirmDialog_Delete.popup()

func _on_btn_open_explor_pressed():
	OS.shell_open(root_path)
