extends CharacterBody2D

class_name PrototypePlayer

# signal hit
signal on_end_invulnerability

const STOP_LAG = 8.0
const MOVE_LAG = 16.0
const WALK_SPEED = 300.0

@onready var damageable: Damageable = $Damageable
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(_delta):
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if direction.length() > 0:
        $AnimatedSprite2D.play()
    else:
        $AnimatedSprite2D.stop()

    if direction.x != 0:
        $AnimatedSprite2D.animation = "walk"
        $AnimatedSprite2D.flip_v = false
        # See the note below about boolean assignment.
        $AnimatedSprite2D.flip_h = direction.x < 0
    elif direction.y != 0:
        $AnimatedSprite2D.animation = "up"
        $AnimatedSprite2D.flip_v = direction.y > 0

func _physics_process(delta):
    var speed = WALK_SPEED

    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if direction != Vector2.ZERO:
        velocity = lerp(velocity, direction * speed, delta * MOVE_LAG)
    else:   
        velocity = lerp(velocity, direction * speed, delta * STOP_LAG)

    move_and_slide()

# func _on_body_entered(body):
    # hide() # Player disappears after being hit.
    # hit.emit()
    # Must be deferred as we can't change physics properties on a physics callback.
    # $CollisionShape2D.set_deferred("disabled", true)
    
func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false

func _on_enemy_collision_detection_on_damage(damage_info):
    print("player damaged" + str(damage_info))
    damageable.invulnerable = true
    animation_player.stop()
    animation_player.play("hit")

func end_invulnerability():
    damageable.invulnerable = false
    on_end_invulnerability.emit()
