extends CardState

@onready var card_details = $"../../CardDetails"

var hand_tween : Tween

func enter() -> void:
	if not card_hand_ui.is_node_ready():
		await card_hand_ui.ready
	
	card_hand_ui.reparent_requested.emit(card_hand_ui)
	
	
	hand_container.update_hand()
	card_details.hide()
	
	card_hand_ui.color_rect.color = Color.WEB_GREEN
	card_hand_ui.state.text = "BASE"
	card_hand_ui.pivot_offset = Vector2.ZERO
	


func on_mouse_entered() -> void:
	if hand_tween:
		hand_tween.kill()
	#print(hand_container.position)
	hand_tween = hand_container.get_tree().create_tween()
	hand_tween.tween_property(hand_container, "position:y", 850, 0.15)
	
	#hand_container.position = Vector2(hand_container.position.x, 880)
	transition_requested.emit(self, CardState.State.HOVER)
	
