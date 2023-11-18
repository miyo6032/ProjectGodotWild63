extends RigidBody2D

@export var explosion_knockback: float
@export var initial_angular_velocity: float
@export var particles_scenes: Array[PackedScene]

@onready var sprite: Sprite2D = $Sprite2D
@onready var explosion_area = $ExplosionArea

var trash_can_parent

func _on_area_2d_area_entered(_area:Area2D):
    explode()

func _on_area_2d_body_entered(_body:Node2D):
    explode()

func _process(delta):
    sprite.rotation += initial_angular_velocity * delta   

func explode():
    for area in explosion_area.get_overlapping_areas():
        area.damage_ignore_dashing({damage = 1, knockback = (area.global_position - global_position).normalized() * explosion_knockback})

    for scene in particles_scenes:
        var particles: CPUParticles2D = scene.instantiate()
        particles.global_position = global_position
        get_parent().add_child(particles)

    queue_free()