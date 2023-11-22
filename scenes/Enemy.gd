extends CharacterBody2D

class_name Enemy

signal transitioned(state_name)
signal died

@export var initial_state := NodePath()
@export var start_attack_distance: float
@export var start_chasing_distance: float
@export var lose_sight_distance: float
@export var health = 3
@export var death_particles_scene: PackedScene
@export var enemy_death_sfx: AudioStream
@export var animation_suffix: String
@export var player: Player

@onready var current_state: State = get_node(initial_state)
@onready var states: Node = %States
@onready var global_transitions: Node = %GlobalTransitions

var state_data

func _ready():
    set_sprite_animation("idle")
    if player:
        init(player)

func init(in_player):
    player = in_player
    state_data = { 
        player = player, 
        enemy = self, 
        can_move = true, 
        stunned = false, 
        is_dead = false,
        start_attack_distance = start_attack_distance,
        start_chasing_distance = start_chasing_distance,
        lose_sight_distance = lose_sight_distance,
        zero_distance = 0
    }
    for child in states.get_children():
        if child is State:
            child.set_state_machine(self)
            for transition in child.get_children():
                transition.state_data = state_data
    for transition in global_transitions.get_children():
        transition.state_data = state_data
    current_state.enter()

func _unhandled_input(event: InputEvent) -> void:
    current_state.handle_input(event)

func _process(delta: float) -> void:
    maybe_transition_state()
    current_state.update(delta)

func _physics_process(delta: float) -> void:
    maybe_transition_state()
    current_state.physics_update(delta)
    move_and_slide()

func transition_to(target_state: State, msg: Dictionary = {}) -> void:
    if not is_ancestor_of(target_state):
        push_warning("unknown state %s" % target_state.name)
        return

    print("transitioning to %s" % target_state.name)
    current_state.exit()
    current_state = target_state
    current_state.enter(msg)
    emit_signal("transitioned", current_state.name)

func maybe_transition_state():
    for transition in current_state.get_children():
        if transition is StateTransition:
            var decision = transition.get_decision()
            if decision:
                var has_true_state = is_ancestor_of(transition.true_state)
                if has_true_state and transition.true_state != current_state:
                    transition_to(transition.true_state)
                    return
    for transition in global_transitions.get_children():
        if transition is StateTransition:
            var decision = transition.get_decision()
            if decision:
                var has_true_state = is_ancestor_of(transition.true_state)
                if has_true_state and transition.true_state != current_state:
                    transition_to(transition.true_state)
                    return

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var shadow_pivot: Node2D = %ShadowPivot
@onready var shine_pivot: Node2D = %ShinePivot
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var damageable: Damageable = %Damageable


func _on_damageable_on_damage(damage_info):
    if health <= 0:
        return

    health -= damage_info.damage
    state_data.stunned = true

    if damage_info.has("knockback"):
        velocity += damage_info.knockback

    if health <= 0:
        state_data.is_dead = true
        animation_player.play("death")
        died.emit()
        var particles: CPUParticles2D = death_particles_scene.instantiate()
        particles.global_position = global_position
        get_parent().get_parent().add_child(particles)
        audio_stream_player.stream = enemy_death_sfx
        audio_stream_player.play()
        damageable.set_deferred("monitorable", false)
    else:
        animation_player.play("hit")

func set_flip(flip: bool) -> void:
    animated_sprite.flip_h = flip
    shadow_pivot.rotation = TAU * 0.5 if flip else 0.0
    shine_pivot.rotation = TAU * 0.5 if flip else 0.0

func set_sprite_animation(animation: String):
    animated_sprite.play(animation + "_" + animation_suffix)
