extends Node

class_name ShootLogic

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 500

func shoot(enemy: Node2D, player: Node2D):
    var fireball_instance = projectile_scene.instantiate()
    var fireball_position = enemy.global_position
    fireball_instance.linear_velocity = (player.global_position - fireball_position).normalized() * projectile_speed
    fireball_instance.global_position = fireball_position
    fireball_instance.look_at(player.global_position)
    get_tree().current_scene.add_child(fireball_instance)
