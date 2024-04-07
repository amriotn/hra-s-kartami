extends CardState

var played: bool

func enter() -> void:
	var card_detection_zones_layer : Area2D = get_tree().get_first_node_in_group("card_detection_zones")
	#print(card_detection_zones_layer)
	
	
	card_hand_ui.color_rect.color = Color.DARK_VIOLET
	card_hand_ui.state.text = "RELEASED"
	
	played = false
	
	if not card_hand_ui.targets.is_empty():
		if card_hand_ui.targets.has(card_detection_zones_layer):
			played = true
			#print("play card for target(s) ", card_hand_ui.targets)
			card_hand_ui.data.trigger_effect()
			card_hand_ui.queue_free()

func on_input(_event: InputEvent) -> void:
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
