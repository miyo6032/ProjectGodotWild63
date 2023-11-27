extends Control

signal play_pressed

@onready var animation_player = $AnimationPlayer
@onready var main_menu_button = %MainMenuButton
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var pause_menu = %PauseMenu
@onready var settings_grid_container = %PauseSettingsGridContainer
@onready var play_button: Button = %PlayButton
@onready var try_again_button: Button = %TryAgainButton
@onready var play_again_button: Button = %PlayAgainButton
@onready var options_menu: = %OptionsMenu
@onready var options_settings_grid_container = %OptionsSettingsGridContainer
@onready var main_menu = %MainMenu
@onready var level_label = %LevelLabel
@onready var death_menu = %DeathMenu
@onready var win_menu = %WinMenu

func _ready():
    EventBus.on_game_win.connect(_game_won)
    EventBus.on_game_over.connect(_game_over)
    EventBus.on_level_started.connect(_level_started)
    EventBus.on_level_cleared.connect(_level_cleared)
    pause_menu.visible = false
    play_button.grab_focus()

func _game_won():
    play_again_button.grab_focus()
    animation_player.play("win")
    await animation_player.animation_finished
    get_tree().paused = true

func _game_over():
    try_again_button.grab_focus()
    animation_player.play("game_over")
    await get_tree().create_timer(0.6).timeout
    get_tree().paused = true

func _on_play_button_pressed():
    animation_player.play("clear_menu")
    await animation_player.animation_finished
    play_pressed.emit()
    
func _on_quit_button_pressed():
    get_tree().quit()

func _on_try_again_button_pressed():
    get_tree().reload_current_scene()

func _input(event):
    if event.is_action_pressed("ui_cancel") and ((!main_menu.visible and !death_menu.visible and !win_menu.visible) or pause_menu.visible):
        toggle_pause_menu()

func toggle_pause_menu():
    pause_menu.visible = !pause_menu.visible
    get_tree().paused = pause_menu.visible
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

func _on_options_button_pressed():
    options_menu.visible = true
    options_settings_grid_container.get_child(1).grab_focus()

func _on_back_button_pressed():
    options_menu.visible = false
    play_button.grab_focus()

func _level_started(index):
    level_label.text = "Level " + str(index + 1)
    animation_player.play("level_screen_first")

func _level_cleared():
    animation_player.play("level_cleared")
