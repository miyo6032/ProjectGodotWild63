extends RigidBody2D

func _on_area_2d_area_entered(area:Area2D):
    area.damage({damage = 1})
    queue_free()
