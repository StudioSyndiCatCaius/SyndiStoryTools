extends Control
class_name wg_ScreenplayDisplay

@export var N_Vbox: Container

func __DATA_Set(data: Dictionary):
	
	if N_Vbox:
		APP.NODE_ClearAllChildren(N_Vbox)
		var scene_ref=preload("res://scripts/ui/s_ScreenplayEvent.tscn")
		for i in data.get('nodes',[]):
			if i['type']=='event':
				var new_node=scene_ref.instantiate()
				new_node.DATA_Set(i)
				N_Vbox.add_child(new_node)
