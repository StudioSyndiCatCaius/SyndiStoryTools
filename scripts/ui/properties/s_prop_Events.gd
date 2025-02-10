extends wg_PropertyBase
class_name PropertyEdit_Event



@export var N_EventList: VBoxContainer
@export var N_KeyOffsetStart: SpinBox


func _init_value():
	_REBUILD()
	

func Value_GetDefault()-> Dictionary:
	return {speaker='',line="",direction=""}

func _validateEvents():
	if !owner_DATA.has('events'):
		owner_DATA['events']=[]

func _REBUILD():
	for i in N_EventList.get_children():
		i.queue_free()
	
	_validateEvents()
	for i in owner_DATA.events:
		LINE_New(i)

func LINE_NewDefault(auto_index: int=-1) -> wg_EventLine:
	return LINE_New(Value_GetDefault(),auto_index)

func LINE_New(data: Dictionary, auto_index: int=-1) -> wg_EventLine:
	var new_event=preload("res://scripts/ui/s_Line.tscn").instantiate()

	new_event.event_data=data.duplicate(true)
	
	new_event.onSelectAdd.connect(on_LineAdd)
	new_event.onDelete.connect(on_LineDelete)
	new_event.onDuplicate.connect(on_LineCopy)
	
	N_EventList.add_child(new_event)
	if auto_index>=0:
		N_EventList.move_child(new_event,auto_index)
		
	new_event._REBUILD()
	return new_event

func _process(delta):
	owner_DATA.events=[]
	for i in N_EventList.get_children():
		owner_DATA.events.push_back(i.event_data)

func on_LineAdd(node: Node):
	var ind=N_EventList.get_children().find(node)+1
	var new_node=LINE_NewDefault(ind)
	new_node.FOCUS_Give()

func on_LineDelete(node: Node):
	var new_index=N_EventList.get_children().find(node)-1
	node.queue_free()
	var target = N_EventList.get_child(new_index)
	#target.FOCUS_Give()
	
func on_LineCopy(node: Node):
	var ind=N_EventList.get_children().find(node)+1
	var new_node=LINE_New(node.event_data,ind)
	new_node.FOCUS_Give()

func _on_btn_new_line_pressed():
	LINE_NewDefault().FOCUS_Give()

func _on_btn_clear_all_pressed():
	APP.NODE_ClearAllChildren(N_EventList)


func _on_btn_autoset_keys_pressed():
	
	for i in N_EventList.get_children().size():
		var dat=N_EventList.get_children()[i]
		var new_key=owner_DATA.get('name','')+'_'+str(i+N_KeyOffsetStart.value)
		dat.SetKey(new_key)
