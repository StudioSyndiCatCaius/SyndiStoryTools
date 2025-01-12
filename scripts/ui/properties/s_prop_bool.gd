extends wg_PropertyBase

@export var N_check: CheckBox

func _init_value():
	default_value=false
	N_check.toggle_mode=Value_Get()


func _on_check_box_toggled(toggled_on):
	Value_Set(toggled_on)
