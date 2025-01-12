extends Control
class_name wg_PropertyBase

@export var N_label: Label

var owner_DATA={}
var owner_field=''
var default_value=0

func _SETUP(data,field):
	owner_DATA=data
	owner_field=field
	if N_label!=null:
		N_label.text=field
	_init_value()

func _init_value():
	pass

func Value_Get():
	return owner_DATA.get(owner_field,default_value)

func Value_Set(value):
	owner_DATA[owner_field]=value
