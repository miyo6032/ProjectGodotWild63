extends State

class_name MoveToTargetState

@export var object_detector : BaseObjectDetector
@export var maximum_time_in_a_direction : float = 1
@export var object_detection_distance : float = 0.5
@export var speed : float = 100
@export var move_lag : float = 16.0

var direction : Vector2

func on_exit_state() -> void:
    stop_moving()

func physics_update(delta: float) -> void:
    if not state_data.can_move:
        enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, delta * move_lag)
        return

    direct_to_target()
    if not valid_spot():
        enemy.velocity = lerp(enemy.velocity, Vector2.ZERO, delta * move_lag)
        enemy.animated_sprite.play("idle")
    else:
        enemy.velocity = lerp(enemy.velocity, direction * speed, delta * move_lag)
        enemy.animated_sprite.play("move")
        if direction.x != 0:
            enemy.animated_sprite.flip_v = false
            enemy.animated_sprite.flip_h = direction.x < 0

func valid_spot() -> bool:
    position_detector(object_detector, object_detection_distance)
    return object_detector.detect_objects().is_empty()

func position_detector(detector: BaseObjectDetector, distance: float) -> void:
    var position = enemy.global_position
    var object_detection_pos = position + direction.normalized() * distance
    detector.global_position = object_detection_pos

func direct_to_target() -> void:
        direction = (player.global_position - enemy.global_position).normalized()
        object_detector.position = direction * object_detection_distance

func stop_moving() -> void:
    direction = Vector2.ZERO

func move_in_direction(dir : Vector2) -> void:
    self.direction = dir
