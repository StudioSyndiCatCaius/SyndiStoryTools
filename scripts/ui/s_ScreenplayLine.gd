extends Control

var DATA={}

@export var N_txtDir: Label
@export var N_txtSpeaker: Label
@export var N_txtLine: TextEdit

func DATA_Set(data: Dictionary):
	DATA=data
	N_txtDir.text=DATA.get('direction',"")
	N_txtSpeaker.text=DATA.get('speaker',"")
	N_txtLine.text=DATA.get('line',"")


func _on_text_edit_line_text_changed():
	DATA['line']=N_txtLine.text
