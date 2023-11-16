extends ShootLogic

class_name EightShootLogic

func shoot(enemy: Node2D, player: Node2D):
    var eight_angle_offsets = [0, TAU * 0.125, TAU * 0.25, TAU * 0.375, TAU * 0.5, TAU * 0.625, TAU * 0.75, TAU * 0.875]
    for angle_offset in eight_angle_offsets:
        var fireball_instance = projectile_scene.instantiate()
        var fireball_position = enemy.global_position
        fireball_instance.linear_velocity = ((player.global_position - fireball_position).normalized() * projectile_speed).rotated(angle_offset)
        fireball_instance.global_position = fireball_position
        fireball_instance.look_at(player.global_position)
        fireball_instance.rotate(angle_offset)
        get_tree().current_scene.add_child(fireball_instance)
