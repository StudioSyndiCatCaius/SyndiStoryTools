extends Control
class_name WG_FileExplorer

signal file_selected(path: String)

@export var RootTree: Tree
@export var Filter_Folder: TreeExplorerFilter
@export var Filter_Files: Array[TreeExplorerFilter]
@export var root_path = "res://"  # Change this to your desired root path

func _ready():
	root_path=APP.Project_GetSubDir('dlg')
	# Initialize the tree
	RootTree.set_hide_root(true)
	RootTree.columns = 1
	
	# Connect the built-in signal to our handler
	RootTree.item_selected.connect(ITEM_Selected)
	RootTree.item_activated.connect(ITEM_Activated)
	
	# Create and populate the tree
	_REBUILD()

func _REBUILD():
	# Clear existing items
	RootTree.clear()
	
	# Create root item
	var root = RootTree.create_item()
	root.set_text(0, "Root")
	
	# Start recursive population from root path
	populate_recursive(root_path, root)

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
