extends CharacterBody2D

signal transitioned(state_name)

@export var initial_state := NodePath()
@export var player: Player

@onready var current_state: State = get_node(initial_state)
@onready var states: Node = $States

var state_data

func _ready() -> void:
    state_data = { player = player, enemy = self }
    await owner.ready
    for child in states.get_children():
        child.state_machine = self
        for transition in child.get_children():
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

func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
    if not has_node(target_state_name):
        push_warning("unknown state %s" % target_state_name)
        return

    current_state.exit()
    current_state = get_node(target_state_name)
    current_state.enter(msg)
    emit_signal("transitioned", current_state.name)

func maybe_transition_state():
    for transition in current_state.get_children():
        if transition is StateTransition:
            var decision = transition.get_decision()
            if decision:
                var has_true_state = has_node(transition.true_state)
                if has_true_state and transition.true_state != current_state.state_name:
                    var ai_state = get_node(transition.true_state)
                    transition_to(ai_state.state_name)
                    break
            else:
                var has_false_state = has_node(transition.false_state)
                if has_false_state and transition.false_state != current_state.state_name:
                    var ai_state = get_node(transition.false_state)
                    transition_to(ai_state.state_name)
                    break

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var health = 2

func _on_damageable_on_damage(damage_info):
    animation_player.play("hit")
    health -= damage_info.damage
    if health <= 0:
        queue_free()
