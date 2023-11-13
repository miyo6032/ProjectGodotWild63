extends State

class_name EnemyRangedAttackState

@export var fireball_scene: PackedScene
@export var shoot_time: float = 2
@export var telegraph_time: float = 1.0
@export var projectile_speed: float = 25

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
    var fireball_instance = fireball_scene.instantiate()
    var fireball_position = enemy.global_position
    fireball_instance.linear_velocity = (player.global_position - fireball_position).normalized() * projectile_speed
    fireball_instance.global_position = fireball_position
    fireball_instance.look_at(player.global_position)
    get_tree().current_scene.add_child(fireball_instance)

func exit() -> void:
    if fireball_tween and state_data.stunned:
        fireball_tween.kill()
