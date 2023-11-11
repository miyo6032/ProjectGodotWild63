extends CharacterBody2D

@export var target: Node2D

const SPEED = 150.0

func _physics_process(_delta):
    var direction = target.position - position
    direction = direction.normalized()
    velocity = direction * SPEED

    move_and_slide()


func _on_damage_area_area_entered(area):
    print("damage")
