extends StateTransition

class_name DetectTargetTransition

@export var range_min_name: String
@export var range_max_name: String
@export var raycast2d : RayCast2D

func get_decision() -> bool:
    var distance_range = Vector2(state_data[range_min_name], state_data[range_max_name])
    var player = state_data.player
    var enemy = state_data.enemy
    var distance = (enemy.global_position - player.global_position).length_squared()
    raycast2d.target_position = player.global_position - enemy.global_position
    var no_solid_objects = not raycast2d.is_colliding()
    return distance < pow(distance_range.y, 2.0) and distance > pow(distance_range.x, 2.0) and no_solid_objects
