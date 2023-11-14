extends Control

signal play_pressed

@onready var animation_player = $AnimationPlayer

func _on_play_button_pressed():
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    animation_player.play("clear_menu")
    play_pressed.emit()
    
func _on_quit_button_pressed():
    get_tree().quit()
