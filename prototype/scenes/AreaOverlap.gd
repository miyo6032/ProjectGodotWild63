extends Node2D

@export var area: Area2D

func _ready():
    Console.add_command("test", test)

func test():
    area.monitoring = false
    await get_tree().create_timer(1.0).timeout
    area.monitoring = true

func _on_area_2d_2_area_entered(_area:Area2D):
    print("area entered")
