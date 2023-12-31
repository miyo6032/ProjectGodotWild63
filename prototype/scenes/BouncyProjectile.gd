extends CharacterBody2D

@export var knockback: float
@export var max_bounces: = 2
@export var initial_angular_velocity: float
@export var bounce_audio: AudioStream
@export var break_audio_scene: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var linear_velocity: set = set_linear_velocity, get = get_linear_velocity

func set_linear_velocity(value: Vector2) -> void:
    velocity = value

func get_linear_velocity() -> Vector2:
    return velocity

func _on_area_2d_area_entered(area:Area2D):
    if area is Damageable and !area.dashing:
        area.damage({damage = 1, knockback = (area.global_position - global_position) * knockback})
        queue_free()

func _physics_process(delta):
    var collision = move_and_collide(velocity * delta) 

    if collision:
        if max_bounces <= 0:
            get_parent().add_child(break_audio_scene.instantiate())
            queue_free()
        audio.stream = bounce_audio
        audio.play()
        velocity = velocity.bounce(collision.get_normal())
        max_bounces -= 1

func _process(delta):
    sprite.rotation += initial_angular_velocity * delta   
