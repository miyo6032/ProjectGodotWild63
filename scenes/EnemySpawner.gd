extends Node2D

@export var waves: EnemyWaves
@export var telegraph_spawn_delay: float
@export var spawn_positions: Array[Area2D]
@export var player: Player

var current_wave_index

func _ready():
    Console.add_command("waves", start_waves)

func start_waves():
    current_wave_index = -1
    start_spawning()

func start_spawning():
    current_wave_index += 1
    if current_wave_index >= waves.waves.size():
        print("All waves spawned")
        return
    var enemy_spawn = waves.waves[current_wave_index]
    var tween = create_tween()
    for i in enemy_spawn.spawn_amount:
        tween.tween_callback(spawn_enemy).set_delay(enemy_spawn.initial_delay if i == 0 else enemy_spawn.in_between_delay)
    tween.tween_callback(start_spawning)

func spawn_enemy():
    var available_positions = [] + spawn_positions

    while available_positions.size() > 0:
        var random_position = available_positions[randi() % available_positions.size()]
        available_positions.remove_at(available_positions.find(random_position))
        if random_position.get_overlapping_areas().size() == 0:
            var enemy_spawn = waves.waves[current_wave_index]
            var enemy_instance = enemy_spawn.enemy.instantiate()
            enemy_instance.init(player)
            add_child(enemy_instance)
            enemy_instance.global_position = random_position.global_position
            return