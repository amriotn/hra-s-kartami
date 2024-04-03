extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05

var minimum_drag_time_elapsed := false

func enter() -> void:
	#var hand_node = get_tree().get_first_node_in_group("hand")
	#print(hand_node)
	
	var ui_layer := get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		#print(ui_layer)
		card_hand_ui.reparent(ui_layer)
		hand_container.update_hand()
	
	var camera_layer : Camera2D = get_tree().get_first_node_in_group("cameras")
	#print(camera_layer)
	if camera_layer:
		camera_layer.can_move = false
	
	
	card_hand_ui.color_rect.color = Color.NAVY_BLUE
	card_hand_ui.state.text = "DRAGGING"
	
	card_hand_ui.pivot_offset = card_hand_ui.get_global_mouse_position() - card_hand_ui.global_position


func _process(delta):
	var card_detection_zones_layer : Area2D = get_tree().get_first_node_in_group("card_detection_zones")
	if not card_hand_ui.targets.is_empty():
		if card_hand_ui.targets.has(card_detection_zones_layer):
			card_hand_ui.shine.show()
	else:
		card_hand_ui.shine.hide()
	

func on_input(event: InputEvent) -> void:
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	var camera_layer : Camera2D = get_tree().get_first_node_in_group("cameras")
	
	if mouse_motion:
		card_hand_ui.position = card_hand_ui.get_global_mouse_position() - card_hand_ui.pivot_offset
	
	if cancel:
		if camera_layer: camera_layer.can_move = true
		transition_requested.emit(self, CardState.State.BASE)
	
	elif confirm:
		if camera_layer: camera_layer.can_move = true
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)

