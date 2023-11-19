extends RigidBody2D

@export var knockback: float

func _on_area_2d_area_entered(area:Area2D):
    if area is Damageable and !area.dashing:
        area.damage({damage = 1, knockback = (area.global_position - global_position) * knockback})
        queue_free()

func _on_area_2d_body_entered(_body:Node2D):
    queue_free()
