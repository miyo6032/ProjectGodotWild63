extends RigidBody2D

@export var knockback: float
@export var explosion_scene: PackedScene
@export var homing_time = 1.5
@export var homing_speed = 10.0

@onready var area2d = $Area2D

var target: Node2D

func _ready():
    await get_tree().create_timer(0.5).timeout
    area2d.collision_mask = 15

func _physics_process(delta):
    if homing_time > 0:
        homing_time -= delta
        var desired_velocity = (target.global_position - global_position).normalized() * linear_velocity.length()
        linear_velocity = linear_velocity.lerp(desired_velocity, homing_speed * delta).normalized() * linear_velocity.length()
        look_at(global_position + linear_velocity)

func _on_area_2d_area_entered(area:Area2D):
    if area is Damageable and !area.dashing:
        area.damage({damage = 1, knockback = (area.global_position - global_position) * knockback})
        spawn_explosion()
        queue_free()

func _on_area_2d_body_entered(_body:Node2D):
    spawn_explosion()
    queue_free()

func spawn_explosion():
    var explosion = explosion_scene.instantiate()
    get_parent().add_child(explosion)
    explosion.global_position = global_position
