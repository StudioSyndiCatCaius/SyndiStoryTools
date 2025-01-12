extends GraphNode
class_name  Flow_Node

@onready var N_Btn=$TextEdit/Button

var DATA={}
var type: String='event'

# temp
var type_data={}

# Called when the node enters the scene tree for the first time.
func _ready():
	size=Vector2(250,150)



func _REBUILD():
	if APP.GraphNode_Types.has(type):
		type_data=APP.GraphNode_Types[type]
		title=type_data.name
		self_modulate=type_data.color
		size=type_data.size
		
		if type_data.has('is_button'):
			N_Btn.visible=type_data.is_button
			N_Btn.text=type_data.button_name
		else:
			N_Btn.visible=false
		
		set_slot_enabled_left(0,type_data.inputs.size()>0)
		set_slot_enabled_right(0,type_data.outputs.size()>0)


