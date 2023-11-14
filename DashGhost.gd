extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    animation_player.play("fade_out")
    await animation_player.animation_finished
    queue_free()