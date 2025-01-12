extends Control


var event_data={
	line='',
	speaker="",
	direction="",
}

@onready var N_speaker=$MarginContainer/ColorRect/MarginContainer/HBoxContainer/Control/box_line/opt_speaker
@export var N_line: TextEdit
@export var N_direction: TextEdit

@onready var N_TypeRoot=$MarginContainer/ColorRect/MarginContainer/HBoxContainer/Control

func _ready():
	pass

func _REBUILD():
	print('godo: '+str(event_data))

	N_line.text=event_data.get('line',"")
	N_direction.text=event_data.get('direction',"")
	
	var speaker_name=event_data.get('speaker',"")
	if N_speaker:
		for i in N_speaker.item_count:
			if N_speaker.get_item_text(i)==speaker_name:
				N_speaker.selected=i
				break

func _on_bt_n_delete_pressed():
	queue_free()

func _on_opt_type_item_selected(index):
	for i in N_TypeRoot.get_children():
		i.visible=false
	N_TypeRoot.get_child(index).visible=true

func _on_t_edit_dir_text_changed():
	event_data['direction']=N_direction.text

func _on_t_edit_line_text_changed():
	event_data['line']=N_line.text
