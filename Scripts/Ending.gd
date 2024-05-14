extends Area3D

@onready var player = $"../../../../Player"

# Cooldown Timer reference
@onready var cooldown_timer = $cooldown_timer

func _on_body_entered(body):
	if not cooldown_timer.is_stopped():
		return # Exit if the timer is still running
	if body.name == "Player":
		body.play_Ending_Dialogue()
		cooldown_timer.start()
