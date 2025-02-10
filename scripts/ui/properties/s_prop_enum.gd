extends wg_PropertyBase

@export var N_ValueEdit: OptionButton

var option_strings: Array

func _init_value():
	var local_meta=owner_META.get(owner_field,{})
	var val_call=local_meta.get('GetOptions',null)
	if val_call!=null:
		option_strings=val_call.call()
		N_ValueEdit.clear()
		for i in option_strings:
			N_ValueEdit.add_item(i)
	default_value=''
	
	for i in N_ValueEdit.item_count:
		if N_ValueEdit.get_item_text(i)==Value_Get():
			N_ValueEdit.selected=i
			break

func _on_option_button_item_selected(index):
	var target_val=N_ValueEdit.get_item_text(index)
	print('targo: '+target_val)
	Value_Set(target_val)
