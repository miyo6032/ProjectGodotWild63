extends Node

class_name StateTransition

@export var true_state: String
@export var false_state: String

var state_data = null

func get_decision() -> bool:
    return false