extends HBoxContainer

@export var heart_full: Texture2D
@export var heart_half: Texture2D
@export var heart_empty: Texture2D

@export var hearts_to_show = 5

func _ready():
    for i in hearts_to_show:
        add_child(TextureRect.new())

func update_health(health, max_health):
    for i in get_child_count():
        if health > i * 2 + 1:
            get_child(i).texture = heart_full
        elif health > i * 2:
            get_child(i).texture = heart_half
        elif max_health > i * 2:
            get_child(i).texture = heart_empty
        else:
            get_child(i).texture = null