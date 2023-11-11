extends Node

@export var player: CharacterBody2D
@export var fireball_scene: PackedScene

func _ready():
    GameConsole.add_command("meteor", fireball)

func fireball():
    var fireball_instance = fireball_scene.instantiate()
    var fireball_position = player.global_position + player.last_direction * 250
    fireball_instance.global_position = fireball_position
    add_child(fireball_instance)
