extends State

class_name StunnedState

@export var recover_state : State
@export var transition_speed : float = 4.0

var stunned_tween

func enter(_msg := {}) -> void:
    state_data.can_move = false

    var direction = player.global_position - enemy.global_position
    if direction.x != 0:
        enemy.set_flip(direction.x < 0)

    enemy.animated_sprite.play("hit")
    await enemy.animated_sprite.animation_finished
    state_data.can_move = true
    state_data.stunned = false
    state_machine.transition_to(recover_state)

func exit() -> void:
    if stunned_tween:
        stunned_tween.kill()

func physics_update(delta: float) -> void:
    enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, delta * transition_speed)
