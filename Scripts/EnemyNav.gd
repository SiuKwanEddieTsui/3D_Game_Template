extends Node3D

@onready var player = $"../Player"

func _physics_process(_delta):
	# Check if the player node exists
	if player:
		# Check if there are enemies in the current level
		var enemies = get_tree().get_nodes_in_group("enemies")
		if enemies.size() > 0:
			get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
