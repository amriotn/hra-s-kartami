extends CardState

var hand_tween : Tween

func enter() -> void:
	#card_hand_ui.scale = Vector2(2,2)
	card_hand_ui.color_rect.color = Color.ORANGE
	card_hand_ui.state.text = "HOVER"
	#card_hand_ui.drop_detection_area.monitoring = true
	
	

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		#card_hand_ui.pivot_offset = card_hand_ui.get_global_mouse_position() - card_hand_ui.global_position
		transition_requested.emit(self, CardState.State.DRAGGING)


func on_mouse_exited():
	if hand_tween:
		hand_tween.kill()
	hand_tween = hand_container.get_tree().create_tween()
	hand_tween.tween_property(hand_container, "position:y", 1000, 0.15)
	#hand_container.position = Vector2(hand_container.position.x, 1000)
	#print(hand_container.position)
	transition_requested.emit(self, CardState.State.BASE)

"""
var threshold_time = 0.2
var timer = 0
var action_started = false

func _physics_process(delta):
	if Input.is_action_just_pressed("left_mouse"):
		action_started = true
		
	if Input.is_action_pressed("left_mouse") and action_started:
		timer += delta
		
	if timer >= threshold_time and action_started:
		action_started = false
		timer = 0
		print("hold")
		transition_requested.emit(self, CardState.State.DRAGGING)

	if Input.is_action_just_released("left_mouse"):
		if timer < threshold_time and action_started:
			print("press")
		action_started = false
		timer = 0
"""
