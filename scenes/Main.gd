extends Node

@onready var enemies: Node2D = %Enemies
@onready var player: Node2D = %Player

func _ready() -> void:
    for enemy in enemies.get_children():
        enemy.died.connect(_on_enemy_died)
        enemy.player = player

func _on_enemy_died() -> void:
    await get_tree().create_timer(1.0).timeout
    if enemies.get_child_count() == 0:
        print("YOU WIN")
