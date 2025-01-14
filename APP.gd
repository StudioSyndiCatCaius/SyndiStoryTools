extends Node

var lua = LuaAPI.new()

var app_config={}

var _D={}
var GraphNode_Types={}

var project_path=""
var project_data={}
var kino=''

func Project_GetBasePath():
	return SynString.Split(project_path,"/",true)[0]

func Project_GetSubDir(dir_name: String):
	return Project_GetBasePath()+"/"+dir_name+"/"

func _ready():
	var config_path=APP.APP_GetRootDir('saved')+'config.json'
	APP.app_config=SynFile.FILE_LoadAsJson(config_path)
	
	Project_Load(app_config['recent_projects'][0])

func Project_Load(path: String):
	GraphNode_Types={}
	_D={}
	project_path=path
	project_data=JSON.parse_string(FileAccess.get_file_as_string(project_path))
	if project_data==null:return
	
	# LOAD LUA LIBS
	lua.bind_libraries(["base", "table", "string"])
	
	for p in project_data.get('directories',[]):
		var real_path=p
		if p=="./":
			real_path=Project_GetBasePath()
			# load database
			for i in SynFile.FILES_ListInDirectory(real_path+"/data/",'lua'):
				var lua_data = lua.do_file(i)

			for i in SynFile.FILES_ListInDirectory(SynFile.Dir_Root()+"lua/nodes/",'lua'):
				var lua_data = lua.do_file(i)
				if lua_data.has('id'):
					GraphNode_Types[lua_data['id']]=lua_data
	
	var new_D=lua.pull_variant('_D')
	if new_D is Dictionary:
		_D = lua.pull_variant('_D')


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

func IMPORT_Image(path: String) -> ImageTexture:
	return SynFile.IMPORT_ImageAsTexture(Project_GetSubDir('/img/')+path)


func APP_GetRootDir(dir: String)-> String:
	return SynFile.Dir_Root()+dir+'/'
