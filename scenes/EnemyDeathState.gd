extends State

class_name EnemyDeathState

@export var move_lag : float = 16.0

func enter(_msg := {}) -> void:
    state_data.can_move = false

    var direction = player.global_position - enemy.global_position
    if direction.x != 0:
        enemy.set_flip(direction.x < 0)

    enemy.set_sprite_animation("hit")
    await enemy.animated_sprite.animation_finished
    enemy.queue_free()

func physics_update(delta: float) -> void:
    enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, delta * move_lag)