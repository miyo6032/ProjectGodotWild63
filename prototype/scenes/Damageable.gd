extends Area2D

class_name Damageable

signal on_damage(damage_info)

var invulnerable: bool

func damage(damage_info):
    if not invulnerable:
        on_damage.emit(damage_info)
