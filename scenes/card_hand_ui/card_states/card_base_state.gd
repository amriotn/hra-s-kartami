extends CardState


func enter() -> void:
	if not card_hand_ui.is_node_ready():
		await card_hand_ui.ready
	
	card_hand_ui.reparent_requested.emit(card_hand_ui)
	card_hand_ui.color_rect.color = Color.WEB_GREEN
	card_hand_ui.state.text = "BASE"
	card_hand_ui.pivot_offset = Vector2.ZERO

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		#card_hand_ui.pivot_offset = card_hand_ui.get_global_mouse_position() - card_hand_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
	

func on_mouse_entered() -> void:
	card_hand_ui.state.text = "HOVER"

func on_mouse_exited() -> void:
	card_hand_ui.state.text = "BASE"
