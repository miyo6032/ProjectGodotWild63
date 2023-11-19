extends ShootLogic

class_name HomingShootLogic

func shoot(enemy: Node2D, player: Node2D):
    var projectile = projectile_scene.instantiate()
    var fireball_position = enemy.global_position
    projectile.linear_velocity = (player.global_position - fireball_position).normalized() * projectile_speed
    projectile.global_position = fireball_position
    projectile.look_at(player.global_position)
    projectile.target = player
    enemy.get_parent().get_parent().add_child(projectile)
