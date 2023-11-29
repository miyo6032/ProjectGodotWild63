extends State

class_name EnemyRangedAttackState

@export var shoot_time: float = 2
@export var telegraph_time: float = 1.0
@export var shoot_logic: ShootLogic
@export var prepare_sfx: AudioStream
@export var shoot_sfx: Array[AudioStream]
@export var shoot_knockback: float

var current_time = shoot_time
var fireball_tween: Tween

func enter(_msg := {}) -> void:
    if _msg.has("was_stunned"):
        current_time = 0
    current_time = shoot_time * 0.75

func update(delta: float) -> void:
    current_time += delta
    if current_time >= shoot_time:
        state_data.can_move = false
        enemy.set_sprite_animation("attack")
        enemy.animation_player.play("prepare")
        enemy.audio_stream_player.stream = prepare_sfx
        enemy.audio_stream_player.play()
        fireball_tween = create_tween()
        fireball_tween.tween_callback(fireball).set_delay(telegraph_time)
        current_time = 0

        var direction = player.global_position - enemy.global_position
        if direction.x != 0:
            enemy.set_flip(direction.x < 0)

func fireball():
    enemy.audio_stream_player.stream = shoot_sfx[randi() % shoot_sfx.size()]
    enemy.audio_stream_player.play()
    shoot_logic.shoot(enemy, player)
    var direction = player.global_position - enemy.global_position
    enemy.velocity += direction.normalized() * shoot_knockback * -1
    enemy.set_sprite_animation("hit")
    await get_tree().create_timer(0.1).timeout
    state_data.can_move = true

func exit() -> void:
    if fireball_tween and state_data.stunned:
        fireball_tween.kill()
