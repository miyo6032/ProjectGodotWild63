extends Camera2D

@export var decay = 0.8  # How quickly the shaking stops [0, 1].
@export var max_offset = Vector2(100, 75)  # Maximum hor/ver shake in pixels.
@export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].

# @onready var noise = FastNoiseLite.new()
var noise_y = 0

func _ready():
    randomize()
    # noise.seed = randi()
    # noise.frequency = 4
    # noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
    Console.add_command("shake", shake_test, 1)

func shake_test(val):
    add_trauma(float(val))

func add_trauma(amount):
    trauma = min(trauma + amount, 1.0)

func _process(delta):
    if trauma:
        trauma = max(trauma - decay * delta, 0)
        shake()

func shake():
    var amount = pow(trauma, trauma_power)
    rotation = max_roll * amount * randf_range(-1, 1)
    offset.x = max_offset.x * amount * randf_range(-1, 1)
    offset.y = max_offset.y * amount * randf_range(-1, 1)

func _on_player_attack_hit():
    add_trauma(0.1)
