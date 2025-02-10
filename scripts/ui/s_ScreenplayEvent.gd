extends Control
class_name wg_ScreenplayEvent

var DATA={}

@export var N_EventBox: Container

func DATA_Set(data: Dictionary):
	APP.NODE_ClearAllChildren(N_EventBox)
	DATA=data
	var scene_ref=preload("res://scripts/ui/s_ScreenplayLine.tscn")
	for i in DATA['data'].get('events',[]):
		var new_node=scene_ref.instantiate()
		new_node.DATA_Set(i)
		N_EventBox.add_child(new_node)
