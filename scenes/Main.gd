extends Node

@export var enemy_spawner: EnemySpawner

func _on_menus_play_pressed():
    await get_tree().create_timer(1.0).timeout
    enemy_spawner.start_waves()
