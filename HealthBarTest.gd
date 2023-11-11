extends Control

@onready var health_bar = $HealthBar

var health = 3

func _on_button_2_pressed():
    health -= 1
    health_bar.update_health(health)

func _on_button_pressed():
    health += 1
    health_bar.update_health(health)
