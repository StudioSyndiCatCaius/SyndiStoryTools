extends Control
class_name PropertyEdit_Common

@export var N_VBox: VBoxContainer

var DATA={}
var Schema={}

var type_widgets={
	String=preload("res://scripts/ui/properties/s_prop_text.tscn"),
	int=preload("res://scripts/ui/properties/s_prop_int.tscn"),
	float=preload("res://scripts/ui/properties/s_prop_float.tscn"),
	bool=preload("res://scripts/ui/properties/s_prop_bool.tscn"),
	Events=preload("res://scripts/ui/properties/s_prop_Events.tscn"),
	Script=preload("res://scripts/ui/properties/s_prop_script.tscn"),
	Code=preload("res://scripts/ui/properties/s_prop_code.tscn"),
}

func _ready():
	_REBUILD()

func _SETUP(schema, data):
	Schema=schema
	DATA=data
	_REBUILD()

func _REBUILD():
	APP.NODE_ClearAllChildren(N_VBox)
	for i in Schema:
		var in_type=Schema[i]
		var new_prop=type_widgets[in_type].instantiate()
		N_VBox.add_child(new_prop)
		new_prop._SETUP(DATA,i)



