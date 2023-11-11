extends HBoxContainer

enum MODES {simple, empty, partial}

@export var heart_full: Texture2D
@export var heart_half: Texture2D
@export var heart_empty: Texture2D

@export var mode = MODES.simple

func update_health(value):
    match mode:
        MODES.simple:
            update_simple(value)
        MODES.empty:
            update_empty(value)
        MODES.partial:
            update_partial(value)

func update_simple(value):
    for i in get_child_count():
        get_child(i).visible = value > i

func update_empty(value):
    for i in get_child_count():
        if value > i:
            get_child(i).texture = heart_full
        else:
            get_child(i).texture = heart_empty

func update_partial(value):
    for i in get_child_count():
        if value > i * 2 + 1:
            get_child(i).texture = heart_full
        elif value > i * 2:
            get_child(i).texture = heart_half
        else:
            get_child(i).texture = heart_empty