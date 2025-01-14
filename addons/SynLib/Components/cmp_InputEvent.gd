extends Node
class_name cmp_InputEvent

@export var input_key: Key
@export var require_shift: bool = false
@export var require_alt: bool = false
@export var require_ctrl: bool = false
@export var RequiredFocus: Array[Control]
@export var VisibilityBind: Array[Node]
@export var TickUpdate=false

var can_input=true

signal input_start
signal input_update
signal input_stop

func setBoundAsVisible(val):
	for i in VisibilityBind:
		if i!=null:
			i.visible=val

func _ready():
	setBoundAsVisible(false)
	await get_tree().create_timer(1).timeout
	can_input=true

func CanInput():
	if can_input:
		if RequiredFocus.is_empty(): return true
		for i in RequiredFocus:
			if i.has_focus(): return true
	return false

func _input(event: InputEvent):
	if CanInput():
		if event is InputEventKey and event.keycode == input_key:
			# Check if all required modifiers are pressed
			if require_shift == event.shift_pressed and \
			   require_alt == event.alt_pressed and \
			   require_ctrl == event.ctrl_pressed:
				if event.pressed and not event.is_echo():
					input_start.emit()
					setBoundAsVisible(true)
				elif not event.pressed:
					setBoundAsVisible(false)
					input_stop.emit()

func _process(_delta):
	if TickUpdate:
		if CanInput():
			if Input.is_key_pressed(input_key) and \
			   (not require_shift or Input.is_key_pressed(KEY_SHIFT)) and \
			   (not require_alt or Input.is_key_pressed(KEY_ALT)) and \
			   (not require_ctrl or Input.is_key_pressed(KEY_CTRL)):
				input_update.emit()
