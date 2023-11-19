extends RigidBody2D

@export var knockback: float
@export var explosion_scene: PackedScene
@onready var explosion_area = $ExplosionArea

func _on_area_2d_area_entered(_area:Area2D):
    spawn_explosion()

func _on_area_2d_body_entered(_body:Node2D):
    spawn_explosion()

func spawn_explosion():
    for area in explosion_area.get_overlapping_areas():
        area.damage_ignore_dashing({damage = 1, knockback = (area.global_position - global_position).normalized() * knockback})

    var explosion = explosion_scene.instantiate()
    get_parent().add_child(explosion)
    explosion.global_position = global_position

    queue_free()
