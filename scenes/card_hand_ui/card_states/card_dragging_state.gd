extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05

var minimum_drag_time_elapsed := false

func enter() -> void:
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		#print(ui_layer)
		card_hand_ui.reparent(ui_layer)
	
	var camera_layer : Camera2D = get_tree().get_first_node_in_group("cameras")
	print(camera_layer)
	if camera_layer:
		camera_layer.movement_toggle()
	
	
	card_hand_ui.color_rect.color = Color.NAVY_BLUE
	card_hand_ui.state.text = "DRAGGING"
	
	minimum_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func(): minimum_drag_time_elapsed = true)
	

func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	var camera_layer : Camera2D = get_tree().get_first_node_in_group("cameras")
	
	if mouse_motion:
		card_hand_ui.global_position = card_hand_ui.get_global_mouse_position() - card_hand_ui.pivot_offset
	
	if cancel:
		camera_layer.movement_toggle()
		transition_requested.emit(self, CardState.State.BASE)
	
	elif minimum_drag_time_elapsed and confirm:
		camera_layer.movement_toggle()
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
