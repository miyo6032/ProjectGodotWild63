extends Node

signal EventBus

signal on_game_win
signal on_game_over
signal on_game_pause
signal on_level_started
signal on_level_cleared
signal player_health_changed(health, max_health)

func _ready():
    Console.add_command("win", _on_game_win_test)
    Console.add_command("lose", _on_game_over_test)

func _on_game_over_test():
    on_game_over.emit()

func _on_game_win_test():
    on_game_win.emit()
