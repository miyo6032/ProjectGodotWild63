extends Node

@export var levels: Array[PackedScene]

func _ready() -> void:
    Console.add_command("level", start_level, 1)

func start_level(level_index) -> void:
    var level_scene = levels[int(level_index)]
    var level = level_scene.instantiate()
    add_child(level)
