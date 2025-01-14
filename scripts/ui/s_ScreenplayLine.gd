extends Control

var DATA={}

@onready var N_txtDir=$VBoxContainer/txt_direction
@onready var N_txtSpeaker=$VBoxContainer/txt_speaker
@onready var N_txtLine=$VBoxContainer/txt_line

func DATA_Set(data: Dictionary):
	DATA=data
	N_txtDir.text=DATA.get('direction',"")
	N_txtSpeaker.text=DATA.get('speaker',"")
	N_txtLine.text=DATA.get('line',"")
