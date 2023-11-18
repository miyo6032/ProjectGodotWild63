extends Node

@export var levels: Array[PackedScene]

var current_level: Node
var current_level_index: int

func _ready() -> void:
    Console.add_command("level", start_level, 1)
    EventBus.on_level_cleared.connect(_on_level_cleared)

func _on_level_cleared() -> void:
    if current_level_index < levels.size() - 1:
        await get_tree().create_timer(2.0).timeout
        start_level(current_level_index + 1)
    else:
        EventBus.on_game_win.emit()

func start_level(level_index) -> void:
    Engine.time_scale = 1.0
    EventBus.on_level_started.emit(level_index)

    if current_level:
        current_level.queue_free()

    var level_scene = levels[int(level_index)]
    var level = level_scene.instantiate()
    add_child(level)
    current_level = level
    current_level_index = level_index

func _on_menus_play_pressed():
    start_level(0)
