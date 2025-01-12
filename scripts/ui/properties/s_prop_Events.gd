extends wg_PropertyBase
class_name PropertyEdit_Event



@export var N_EventList: VBoxContainer

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

func LINE_New(data: Dictionary):
	print('ido'+str(data))
	var new_event=preload("res://scripts/ui/s_Line.tscn").instantiate()
	
	new_event.event_data=data
	
	new_event._REBUILD()
	N_EventList.add_child(new_event)


func _on_btn_new_line_pressed():
	var val=Value_GetDefault()
	LINE_New(val)
	_validateEvents()
	owner_DATA.events.push_back(val)
