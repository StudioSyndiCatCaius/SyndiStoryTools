extends Control

var file
var DATA={}
var current_path='res://'

@export var N_FileTree:WG_FileExplorer
@export var N_Popup_Tree: PopupMenu
@export var N_Tabs_FlowGraphs: TabContainer

@onready var N_menu_file: MenuButton=$VBoxContainer/ColorRect/MenuBar/menu_file

@onready var CLASS_line=preload("res://scripts/ui/s_Line.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	N_menu_file.get_popup().index_pressed.connect(MenuSelect_File)

func MenuSelect_File(index: int):
	match index:
		0:
			GRAPH_CreateNew()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_tree_file_selected(path):
	if APP.PATH_IsFolder(path):
		current_path=path
	else:
		#file=FileAccess.open(path,FileAccess.READ_WRITE)
		#DATA = JSON.parse_string(file.get_as_text())
		var in_name=path.get_file().get_basename()
		var already_exists=false
		var in_node
		
		#if already in, select instead
		for i in N_Tabs_FlowGraphs.get_children():
			if i.name==in_name:
				in_node=i
				already_exists=true
				break
		
		if already_exists:
			N_Tabs_FlowGraphs.current_tab=N_Tabs_FlowGraphs.get_children().find(in_node)
		else:
			var new_graph = GRAPH_CreateNew()
			new_graph.GRAPH_Load_FromFile(path)


func LINE_Add(data: Dictionary):
	var new_line = CLASS_line.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	new_line.DATA=data
	new_line._REBUILD()


func LINE_AddDefault():
	LINE_Add({speaker='',line=""})

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			pass


func create_sceneFile(path):
	var new_file_path=path+"new_file.json"
	APP.FILE_CreateJson({
		events=[{speaker='',line=''}]
	},new_file_path)
	N_FileTree._REBUILD()


func _on_popup_menu_index_pressed(index):
	if index==0:
		create_sceneFile(current_path)


func _on_btn_new_line_pressed():
	LINE_AddDefault()

# ####################################################################################
# GRAPH
# ####################################################################################

func GRAPH_CreateNew(in_name: String='') -> FlowGraph:
	
	
	var new_flow=preload("res://scripts/ui/s_FlowGraph.tscn").instantiate()
	N_Tabs_FlowGraphs.add_child(new_flow)
	N_Tabs_FlowGraphs.current_tab+=1
	return new_flow

# New Flow
func _on_ie_new_scene_input_start():
	GRAPH_CreateNew()

var N_graph_active: FlowGraph
@onready var N_DialogSave=$Dialog_SaveFlow

# ####################################################################################
# SAVE
# ####################################################################################

func _on_ie_save_input_start():
	N_graph_active = N_Tabs_FlowGraphs.get_children()[N_Tabs_FlowGraphs.current_tab]
	if FileAccess.file_exists(N_graph_active.linked_file):
		ActiveGraph_Save(N_graph_active.linked_file)
	else:
		N_DialogSave.visible=true

func _on_dialog_save_flow_confirmed():
	var out_path=N_DialogSave.root_subfolder+N_DialogSave.current_dir+N_DialogSave.current_file
	ActiveGraph_Save(out_path)

func ActiveGraph_Save(path: String):
	N_graph_active.GRAPH_Save_ToFile(path)
	N_FileTree._REBUILD()
