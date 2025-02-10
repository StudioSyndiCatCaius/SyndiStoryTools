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

func Project_GetSubDir(dir_name: String, create_if_invalid: bool=false):
	var target=Project_GetBasePath()+"/"+dir_name+"/"
	if !DirAccess.dir_exists_absolute(target) and create_if_invalid:
		DirAccess.make_dir_absolute(target)
	return target

func Project_GetConfigFilePath()-> String:
	return APP.APP_GetRootDir('saved')+'config.json'

func _ready():
	var config_path=Project_GetConfigFilePath()
	print('trying to load config.json from: '+config_path)
	APP.app_config=SynFile.FILE_LoadAsJson(config_path)
	
	app_config['recent_projects']=app_config.get('recent_projects',[])
	
	Project_Load(app_config['recent_projects'][0])

func _exit_tree():
	SynFile.FILE_SaveAsJson(app_config,Project_GetConfigFilePath())

func Project_Load(path: String):
	GraphNode_Types={}
	_D={}
	project_path=path
	project_data=JSON.parse_string(FileAccess.get_file_as_string(project_path))
	if project_data==null:return
	
	# LOAD LUA LIBS
	lua.bind_libraries(["base", "table", "string", "io"])
	
	for p in project_data.get('directories',[]):
		var real_path=p
		if p=="./":
			real_path=Project_GetBasePath()
			# load database
			print('---- Begin loading DATA ----')
			
			for i in SynFile.FILES_ListInDirectory(real_path+"/data/",'lua'):
				print('Trying to load .lua file as DATA: '+i)
				var lua_data = lua.do_file(i)
				print('load result: '+str(lua_data))
				
			print('---- Begin loading nodes ----')
			
			for i in SynFile.FILES_ListInDirectory(SynFile.Dir_Root()+"lua/nodes/",'lua'):
				print('Trying to load .lua file as Node: '+i)
				var lua_data = lua.do_file(i)
				if lua_data is LuaError:
					print('load ERROR: '+str(lua_data))
				else:
					print('load SUCCESS')
				if lua_data.has('id'):
					GraphNode_Types[lua_data['id']]=lua_data
	
	var new_D=lua.pull_variant('_D')
	if new_D is Dictionary:
		_D = lua.pull_variant('_D')


# ----------------------------------------------------------------
# PATH
# ----------------------------------------------------------------




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
