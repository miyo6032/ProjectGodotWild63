extends CPUParticles2D

func free_soon():
    await get_tree().create_timer(0.4).timeout
    queue_free()
