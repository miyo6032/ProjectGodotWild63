extends StateTransition

class_name EnemyDiedTransition

func get_decision() -> bool:
    return state_data.is_dead
