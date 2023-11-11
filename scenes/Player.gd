extends CharacterBody2D

class_name Player

signal on_end_invulnerability
signal update_health(health, max_health)

const STOP_LAG = 8.0
const MOVE_LAG = 16.0
const WALK_SPEED = 300.0

@onready var damageable: Damageable = $Damageable
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var movement_enabled = true
var last_direction = Vector2.RIGHT

func _process(_delta):
    if not movement_enabled:
        return

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if direction.length() > 0:
        $AnimatedSprite2D.animation = "walk"
        $AnimatedSprite2D.play()
        last_direction = direction
    else:
        $AnimatedSprite2D.stop()
        $AnimatedSprite2D.animation = "idle"

    if direction.x != 0:
        $AnimatedSprite2D.flip_v = false
        $AnimatedSprite2D.flip_h = direction.x < 0
    # elif direction.y != 0:
        # $AnimatedSprite2D.flip_v = direction.y > 0

func _physics_process(delta):
    var speed = WALK_SPEED

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if movement_enabled and direction != Vector2.ZERO:
        velocity = lerp(velocity, direction * speed, delta * MOVE_LAG)
    else:   
        velocity = lerp(velocity, Vector2.ZERO, delta * STOP_LAG)

    move_and_slide()

@export var max_health = 6
@export var health = 6

func _ready():
    update_health.emit(health, max_health)
    GameConsole.console_opened.connect(disable_movement)
    GameConsole.console_closed.connect(enable_movement)

func disable_movement():
    movement_enabled = false

func enable_movement():
    movement_enabled = true

func _on_enemy_collision_detection_on_damage(damage_info):
    print("player damaged" + str(damage_info))
    damageable.invulnerable = true
    animation_player.stop()
    animation_player.play("hit")
    health -= damage_info.damage
    update_health.emit(health, max_health)
    if health <= 0:
        print("u died!")

func end_invulnerability():
    damageable.invulnerable = false
    on_end_invulnerability.emit()
