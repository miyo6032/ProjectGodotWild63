extends Node2D

var enemies: Node2D

func _ready():
    var player = get_node("%Player")
    enemies = get_node("%Enemies")
    for enemy in enemies.get_children():
        enemy.died.connect(_on_enemy_died)
        enemy.init(player)

func _on_enemy_died() -> void:
    await get_tree().create_timer(1.0).timeout
    if enemies.get_child_count() == 0:
        print("YOU WIN")