extends Control

@export var N_ProjectBox: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	APP.NODE_ClearAllChildren(N_ProjectBox)
	for p in APP.app_config.get('recent_projects',[]):
		var new_item=preload("res://scripts/ui/s_ProjectIcon.tscn").instantiate()
		N_ProjectBox.add_child(new_item)
		new_item.DATA_Set(p)
		new_item.on_selected.connect(on_select_project)


func on_select_project(path):
	APP.Project_Load(path)
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
