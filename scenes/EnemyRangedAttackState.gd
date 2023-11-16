extends State

class_name EnemyRangedAttackState

@export var shoot_time: float = 2
@export var telegraph_time: float = 1.0
@export var shoot_logic: ShootLogic

var current_time = shoot_time
var fireball_tween: Tween

func update(delta: float) -> void:
    current_time += delta
    if current_time >= shoot_time:
        state_data.can_move = false
        enemy.animated_sprite.play("attack")
        fireball_tween = create_tween()
        fireball_tween.tween_callback(fireball).set_delay(telegraph_time)
        current_time = 0

func fireball():
    state_data.can_move = true
    shoot_logic.shoot(enemy, player)

func exit() -> void:
    if fireball_tween and state_data.stunned:
        fireball_tween.kill()
