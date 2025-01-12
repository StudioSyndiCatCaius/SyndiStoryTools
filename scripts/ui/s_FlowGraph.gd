extends Control
class_name FlowGraph

var is_dragging=false
var is_draggingOutput=false
var N_DragginNode
var N_DragginPort
var N_PropertyEdit

var linked_file='_nil'

@export var N_Root_properties: Control

@onready var N_NodeButtonBOx: Tree=$vb/HBoxContainer/Tree_DragNodes
@onready var N_FlowGraph=$vb/HBoxContainer/HSplit/Root_Graph/SFlowGraph
@onready var CLASS_FlowNode= preload("res://scripts/ui/s_FlowNode.tscn")
@onready var N_Popup_NewNode=$PopupMenu
@onready var N_Root_FlowGraph=$vb/HBoxContainer/Root_Graph

@onready var N_Notif=$vb/ColorRect2/txt_notification
@onready var N_Timer_Notify=$Timer_NotifDisplay

func _ready():
	name="untitled"
	var DragNodeRoot = N_NodeButtonBOx.create_item()
	
	for i in APP.GraphNode_Types.keys():
		var in_name=APP.GraphNode_Types[i].name
		N_Popup_NewNode.add_item(i)
		var item = N_NodeButtonBOx.create_item(DragNodeRoot)
		item.set_text(0,i)
	
	GRAPH_Load_FromDict({
		nodes=[
			{type='start',position="(0,0)", name='n_start', data={flag='start'}},
			{type='event',position="(200,-20)", name='n_event1',data={events=[{}]}},
			{type='finish',position="(500,0)", name='n_end',data={flag='end'}},
		],
		connections=[
			{from_node='n_start',from_port=0,to_node='n_event1',to_port=0,},
			{from_node='n_event1',from_port=0,to_node='n_end',to_port=0,},
		]
	})

# ==================================================================
# Notification
# ==================================================================
func NOTIFICATION_Add(text: String,color: Color):
	N_Notif.text=text
	N_Notif.self_modulate=color
	N_Timer_Notify.start(0.0)
	N_Notif.visible=true
	pass

func _on_timer_notif_display_timeout():
	N_Notif.visible=false


func _process(delta):
	if is_draggingNewNode:
		if  Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#n_dragDummy.position=get_global_mouse_position()
			pass

# ==================================================================
# DATA
# ==================================================================

func DATA_GetDictionary() -> Dictionary:
	var out={
		nodes=[],
		connections=[],
	}
	
	for i in N_FlowGraph.get_children():
		var node_data={}
		node_data['position']=i.position_offset
		node_data['type']=i.type
		node_data['name']=i.name
		node_data['data']=i.DATA
		out['nodes'].push_back(node_data)
	
	for c in N_FlowGraph.get_connection_list():
		out['connections'].push_back(c)
		
	return out



# ==================================================================
# Flow Graph -- Drop Nodes
# ==================================================================
var is_draggingNewNode=false
var n_dragItem
var n_dragDummy

func _on_tree_drag_nodes_button_clicked(item, column, id, mouse_button_index):
	pass


func _on_tree_drag_nodes_item_activated():

	if false: # THIS IS FOR A DRAG AND DROP SYSTEM. Right now doesn't work. fix later.
		is_draggingNewNode=true
		n_dragItem=N_NodeButtonBOx.get_selected()
		n_dragDummy=FlowDropNode.new()
		N_Root_FlowGraph.add_child(n_dragDummy)
	else:
		
		var spawn_pos= N_FlowGraph.scroll_offset+Vector2(150,150)+SynMath.Vector2_RandomSingle(50)
		var type_name=N_NodeButtonBOx.get_selected().get_text(0)
		Node_Create(type_name,spawn_pos)

# ==================================================================
# Flow Graph -- File
# ==================================================================

func GRAPH_Save_ToFile(filepath: String):
	linked_file=filepath
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	var data_to_save=DATA_GetDictionary()
	var json_string = JSON.stringify(data_to_save, "  ")
	file.store_string(json_string)
	NOTIFICATION_Add("Saved DLG: "+filepath,Color.LAWN_GREEN)
	return OK

func GRAPH_Load_FromFile(filepath: String):
	NOTIFICATION_Add("Loaded DLG: "+filepath,Color.LAWN_GREEN)
	linked_file=filepath
	name=filepath.get_file().get_basename()
	var in_data=JSON.parse_string(FileAccess.get_file_as_string(filepath))
	GRAPH_Load_FromDict(in_data)


func GRAPH_Load_FromDict(data: Dictionary):
	for i in N_FlowGraph.get_children():
		i.free()
			
	for i in data['nodes']:
		var in_pos=Vector2(0,0)
		in_pos=SynMath.Vector2_FromString(i.get('position','(500,20)'))
		Node_Create(i['type'],in_pos,i.get('name',''),i.get('data',{}))
	
	for i in data['connections']:
		N_FlowGraph.connect_node(i['from_node'],i['from_port'],i['to_node'],i['to_port'],)

# ==================================================================
# Flow Graph -- NODES
# ==================================================================
func Node_Create(type: String,  position: Vector2, node_name: String='',data:Dictionary={}):
	var new_node: GraphNode = CLASS_FlowNode.instantiate()

	N_FlowGraph.add_child(new_node)
	new_node.position_offset=position
	new_node.type=type
	if node_name != '':
		new_node.name=node_name
	else:
		new_node.name=type
		
	new_node.DATA=data
	new_node._REBUILD()
	if N_DragginNode:
		if is_draggingOutput:
			N_FlowGraph.connect_node(N_DragginNode,N_DragginPort,new_node.name,0)
		else:
			N_FlowGraph.connect_node(new_node.name,0,N_DragginNode,N_DragginPort)


var propertyEditorTypes=[
	preload("res://scripts/ui/s_Properties.tscn"),
]

func _on_s_flow_graph_node_selected(node):
	if N_PropertyEdit!=null:
		N_PropertyEdit.queue_free()
	var type_data=APP.GraphNode_Types[node.type]
	var editor_type=propertyEditorTypes[type_data.get('editor_type',0)]
	N_PropertyEdit=editor_type.instantiate()
	
	N_PropertyEdit._SETUP(type_data.get('schema',{}),node.DATA)
	
	N_Root_properties.add_child(N_PropertyEdit)

func _on_s_flow_graph_node_deselected(node):
	if N_PropertyEdit:
		N_PropertyEdit.queue_free()


# ==================================================================
# Flow Graph -- Connect/Disconect
# ==================================================================
func _on_s_flow_graph_connection_request(from_node, from_port, to_node, to_port):
	#SynNode.GraphNode_DisconnectNode(N_FlowGraph,N_FlowGraph.get_node(from_node),true,false)
	
	N_FlowGraph.connect_node(from_node,from_port,to_node,to_port)

func _on_s_flow_graph_disconnection_request(from_node, from_port, to_node, to_port):
	N_FlowGraph.disconnect_node(from_node,from_port,to_node,to_port)

# ==================================================================
# Flow Graph -- Drag
# ==================================================================
func _on_s_flow_graph_connection_drag_started(from_node, from_port, is_output):
	N_DragginNode=from_node
	N_DragginPort=from_port
	is_draggingOutput=is_output


func _on_s_flow_graph_connection_drag_ended():
	N_DragginNode=null


func _on_s_flow_graph_delete_nodes_request(nodes):
	for c in N_FlowGraph.get_children():
		if nodes.has(c.name):
			c.queue_free()

# ==================================================================
# INPUTS
# ==================================================================
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if get_viewport().gui_get_focus_owner()==N_FlowGraph:
				pass
				#N_Popup_NewNode.popup()
				#N_Popup_NewNode.position=get_global_mouse_position()


func _on_popup_menu_index_pressed(index):
	N_Popup_NewNode.hide()
	get_viewport().gui_release_focus()  # Force release any stuck focus
	var dat = APP.GraphNode_Types
	var in_type=dat.keys()[index]
	Node_Create(in_type,get_global_mouse_position())

func _on_button_pressed():
	SynNode.GraphNode_DisconnectAll(N_FlowGraph)

func _on_btn_close_pressed():
	queue_free()

func _on_s_flow_graph_connection_to_empty(from_node, from_port, release_position):
	SynNode.GraphNode_DisconnectNode(N_FlowGraph,N_FlowGraph.get_node(from_node),true,false)

