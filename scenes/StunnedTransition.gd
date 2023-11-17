extends StateTransition

class_name StunnedTransition

func get_decision() -> bool:
    return state_data.stunned and not state_data.is_dead