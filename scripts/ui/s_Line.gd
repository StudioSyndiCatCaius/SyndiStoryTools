extends Control
class_name wg_EventLine

var event_data={
	line='',
	speaker="",
	direction="",
}

signal onSelectAdd(instigator: Control)
signal onDelete(instigator: Control)
signal onDuplicate(instigator: Control)

@export var N_speaker: OptionButton
@export var N_line: TextEdit
@export var N_direction: TextEdit
@export var N_script: CodeEdit
@export var N_LineIndex:Label
@export var N_portrait:TextureRect

@onready var animator=$AnimationPlayer

func _ready():
	animator.play("appear")

func _process(delta):
	N_LineIndex.text=str(get_parent().get_children().find(self))

func FOCUS_Give():
	N_line.grab_focus()


func _REBUILD():
	#)
	N_speaker.clear()
	var input=0
	for i in APP._D.get('Speakers',[]):
		N_speaker.add_item(i,input)
		input+=1

	
	N_line.text=event_data.get('line',"")
	N_direction.text=event_data.get('direction',"")
	N_script.text=event_data.get('script',"")
	
	var speaker_name=event_data.get('speaker',"")
	for i in range(N_speaker.item_count):
		if N_speaker.get_item_text(i)==speaker_name:
			N_speaker.select(i)
	
	REBUILD_Portrait()


func _on_bt_n_delete_pressed():
	onDelete.emit(self)


func _on_t_edit_dir_text_changed():
	event_data['direction']=N_direction.text

func _on_t_edit_line_text_changed():
	event_data['line']=N_line.text

func _on_t_edit_code_text_changed():
	event_data['script']=N_script.text

func _on_opt_speaker_item_selected(index):
	event_data['speaker']=N_speaker.get_item_text(index)
	REBUILD_Portrait()

func REBUILD_Portrait():
	var img_path="PO_"+N_speaker.get_item_text(N_speaker.selected)+".png"
	print(img_path)
	var img=APP.IMPORT_Image(img_path)
	N_portrait.texture=img
	N_portrait.custom_minimum_size=Vector2(100,100)

func _on_bt_n_new_pressed():
	onSelectAdd.emit(self)

func _on_ie_new_line_input_start():
	_on_bt_n_new_pressed()

func _on_ie_line_delete_input_start():
	onDelete.emit(self)

func _on_bt_n_dupe_pressed():
	onDuplicate.emit(self)

