extends wg_PropertyBase

@export var N_ValueEdit: TextEdit




func _init_value():
	custom_minimum_size.y=_GetMetaValue('size',30)
	default_value=''
	N_ValueEdit.text=Value_Get()


func _on_text_edit_text_changed():
	Value_Set(N_ValueEdit.text)
