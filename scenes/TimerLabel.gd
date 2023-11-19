extends Label

@export var time_label: Label

var time = 0
var is_running: bool

func _ready():
    Console.add_command("timer", start_timer)
    EventBus.on_game_win.connect(set_timer_text)

func set_timer_text():
    time_label.text = "Total time: %.2f" % time
    is_running = false

func start_timer():
    time = 0
    is_running = true

func _process(delta):
    if is_running:
        time += delta
        text = "%.2f" % time

func _on_menus_play_pressed():
    start_timer()
