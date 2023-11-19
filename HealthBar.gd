extends HBoxContainer

@export var heart_full: Texture2D
@export var heart_empty: Texture2D

@export var hearts_to_show = 5

func _ready():
    EventBus.player_health_changed.connect(update_health)
    for i in hearts_to_show:
        add_child(TextureRect.new())

func update_health(health, max_health):
    for i in get_child_count():
        if health > i:
            get_child(i).texture = heart_full
        elif max_health > i:
            get_child(i).texture = heart_empty
        else:
            get_child(i).texture = null
