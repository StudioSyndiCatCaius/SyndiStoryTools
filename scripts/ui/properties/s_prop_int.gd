extends wg_PropertyBase

func _init_value():
	$HBoxContainer/SpinBox.value=Value_Get()

func _on_spin_box_value_changed(value):
	Value_Set(value)
