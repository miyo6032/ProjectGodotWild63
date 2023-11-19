extends Node2D

var enemies: Node2D

func _ready():
	Console.add_command("levelclear", func(): EventBus.on_level_cleared.emit())
	var player = get_node("%Player")
	enemies = get_node("%Enemies")
	for enemy in enemies.get_children():
		enemy.died.connect(_on_enemy_died)
		enemy.init(player)

func _on_enemy_died() -> void:
	# await get_tree().create_timer(1.0).timeout
	var num_enemies = 0
	for child in enemies.get_children():
		if child is Enemy and child.health > 0:
			num_enemies += 1
	if num_enemies == 0:
		EventBus.on_level_cleared.emit()
