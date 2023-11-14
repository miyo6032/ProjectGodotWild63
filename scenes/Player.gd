extends CharacterBody2D

class_name Player

signal on_end_invulnerability
signal update_health(health, max_health)
signal attack_hit

@export var stop_lag = 16.0
@export var move_lag = 16.0
@export var walk_speed = 30.0
@export var attack_velocity = 100.0
@export var knockback = 80.0
@export var dash_ghost_scene: PackedScene

@onready var damageable: Damageable = $Damageable
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particle_animation_player: AnimationPlayer = $ParticleAnimationPlayer
@onready var facing_direction: Node2D = $FacingDirection
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $FacingDirection/AttackArea

var movement_enabled = true
var attack_enabled = true
var last_direction = Vector2.RIGHT
var time_since_last_dash = 0
var is_dashing = false
var attack_direction = Vector2.ZERO

func _process(delta):
    if movement_enabled:
        handle_sprite_movement()
    if attack_enabled:
        handle_attack_input()
    time_since_last_dash += delta

func handle_attack_input():
    attack_direction = Input.get_vector("attack_left", "attack_right", "attack_up", "attack_down")
    if attack_direction.length() > 0:
        facing_direction.look_at(facing_direction.global_position + attack_direction)
        animation_player.play("attack")
        attack_area.monitoring = true
        is_dashing = true
        if attack_direction.x != 0:
            animated_sprite.flip_v = false
            animated_sprite.flip_h = attack_direction.x < 0
        movement_enabled = false
        attack_enabled = false
        damageable.monitorable = false
        await get_tree().create_timer(0.1).timeout
        is_dashing = false
        await get_tree().create_timer(0.05).timeout
        attack_area.monitoring = false
        movement_enabled = true
        damageable.monitorable = true
        await get_tree().create_timer(0.05 if time_since_last_dash > 0.25 else 0.25).timeout
        time_since_last_dash = 0
        attack_enabled = true

func handle_sprite_movement():
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if direction.length() > 0:
        animated_sprite.play("walk")
        last_direction = direction
        particle_animation_player.play("move")
    else:
        animated_sprite.stop()
        animated_sprite.animation = "idle"
        particle_animation_player.play("idle")

    if direction.x != 0:
        animated_sprite.flip_v = false
        animated_sprite.flip_h = direction.x < 0

func _physics_process(delta):
    var speed = walk_speed

    var direction = Vector2.ZERO
    if movement_enabled:
        direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    if is_dashing:
        velocity = attack_direction * attack_velocity
    elif direction != Vector2.ZERO:
        velocity = lerp(velocity, direction * speed, delta * move_lag)
    else:   
        velocity = lerp(velocity, Vector2.ZERO, delta * stop_lag)

    move_and_slide()

@export var max_health = 6
@export var health = 6

func _ready():
    attack_area.monitoring = false
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
    if damage_info.has("knockback"):
        velocity += damage_info.knockback

    if health <= 0:
        print("u died!")

func end_invulnerability():
    damageable.invulnerable = false
    on_end_invulnerability.emit()

func _on_attack_area_area_entered(area:Area2D):
    velocity = velocity * -0.7
    is_dashing = false
    if not area.invulnerable:
        area.damage({damage = 1, knockback = last_direction * knockback})
        attack_hit.emit()

func spawn_dash_ghost():
    var dash_ghost: Sprite2D = dash_ghost_scene.instantiate()
    dash_ghost.global_position = global_position
    dash_ghost.texture = animated_sprite.sprite_frames.get_frame_texture(animated_sprite.animation, animated_sprite.frame)
    # dash_ghost.vframes = animated_sprite.vframes
    # dash_ghost.hframes = animated_sprite.hframes
    # dash_ghost.frame = animated_sprite.frame
    dash_ghost.flip_h = animated_sprite.flip_h
    get_parent().add_child(dash_ghost)
