extends ShootLogic

class_name TripleShootLogic

func shoot(enemy: Node2D, player: Node2D):
    var angle_offsets = [TAU * - 0.1, 0, TAU * 0.1]
    for angle_offset in angle_offsets:
        var fireball_instance = projectile_scene.instantiate()
        var fireball_position = enemy.global_position
        fireball_instance.linear_velocity = ((player.global_position - fireball_position).normalized() * projectile_speed).rotated(angle_offset)
        fireball_instance.global_position = fireball_position
        fireball_instance.look_at(player.global_position)
        fireball_instance.rotate(angle_offset)
        get_tree().current_scene.add_child(fireball_instance)