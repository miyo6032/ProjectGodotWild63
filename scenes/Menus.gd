extends Control

signal play_pressed

@export var action_items: Array[String]

@onready var animation_player = $AnimationPlayer
@onready var settings_grid_container = %SettingsGridContainer
@onready var main_menu_button = %MainMenuButton
@onready var continue_button = %ContinueButton
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var pause_menu = %PauseMenu

func _ready():
    EventBus.on_game_win.connect(_game_won)
    EventBus.on_game_over.connect(_game_over)
    pause_menu.visible = false
    create_action_remap_items()

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

func create_action_remap_items() -> void:
    var previous_item = settings_grid_container.get_child(-1)
    for index in range(action_items.size()):
        var action = action_items[index]		
        var label = Label.new()
        label.text = action
        settings_grid_container.add_child(label)
        var button = RemapButton.new()
        button.action = action
        button.focus_neighbor_top = previous_item.get_path()
        settings_grid_container.add_child(button)
        previous_item.focus_neighbor_bottom = button.get_path()
        if index == action_items.size() - 1:
            continue_button.focus_neighbor_top = button.get_path()
            button.focus_neighbor_bottom = continue_button.get_path()
        previous_item = button

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        toggle_pause_menu()

func toggle_pause_menu():
    get_tree().paused = !get_tree().paused
    pause_menu.visible = !pause_menu.visible
    if pause_menu.visible:
        settings_grid_container.get_child(1).grab_focus()

func _on_sfx_slider_value_changed(value:float):
    AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
    AudioServer.set_bus_mute(sfx_bus_id, value < 0.05)

func _on_music_slider_value_changed(value:float):
    AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
    AudioServer.set_bus_mute(music_bus_id, value < 0.05)

func _on_continue_button_pressed():
    toggle_pause_menu()

func _on_main_menu_button_pressed():
    get_tree().reload_current_scene()
