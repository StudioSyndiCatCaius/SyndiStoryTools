extends Node
class_name cmp_InputEvent

@export var input_key: Key
@export var require_shift: bool = false
@export var require_alt: bool = false
@export var require_ctrl: bool = false

signal input_start
signal input_update
signal input_stop

func _input(event: InputEvent):
	if event is InputEventKey and event.keycode == input_key:
		# Check if all required modifiers are pressed
		if require_shift == event.shift_pressed and \
		   require_alt == event.alt_pressed and \
		   require_ctrl == event.ctrl_pressed:
			if event.pressed and not event.is_echo():
				input_start.emit()
			elif not event.pressed:
				input_stop.emit()

func _process(_delta):
	if Input.is_key_pressed(input_key) and \
	   (not require_shift or Input.is_key_pressed(KEY_SHIFT)) and \
	   (not require_alt or Input.is_key_pressed(KEY_ALT)) and \
	   (not require_ctrl or Input.is_key_pressed(KEY_CTRL)):
		input_update.emit()
