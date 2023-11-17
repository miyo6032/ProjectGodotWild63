extends Node

@export var levels: Array[PackedScene]

var current_level: Node

func _ready() -> void:
    Console.add_command("level", start_level, 1)

func start_level(level_index) -> void:
    if current_level:
        current_level.queue_free()

    var level_scene = levels[int(level_index)]
    var level = level_scene.instantiate()
    add_child(level)
    current_level = level
