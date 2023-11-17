extends CPUParticles2D

func _on_player_attack_hit():
    emitting = true
    await get_tree().create_timer(0.1).timeout
    emitting = false
