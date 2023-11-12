extends Node

class_name StateTransition

@export var true_state: State
@export var false_state: State

var state_data = null

func get_decision() -> bool:
    return false