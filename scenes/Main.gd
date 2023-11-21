extends Node

@export var start: int = 0
@export var levels: Array[PackedScene]

var current_level: Node
var current_level_index: int

func _ready() -> void:
    Console.add_command("level", level_command, 1)
    EventBus.on_level_cleared.connect(_on_level_cleared)
    
func level_command(index):
    start_level(int(index) - 1)

func _on_level_cleared() -> void:
    if current_level_index < levels.size() - 1:
        await get_tree().create_timer(0.5).timeout
        get_tree().paused = true
        start_level(current_level_index + 1)
    else:
        EventBus.on_game_win.emit()
        await get_tree().create_timer(0.5).timeout
        get_tree().paused = true

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

    await get_tree().create_timer(2.0).timeout
    get_tree().paused = false

func _on_menus_play_pressed():
    get_tree().paused = true
    start_level(start)
