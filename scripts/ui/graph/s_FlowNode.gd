extends GraphNode
class_name  Flow_Node

@onready var N_Btn=$TextEdit/Button
@export var N_label: Label

var DATA={}
var type: String='event'

# temp
var type_data={}

# Called when the node enters the scene tree for the first time.
func _ready():
	var _timr: Timer =$Timer
	_timr.wait_time=randf_range(0.1,0.2)
	size=Vector2(250,150)

func _REBUILD():
	if APP.GraphNode_Types.has(type):
		type_data=APP.GraphNode_Types[type]
		title=type_data.name
		var in_colr=type_data.color
		self_modulate=SynType.conv_DictToColor(in_colr) 
		size=SynType.conv_DictToVec2(type_data.size)
		
		if type_data.has('is_button'):
			N_Btn.visible=type_data.is_button
			N_Btn.text=type_data.button_name
		else:
			N_Btn.visible=false
		
		var far=[]
		far.size()
		
		for index in type_data.inputs.size():
			print('tingo: '+str(index)+'/'+str(type_data.inputs.size()))
			var pin_data=type_data.inputs[index]
			get_child(index).visible=true
			set_slot_enabled_left(index,true)
			set_slot_color_left(index,SynType.conv_DictToColor(pin_data.get('color',{})))
			
		for index in type_data.outputs.size():
			var pin_data=type_data.outputs[index]
			print('do the output: '+str(index))
			get_child(index).visible=true
			set_slot_enabled_right(index,true)
			set_slot_color_right(index,SynType.conv_DictToColor(pin_data.get('color',{})))
		
		resizable=type_data.get('resize',false)
		
		if IS_DirectEditable():
			var cont: Control = $TextEdit
			cont.mouse_filter=0
	# STYLES



func IS_DirectEditable()->bool:
	if type_data==null: return false
	return type_data.get('direct_edit',false)

func _process(delta):
	pass
	
	#if IS_DirectEditable():
	#	if type_data.has('OnDirectEdit'):
#			var mthd=type_data['OnDirectEdit']
	#		var output=mthd.call(self,N_label.text)


func _on_timer_timeout():
	if type_data.has('GetDisplayText'):
		var mthd=type_data['GetDisplayText']
		var output=mthd.call(type_data,DATA)
		if typeof(output)==TYPE_STRING:
			N_label.text=output
	
	if type_data.has('GetNodeTitle'):
		var mthd=type_data['GetNodeTitle']
		var output=mthd.call(type_data,DATA)
		if typeof(output)==TYPE_STRING and output!='':
			title=output
