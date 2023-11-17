extends GridContainer

@export var action_items: Array[String]
@export var bottom_control: Button

@onready var settings_grid_container = self

func _ready():
    create_action_remap_items()

func create_action_remap_items() -> void:
    var previous_item = settings_grid_container.get_child(-1)
    for index in range(action_items.size()):
        var action = action_items[index]		
        var label = Label.new()
        label.text = action
        settings_grid_container.add_child(label)
        var button = RemapButton.new()
        button.action = action
        button.focus_neighbor_top = previous_item.get_path()
        settings_grid_container.add_child(button)
        previous_item.focus_neighbor_bottom = button.get_path()
        if index == action_items.size() - 1:
            bottom_control.focus_neighbor_top = button.get_path()
            button.focus_neighbor_bottom = bottom_control.get_path()
        previous_item = button
