extends Area2D

class_name Damageable

signal on_damage(damage_info)

var invulnerable: bool
var dashing: bool

func damage(damage_info):
    if not invulnerable and not dashing:
        on_damage.emit(damage_info)

func damage_ignore_dashing(damage_info):
    if not invulnerable:
        on_damage.emit(damage_info)