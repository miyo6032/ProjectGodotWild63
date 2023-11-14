extends Control

signal play_pressed

@onready var animation_player = $AnimationPlayer

func _ready():
    EventBus.on_game_win.connect(_game_won)
    EventBus.on_game_over.connect(_game_over)

func _game_won():
    animation_player.play("win")

func _game_over():
    animation_player.play("game_over")

func _on_play_button_pressed():
    mouse_filter = Control.MOUSE_FILTER_IGNORE
    animation_player.play("clear_menu")
    play_pressed.emit()
    
func _on_quit_button_pressed():
    get_tree().quit()

func _on_try_again_button_pressed():
    get_tree().reload_current_scene()
