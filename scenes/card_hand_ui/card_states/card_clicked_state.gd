extends CardState


func enter() -> void:
	card_hand_ui.color_rect.color = Color.ORANGE
	card_hand_ui.state.text = "CLICKED"
	card_hand_ui.drop_detection_area.monitoring = true
	

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		transition_requested.emit(self, CardState.State.BASE)
	if event is InputEventMouseMotion:
		#transition_requested.emit(self, CardState.State.DRAGGING)
		pass

