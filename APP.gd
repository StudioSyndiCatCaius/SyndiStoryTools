extends Node

var L = LuaAPI.new()

func _ready():
	for i in SynFile.FILES_ListInDirectory("res://lua/nodes/",'lua'):
		var lua_data = L.do_file(i)
		if lua_data.has('id'):
			GraphNode_Types[lua_data['id']]=lua_data

# ----------------------------------------------------------------
# Types
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# DATA
# ----------------------------------------------------------------
var GraphNode_Types={}
var GraphNode_TypesB={
	start={
		name="Start",
		inputs=[],
		outputs=[{}],
		color=Color.RED,
		size=Vector2(100,50),
		schema={flag='String'},
	},
	finish={
		name="Finish",
		inputs=[{}],
		outputs=[],
		color=Color.RED,
		size=Vector2(100,50),
		schema={flag='String'}
	},
	event={
		name="Event",
		inputs=[{}],
		outputs=[{}],
		color=Color.SKY_BLUE,
		size=Vector2(200,100),
		schema={events='Events'},
	},
	choice_hub={
		name="Choice Hub",
		inputs=[{}],
		outputs=[{}],
		allowed_outputs=['choice'],
		color=Color.MEDIUM_SEA_GREEN,
		size=Vector2(100,50),
	},
	choice={
		name="Choice",
		inputs=[{}],
		outputs=[{}],
		allowed_inputs=['choice_hub'],
		color=Color.PALE_GREEN,
		size=Vector2(200,100),
		DATA={Text=""}
		
	},
	to_hub={
		name="To HUB",
		inputs=[{}],
		outputs=[],
		color=Color.BURLYWOOD,
		size=Vector2(150,75),
	},
	hub={
		name="HUB",
		inputs=[],
		outputs=[{}],
		color=Color.BURLYWOOD,
		size=Vector2(150,75),
	},
	to_scene={
		name="To Scene",
		inputs=[{}],
		outputs=[],
		color=Color.MEDIUM_PURPLE,
		size=Vector2(200,100),
		is_button=true, button_name="Open"
	},
}


# ----------------------------------------------------------------
# PATH
# ----------------------------------------------------------------

func FILE_CreateJson(dict: Dictionary, file_path: String) -> Error:
	# Convert dictionary to JSON string
	var json_string = JSON.stringify(dict)
	
	# Create new file
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
		
	# Write to file
	file.store_string(json_string)
	
	return OK


# ----------------------------------------------------------------
# NODES
# ----------------------------------------------------------------

func NODE_ClearAllChildren(node: Node):
	if node:
		for i in node.get_children():
			i.queue_free()

func NODE_ChildHasFocus(node: Node) -> bool:
	if node:
		for i in node.get_children():
			i.queue_free()
	return false

# ----------------------------------------------------------------
# PATH
# ----------------------------------------------------------------

func PATH_IsFile(path: String) -> bool:
	return FileAccess.file_exists(path)

func PATH_IsFolder(path: String) -> bool:
	return DirAccess.dir_exists_absolute(path)
