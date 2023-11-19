extends Node2D

@export var explosion_knockback: float
@export var particles_scene: PackedScene

@onready var explosion_area = $ExplosionArea
@onready var damageable = $Damageable

var is_exploded: bool
var did_raycast: bool

func _ready():
    Console.add_command("explode", explode)

func _on_damageable_on_damage(_amount):
    explode()

func explode():
    if is_exploded:
        return

    is_exploded = true

    var particles: CPUParticles2D = particles_scene.instantiate()
    particles.global_position = global_position
    get_parent().add_child(particles)

    var tween = create_tween()
    tween.tween_callback(queue_free).set_delay(0.2)

func _physics_process(_delta):
    if is_exploded and not did_raycast:
        did_raycast = true
        for area in explosion_area.get_overlapping_areas():
            if area != damageable:
                var space_state = get_world_2d().direct_space_state
                var query = PhysicsRayQueryParameters2D.create(global_position, area.global_position)
                query.exclude = [damageable, area]
                var result = space_state.intersect_ray(query)
                if !result:
                    area.damage_ignore_dashing({damage = 1, knockback = (area.global_position - global_position).normalized() * explosion_knockback})
