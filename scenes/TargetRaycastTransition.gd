extends StateTransition

class_name TargetRaycastTransition

@export var raycast2d : RayCast2D

func get_decision() -> bool:
	var player = state_data.player
	var enemy = state_data.enemy
	raycast2d.target_position = player.global_position - enemy.global_position
	return raycast2d.is_colliding()
