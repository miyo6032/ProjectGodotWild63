extends Area2D

class_name BaseObjectDetector

func detect_objects() -> Array:
    return get_overlapping_bodies()