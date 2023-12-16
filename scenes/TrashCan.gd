extends Node2D

@export var lid_particles_scene: PackedScene
@export var particle_textures: Array[Texture2D]
@export var trash_bag_projectile_scene: PackedScene
@export var bag_velocity: float
@export var trash_can_sound: AudioStream

@onready var damageable = $Damageable

func _on_damageable_on_damage(damage_info):
    for i in particle_textures:
        var lid_particles: CPUParticles2D = lid_particles_scene.instantiate()
        lid_particles.direction = damage_info.knockback
        lid_particles.global_position = global_position
        lid_particles.texture = i
        get_parent().add_child(lid_particles)

    SfxPlayer.play_sfx(trash_can_sound, global_position)

    call_deferred("trash_bag", damage_info)

func trash_bag(damage_info):
    var trash_bag_projectile: RigidBody2D = trash_bag_projectile_scene.instantiate()
    trash_bag_projectile.linear_velocity = to_direction(damage_info.knockback) * bag_velocity
    trash_bag_projectile.global_position = global_position
    get_parent().add_child(trash_bag_projectile)
    queue_free()

func to_direction(vector: Vector2) -> Vector2:
    return Vector2.RIGHT.rotated(round(vector.angle() / TAU * 4) * TAU / 4).snapped(Vector2.ONE)
