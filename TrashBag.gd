extends Node2D

func _on_damageable_on_damage(amount):
    queue_free()