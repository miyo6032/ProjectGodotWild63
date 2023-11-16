extends CharacterBody2D

@export var knockback: float
@export var max_bounces: = 2

var linear_velocity: set = set_linear_velocity, get = get_linear_velocity

func set_linear_velocity(value: Vector2) -> void:
    velocity = value

func get_linear_velocity() -> Vector2:
    return velocity

func _on_area_2d_area_entered(area:Area2D):
    area.damage({damage = 1, knockback = (area.global_position - global_position) * knockback})
    queue_free()

func _physics_process(delta):
    var collision = move_and_collide(velocity * delta) 

    if collision:
        if max_bounces <= 0:
            queue_free()
        velocity = velocity.bounce(collision.get_normal())
        look_at(global_position + linear_velocity)
        max_bounces -= 1
