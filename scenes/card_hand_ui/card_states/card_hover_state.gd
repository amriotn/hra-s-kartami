extends CardState

var hand_tween : Tween

func enter() -> void:
	card_hand_ui.color_rect.color = Color.ORANGE
	card_hand_ui.state.text = "HOVER"
	
	#card_hand_ui.pivot_offset = Vector2(133/2, 200)
	hand_container.update_hand()
	card_hand_ui.position.y -= 30
	#card_hand_ui.drop_detection_area.monitoring = true
	
	

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		#card_hand_ui.pivot_offset = card_hand_ui.get_global_mouse_position() - card_hand_ui.global_position
		transition_requested.emit(self, CardState.State.DRAGGING)
	if event.is_action_pressed("right_mouse"):
		print("Show details")


func on_mouse_exited():
	#hand_container.position = Vector2(hand_container.position.x, 1000)
	#print(hand_container.position)
	transition_requested.emit(self, CardState.State.BASE)

