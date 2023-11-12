class_name State
extends Node

var state_machine = null
var state_data : get = get_state_data
var enemy : get = get_enemy
var player : get = get_player

func get_player():
    return state_machine.state_data.player

func get_enemy():
    return state_machine.state_data.enemy

func get_state_data():
    return state_machine.state_data

func handle_input(_event: InputEvent) -> void:
    pass

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass

func enter(_msg := {}) -> void:
    pass

func exit() -> void:
    pass
