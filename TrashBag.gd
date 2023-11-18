extends Node2D

@export var explosion_knockback: float

@onready var explosion_area = $ExplosionArea
@onready var damageable = $Damageable

func _ready():
    pass

func _on_damageable_on_damage(_amount):
    for area in explosion_area.get_overlapping_areas():
        if area != damageable:
            area.damage_ignore_dashing({damage = 1, knockback = (area.global_position - global_position).normalized() * explosion_knockback})

    await get_tree().create_timer(0.2).timeout
    queue_free()

func _on_explosion_area_area_entered(area:Area2D):
    print(area.name)
