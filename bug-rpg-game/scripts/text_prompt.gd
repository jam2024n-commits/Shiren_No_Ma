extends CanvasLayer

@onready var _root: Control = $Root
@onready var _title: Label = $Root/Panel/Title
@onready var _log: Label = $Root/Panel/Log

var _was_paused := false


func _ready() -> void:
	_root.visible = false


func is_open() -> bool:
	return _root.visible


# 文章を出す（看板など）。E / Enter / Esc で閉じる
func show_message(title: String, message: String) -> void:
	_title.text = title
	_log.text = message
	_was_paused = get_tree().paused
	get_tree().paused = true
	_root.visible = true


func close() -> void:
	_root.visible = false
	get_tree().paused = _was_paused


func _input(event: InputEvent) -> void:
	if not is_open():
		return
	if event.is_action_pressed("pause_menu") or _is_message_close(event):
		close()
		get_viewport().set_input_as_handled()


func _is_message_close(event: InputEvent) -> bool:
	if event.is_action_pressed("interact"):
		return true
	var key := event as InputEventKey
	return key != null and key.pressed and not key.echo \
		and (key.keycode == KEY_ENTER or key.keycode == KEY_KP_ENTER)
