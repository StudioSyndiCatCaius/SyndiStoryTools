extends wg_PropertyBase

@export var N_ValueEdit: TextEdit



func _init_value():
	default_value=''
	N_ValueEdit.text=Value_Get()


func _on_text_edit_text_changed():
	Value_Set(N_ValueEdit.text)
