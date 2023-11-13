extends State

class_name EnemyDeathState

@export var move_lag : float = 16.0

func enter(_msg := {}) -> void:
    state_data.can_move = false
    enemy.animated_sprite.play("die")
    await enemy.animated_sprite.animation_finished
    await get_tree().create_timer(0.1).timeout
    enemy.queue_free()

func physics_update(delta: float) -> void:
    enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, delta * move_lag)