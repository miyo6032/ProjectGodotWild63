extends CharacterBody2D

signal transitioned(state_name)

@export var initial_state := NodePath()

@onready var current_state: State = get_node(initial_state)
@onready var states: Node = $States

var state_data
@export var player: Player

func init(in_player):
    player = in_player

func _ready() -> void:
    state_data = { player = player, enemy = self, can_move = true, stunned = false, is_dead = false }
    for child in states.get_children():
        child.set_state_machine(self)
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
                if transition.true_state:
                    var has_true_state = is_ancestor_of(transition.true_state)
                    if has_true_state and transition.true_state != current_state:
                        transition_to(transition.true_state)
                        break
            else:
                if transition.false_state:
                    var has_false_state = is_ancestor_of(transition.false_state)
                    if has_false_state and transition.false_state != current_state:
                        transition_to(transition.false_state)
                        break

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var health = 2

func _on_damageable_on_damage(damage_info):
    animation_player.play("hit")
    health -= damage_info.damage
    state_data.stunned = true

    if damage_info.has("knockback"):
        velocity += damage_info.knockback

    if health <= 0:
        state_data.is_dead = true
