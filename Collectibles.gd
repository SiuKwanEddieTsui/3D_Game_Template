extends Area3D

var is_collected = false
@onready var player = $"../../Player"
signal item_collected


func _on_body_entered(body):
	if body.name == "Player":
		Global.apple_count += 1
		print("apple count", Global.apple_count)
		body.play_pickup_sound()
		emit_signal("item_collected")
		if Global.apple_count == 30:
			player.unlock_double_jump()

		if Global.apple_count == 50:
			player.unlock_air_dash()

		queue_free() # remove object from scene
