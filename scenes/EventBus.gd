extends Node

signal EventBus

signal on_game_win
signal on_game_over

func _ready():
    Console.add_command("win", _on_game_win_test)
    Console.add_command("lose", _on_game_over_test)

func _on_game_over_test():
    on_game_over.emit()

func _on_game_win_test():
    on_game_win.emit()