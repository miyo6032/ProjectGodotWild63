extends ShootLogic

class_name ShotgunShootLogic

@export var amount: int = 8
@export var spread: float = TAU * 0.1

func shoot(enemy: Node2D, player: Node2D):
    for i in amount:
        var fireball_instance = projectile_scene.instantiate()
        var fireball_position = enemy.global_position
        var angle_offset = randf_range(-spread, spread)
        fireball_instance.linear_velocity = ((player.global_position - fireball_position).normalized() * projectile_speed).rotated(angle_offset)
        fireball_instance.global_position = fireball_position
        fireball_instance.look_at(player.global_position)
        fireball_instance.rotate(angle_offset)
        get_tree().current_scene.add_child(fireball_instance)
        await get_tree().create_timer(0.01).timeout