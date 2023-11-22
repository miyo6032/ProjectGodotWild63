extends Node2D

@export var to_follow: Node2D

func _process(delta):
    global_position = to_follow.global_position
