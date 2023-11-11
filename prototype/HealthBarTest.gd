extends Control

@onready var health_bar = $HealthBar

var health = 6
var max_health = 6

func _on_button_2_pressed():
    health -= 1
    health_bar.update_health(health, max_health)

func _on_button_pressed():
    health += 1
    if health > max_health:
        health = max_health
    health_bar.update_health(health, max_health)

func _on_max_health_down_pressed():
    max_health -= 1
    if health > max_health:
        health = max_health
    health_bar.update_health(health, max_health)
    
func _on_max_health_up_pressed():
    max_health += 1
    health += 1
    health_bar.update_health(health, max_health)
