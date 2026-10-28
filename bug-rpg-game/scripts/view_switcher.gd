extends CanvasLayer

const FADE_TIME := 0.4

@onready var _fade: ColorRect = $Fade

var _busy := false


func go_to(scene_path: String) -> void:
	await _switch(scene_path)


func _switch(scene_path: String) -> void:
	if _busy:
		return
	_busy = true
	await _fade_to(1.0)
	var old_scene := get_tree().current_scene
	get_tree().change_scene_to_file(scene_path)
	await _wait_for_scene(old_scene)
	await get_tree().process_frame
	await _fade_to(0.0)
	_busy = false


func _wait_for_scene(old_scene: Node) -> Node:
	for i in 30:
		await get_tree().process_frame
		var scene := get_tree().current_scene
		if scene != null and scene != old_scene:
			return scene
	return null


func _fade_to(alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(_fade, "color:a", alpha, FADE_TIME)
	await tween.finished
