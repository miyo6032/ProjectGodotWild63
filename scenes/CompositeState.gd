extends State

class_name CompositeState

@export var states : Array[State]

func set_state_machine(new_state_machine):
    state_machine = new_state_machine
    for state in states:
        state.set_state_machine(new_state_machine)

func enter(_msg := {}) -> void:
    for state in states:
        state.enter(_msg)

func exit() -> void:
    for state in states:
        state.exit()

func handle_input(_event: InputEvent) -> void:
    for state in states:
        state.handle_input(_event)

func update(_delta: float) -> void:
    for state in states:
        state.update(_delta)

func physics_update(_delta: float) -> void:
    for state in states:
        state.physics_update(_delta)
