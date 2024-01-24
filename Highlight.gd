extends Area2D

func _ready():
	add_user_signal("send_highlight_position", [
		{"name":"highlight_position", "type":TYPE_VECTOR2}
	])

func _on_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if (event.button_index == MOUSE_BUTTON_LEFT):
			emit_signal("send_highlight_position", self.position)
			#self.queue_free()
