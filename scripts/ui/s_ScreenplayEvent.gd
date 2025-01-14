extends Control
class_name wg_ScreenplayEvent

var DATA={}

@export var N_EventBox: Container

func DATA_Set(data: Dictionary):
	APP.NODE_ClearAllChildren(N_EventBox)
	
	DATA=data
	for i in DATA.get('events',[]):
		var new_node=preload("res://scripts/ui/s_ScreenplayLine.tscn").instantiate()
		DATA_Set(i)
		N_EventBox.add_child(new_node)
