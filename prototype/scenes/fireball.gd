extends Node2D

@onready var animation_player = $AnimationPlayer

func _ready():
    animation_player.play("fireball")

func _on_area_2d_area_entered(area):
    area.damage({damage = 1})
