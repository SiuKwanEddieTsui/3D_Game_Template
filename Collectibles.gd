extends Area3D

var is_collected = false
@onready var player = get_node("/root/Level 1/Player")
signal item_collected

func _on_body_entered(body):
	if body.name == "Player":
		global.apple_count += 1
		print("apple count", global.apple_count)
		body.play_pickup_sound()
		emit_signal("item_collected")
		if global.apple_count == 30:
			player.unlock_double_jump()
		if global.apple_count == 50:
			player.air_dash_unlocked = true
			print("Air Dash Unlocked!")
		queue_free()  # remove object from scene
