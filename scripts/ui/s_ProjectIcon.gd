extends Control


var project_path=""
var project_data={}

signal on_selected(path: String)

@export var N_Btn: Button
@export var N_txt_path: Label

func DATA_Set(path: String):
	project_path=path
	N_txt_path.text=path
	project_data=SynFile.FILE_LoadAsJson(project_path)
	N_Btn.text=project_data.get('project_name',"")


func _on_button_pressed():
	on_selected.emit(project_path)
