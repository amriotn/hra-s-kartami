extends TextureRect

@onready var obstacle_description : RichTextLabel = $ObstacleDescription
@onready var affected_tiles : Node2D = $AffectedTiles


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		obstacle_description.visible = not obstacle_description.visible
		affected_tiles.visible = not affected_tiles.visible
