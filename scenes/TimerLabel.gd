extends Label

@export var time_label: Label

var time = 0
var is_running: bool

func _ready():
    Console.add_command("timer", start_timer)
    EventBus.on_game_win.connect(set_timer_text)

func set_timer_text():
    time_label.text = "Cleared in %.0f minutes %02d.%02d seconds" % [floor(time / 60), fmod(time, 60), fmod(time * 100, 100)]
    is_running = false

func start_timer():
    time = 0
    is_running = true

func _process(delta):
    if is_running:
        time += delta
        text = "%.0f.%02d.%02d" % [floor(time / 60), fmod(time, 60), fmod(time * 100, 100)]

func _on_menus_play_pressed():
    start_timer()
