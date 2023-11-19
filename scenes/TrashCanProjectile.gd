extends RigidBody2D

@export var explosion_knockback: float
@export var initial_angular_velocity: float
@export var particles_scene: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var explosion_area = $ExplosionArea
@onready var area2d = $Area2D

var trash_can_parent
var is_exploded: bool
var did_raycast: bool

func _ready():
    await get_tree().create_timer(0.2).timeout
    area2d.collision_mask = 15

func _on_area_2d_area_entered(_area:Area2D):
    explode()

func _on_area_2d_body_entered(_body:Node2D):
    explode()

func _process(delta):
    sprite.rotation += initial_angular_velocity * delta   

func explode():
    if is_exploded:
        return

    is_exploded = true

    var particles: CPUParticles2D = particles_scene.instantiate()
    particles.global_position = global_position
    get_parent().add_child(particles)

func _physics_process(_delta):
    if is_exploded and not did_raycast:
        did_raycast = true
        for area in explosion_area.get_overlapping_areas():
            var space_state = get_world_2d().direct_space_state
            var query = PhysicsRayQueryParameters2D.create(global_position, area.global_position)
            query.exclude = [area]
            var result = space_state.intersect_ray(query)
            if !result:
                area.damage_ignore_dashing({damage = 1, knockback = (area.global_position - global_position).normalized() * explosion_knockback})
        queue_free()
