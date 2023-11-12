extends State

class_name EnemyRangedAttackState

@export var fireball_scene: PackedScene

func enter(_msg := {}) -> void:
    fireball()

func fireball():
    var fireball_instance = fireball_scene.instantiate()
    var fireball_position = enemy.global_position
    fireball_instance.linear_velocity = (player.global_position - fireball_position).normalized() * 250
    fireball_instance.global_position = fireball_position
    fireball_instance.look_at(fireball_position)
    get_tree().current_scene.add_child(fireball_instance)