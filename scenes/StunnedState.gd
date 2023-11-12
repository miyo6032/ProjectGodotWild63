extends State

class_name StunnedState

@export var stun_time : float = 1.0
@export var recover_state : State

var stunned_tween

func enter(_msg := {}) -> void:
    state_data.can_move = false
    enemy.animated_sprite.play("idle")
    stunned_tween = create_tween()
    stunned_tween.tween_callback(remove_stun).set_delay(stun_time)

func remove_stun():
    state_data.can_move = true
    state_data.stunned = false
    state_machine.transition_to(recover_state)

func exit() -> void:
    if stunned_tween:
        stunned_tween.kill()
