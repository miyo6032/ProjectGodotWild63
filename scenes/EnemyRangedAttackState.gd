extends State

class_name EnemyRangedAttackState

@export var shoot_time: float = 2
@export var telegraph_time: float = 1.0
@export var shoot_logic: ShootLogic
@export var prepare_sfx: AudioStream
@export var shoot_sfx: Array[AudioStream]

var current_time = shoot_time
var fireball_tween: Tween

func update(delta: float) -> void:
    current_time += delta
    if current_time >= shoot_time:
        state_data.can_move = false
        enemy.animated_sprite.play("attack")
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
    state_data.can_move = true
    shoot_logic.shoot(enemy, player)

func exit() -> void:
    if fireball_tween and state_data.stunned:
        fireball_tween.kill()
