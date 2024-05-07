extends Area3D

@export_file var level_to_load

var player_entered = false
signal update_console

func _unhandled_input(_event):
	if Input.is_action_just_pressed("portal") and global.apple_count >= 30:
		get_tree().change_scene_to_file(level_to_load)

func _on_body_entered(_body):
	player_entered = true
	if global.apple_count < 30:
		emit_signal("update_console", "Collect 30 apples to unlock the portal")
	else:
		emit_signal("update_console", "Press G to go to the next level")

func _on_body_exited(_body):
	player_entered = false
	emit_signal("update_console", "")
