extends CharacterBody2D

@export var target: PrototypePlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 100.0

var overlap_area

func _ready():
    target.on_end_invulnerability.connect(damage)

func _exit_tree():
    target.on_end_invulnerability.disconnect(damage)

func _physics_process(_delta):
    var direction = target.position - position
    direction = direction.normalized()
    velocity = direction * SPEED

    move_and_slide()

func damage():
    if overlap_area:
        overlap_area.damage({damage = 1})

func _on_damage_area_area_entered(area):
    overlap_area = area
    damage()

func _on_damage_area_area_exited(area):
    if area == overlap_area:
        overlap_area = null

var health = 2

func _on_damageable_on_damage(damage_info):
    animation_player.play("hit")
    health -= damage_info.damage
    if health <= 0:
        queue_free()
