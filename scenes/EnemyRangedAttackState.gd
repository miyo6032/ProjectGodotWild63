extends State

class_name EnemyRangedAttackState

@export var fireball_scene: PackedScene
@export var shoot_time: float = 2

var current_time = 0

func update(delta: float) -> void:
    current_time += delta
    if current_time >= shoot_time:
        fireball()
        current_time = 0

func fireball():
    var fireball_instance = fireball_scene.instantiate()
    var fireball_position = enemy.global_position
    fireball_instance.linear_velocity = (player.global_position - fireball_position).normalized() * 250
    fireball_instance.global_position = fireball_position
    fireball_instance.look_at(fireball_position)
    get_tree().current_scene.add_child(fireball_instance)