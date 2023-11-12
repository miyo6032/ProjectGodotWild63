extends StateTransition

@export var distance : float

func get_decision() -> bool:
    var player = state_data.player
    var enemy = state_data.enemy
    var within_distance = (enemy.global_position - player.global_position).length_squared() < pow(distance, 2.0)
    return within_distance
