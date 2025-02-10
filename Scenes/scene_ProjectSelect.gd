extends Control

@export var N_ProjectBox: Control

@export var N_BTN_New: Button
@export var N_Dialog_New: FileDialog
@export var N_Dialog_Open: FileDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	N_Dialog_New.root_subfolder=APP.Project_GetBasePath()
	__RebuildList()

func __RebuildList():
	APP.NODE_ClearAllChildren(N_ProjectBox)
	for p in APP.app_config.get('recent_projects',[]):
		var new_item=preload("res://scripts/ui/s_ProjectIcon.tscn").instantiate()
		N_ProjectBox.add_child(new_item)
		new_item.DATA_Set(p)
		new_item.on_selected.connect(on_select_project)

func on_select_project(path):
	print('try open: '+path)
	APP.Project_Load(path)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_btn_create_project_pressed():
	N_Dialog_New.popup()
	
func _on_btn_open_project_pressed():
	N_Dialog_Open.popup()

# =============================================================================
# DIALOG
# =============================================================================


func _on_dialog_new_file_selected(path):
	var filepath=path+'.SyndiStory'
	filepath=filepath.replace("\\", "/")
	var new_project_data={
		project_name=filepath.get_file().get_basename(),
		directories=["./"]
	}
	SynFile.FILE_SaveAsJson(new_project_data,filepath)
	APP.app_config['recent_projects'].push_back(filepath)
	__RebuildList()


func _on_dialog_open_file_selected(path):
	var file_path=path.replace("\\", "/")
	if FileAccess.file_exists(file_path):
		var file_data=SynFile.FILE_LoadAsJson(file_path)
		if file_data is Dictionary:
			if !APP.app_config['recent_projects'].has(file_path):
				APP.app_config['recent_projects'].push_back(file_path)
			on_select_project(file_path)
